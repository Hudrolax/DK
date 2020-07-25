unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
// Определение системной папки
function GetSystemDir:string;
var
  a : Array[0..144] of char;
begin
//  GetWindowsDirectory(a, sizeof(a));
//  ShowMessage(StrPas(a));
  GetSystemDirectory(a, sizeof(a));
Result:=StrPas(a);
end;


procedure TForm1.Timer1Timer(Sender: TObject);
var
f:TextFile;
begin
 Form1.Visible:=False;

  try
  if not FileExists(GetSystemDir+'\Mfcans32.dll') then
    CopyFile(PChar('Mfcans32.dll'),PChar(GetSystemDir+'\Mfcans32.dll'),false);
  if not FileExists(GetSystemDir+'\msvcrt20.dll') then
    CopyFile(PChar('msvcrt20.dll'),PChar(GetSystemDir+'\msvcrt20.dll'),false);
  if not FileExists(GetSystemDir+'\Oc30.dll') then
    CopyFile(PChar('Oc30.dll'),PChar(GetSystemDir+'\Oc30.dll'),false);
  if not FileExists(GetSystemDir+'\Vcf132.ocx') then
    begin
    CopyFile(PChar('Vcf132.ocx'),PChar(GetSystemDir+'\Vcf132.ocx'),false);
    AssignFile(f,'regdll.bat');
    Rewrite(f);
    Writeln(f,'regsvr32.exe /s vcf132.ocx');
    Writeln(f,'start client.exe');
    CloseFile(f);

    WinExec('regdll.bat',SW_NORMAL);
    DeleteFile('regdll.bat');
    Application.Terminate;
    end;
   except
     ShowMessage('Не удалось зарегистрировать компонент.');
     Application.Terminate;
     end;
  Close;
end;

end.
