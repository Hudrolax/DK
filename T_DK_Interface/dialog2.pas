unit dialog2;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, DBF;

type
  TExportDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Memo1: TMemo;
    DBF: TDBF;
    procedure CancelBtnClick(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportDialog: TExportDialog;

implementation

{$R *.dfm}
// Процедура формирования файла выгрузки
procedure ExportDemo(pos1,pos2,pos3,pos4:boolean);
var i,j:Integer;
f:TextFile;
s:string;
bars:integer;
begin
   // Открываем БД database.dbf
 try
  ExportDialog.DBF.TableName:='base\database.dbf';
  ExportDialog.DBF.Exclusive:=false;
  ExportDialog.DBF.Open;
  except
   Exit;
   end;

// Первая касса
if pos1 then
 begin
  ExportDialog.DBF.First;
  AssignFile(f,'c:\T_pos\pos01\demo.spr');
  Rewrite(f);
  Writeln(f,'##@@&&');
  Writeln(f,'#');
  for i:=1 to ExportDialog.DBF.RecordCount do
  begin
   bars:=0;
   // Смотрим сколько баркодов у товара
    for j:=6 to 10 do
      if ExportDialog.DBF.GetFieldData(j)<>'' then bars:=bars+1;
   // Записываем сам товар
   s:=ExportDialog.DBF.GetFieldData(1)+';'+ExportDialog.DBF.GetFieldData(6)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(3)+';0;0;'+ExportDialog.DBF.GetFieldData(11)+';0;0;0;0;0;0;0;0;1;';
   Writeln(f,s);
   // Если больше одного баркода, то дописываем стоки
   if bars>1 then
     for j:=7 to 10 do
      if ExportDialog.DBF.GetFieldData(j)<>'' then
   begin
    s:='#'+ExportDialog.DBF.GetFieldData(1)+';'+ExportDialog.DBF.GetFieldData(j)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(3)+';0;0;0;0;1;';
    Writeln(f,s);
   end;
   // Переходим на след. строку в БД
   ExportDialog.DBF.Next;
  end;
  CloseFile(f);
  AssignFile(f,'c:\T_pos\pos01\load.flz');
  Rewrite(f);
  CloseFile(f);
 end;

 //Вторая Касса
 if pos2 then
 begin
  ExportDialog.DBF.First;
  AssignFile(f,'c:\T_pos\pos02\demo.spr');
  Rewrite(f);
  Writeln(f,'##@@&&');
  Writeln(f,'#');
  for i:=1 to ExportDialog.DBF.RecordCount do
  begin
   bars:=0;
   // Смотрим сколько баркодов у товара
    for j:=6 to 10 do
      if ExportDialog.DBF.GetFieldData(j)<>'' then bars:=bars+1;
   // Записываем сам товар
   s:=ExportDialog.DBF.GetFieldData(1)+';'+ExportDialog.DBF.GetFieldData(6)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(3)+';0;0;'+ExportDialog.DBF.GetFieldData(11)+';0;0;0;0;0;0;0;0;1;';
   Writeln(f,s);
   // Если больше одного баркода, то дописываем стоки
   if bars>1 then
     for j:=7 to 10 do
      if ExportDialog.DBF.GetFieldData(j)<>'' then
   begin
    s:='#'+ExportDialog.DBF.GetFieldData(1)+';'+ExportDialog.DBF.GetFieldData(j)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(3)+';0;0;0;0;1;';
    Writeln(f,s);
   end;
   // Переходим на след. строку в БД
   ExportDialog.DBF.Next;
  end;
  CloseFile(f);
  AssignFile(f,'c:\T_pos\pos02\load.flz');
  Rewrite(f);
  CloseFile(f);
 end;

 //Третья касса
 if pos3 then
 begin
  ExportDialog.DBF.First;
  AssignFile(f,'c:\T_pos\pos03\demo.spr');
  Rewrite(f);
  Writeln(f,'##@@&&');
  Writeln(f,'#');
  for i:=1 to ExportDialog.DBF.RecordCount do
  begin
   bars:=0;
   // Смотрим сколько баркодов у товара
    for j:=6 to 10 do
      if ExportDialog.DBF.GetFieldData(j)<>'' then bars:=bars+1;
   // Записываем сам товар
   s:=ExportDialog.DBF.GetFieldData(1)+';'+ExportDialog.DBF.GetFieldData(6)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(3)+';0;0;'+ExportDialog.DBF.GetFieldData(11)+';0;0;0;0;0;0;0;0;1;';
   Writeln(f,s);
   // Если больше одного баркода, то дописываем стоки
   if bars>1 then
     for j:=7 to 10 do
      if ExportDialog.DBF.GetFieldData(j)<>'' then
   begin
    s:='#'+ExportDialog.DBF.GetFieldData(1)+';'+ExportDialog.DBF.GetFieldData(j)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(3)+';0;0;0;0;1;';
    Writeln(f,s);
   end;
   // Переходим на след. строку в БД
   ExportDialog.DBF.Next;
  end;
  CloseFile(f);
  AssignFile(f,'c:\T_pos\pos03\load.flz');
  Rewrite(f);
  CloseFile(f);
 end;

 // Четвертая касса
 if pos4 then
 begin
  ExportDialog.DBF.First;
  AssignFile(f,'c:\T_pos\pos04\demo.spr');
  Rewrite(f);
  Writeln(f,'##@@&&');
  Writeln(f,'#');
  for i:=1 to ExportDialog.DBF.RecordCount do
  begin
   bars:=0;
   // Смотрим сколько баркодов у товара
    for j:=6 to 10 do
      if ExportDialog.DBF.GetFieldData(j)<>'' then bars:=bars+1;
   // Записываем сам товар
   s:=ExportDialog.DBF.GetFieldData(1)+';'+ExportDialog.DBF.GetFieldData(6)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(3)+';0;0;'+ExportDialog.DBF.GetFieldData(11)+';0;0;0;0;0;0;0;0;1;';
   Writeln(f,s);
   // Если больше одного баркода, то дописываем стоки
   if bars>1 then
     for j:=7 to 10 do
      if ExportDialog.DBF.GetFieldData(j)<>'' then
   begin
    s:='#'+ExportDialog.DBF.GetFieldData(1)+';'+ExportDialog.DBF.GetFieldData(j)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(2)+';'+ExportDialog.DBF.GetFieldData(3)+';0;0;0;0;1;';
    Writeln(f,s);
   end;
   // Переходим на след. строку в БД
   ExportDialog.DBF.Next;
  end;
  CloseFile(f);
  AssignFile(f,'c:\T_pos\pos04\load.flz');
  Rewrite(f);
  CloseFile(f);
 end;


   // Закрываем БД
 try
  ExportDialog.DBF.Close;
 except
   end;
end;


procedure TExportDialog.CancelBtnClick(Sender: TObject);
begin
 ExportDialog.Visible:=False;
end;

procedure TExportDialog.CheckBox5Click(Sender: TObject);
begin
 if CheckBox5.Checked then
  begin
    // Выключаем все
    CheckBox1.Enabled:=False;
    CheckBox2.Enabled:=False;
    CheckBox3.Enabled:=False;
    CheckBox4.Enabled:=False;
  end
  else
    begin
       // Включаем все
     CheckBox1.Enabled:=True;
     CheckBox2.Enabled:=True;
     CheckBox3.Enabled:=True;
     CheckBox4.Enabled:=True;
    end;
end;

procedure TExportDialog.OKBtnClick(Sender: TObject);
begin
 If CheckBox5.Checked then
 begin
  ExportDemo(True,true,true,true);
  ExportDialog.Visible:=False;
  end else
  begin
   ExportDemo(CheckBox1.Checked,CheckBox2.Checked,CheckBox3.Checked,CheckBox4.Checked);
   ExportDialog.Visible:=False;
  end;
end;

end.
