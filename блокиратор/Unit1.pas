unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  f:file;
h:longInt;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
h:=fileOpen('c:\pos\pos02\transact.sdf',fmShareExclusive)
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
FileClose(h);
end;

end.
