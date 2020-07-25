unit nomencl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, DBF, ExtCtrls, Gvar, serch;

type
  TForm8 = class(TForm)
    sg1: TStringGrid;
    ListBox1: TListBox;
    StaticText1: TStaticText;
    Button1: TButton;
    DBF3: TDBF;
    Button2: TButton;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure wmGetMinMaxInfo(var Msg : TMessage); message wm_GetMinMaxInfo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form8: TForm8;
  myrect:TGridRect;
implementation

{$R *.dfm}
function KdnRect(Rect: TRect; DLeft,DTop,DRight,DBottom: Integer): TRect;
begin
With Result do
  begin
   Left:= Rect.Left + DLeft;
   Top:= Rect.Top + DTop;
   Right:= Rect.Right + DRight;
   Bottom:= Rect.Bottom + DBottom;
  end;
end;

procedure PutBar(ARow:integer);
 var
   i,j:Integer;
begin
   // Открываем БД database.dbf
  Form8.ListBox1.Clear;

 try
  form8.DBF3.TableName:='base\database.dbf';
  Form8.DBF3.Exclusive:=false;
  Form8.DBF3.Open;
  except
   end;

  try
    Form8.DBF3.GoToRecord(ARow);
    for j:=6 to 10 do
        if Form8.DBF3.GetFieldData(j)<>'' then
          Form8.ListBox1.Items.Add(Form8.DBF3.GetFieldData(j));

   except
    end;

   // Закрываем БД
 try
  Form8.DBF3.Close;
 except
   end;
end;

procedure flood;
var i,j,k:Integer;
begin
  // Чистим табличку.
 try
  for i:=1 to Form8.sg1.RowCount-1 do
    for j:=0 to Form8.sg1.ColCount do
      Form8.sg1.Cells[j,i]:='';
  except
  end;
  
  // Открываем БД database.dbf
 try
  form8.DBF3.TableName:='base\database.dbf';
  Form8.DBF3.Exclusive:=false;
  Form8.DBF3.Open;
  except
   end;

 //Заполняем записями из БД
 try
 if not Form8.DBF3.IsEmpty then
  Form8.DBF3.First else
    begin
       try
      Form8.DBF3.Close;
      except
      end;
      Exit;
      end;
 for i:=1 to Form8.DBF3.RecordCount do
  begin
   if Form8.sg1.RowCount<i+1 then
     Form8.sg1.RowCount:=Form8.sg1.RowCount+1;
   k:=0;
   Form8.sg1.Cells[0,i]:=IntToStr(i);
   Form8.sg1.Cells[1,i]:=Form8.DBF3.GetFieldData(1);
   Form8.sg1.Cells[2,i]:=Form8.DBF3.GetFieldData(2);
   Form8.sg1.Cells[4,i]:=Form8.DBF3.GetFieldData(3);
   Form8.sg1.Cells[5,i]:=Form8.DBF3.GetFieldData(4);
   for j:=6 to 10 do
     if Form8.DBF3.GetFieldData(j)<>'' then k:=k+1;

   Form8.sg1.Cells[3,i]:=IntToStr(k);
   Form8.DBF3.Next;
  end;
  except
    end;


  // Закрываем БД
 try
  Form8.DBF3.Close;
 except
   end;

 Form8.Edit1.SetFocus;  
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
 sg1.Cells[0,0]:='№';
 sg1.Cells[1,0]:='Код:';
 sg1.Cells[2,0]:='Наименование:';
 sg1.Cells[3,0]:='ШК:';
 sg1.Cells[4,0]:='Цена:';
 sg1.Cells[5,0]:='Дата получения';
 end;

procedure TForm8.Button1Click(Sender: TObject);
begin
Form8.Visible:=False;
end;

procedure TForm8.Button2Click(Sender: TObject);
begin
flood;
end;

procedure TForm8.sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
PutBar(ARow);
end;

