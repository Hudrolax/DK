program DKConsole;

uses
  Forms,
  acon in 'acon.pas' {Form1},
  report1 in 'report1.pas' {Form2},
  nomencl in 'nomencl.pas' {Form3},
  dlg1 in 'dlg1.pas' {Form4},
  db in 'db.pas' {Form5},
  zapros1 in 'zapros1.pas' {Form6},
  zapros2 in 'zapros2.pas' {Form7},
  settings in 'settings.pas' {Form8};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.Run;
end.
