unit term;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Gvar;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
form1.Visible:=False;
Timer1.Enabled:=False;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
termu:textfile;
process:TStringList;
notterm:Boolean;
i:Integer;
begin
  notterm:=False;
 try
   AssignFile(termu,'terminateu.txt');
   Rewrite(termu);
   CloseFile(termu);
   except
     end;

 try
  if FileExists('dkrupdater.exe_') then
  DeleteFile('dkrupdater.exe') else Application.Terminate;
  
  if RenameFile('dkrupdater.exe_','dkrupdater.exe') then
  begin
      DeleteFile('terminateu.txt');
    WinExec ('dkrupdater.exe', SW_MINIMIZE);
    WinExec ('dk_interface.exe', SW_MINIMIZE);
    Application.Terminate;
    end;

 except
   end;
     

end;

end.
