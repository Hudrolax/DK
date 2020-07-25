unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Gvar, StdCtrls, ShlObj, shellapi;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function GetSpecialPath(CSIDL: word): string;
var
  Form1: TForm1;

implementation

{$R *.dfm}
function GetSpecialPath(CSIDL: word): string;
var s:  string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
  then s := '';
  result := PChar(s);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
ShowMessage(GetSpecialPath(CSIDL_COMMON_STARTUP));
end;

end.
