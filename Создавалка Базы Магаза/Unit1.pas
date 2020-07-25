unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBF, Gvar;

type
  TForm1 = class(TForm)
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    lbl1: TLabel;
    edt1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    DBF1: TDBF;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var i,j:Integer;
prefix:string;
nmagaz,npostupl:string;
begin
 // Установим префикс архивов
 if RadioButton1.Checked then prefix:='k' else
  if RadioButton2.Checked then prefix:='t';

 // Приведем номер магаза к 3-х значному виду
 nmagaz:=Edit2.Text;
 for i:=2 downto Length(Edit2.Text) do
  nmagaz:='0'+nmagaz;

 // ************ Предупреждения ****************
 if (not IsDigit(Edit1.Text)) or (not IsDigit(Edt1.Text)) then begin
   ShowMessage('Ошибка в интервале поступлений!!');
   Exit;
   end;

 if not IsDigit(Edit2.Text) then begin
   ShowMessage('Ошибка в номере магазина!!');
   Exit;
   end;

  if StrToInt(Edit1.Text)>StrToInt(edt1.Text) then begin
   ShowMessage('Ошибка! Начальный номер поступлений больше конечного!');
   Exit;
   end;

 if (Edit1.Text='') or (edt1.Text='') then begin
   ShowMessage('Задайте интервал поступлений!');
   Exit;
   end;

 if Edit2.Text='' then
 begin
   ShowMessage('Задайте номер магазина!');
   Exit;
 end;

 if Length(Edit2.Text)>3 then
  begin
    ShowMessage('Номер магазина не может превышать 3 знака.');
    Exit;
    end;
 // *********************************************

 npostupl:='';
     //Пробуем создать БД download.dbf
 try
  dbf1.TableName:='download.dbf';
  if not FileExists('download.dbf') then begin
   dbf1.AddFieldDefs('NFILE',bfString,20,0);
   dbf1.AddFieldDefs('DFILE',bfString,50,0);
   dbf1.AddFieldDefs('TOPOS01',bfString,1,0);
   dbf1.AddFieldDefs('TOPOS02',bfString,1,0);
   dbf1.AddFieldDefs('TOPOS03',bfString,1,0);
   dbf1.AddFieldDefs('TOPOS04',bfString,1,0);
   dbf1.CreateTable;
    end else
    begin
      ShowMessage('download.dbf уже есть в папке с программой. Удалите старую БД!');
      Exit;
      end;
  except
    end;


 for i:=StrToInt(edit1.text) to StrToInt(edt1.Text) do
  begin
     // Приведем номер магаза к 3-х значному виду
      npostupl:=IntToStr(i);
     for j:=3 downto Length(IntToStr(i)) do
       npostupl:='0'+npostupl;

   DBF1.Append;
   DBF1.SetFieldData(1,prefix+nmagaz+npostupl+'.zip');
   DBF1.SetFieldData(2,GetDateT);
   DBF1.SetFieldData(3,'3');
   DBF1.SetFieldData(4,'3');
   DBF1.SetFieldData(5,'3');
   DBF1.SetFieldData(6,'3');
   DBF1.Post;
  end;


 try
   DBF1.close;
 except
 end;

 showmessage('БД download.dbf создана.');
end;

end.
