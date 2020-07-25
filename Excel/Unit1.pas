unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AxCtrls, OleCtrls, VCF1, StdCtrls, VCFI, OleServer, WordXP;

type
  TForm1 = class(TForm)
    F1Book1: TF1Book;
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

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var k: smallint;
efile:WideString;
i,j:Integer;
begin
k:=F1FileExcel5;
efile:='1.xls';
F1Book1.Read(efile,k);
end;

procedure TForm1.Button2Click(Sender: TObject);
var i,j:Integer;
begin
 for i:=1 to 15 do
  for j:=1 to 5000 do
  begin
    F1Book1.SetActiveCell(j,i);//выбираем куда писать
    F1book1.SetFont('Courier New Cyr',10,false,false,false,false,0,false,false); //выставляем кирилический шрифт
    end;

end;

end.
