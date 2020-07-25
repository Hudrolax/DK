unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dbf, Grids, DBGrids, StdCtrls, DB, DBTables, ExtCtrls, DBCtrls,
  Menus;

type
  TForm1 = class(TForm)
    Button1: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    Exit1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  tabdbf: TDbf;
  
implementation

{$R *.dfm}

// connect
procedure TForm1.Button1Click(Sender: TObject);
begin
if Button1.Caption='Connect' then
  begin
    tabdbf.Active:=True;
    DataSource1.DataSet:=tabdbf;
    Button2.Enabled:=True;
    Button3.Enabled:=True;
    CheckBox1.Enabled:=True;
    Button1.Caption:='Disconnect';
  end else
  begin
    tabdbf.Active:=False;
    Button2.Enabled:=False;
    Button3.Enabled:=False;
    CheckBox1.Enabled:=False;
    Button1.Caption:='Connect';
  end;
end;

// show del
procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if CheckBox1.Checked=True then tabdbf.ShowDeleted:=True
else tabdbf.ShowDeleted:=False;
tabdbf.Resync([]);
end;

// clear
procedure TForm1.Button2Click(Sender: TObject);
begin
  while not tabdbf.Eof do
  tabdbf.Delete;
end;

// pack
procedure TForm1.Button3Click(Sender: TObject);
begin
tabdbf.PackTable;
end;

// create form
procedure TForm1.FormCreate(Sender: TObject);
begin
  tabdbf:=TDbf.Create(Form1);
  tabdbf.Name:='TABL';
  tabdbf.TableName:='zar.DBF';
end;

// exit
procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

// help
procedure TForm1.Help1Click(Sender: TObject);
begin
  MessageBox(GetActiveWindow, 'Тест экспорта данных в DBF файл'+ #13#10+ 'Оленев Сергей, 2002г.' + #13#10+ 'e-mail: toolsmarket@mail.ru', 'Help', MB_ICONINFORMATION OR MB_OK);
end;

end.
