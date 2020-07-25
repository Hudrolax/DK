unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm7 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
begin
Form7.Visible:=False;
end;

procedure TForm7.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=False;
try
memo1.Lines.LoadFromFile('help.txt');
except
  ShowMessage('Не могу найти файл help.txt!');
  end;
end;

end.
