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
   h:LongInt;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  h:=FileOpen('c:\pos\pos01\pos.rep',fmShareExclusive);
if h>0 then
 ShowMessage('Не заблокирован!') else ShowMessage('ЗАБЛОКИРОАН!');
 FileClose(h);
end;

end.
