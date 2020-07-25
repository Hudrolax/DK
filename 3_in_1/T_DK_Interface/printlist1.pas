unit printlist1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBF, Gvar,
  RpRenderPreview, RpRender, RpRenderCanvas,
  RpRenderPrinter, RpDefine, RpRave, RpBase, RpSystem, RvCsStd, RvClass, RvProj;

type
  TForm16 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Timer1: TTimer;
    DBF: TDBF;
    RvProject1: TRvProject;
    RvSystem1: TRvSystem;
    RvRenderPrinter1: TRvRenderPrinter;
    RvRenderPreview1: TRvRenderPreview;
    Edit1: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TTovar = record
    kod:string[14];
    bar:string[14];
    name:string[50];
    art:string[14];
    proizvod:string[50];
    cena:string[10];
    Ed:string[10];
    Prikaz:string[15];

  end;

var
  Form16: TForm16;
   Tovar:array of TTovar;
   rvMem:TRaveMemo;
rvPage: TRavePage;
implementation

{$R *.dfm}
procedure ReloadList;
var i:integer;
begin
 Form16.ListBox1.Clear;
 if Length(PrintList) > 0 then
   for i:=0 to Length(PrintList)-1 do
    Form16.ListBox1.Items.Append(PrintList[i].kod+' - '+PrintList[i].name);
end;

procedure DelList;
var i:integer;
s,s1:string;
pl:array of TPrintList;
begin
  if form16.ListBox1.ItemIndex=-1 then Exit;
 s:= form16.ListBox1.Items.Strings[form16.ListBox1.itemIndex];
 for i:=1 to length(s) do
  if copy(s,i,1)<>' ' then
    s1:=s1+copy(s,i,1)
  else break;
 if Length(PrintList) > 0 then
   for i:=0 to Length(PrintList)-1 do
    if PrintList[i].kod = s1 then
        begin
          PrintList[i].kod:='';
          PrintList[i].name:='';
          Break;
          end;
 if NOT IsDigit(s1) then Exit;
 SetLength(pl,0);
   for i:=0 to length(PrintList)-1 do
    if PrintList[i].kod <> '' then
    begin
     SetLength(pl,length(pl)+1);
     pl[length(pl)-1].kod:=Printlist[i].kod;
     pl[length(pl)-1].name:=Printlist[i].name;
    end;
   SetLength(PrintList,0);
   SetLength(PrintList,length(pl));
   for i:=0 to length(pl)-1 do
    begin
     PrintList[i].kod := pl[i].kod;
     PrintList[i].name := pl[i].name;
    end;
  ReloadList;
end;

procedure TForm16.Button1Click(Sender: TObject);
begin
 ListBox1.Clear;
 Form16.Visible := false;
end;

procedure TForm16.Timer1Timer(Sender: TObject);
begin
 timer1.Enabled:=false;
 ReloadList;
end;

procedure PrintT;
var i,j,inter,nom,magazz:integer;
dop,ccod:string;
codes:TCodeString;
PlusText:string;
NumInStr:integer;
begin
  try
  // Открываем БД
   Form16.DBF.TableName:='base\database'+form16.edit1.text+'.dbf';
   Form16.DBF.Exclusive:=false;
   Form16.DBF.Open;
   magazz:=strtoint(form16.Edit1.Text);
  except
    ShowMessage('Не выбран магазин в номенклатуре!');
    Exit;
  end;
  if form16.DBF.RecordCount = 0 then
    begin
      ShowMessage('В базе данных нет информации о товаре!');
      Exit;
      end;
  // Читаем всю инфу о нужном товаре
  SetLength(Tovar,0);
  if Form16.RadioButton1.Checked then
    NumInStr:=9
  else if Form16.RadioButton2.Checked then
    NumInStr:=14
  else if Form16.RadioButton3.Checked then
    NumInStr:=20;

  PlusText:='';
  if Form16.RadioButton2.Checked then
     PlusText:='_new'
  else if Form16.RadioButton3.Checked then
     PlusText:='_2new';

  // Тут считываем все из БД в переменные
  for i:=0 to length(PrintList)-1 do
    begin
     form16.DBF.First;
     for j:=1 to form16.DBF.RecordCount do
      begin
        codes:=CodeStringToArray(form16.DBF.GetFieldData(1));
        ccod:=codes[length(codes)-1];
        if ccod = PrintList[i].kod then
          begin
           SetLength(Tovar,length(Tovar)+1);
           Tovar[Length(Tovar)-1].kod:=ccod;
           Tovar[Length(Tovar)-1].bar:=form16.DBF.GetFieldData(6);
           Tovar[Length(Tovar)-1].name:=form16.DBF.GetFieldData(2);
           Tovar[Length(Tovar)-1].art:=form16.DBF.GetFieldData(12);
           if Tovar[Length(Tovar)-1].art = '0' then Tovar[Length(Tovar)-1].art:='';
           Tovar[Length(Tovar)-1].proizvod:=form16.DBF.GetFieldData(13);
           if Tovar[Length(Tovar)-1].proizvod = '0' then Tovar[Length(Tovar)-1].proizvod:='';
           Tovar[Length(Tovar)-1].cena:=form16.DBF.GetFieldData(3);
           Tovar[Length(Tovar)-1].Ed:=form16.DBF.GetFieldData(14);
           if Tovar[Length(Tovar)-1].Ed = '0' then Tovar[Length(Tovar)-1].Ed:='';
           Tovar[Length(Tovar)-1].Prikaz:=form16.DBF.GetFieldData(15);
          end;
        form16.DBF.Next;
      end;
    end;
  form16.DBF.Close;

  
 inter:=length(Tovar) div NumInStr;
 nom:=1;
 if inter > 0 then
  begin
    for i:=1 to inter do
    begin
     form16.RvProject1.ProjectFile:='Template'+PlusText+inttostr(NumInStr)+'.rav';
     form16.RvProject1.Open;
     form16.RvProject1.SelectReport('Report1',false);
     for j:=1 to NumInStr do
      begin
        dop:=inttostr(j);
        if dop='1' then dop:='';
        form16.RvProject1.SetParam('Name'+dop,Tovar[nom-1].name);
        form16.RvProject1.SetParam('Kod'+dop,Tovar[nom-1].kod);
        form16.RvProject1.SetParam('Cena'+dop,Tovar[nom-1].cena);
        form16.RvProject1.SetParam('Izgot'+dop,Tovar[nom-1].proizvod);
        form16.RvProject1.SetParam('Ed'+dop,Tovar[nom-1].Ed);
        form16.RvProject1.SetParam('Data'+dop,Datetostr(Date));
        form16.RvProject1.SetParam('Firma'+dop,Magaz[magazz].Firm);
        form16.RvProject1.SetParam('Bar'+dop,Tovar[nom-1].bar);
        form16.RvProject1.SetParam('Prikaz'+dop,Tovar[nom-1].Prikaz);
        if (NOT Form16.RadioButton2.Checked) then
        begin
         form16.RvProject1.SetParam('Art'+dop,Tovar[nom-1].art);
        end;
        nom:=nom+1;
      end;
     form16.RvProject1.ExecuteReport('Report1');
     form16.RvProject1.Close;
    end;
  end;
 inter:=length(Tovar)-inter*NumInStr;
 if inter = 0 then Exit;
 // Печатаем остаток
 form16.RvProject1.ProjectFile:='Template'+PlusText+inttostr(inter)+'.rav';
 form16.RvProject1.Open;
 form16.RvProject1.SelectReport('Report1',false);
 for i:=1 to inter do
  begin
    dop:=inttostr(i);
    if dop='1' then dop:='';
