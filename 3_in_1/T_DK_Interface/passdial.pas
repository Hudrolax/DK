unit passdial;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons,Gvar,Dialogs;

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PasswordDlg: TPasswordDlg;

implementation

{$R *.dfm}

procedure TPasswordDlg.CancelBtnClick(Sender: TObject);
begin
 PasswordDlg.Visible:=False;
end;

procedure TPasswordDlg.OKBtnClick(Sender: TObject);
begin
 if Password.Text='7950295' then
    begin
     ADMMod:=True;
     Password.Text:='';
     PasswordDlg.Visible:=False;
    end else
    begin
     ShowMessage('Не верный пароль!');
     Sleep(1000);
     Password.Text:='';
     end;
end;

end.
 
