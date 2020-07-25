unit nomencl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ZipForge, StdCtrls, ExtCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdFTP, DBF, Gvar;

type
  TForm3 = class(TForm)
    sg1: TStringGrid;
    LabeledEdit1: TLabeledEdit;
    Timer1: TTimer;
    Button1: TButton;
    zp1: TZipForge;
    ftp: TIdFTP;
    DBF3: TDBF;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    DBF1: TDBF;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button2: TButton;
    Button3: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

 Ttovar = record
 kod:string;
 nam:string;
 bar:string;
 rub:string;
 date:string;
 kt:string;
 end;

var
  Form3: TForm3;
  myrect:TGridRect;

implementation
procedure PutBar(ARow:integer);
 var
   i,j:Integer;
begin
   // Открываем БД database.dbf
  Form3.ListBox1.Clear;

 try
  form3.DBF1.TableName:='base\database.dbf';
  Form3.DBF1.Exclusive:=false;
  Form3.DBF1.Open;
  except
   end;

  try
    Form3.DBF1.GoToRecord(ARow);
    for j:=6 to 10 do
        if Form3.DBF1.GetFieldData(j)<>'' then
          Form3.ListBox1.Items.Add(Form3.DBF1.GetFieldData(j));

   except
    end;

   // Закрываем БД
 try
  Form3.DBF1.Close;
 except
   end;
end;

{$R *.dfm}
procedure flood;
var i,j,k:Integer;
begin
  // Чистим табличку.
 try
  for i:=1 to Form3.sg1.RowCount-1 do
    for j:=0 to Form3.sg1.ColCount do
      Form3.sg1.Cells[j,i]:='';
  except
  end;

  // Открываем БД database.dbf
 try
  form3.DBF3.TableName:='base\database.dbf';
  Form3.DBF3.Exclusive:=false;
  Form3.DBF3.Open;
  except
   end;

 //Заполняем записями из БД
 try
 if not Form3.DBF3.IsEmpty then
  Form3.DBF3.First else
    begin
      try
      Form3.DBF3.Close;
      except
      end;
      Exit;
      end;
 for i:=1 to Form3.DBF3.RecordCount do
  begin
   if Form3.sg1.RowCount<i+1 then
     Form3.sg1.RowCount:=Form3.sg1.RowCount+1;
   k:=0;
   Form3.sg1.Cells[0,i]:=IntToStr(i);
   Form3.sg1.Cells[1,i]:=Form3.DBF3.GetFieldData(1);
   Form3.sg1.Cells[2,i]:=Form3.DBF3.GetFieldData(2);
   Form3.sg1.Cells[4,i]:=Form3.DBF3.GetFieldData(3);
   Form3.sg1.Cells[5,i]:=Form3.DBF3.GetFieldData(4);
   for j:=6 to 10 do
     if Form3.DBF3.GetFieldData(j)<>'' then k:=k+1;

   Form3.sg1.Cells[3,i]:=IntToStr(k);
   Form3.DBF3.Next;
  end;
  except
    end;


  // Закрываем БД
 try
  Form3.DBF3.Close;
 except
   end;

 Form3.LabeledEdit1.SetFocus;
end;


