program dk_interface;

uses
  Forms,
  dkinterface in '..\dk_interface\dkinterface.pas' {Form1},
  Unit2 in '..\dk_interface\Unit2.pas' {Form2},
  Unit3 in '..\dk_interface\Unit3.pas' {Form3},
  Unit4 in '..\dk_interface\Unit4.pas' {Form4},
  Unit1 in '..\dk_interface\Unit1.pas' {Frame12: TFrame},
  Unit5 in '..\dk_interface\Unit5.pas' {Form5},
  Unit6 in '..\dk_interface\Unit6.pas' {Form6},
  Unit7 in '..\dk_interface\Unit7.pas' {Form7};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DK Report Interface';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.
