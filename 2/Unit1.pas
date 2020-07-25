unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function GetSystemDir:string;
var
  a : Array[0..144] of char;
begin
//  GetWindowsDirectory(a, sizeof(a));
//  ShowMessage(StrPas(a));
  GetSystemDirectory(a, sizeof(a));
Result:=StrPas(a);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
CopyFile('Mfcans32.dll',GetSystemDir+'\Mfcans32.dll',false);
CopyFile('msvcrt20.dll',GetSystemDir+'\msvcrt20.dll',false);
CopyFile('Oc30.dll',GetSystemDir+'\Oc30.dll',false);
CopyFile('Vcf132.ocx',GetSystemDir'\Vcf132.ocx',false);
WinExec('run.bat',SW_NORMAL);
end;
end.
