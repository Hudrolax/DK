unit serch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, DBF, Gvar, ComCtrls, ExtCtrls;

type
  TForm9 = class(TForm)
    sg1: TStringGrid;
    DBF1: TDBF;
    Button1: TButton;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button2: TButton;
    CheckBox4: TCheckBox;
    procedure wmGetMinMaxInfo(var Msg : TMessage); message wm_GetMinMaxInfo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure sg1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;


implementation

{$R *.dfm}
procedure Addlist;
var el,i:integer;
begin
 if form9.sg1.Cells[1,form9.sg1.row] <> '' then
  begin
   if length(PrintList)>0 then
    for i:=0 to length(PrintList)-1 do
      if PrintList[i].kod = form9.sg1.Cells[1,form9.sg1.row] then
        begin
          ShowMessage('Этот товар уже есть в списке печати!');
          Exit;
          end;
   el:= Length(PrintList)+1;
   SetLength(PrintList,el);
   PrintList[el-1].kod:=form9.sg1.Cells[1,form9.sg1.row];
   PrintList[el-1].name:=form9.sg1.Cells[2,form9.sg1.row];
  end;
 //ReloadList;
end;

procedure srh(s:string;b1,b2,b3,b4:Boolean);
var i,j,k,next:Integer;
begin
  // Чистим табличку.
 try
  for i:=1 to Form9.sg1.RowCount-1 do
    for j:=0 to Form9.sg1.ColCount do
      Form9.sg1.Cells[j,i]:='';
  Form9.sg1.RowCount:=14;    
  except
  end;
 next:=1;

 for i:=0 to Length(tbl)-1 do
 begin
     if Form9.sg1.RowCount<next then
     Form9.sg1.RowCount:=Form9.sg1.RowCount+1;
 
   // Ищем по коду
 if b1 then
   if AnsiPos(s,tbl[i].kod)>0 then
     begin
    Form9.sg1.Cells[0,next]:=inttostr(next);
    Form9.sg1.Cells[1,next]:=tbl[i].kod;
    Form9.sg1.Cells[2,next]:=tbl[i].nam;
    Form9.sg1.Cells[3,next]:=tbl[i].bar;
    Form9.sg1.Cells[4,next]:=tbl[i].rub;
    Form9.sg1.Cells[5,next]:=tbl[i].date;
    Form9.sg1.Cells[6,next]:=tbl[i].bars;
    next:=next+1;
    Continue;
   end;

  if b2 then
    if AnsiPos(alphamin(s),alphamin(tbl[i].nam))>0 then
//   if ((Pos(alphamin(s),alphamin(tbl[i].nam))=1) or
//    (s[Pos(alphamin(s),alphamin(tbl[i].nam))-1]=' ')) and
//    (s[Pos(alphamin(s),alphamin(tbl[i].nam))+length(alphamin(s))]=' ')
//
//      then
    begin
    Form9.sg1.Cells[0,next]:=inttostr(next);
    Form9.sg1.Cells[1,next]:=tbl[i].kod;
    Form9.sg1.Cells[2,next]:=tbl[i].nam;
    Form9.sg1.Cells[3,next]:=tbl[i].bar;
    Form9.sg1.Cells[4,next]:=tbl[i].rub;
    Form9.sg1.Cells[5,next]:=tbl[i].date;
    Form9.sg1.Cells[6,next]:=tbl[i].bars;
    next:=next+1;
    Continue;
   end;

  if b3 then
    if AnsiPos(s,tbl[i].rub)>0 then
    begin
    Form9.sg1.Cells[0,next]:=inttostr(next);
    Form9.sg1.Cells[1,next]:=tbl[i].kod;
    Form9.sg1.Cells[2,next]:=tbl[i].nam;
    Form9.sg1.Cells[3,next]:=tbl[i].bar;
    Form9.sg1.Cells[4,next]:=tbl[i].rub;
    Form9.sg1.Cells[5,next]:=tbl[i].date;
    Form9.sg1.Cells[6,next]:=tbl[i].bars;
    next:=next+1;
    Continue;
   end;

   if b4 then
    if AnsiPos(s,tbl[i].bars)>0 then
    begin
    Form9.sg1.Cells[0,next]:=inttostr(next);
    Form9.sg1.Cells[1,next]:=tbl[i].kod;
    Form9.sg1.Cells[2,next]:=tbl[i].nam;
    Form9.sg1.Cells[3,next]:=tbl[i].bar;
    Form9.sg1.Cells[4,next]:=tbl[i].rub;
    Form9.sg1.Cells[5,next]:=tbl[i].date;
    Form9.sg1.Cells[6,next]:=tbl[i].bars;
    next:=next+1;
    Continue;
   end;

 end;


end;


procedure TForm9.FormCreate(Sender: TObject);
begin
 sg1.Cells[0,0]:='№';
 sg1.Cells[1,0]:='Код:';
 sg1.Cells[2,0]:='Наименование:';
 sg1.Cells[3,0]:='ШК:';
 sg1.Cells[4,0]:='Цена:';
 sg1.Cells[5,0]:='Дата получения';
 sg1.Cells[6,0]:='ШтрихКоды';
 end;

procedure TForm9.Button1Click(Sender: TObject);
begin
Form9.Visible:=False;
end;

procedure TForm9.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=False;
 srh(Edit1.Text,CheckBox1.Checked,CheckBox2.Checked,CheckBox3.Checked,CheckBox4.Checked);
end;

procedure TForm9.Button2Click(Sender: TObject);
begin
 srh(Edit1.Text,CheckBox1.Checked,CheckBox2.Checked,CheckBox3.Checked,CheckBox4.Checked);
end;

// Процедура отрисовки ячейки
// Вызывается при каждом изменении ячейки
procedure TForm9.sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var Sprev,Spost:string ;
 begin
 // Прорисовываем заголовки таблицы
  if (ARow=0) then
  with sg1 do
  begin
   Canvas.Font.Color:=clBlue;
   Canvas.Font.Style:=[fsBold];
   Canvas.TextOut(Rect.Left+2,Rect.Top+2,sg1.Cells[Acol,Arow]);
   end;

//  if AnsiPos(Edit1.Text,sg1.Cells[Acol,ARow])>0 then
//  begin
//   sprev:=Copy(sg1.Cells[Acol,Arow],1,Pos(Edit1.Text,Sg1.Cells[ACol,Arow])-1);
//   spost:=Copy(sg1.Cells[Acol,Arow],Pos(Edit1.Text,Sg1.Cells[ACol,Arow]),Length(sg1.Cells[Acol,Arow])-length('33')-length(Sprev));
//   sg1.Canvas.Font.Color:=clBlack;
//   sg1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Sprev);
//   sg1.Canvas.Font.Color:=clRed;
//   sg1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Edit1.Text);
//   sg1.Canvas.Font.Color:=clBlack;
//   sg1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Spost);
//  end;

end;



procedure TForm9.FormShow(Sender: TObject);
begin
 Button2.Default:=True;
 Edit1.SetFocus;
end;

// Установим минимальный размер формы
procedure TForm9.wmGetMinMaxInfo(var Msg : TMessage);

begin
  PMinMaxInfo(Msg.lParam)^.ptMinTrackSize.X := 666; //W
  PMinMaxInfo(Msg.lParam)^.ptMinTrackSize.Y := 310; //H
end;

procedure TForm9.sg1DblClick(Sender: TObject);
begin
Addlist;
end;

end.
