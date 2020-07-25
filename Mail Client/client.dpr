program client;

uses
  Forms,
  Mail_Client in 'Mail_Client.pas' {Form1},
  table in 'table.pas' {Form2},
  userenter in 'userenter.pas' {OKBottomDlg},
  upmessage in 'upmessage.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TOKBottomDlg, OKBottomDlg);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