procedure TForm8.Timer1Timer(Sender: TObject);
var j:Integer;
begin
 Timer1.Enabled:=false;
 flood;
    // Открываем БД database.dbf
  ListBox1.Clear;

 try
  form8.DBF3.TableName:='base\database.dbf';
  Form8.DBF3.Exclusive:=false;
  Form8.DBF3.Open;
  except
   end;

  try
    for j:=6 to 10 do
        if Form8.DBF3.GetFieldData(j)<>'' then
          ListBox1.Items.Add(Form8.DBF3.GetFieldData(j));
   except
    end;

   // Закрываем БД
 try
  Form8.DBF3.Close;
 except
   end;
end;

procedure TForm8.Button3Click(Sender: TObject);
var i,m:Integer;
begin
  m:=Form8.sg1.Selection.Top;
 for i:=m+1 to Form8.sg1.RowCount do
  begin
  if CheckBox1.checked then
    if AnsiPos(Edit1.Text,sg1.Cells[1,i])>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    PutBar(i);
    Break;
   end;

  if CheckBox2.checked then
    if AnsiPos(alphamin(Edit1.Text),alphamin(sg1.Cells[2,i]))>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    PutBar(i);
    Break;
   end;

  if CheckBox3.checked then
    if AnsiPos(Edit1.Text,sg1.Cells[4,i])>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    PutBar(i);
    Break;
   end;

  end;
  Edit1.SetFocus;
  Button3.Default:=True;
  Button4.Default:=False;
end;

procedure TForm8.Button4Click(Sender: TObject);
var i,m:Integer;
begin
  m:=Form8.sg1.Selection.Top;
 for i:=m-1 downto 1 do
  begin
  if CheckBox1.checked then
    if AnsiPos(Edit1.Text,sg1.Cells[1,i])>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    PutBar(i);
    Break;
   end;

  if CheckBox2.checked then
    if AnsiPos(alphamin(Edit1.Text),alphamin(sg1.Cells[2,i]))>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    PutBar(i);
    Break;
   end;

  if CheckBox3.checked then
    if AnsiPos(Edit1.Text,sg1.Cells[4,i])>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    PutBar(i);
    Break;
   end;

  end;
  Edit1.SetFocus;
  Button3.Default:=False;
  Button4.Default:=True;
end;

procedure TForm8.Button5Click(Sender: TObject);
var i:Integer;
begin

 SetLength(tbl,sg1.RowCount-1);

 for i:=1 to sg1.RowCount-1 do
  begin
    tbl[i-1].kod:=sg1.Cells[1,i];
    tbl[i-1].nam:=sg1.Cells[2,i];
    tbl[i-1].bar:=sg1.Cells[3,i];
    tbl[i-1].rub:=sg1.Cells[4,i];
    tbl[i-1].date:=sg1.Cells[5,i];
    end;
 // Если форму открывали - просто показываем ее впереди.

 Form9.Visible:=True;
 Form9.Show;

 // Ставим чекбоксы так же как на основной форме
 if CheckBox1.Checked then Form9.checkbox1.checked:=True else
    Form9.CheckBox1.Checked:=false;
 if CheckBox2.Checked then Form9.checkbox2.checked:=True else
    Form9.CheckBox2.Checked:=false;
 if CheckBox3.Checked then Form9.checkbox3.checked:=True else
    Form9.CheckBox3.Checked:=False;
  Form9.Edit1.Text:=Edit1.Text;
 Form9.Timer1.Enabled:=True;
end;

// Процедура отрисовки ячейки
// Вызывается при каждом изменении ячейки
procedure TForm8.sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var r: TRect;
begin
  // Прорисовываем заголовки таблицы
  if (ARow=0) then
  with sg1 do
  begin
   Canvas.Font.Color:=clBlue;
   Canvas.Font.Style:=[fsBold];
   Canvas.TextOut(Rect.Left+2,Rect.Top+2,sg1.Cells[Acol,Arow]);
   end;

end;

// Установим минимальный размер формы
procedure TForm8.wmGetMinMaxInfo(var Msg : TMessage);

begin
  PMinMaxInfo(Msg.lParam)^.ptMinTrackSize.X := 869; //W
  PMinMaxInfo(Msg.lParam)^.ptMinTrackSize.Y := 709; //H
end;

end.
