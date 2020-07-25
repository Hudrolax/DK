unit upmessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids, Gvar, DBF, ZipForge, table;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    sg1: TStringGrid;
    RichEdit1: TRichEdit;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Button3: TButton;
    Timer1: TTimer;
    DBF1: TDBF;
    DBF2: TDBF;
    zp1: TZipForge;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sg1DblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  Tinclude = record
  num:Integer;
  name:string;
  end;
var
  Form3: TForm3;
  a:array of Tinclude;

implementation

{$R *.dfm}
procedure OpenInclude;
begin
 if (Form3.sg1.Cells[4,SelectRow]<>'') and (Form3.sg1.Cells[4,SelectRow]<>'Нет') then
 begin
 DeleteFile(extractfilepath(paramstr(0))+'\temp\include.xls');
 DeleteFile(extractfilepath(paramstr(0))+'\temp\them.txt');
 DeleteFile(extractfilepath(paramstr(0))+'\temp\text.rtf');
      with form3.zp1 do
      try
      FileName:='\\dk99.kopt.org\MS\upload\'+form3.sg1.Cells[3,SelectRow]+'\'+a[SelectRow-1].name;
      OpenArchive(fmOpenRead);
      BaseDir:=extractfilepath(paramstr(0))+'\temp\';
      ExtractFiles('*.*');
      CloseArchive;
      except
        end;
  if FileExists(extractfilepath(paramstr(0))+'\temp\include.xls') then
    begin
      Fname:=extractfilepath(paramstr(0))+'\temp\include.xls';
      Form2.Visible:=True;
      Form2.Timer1.Enabled:=True;
      end else ShowMessage('Не могу найти вложение для просмотра!');
 end;
end;

