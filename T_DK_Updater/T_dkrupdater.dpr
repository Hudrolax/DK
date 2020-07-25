program T_dkrupdater;

uses
  Forms,
  dkupdater in 'dkupdater.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DK Report Updater';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
