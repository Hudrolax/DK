program T_dk_interface;



uses
  Forms,
  dkinterface in 'dkinterface.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4},
  Unit1 in 'Unit1.pas' {Frame12: TFrame},
  Unit5 in 'Unit5.pas' {Form5},
  Unit6 in 'Unit6.pas' {Form6},
  Unit7 in 'Unit7.pas' {Form7},
  passdial in 'passdial.pas' {PasswordDlg},
  nomencl in 'nomencl.pas' {Form8},
  serch in 'serch.pas' {Form9},
  dialog1 in 'dialog1.pas' {OKBottomDlg},
  dialog2 in 'dialog2.pas' {ExportDialog},
  prikazi in 'prikazi.pas' {Form10},
  prikazi2 in 'prikazi2.pas' {Form11},
  mail in 'mail.pas' {Form12},
  mail2 in 'mail2.pas' {Form13},
  sendmail in 'sendmail.pas' {Form14},
  kass_book in 'kass_book.pas' {Form15};

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
  Application.CreateForm(TPasswordDlg, PasswordDlg);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TOKBottomDlg, OKBottomDlg);
  Application.CreateForm(TExportDialog, ExportDialog);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm13, Form13);
  Application.CreateForm(TForm14, Form14);
  Application.CreateForm(TForm15, Form15);
  Application.Run;
end.
