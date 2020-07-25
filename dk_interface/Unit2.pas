unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
 try
  memo1.Lines.LoadFromFile('about.txt');
  except
    ShowMessage('Не могу найти файл about.txt!');
    end;
 end;

procedure TForm2.Button1Click(Sender: TObject);
begin
Form2.Visible:=False;
end;

end.
