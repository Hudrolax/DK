unit mail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AxCtrls, OleCtrls, VCF1, Grids, DBF, ExtCtrls, Gvar, StdCtrls,
  ZipForge,mail2, ComCtrls;

type
  TForm12 = class(TForm)
    sg1: TStringGrid;
    Timer1: TTimer;
    DBF: TDBF;
    zp1: TZipForge;
    Timer2: TTimer;
    LabeledEdit1: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sg1DblClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure sg1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure sg1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form12: TForm12;
  myrect:TGridRect;

implementation

{$R *.dfm}
procedure onmemo;
var f:TextFile;
s:string;
begin
  // Открываем БД
    try
     Form12.DBF.TableName:='base\mail_down.dbf';
     Form12.DBF.Exclusive:=false;
     Form12.DBF.Open;
     Form12.DBF.GoToRecord(mailtamrowselect);
   except
     Exit;
     end;
         with form12.zp1 do
      try
      FileName:='mail\download\'+form12.dbf.GetFieldData(1);
      OpenArchive(fmOpenRead);
      BaseDir:=extractfilepath(paramstr(0))+'\temp\';
      ExtractFiles('*.*');
      CloseArchive;
      except
        end;
   if FileExists('temp\text.rtf') then
    begin
     Form12.RichEdit1.Lines.LoadFromFile('temp\text.rtf');
     if (Form12.sg1.Cells[5,mailtamrowselect]='Нет') and (Form12.DBF.GetFieldData(4)='0') then
      begin
         Form12.DBF.SetFieldData(4,'1');
         Form12.DBF.Post;
         Form12.sg1.Cells[4,mailtamrowselect]:='Да';
      end;
     end else
     Form12.RichEdit1.Clear;
   Form12.RichEdit1.Update;
   DeleteFile('temp\them.txt');
   DeleteFile('temp\text.rtf');
   DeleteFile('temp\include.xls');

    // Закрываем БД
   try
     Form12.DBF.Close;
     except
       end;
end;

procedure flood;
var i,n,j:Integer;
begin
  // Открываем БД
    try
     Form12.DBF.TableName:='base\mail_down.dbf';
     Form12.DBF.Exclusive:=false;
     Form12.DBF.Open;
   except
     Exit;
     end;

  // Чистим таблицу   
  for i:=1 to Form12.sg1.RowCount do
    for j:=1 to Form12.sg1.ColCount do
    Form12.sg1.Cells[j,i]:='';

  Form12.sg1.RowCount:=25;  

  for i:=1 to Form12.DBF.RecordCount do
    begin
        if Form12.sg1.RowCount<i+1 then
     Form12.sg1.RowCount:=Form12.sg1.RowCount+1;

     Form12.sg1.Cells[0,i]:=IntToStr(i);
     Form12.sg1.Cells[1,i]:=Form12.DBF.GetFieldData(3);
     n:=StrToInt(Copy(Form12.DBF.GetFieldData(1),6,5));
     Form12.sg1.Cells[2,i]:=IntToStr(n);
     form12.sg1.Cells[3,i]:=form12.DBF.GetFieldData(2);
     if form12.DBF.GetFieldData(4)='0' then
        form12.sg1.Cells[4,i]:='Нет' else
        form12.sg1.Cells[4,i]:='Да';

     if form12.DBF.GetFieldData(5)='0' then
        form12.sg1.Cells[5,i]:='Нет' else
        form12.sg1.Cells[5,i]:='Есть';
        Form12.DBF.Next;
    end;


   // Закрываем БД
   try
     Form12.DBF.Close;
     except
       end;
end;

procedure TForm12.FormCreate(Sender: TObject);
begin
 sg1.Cells[0,0]:='№';
 sg1.Cells[1,0]:='Тема:';
 sg1.Cells[2,0]:='№ П.';
 sg1.Cells[3,0]:='Дата:';
 sg1.Cells[4,0]:='Прочитан:';
 sg1.Cells[5,0]:='Вложение:';
 end;

