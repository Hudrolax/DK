unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    sg1: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
type Tovar = record
  kod:integer;
  name:string[200];
end;
type Gruzz = array[1..10000] of Tovar;
type Post = array[1..10000] of Gruzz;
type BD = array[1..10000] of Post;
// Gruzz = record
//  tab:array of TStringGrid;
// end;
//
// Postavshik = record
//  post:array of Gruzz;
// end;

var
  Form1: TForm1;
  BDV:BD;
  BDF:file of BD;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 bdv[1,1,1].kod:=555;
 bdv[1,1,1].name:='Tovar1';

ComboBox1.Items.Append('Поставщик1');
ComboBox1.Items.Append('Поставщик2');

ComboBox2.Items.Append('Грузоотправитель1');
ComboBox2.Items.Append('Грузоотправитель2');
end;

end.
