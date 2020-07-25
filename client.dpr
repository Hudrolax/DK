program client;

uses
  Forms,
  ftp_client in 'ftp_client.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
