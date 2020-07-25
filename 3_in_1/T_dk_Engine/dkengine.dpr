program dkengine;

uses
  Forms,
  engine in 'engine.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DK Report Engine';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
