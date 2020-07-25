unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBF, StdCtrls, Gvar;

type
  TForm1 = class(TForm)
    Button1: TButton;
    DBF: TDBF;
    ListBox1: TListBox;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
 end;
var
  Form1: TForm1;
  tovar:Ttovar;

implementation

{$R *.dfm}
procedure getdemo;
var
demo:textfile;
s:string;
i,n,j:Integer;
clear,indb:Boolean;
begin
  clear:=False;
  s:='';
 // Проверяем на ключ очистки
 //****************************
 try
 AssignFile(demo,'demo.spr');
 Reset(demo);
 while not Eof(demo) do
   begin
   Readln(demo,s);
   if s='$$$CLR' then clear:=True;
   end;
 CloseFile(demo);
 except
  ShowMessage('Ошибка доступа к demo.spr');
  Exit;
   end;
 //****************************

 AssignFile(demo,'demo.spr');
 Reset(demo);
 //Открываем БД
   Form1.dbf.TableName:='base\database.dbf';
   form1.dbf.Exclusive:=false;
   form1.DBF.Open;
   // Если стоит ключ очистки: чистим БД.
 //****************************
  if not form1.DBF.IsEmpty then
  try
   if clear then
   begin
   form1.DBF.Deleted:=True;
   for i:=1 to form1.DBF.FieldCount do
     begin
      Form1.DBF.Next;
      form1.DBF.Deleted:=True;
     end;
     Form1.DBF.PackTable;
   end;
   except
     ShowMessage('Ошибка доступа к БД database.dbf');
     Exit;
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
    end
    else
      begin
      n:=n+1;
      Continue;
      end;
    tovar.date:=GetDateT;
    // Пишем в БД
   if not form1.DBF.IsEmpty then
     form1.DBF.First;
   indb:=false;
   if not form1.DBF.IsEmpty then
     for i:=1 to Form1.DBF.FieldCount do
     begin
      if form1.DBF.GetFieldData(1)=tovar.kod then
            begin
            Form1.dbf.SetFieldData(1,tovar.kod);
            Form1.dbf.SetFieldData(2,tovar.nam);
            Form1.dbf.SetFieldData(3,tovar.rub);
            Form1.dbf.SetFieldData(4,tovar.date);
            Form1.dbf.SetFieldData(6,tovar.bar);
            indb:=True;
            Break;
            end;
      form1.DBF.Next;
     end;

   if not indb then
          begin
            Form1.DBF.Append;
            Form1.dbf.SetFieldData(1,tovar.kod);
            Form1.dbf.SetFieldData(2,tovar.nam);
            Form1.dbf.SetFieldData(3,tovar.rub);
            Form1.dbf.SetFieldData(4,tovar.date);
            Form1.dbf.SetFieldData(6,tovar.bar);
          end;
    Form1.DBF.Post;

  end else
  if (s[1]='#') and IsDigit(s[2]) then
    begin
       n:=1;
    tovar.kod:='';
    tovar.nam:='';
    tovar.bar:='';
    tovar.rub:='';
    tovar.date:='';
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
    Form1.DBF.First;
    for i:=1 to Form1.DBF.FieldCount do begin
      if form1.DBF.GetFieldData(1)=tovar.kod then
      begin
        for j:=6 to 10 do
          if Form1.DBF.GetFieldData(j)='' then
            begin
            Form1.DBF.SetFieldData(j,tovar.bar);
            form1.DBF.SetFieldData(4,tovar.date);
            Break;
            end;
       Break;
      end;
      form1.DBF.Next;
        end;
    Form1.DBF.Post;

   end;

 end;
 // Закрываем файл и БД
 try
 CloseFile(demo);
 // Закрываем БД
    Form1.DBF.Close;
 except
   end;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  dbf.TableName:='database.dbf';
  dbf.Exclusive:=false;
  DBF.Open;

   DBF.Deleted:=True;
   DBF.PackTable;
            
  DBF.Close;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    dbf.TableName:='database.dbf';
  dbf.Exclusive:=false;
  DBF.Open;
  ListBox1.Items.Add(DBF.GetFieldData(1)+' '+DBF.GetFieldData(2)+' '+DBF.GetFieldData(3));
  DBF.Close;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 getdemo;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  try
  if not FileExists('base\database.dbf') then begin
   dbf.TableName:='base\database.dbf';
   dbf.Exclusive:=false;
//   writeln(log,Getdatet+' Файла download.dbf нет. Пробую создать.');
   dbf.AddFieldDefs('kod',bfString,8,0);
   dbf.AddFieldDefs('nam',bfString,100,0);
   dbf.AddFieldDefs('rub',bfString,15,0);
   dbf.AddFieldDefs('date',bfString,20,0);
   dbf.AddFieldDefs('kol',bfString,15,0);
   dbf.AddFieldDefs('bar1',bfString,13,0);
   dbf.AddFieldDefs('bar2',bfString,13,0);
   dbf.AddFieldDefs('bar3',bfString,13,0);
   dbf.AddFieldDefs('bar4',bfString,13,0);
   dbf.AddFieldDefs('bar5',bfString,13,0);
   dbf.CreateTable;
   DBF.close;
//  writeln(log,Getdatet+' Файл download.dbf создан.');
  end;
  except
//    writeln(log,Getdatet+' Не могу создать файл download.dbf.');
    end;
end;

end.