procedure TForm12.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=False;
 flood;

  // Открываем БД
    try
     Form12.DBF.TableName:='base\mail_down.dbf';
     Form12.DBF.Exclusive:=false;
     Form12.DBF.Open;
     Form12.DBF.GoToRecord(1);
   except
     Exit;
     end;
         with form12.zp1 do
      try
      FileName:='mail\download\'+form12.dbf.GetFieldData(1);
      OpenArchive(fmOpenRead);
      BaseDir:=extractfilepath(paramstr(0))+'\temp\';
      ExtractFiles('*.*');
      CloseArchive;
      except
        end;
   if FileExists('temp\text.rtf') then
    begin
     Form12.RichEdit1.Lines.LoadFromFile('temp\text.rtf');
     if (Form12.sg1.Cells[5,1]='Нет') and (Form12.DBF.GetFieldData(4)='0') then
      begin
         Form12.DBF.SetFieldData(4,'1');
         Form12.DBF.Post;
         Form12.sg1.Cells[4,1]:='Да';
      end;
     end else
     Form12.RichEdit1.Clear;
   Form12.RichEdit1.Update;
   DeleteFile('temp\them.txt');
   DeleteFile('temp\text.rtf');
   DeleteFile('temp\include.xls');

    // Закрываем БД
   try
     Form12.DBF.Close;
     except
       end;

 end;

procedure TForm12.sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 mailtamrowselect:=ARow;
 if sg1.Cells[0,Arow]<>'' then
   onmemo else RichEdit1.Clear;
 Form12.RichEdit1.Update;
 Button2.Default:=false;  
end;

procedure TForm12.sg1DblClick(Sender: TObject);
begin
 if (sg1.Cells[0,mailtamrowselect]<>'') and (sg1.Cells[5,mailtamrowselect]='Есть') then
 begin
 Form13.Visible:=True;
 Form13.Timer1.Enabled:=True;
 end;
 
end;

procedure TForm12.Timer2Timer(Sender: TObject);
begin
  if Form12.Visible then
  begin
   Timer2.Enabled:=false;
   flood;
   onmemo;
   Timer2.Enabled:=True;
 end;
end;

procedure TForm12.sg1KeyPress(Sender: TObject; var Key: Char);
begin
 if Ord(Key)=VK_Return then
   begin
      if (sg1.Cells[0,mailtamrowselect]<>'') and (sg1.Cells[5,mailtamrowselect]='Есть') then
     begin
      Form13.Visible:=True;
      Form13.Timer1.Enabled:=True;
      end;
     end;
end;

// Поиск Вверх
procedure TForm12.Button1Click(Sender: TObject);
var i,j,m:Integer;
begin
 m:=Form12.sg1.Selection.Top;
 for i:=m-1 downto 1 do
    for j:=1 to sg1.ColCount-1 do
      if AnsiPos(LabeledEdit1.Text,sg1.Cells[j,i])>0 then
        begin
         myrect.top:=i;
         myrect.bottom:=i;
         myrect.Right:=10;
         sg1.Selection:=myrect;
         sg1.TopRow:=i;
          end;
end;

// Поиск Вниз
procedure TForm12.Button2Click(Sender: TObject);
var m,i,j:Integer;
begin
 m:=Form12.sg1.Selection.Top;
 for i:=m+1 to sg1.RowCount-1 do
    for j:=1 to sg1.ColCount-1 do
      if AnsiPos(LabeledEdit1.Text,sg1.Cells[j,i])>0 then
        begin
         myrect.top:=i;
         myrect.bottom:=i;
         myrect.Right:=10;
         sg1.Selection:=myrect;
         sg1.TopRow:=i;
          end;
end;


procedure TForm12.LabeledEdit1Change(Sender: TObject);
begin
Button2.Default:=True;
end;

procedure TForm12.sg1Click(Sender: TObject);
begin
Button2.Default:=false;
end;

procedure TForm12.Button3Click(Sender: TObject);
begin
 if (sg1.Cells[0,mailtamrowselect]<>'') and (sg1.Cells[5,mailtamrowselect]='Есть') then
 begin
 Form13.Visible:=True;
 Form13.Timer1.Enabled:=True;
 end;
end;

procedure TForm12.Button4Click(Sender: TObject);
begin
Form12.Visible:=false;
end;

end.