procedure flood;
var i,j,NextRow:Integer;
begin
  SetLength(a,1);
 // Чистим таблицу.
 for i:=1 to Form3.sg1.RowCount-1 do
  for j:=1 to Form3.sg1.ColCount-1 do
    Form3.sg1.Cells[j,i]:='';

  NextRow:=1;
    // Открываем БД
    try
     Form3.DBF1.TableName:='\\dk99.kopt.org\MS\magaz.dbf';
     Form3.DBF1.Exclusive:=false;
     Form3.DBF1.Open;
     except
     ShowMessage('Не могу открыть БД '+'\\dk99.kopt.org\MS\magaz.dbf');
     try
      Form3.DBF1.Close;
       except;
         end;
     Exit;
     end;

 for i:=1 to Form3.DBF1.RecordCount do
  begin
       // Открываем БД
    try
     Form3.DBF2.TableName:='\\dk99.kopt.org\MS\upload\'+form3.DBF1.GetFieldData(1)+'.dbf';
     Form3.DBF2.Exclusive:=false;
     Form3.DBF2.Open;
     except
     ShowMessage('Не могу открыть БД '+'\\dk99.kopt.org\MS\upload\'+form3.DBF1.GetFieldData(1)+'.dbf');
     try
      Form3.DBF2.Close;
      except
         end;
     Exit;
     end;

    for j:=1 to Form3.DBF2.RecordCount do
     begin
//       Form3.sg1.RowCount:=10; // Выставляем кол-во строк в табл. по умолчанию
       // Добавляем строку в таблицу если не хватает
      if Form3.sg1.RowCount<NextRow then
        Form3.sg1.RowCount:=Form3.sg1.RowCount+1;

      // Вычисляем сообщения, отправленные пользователем.

      if (Form3.DBF2.GetFieldData(7)=GlobalUser) or (GlobalUser='admin') then
        begin
         Form3.sg1.Cells[0,NextRow]:=IntToStr(NextRow);
         Form3.sg1.Cells[1,NextRow]:=Form3.DBF2.GetFieldData(2);
         Form3.sg1.Cells[2,NextRow]:=Form3.DBF2.GetFieldData(3);
         Form3.sg1.Cells[3,NextRow]:=Form3.DBF1.GetFieldData(1);
         if Form3.DBF2.GetFieldData(5)='0' then
            Form3.sg1.Cells[4,NextRow]:='Нет' else Form3.sg1.Cells[4,NextRow]:='Есть';
         if Form3.DBF2.GetFieldData(6)='0' then
            Form3.sg1.Cells[5,NextRow]:='Не прочитано' else Form3.sg1.Cells[5,NextRow]:='Прочитано';
         a[NextRow-1].num:=NextRow;
         a[NextRow-1].name:=Form3.DBF2.GetFieldData(1);
         NextRow:=NextRow+1;
         SetLength(a,Length(a)+1);
        end;

      Form3.DBF2.Next; // Переходим на след. позиция в БД магазина
     end;
    try  // Закрываем БД магаза
      Form3.DBF2.Close;
      except
      end;
   Form3.DBF1.Next; // Переходим на след. строку в magaz.dbf
  end;

 try  // Закрываем БД.
  Form3.DBF1.Close;
     except
     end;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=False;
 flood;

 // Тут заполняем по первой строке по умолчанию
 if sg1.Cells[4,1]='' then Button2.Enabled:=false else Button2.Enabled:=True;

 if sg1.Cells[3,1]<>'' then // Если пусто в строке, то все стираем
 begin
   if FileExists('\\dk99.kopt.org\MS\upload\'+sg1.Cells[3,1]+'\'+a[0].name) then
      with form3.zp1 do
      try
      FileName:='\\dk99.kopt.org\MS\upload\'+sg1.Cells[3,1]+'\'+a[0].name;
      OpenArchive(fmOpenRead);
      BaseDir:=extractfilepath(paramstr(0))+'\temp\';
      ExtractFiles('*.*');
      CloseArchive;
      except
        end;
  if FileExists(extractfilepath(paramstr(0))+'\temp\text.rtf') then
   RichEdit1.Lines.LoadFromFile(extractfilepath(paramstr(0))+'\temp\text.rtf');

  DeleteFile(extractfilepath(paramstr(0))+'\temp\text.rtf');
  DeleteFile(extractfilepath(paramstr(0))+'\temp\them.txt');
  DeleteFile(extractfilepath(paramstr(0))+'\temp\include.xls');
  end else RichEdit1.Clear;

end;

procedure TForm3.Button1Click(Sender: TObject);
begin
 Form3.Visible:=false;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
 sg1.Cells[0,0]:='№:';
 sg1.Cells[1,0]:='Дата:';
 sg1.Cells[2,0]:='Тема:';
 sg1.Cells[3,0]:='Кому:';
 sg1.Cells[4,0]:='Вложение';
 sg1.Cells[5,0]:='Статус:';
 end;

procedure TForm3.Button3Click(Sender: TObject);
begin
flood;
end;

procedure TForm3.sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 SelectRow:=ARow;
 if sg1.Cells[4,ARow]='' then Button2.Enabled:=false else Button2.Enabled:=True;

 if sg1.Cells[3,ARow]<>'' then // Если пусто в строке, то все стираем
 begin
   if FileExists('\\dk99.kopt.org\MS\upload\'+sg1.Cells[3,ARow]+'\'+a[ARow-1].name) then
      with form3.zp1 do
      try
      FileName:='\\dk99.kopt.org\MS\upload\'+sg1.Cells[3,ARow]+'\'+a[ARow-1].name;
      OpenArchive(fmOpenRead);
      BaseDir:=extractfilepath(paramstr(0))+'\temp\';
      ExtractFiles('*.*');
      CloseArchive;
      except
        end;
  if FileExists(extractfilepath(paramstr(0))+'\temp\text.rtf') then
   RichEdit1.Lines.LoadFromFile(extractfilepath(paramstr(0))+'\temp\text.rtf');

  DeleteFile(extractfilepath(paramstr(0))+'\temp\text.rtf');
  DeleteFile(extractfilepath(paramstr(0))+'\temp\them.txt');
  DeleteFile(extractfilepath(paramstr(0))+'\temp\include.xls');
  end else RichEdit1.Clear;
 end;
procedure TForm3.sg1DblClick(Sender: TObject);
begin
 OpenInclude;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
 OpenInclude;
end;

end.
