unit userenter;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs;

type
  TOKBottomDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OKBottomDlg: TOKBottomDlg;

implementation

{$R *.dfm}

procedure TOKBottomDlg.CancelBtnClick(Sender: TObject);
begin
OKBottomDlg.Visible:=False;
end;

procedure TOKBottomDlg.OKBtnClick(Sender: TObject);
var f:TextFile;
begin
 if not FileExists(extractfilepath(paramstr(0))+'user.dat') then
 try
   AssignFile(f,extractfilepath(paramstr(0))+'user.dat');
   Rewrite(f);
   Writeln(f,edit1.text);
   CloseFile(f);
   OKBtn.Enabled:=False;
   CancelBtn.Caption:='Закрыть';
   except
   showmessage('Не могу записать файл user.dat!');
     end else showmessage('user.dat уже существует! Удалите старые настройки.');
end;

end.
