unit table;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AxCtrls, OleCtrls, VCF1, Gvar, ExtCtrls;

type
  TForm2 = class(TForm)
    F1Book1: TF1Book;
    Button1: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
procedure ClearTable;
var
i,j:Integer;
begin
 Form2.F1Book1.ClearRange(1,1,5000,20,F1ClearAll);
end;

procedure LoadTable;
var k: smallint;
efile:WideString;
i,j:Integer;
begin
  try
    k:=F1FileExcel5;
    efile:=FName;
    Form2.F1Book1.Read(efile,k);
    for i:=1 to 15 do
      for j:=1 to 5000 do
    begin
     Form2.F1Book1.SetActiveCell(j,i);//выбираем куда писать
     Form2.F1book1.SetFont('MS Sans Serif',10,false,false,false,false,0,false,false); //выставляем кирилический шрифт
    end;
    except
      end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
 DeleteFile('temp\include.xls');
 DeleteFile('temp\them.txt');
 DeleteFile('temp\text.rtf');
 Form2.Visible:=false;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=false;
 ClearTable;
 LoadTable;
end;

procedure TForm2.FormResize(Sender: TObject);
begin
F1Book1.Height:=Form2.Height-59;
F1Book1.Width:=Form2.Width-9;
end;

end.