{Процедура создает справочник товаров из demo.spr}
procedure getdemo(LFileName,LMagaz:string);
var
demo:textfile;
s:string;
i,n,j,next:Integer;
clear,indb,Pbar:Boolean;
h:LongInt;
tovar:Ttovar;
begin
 if not DirectoryExists(extractfilepath(paramstr(0))+'\temp') then
  CreateDir(extractfilepath(paramstr(0))+'\temp');
 if not DirectoryExists(extractfilepath(paramstr(0))+'\base') then
  CreateDir(extractfilepath(paramstr(0))+'\base');

  form3.ftp.Host:='10.10.61.10';
  Form3.ftp.Port:=21;
  Form3.ftp.Username:='dk';
  Form3.ftp.Password:='dk';
  try
   Form3.ftp.Connect();
   Form3.ftp.ChangeDir(Lmagaz);
    except
    try
     Form3.ftp.Disconnect;
      except
        end;
   Exit;
      end;

  try
  Form3.ftp.get(LFileName,extractfilepath(paramstr(0))+'\temp\'+LFileName,true,false);
  Form3.ftp.Disconnect;
  except
    try
      Form3.ftp.Disconnect;
      except
        end;
    ShowMessage('Не могу получить файл с FTP!');
    Exit;
    end;

   with form3.zp1 do
      try
      FileName:=extractfilepath(paramstr(0))+'\temp\'+LFileName;
      OpenArchive(fmOpenRead);
      BaseDir:=extractfilepath(paramstr(0))+'\temp\';
      ExtractFiles('*.*');
      CloseArchive;
      except
       ShowMessage('Не могу распаковать архив '+Filename);
       Exit;
        end;

  clear:=False;
  s:='';
  h:=0;
 // Проверяем на ключ очистки
 //****************************
 try
 AssignFile(demo,'temp\demo.spr');
 Reset(demo);
 while not Eof(demo) do
   begin
   Readln(demo,s);
   if AnsiPos('$$$CLR',s)>0 then
    begin
    clear:=True;
    Break;
    end;
   end;
 CloseFile(demo);
 except
  ShowMessage('Ошибка доступа к demo.spr');
  Exit;
   end;
 //****************************

 if clear then
 begin
  Form3.Label2.Font.Color:=clRed;
  Form3.Label2.Caption:='ЕСТЬ';
  end else
  begin
   Form3.Label2.Font.Color:=clGreen;
   Form3.Label2.Caption:='НЕТ';
    end;
   // чистим БД.
 //****************************
  if FileExists('base\database.dbf') then
   if not DeleteFile('base\database.dbf') then Exit;

    // Пробуем создать DBF для товаров
 try
   if not FileExists('base\database.dbf') then
    begin
    Form3.dbf3.TableName:='base\database.dbf';
    Form3.dbf3.Exclusive:=false;
    Form3.dbf3.AddFieldDefs('kod',bfString,8,0);
    Form3.dbf3.AddFieldDefs('nam',bfString,100,0);
    Form3.dbf3.AddFieldDefs('rub',bfString,15,0);
    Form3.dbf3.AddFieldDefs('date',bfString,20,0);
    Form3.dbf3.AddFieldDefs('kol',bfString,15,0);
    Form3.dbf3.AddFieldDefs('bar1',bfString,13,0);
    Form3.dbf3.AddFieldDefs('bar2',bfString,13,0);
    Form3.dbf3.AddFieldDefs('bar3',bfString,13,0);
    Form3.dbf3.AddFieldDefs('bar4',bfString,13,0);
    Form3.dbf3.AddFieldDefs('bar5',bfString,13,0);
    Form3.dbf3.AddFieldDefs('kt',bfString,1,0);
    Form3.dbf3.CreateTable;
    Form3.DBF3.close;
     end;
    except
      Exit;
    end;




 AssignFile(demo,extractfilepath(paramstr(0))+'\temp\demo.spr');
 Reset(demo);
  try
      //Открываем БД
   Form3.dbf3.TableName:='base\database.dbf';
   form3.dbf3.Exclusive:=false;
   form3.DBF3.Open;
  except
    try
      Form3.DBF3.Close;
      except
        end;
    exit;
    end;
 //****************************
 // Заполняем БД данными из файла (Новые позиции)
 while not Eof(demo) do
 begin
 // Читаем строку в переменную
  Readln(demo,s);
  if Length(s)>10 then
  if IsDigit(s[1]) then
  begin
    n:=1;
    tovar.kod:='';
    tovar.nam:='';
    tovar.bar:='';
    tovar.rub:='';
    tovar.date:='';
    tovar.kt:='';
   for i:=1 to Length(s) do
    if s[i]<>';' then
    begin
      if n=1 then
       tovar.kod:=tovar.kod+s[i];

      if n=2 then
       tovar.bar:=tovar.bar+s[i];

      if n=3 then
       tovar.nam:=tovar.nam+s[i];

      if n=5 then
       tovar.rub:=tovar.rub+s[i];

      if n=8 then
       tovar.kt:=tovar.kt+s[i];
    end
    else
      begin
      n:=n+1;
      Continue;
      end;
    tovar.date:=GetDateT;
    // Пишем в БД
   if not form3.DBF3.IsEmpty then
     form3.DBF3.First;
   indb:=false;
   if not form3.DBF3.IsEmpty then
     for i:=1 to Form3.DBF3.RecordCount do
     begin
       {Ищем дубли в БД перед вставкой}
      if form3.DBF3.GetFieldData(1)=tovar.kod then
            begin
//            Form1.dbf3.SetFieldData(1,tovar.kod);
            Form3.dbf3.SetFieldData(2,tovar.nam);
            Form3.dbf3.SetFieldData(3,tovar.rub);
            Form3.dbf3.SetFieldData(4,tovar.date);
            Form3.dbf3.SetFieldData(6,tovar.bar);
            Form3.dbf3.SetFieldData(11,tovar.kt);
            Form3.DBF3.Post;
            indb:=True;
            end;
      if indb then Break; // Если нашли дубль, то дальше можно не искать.
      form3.DBF3.Next;
     end;

   // Если нету в БД, добавляем новой строкой
   if not indb then
          begin
            Form3.DBF3.Append;
            Form3.dbf3.SetFieldData(1,tovar.kod);
            Form3.dbf3.SetFieldData(2,tovar.nam);
            Form3.dbf3.SetFieldData(3,tovar.rub);
            Form3.dbf3.SetFieldData(4,tovar.date);
            Form3.dbf3.SetFieldData(6,tovar.bar);
            Form3.dbf3.SetFieldData(11,tovar.kt);
            Form3.DBF3.Post;
          end;

  end else
  if (s[1]='#') and IsDigit(s[2]) then
    begin
       n:=1;
    tovar.kod:='';
    tovar.nam:='';
    tovar.bar:='';
    tovar.rub:='';
    tovar.date:='';
    tovar.kt:='';
   for i:=2 to Length(s) do
    if (s[i]<>';') then
    begin
      if n=1 then
       tovar.kod:=tovar.kod+s[i];

      if n=2 then
       tovar.bar:=tovar.bar+s[i];

      if n=4 then
       tovar.nam:=tovar.nam+s[i];

      if n=5 then
       tovar.rub:=tovar.rub+s[i];

    end else
      begin
      n:=n+1;
      Continue;
      end;
    tovar.date:=GetDateT;
    // Пишем в БД
    Form3.DBF3.First;
    for i:=1 to Form3.DBF3.RecordCount do begin
      if form3.DBF3.GetFieldData(1)=tovar.kod then
      begin
       Pbar:=false;
       for j:=6 to 10 do
          if Form3.DBF3.GetFieldData(j)=tovar.bar then
            begin
            PBAR:=True;
            Break;
            end;
       if PBar then Break;

        for j:=6 to 10 do
          if Form3.DBF3.GetFieldData(j)='' then
            begin
            Form3.DBF3.SetFieldData(j,tovar.bar);
            form3.DBF3.SetFieldData(4,tovar.date);
            Break;
            end;
       Break;
      end;
      form3.DBF3.Next;
        end;
    Form3.DBF3.Post;

   end;

 end;
 // Закрываем файл и БД
 try
 CloseFile(demo);
 // Закрываем БД
    Form3.DBF3.Close;
 except
   end;
   DeleteFile(extractfilepath(paramstr(0))+'\temp\demo.spr');
   DeleteFile(extractfilepath(paramstr(0))+'\temp\'+LFileName);
   DeleteFile(extractfilepath(paramstr(0))+'\temp\'+copy(LFileName,1,8)+'.txt');
 end;



procedure TForm3.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=False;
getdemo(GFileName,GMagaz);
flood;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
Form3.Visible:=False;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
sg1.Cells[0,0]:='№:';
sg1.Cells[1,0]:='Код товара:';
sg1.Cells[2,0]:='Наименование товара:';
sg1.Cells[3,0]:='ШК:';
sg1.Cells[4,0]:='Цена:';
end;

procedure TForm3.sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  // Прорисовываем заголовки таблицы
  if (ARow=0) then
  with sg1 do
  begin
   Canvas.Font.Color:=clBlue;
   Canvas.Font.Style:=[fsBold];
   Canvas.TextOut(Rect.Left+2,Rect.Top+2,sg1.Cells[Acol,Arow]);
   Exit;
   end;
end;

procedure TForm3.sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 PutBar(Arow);
end;

procedure TForm3.Button2Click(Sender: TObject);
var i,m:Integer;
begin
  m:=Form3.sg1.Selection.Top;
 for i:=m+1 to Form3.sg1.RowCount do
  begin
  if CheckBox1.checked then
    if AnsiPos(LabeledEdit1.Text,sg1.Cells[1,i])>0 then
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
    if AnsiPos(alphamin(LabeledEdit1.Text),alphamin(sg1.Cells[2,i]))>0 then
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
    if AnsiPos(LabeledEdit1.Text,sg1.Cells[4,i])>0 then
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
  LabeledEdit1.SetFocus;
  Button2.Default:=True;
  Button3.Default:=False;
end;



procedure TForm3.Button3Click(Sender: TObject);
var i,m:Integer;
begin
  m:=Form3.sg1.Selection.Top;
 for i:=m-1 downto 1 do
  begin
  if CheckBox1.checked then
    if AnsiPos(LabeledEdit1.Text,sg1.Cells[1,i])>0 then
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
    if AnsiPos(alphamin(LabeledEdit1.Text),alphamin(sg1.Cells[2,i]))>0 then
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
    if AnsiPos(LabeledEdit1.Text,sg1.Cells[4,i])>0 then
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
  LabeledEdit1.SetFocus;
  Button2.Default:=False;
  Button3.Default:=True;
end;




procedure TForm3.LabeledEdit1Change(Sender: TObject);
begin
Button2.Default:=True;
Button3.Default:=False;
end;

end.