//    rvPage := form16.RvProject1.ProjMan.FindRaveComponent('Report1.Page1', nil) as TRavePage;
//    rvMem := form16.RvProject1.ProjMan.FindRaveComponent('DataMemo'+dop, rvPage) as TRaveMemo;
//    rvMem.Font.Size:=20;
//    if Length(Tovar[nom-1].name)>18 then
//      rvMem.Font.Size:=18;
//    if Length(Tovar[nom-1].name)>30 then
//      rvMem.Font.Size:=16;
    form16.RvProject1.SetParam('Name'+dop,Tovar[nom-1].name);
    form16.RvProject1.SetParam('Kod'+dop,Tovar[nom-1].kod);
    form16.RvProject1.SetParam('Cena'+dop,Tovar[nom-1].cena);
    form16.RvProject1.SetParam('Izgot'+dop,Tovar[nom-1].proizvod);
    form16.RvProject1.SetParam('Ed'+dop,Tovar[nom-1].Ed);
    form16.RvProject1.SetParam('Data'+dop,Datetostr(Date));
    form16.RvProject1.SetParam('Firma'+dop,Magaz[magazz].Firm);
    form16.RvProject1.SetParam('Bar'+dop,Tovar[nom-1].bar);
    form16.RvProject1.SetParam('Prikaz'+dop,Tovar[nom-1].Prikaz);
    if (NOT Form16.RadioButton2.Checked) then
      begin
        form16.RvProject1.SetParam('Art'+dop,Tovar[nom-1].art);
      end;
    nom:=nom+1;
  end;
 form16.RvProject1.ExecuteReport('Report1');
 form16.RvProject1.Close;
// RvProject1.Open;
// RvProject1.SelectReport('Report1',false);
// TovName:= 'Голд Классик 0,95';
//
//  rvPage := RvProject1.ProjMan.FindRaveComponent('Report1.Page1', nil) as TRavePage;
//  rvMem := RvProject1.ProjMan.FindRaveComponent('DataMemo1', rvPage) as TRaveMemo;
//  rvMem.Font.Size:=20;
//
//  if Length(TovName)>18 then
//    rvMem.Font.Size:=18;
//
//  if Length(TovName)>30 then
//    rvMem.Font.Size:=16;
//
// RvProject1.SetParam('Name',TovName);
// RvProject1.SetParam('Prikaz','k0350678');
// RvProject1.SetParam('Bar','9000002536171');
// RvProject1.SetParam('Kod','253 617');
// RvProject1.SetParam('Cena','32-50');
// RvProject1.SetParam('Data',Datetostr(Date));
// RvProject1.ExecuteReport('Report1');
// RvProject1.Close;
end;

procedure TForm16.Button3Click(Sender: TObject);
begin
 If ListBox1.Items.Count = 0 then
  ShowMessage('Нет элементов для печати!')
 Else
  PrintT;
end;

procedure TForm16.Button2Click(Sender: TObject);
begin
DelList;
end;

end.
