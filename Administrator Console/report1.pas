unit report1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBF, Gvar, nomencl;

type
  TForm2 = class(TForm)
    sg1: TStringGrid;
    Timer1: TTimer;
    Button1: TButton;
    Button2: TButton;
    DBF: TDBF;
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sg1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
procedure GetZipList;
var openned:Boolean;
k,i,j,next:integer;
s:string;
begin
  k:=0;
  openned:=false;
 while not openned do
  begin
   try // Откроем БД
   Form2.DBF.TableName:='\\'+GSMBServ+'\MS\notloadedarch.dbf';
   Form2.DBF.Exclusive:=false;
   Form2.DBF.Open;
   openned:=True;
   Continue;
   except
     k:=k+1;
     end;
    if k>50 then
     begin
       ShowMessage('Не могу получить доступ к БД \\'+GSMBServ+'\MS\notloadedarch.dbf');
       Exit;
      end;
      Sleep(100);
  end;

 for i:=0 to Form2.sg1.ColCount-1 do
  for j:=1 to Form2.sg1.RowCount do
    form2.sg1.Cells[i,j]:='';

 Form2.sg1.RowCount:=2;
 next:=1;
  for i:=1 to Form2.DBF.RecordCount do
    begin

        if Form2.sg1.RowCount<next+1 then
          Form2.sg1.RowCount:=next+1;
      Form2.sg1.Cells[0,next]:=Form2.DBF.GetFieldData(1);
      Form2.sg1.Cells[1,next]:=Form2.DBF.GetFieldData(2);
      Form2.sg1.Cells[2,next]:=datefromftp(Form2.DBF.GetFieldData(3));

      begin
        s:=Form2.DBF.GetFieldData(1);
        Form2.DBF.Next;
        if s<>Form2.DBF.GetFieldData(1) then
          next:=next+1;
        Form2.DBF.Prior;
        end;

     next:=next+1;
     Form2.DBF.Next;
    end;

  try
    Form2.DBF.Close;
    except
      end;

end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=False;
 GetZipList;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
 GetZipList;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
Form2.Visible:=False;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
sg1.Cells[0,0]:='Магазин:';
sg1.Cells[1,0]:='Файл:';
sg1.Cells[2,0]:='Дата:';
end;

procedure TForm2.sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var c:TColor;
begin
  if (ARow=0) then
  with sg1 do
  begin
   Canvas.Font.Color:=clBlue;
   Canvas.Font.Style:=[fsBold];
   Canvas.TextOut(Rect.Left+2,Rect.Top+2,sg1.Cells[Acol,Arow]);
   Exit;
   end;

  c:=sg1.Canvas.Brush.Color;
 if sg1.Cells[0,Arow]='' then
  begin
  sg1.Canvas.Brush.Color:=clGray;
  sg1.Canvas.FillRect(Rect) end else
    sg1.Canvas.Brush.Color:=c;
end;

procedure TForm2.sg1DblClick(Sender: TObject);
var
i,j:integer;
begin
 if AnsiPos('.zip',sg1.Cells[1,sg1.Row])>0 then
  begin
   Form3.sg1.RowCount:=6;
   for i:=0 to form3.sg1.colcount-1 do
    for j:=1 to form3.sg1.rowcount-1 do
    Form3.sg1.Cells[i,j]:='';

   GFileName:=sg1.Cells[1,sg1.Row];
   GMagaz:=sg1.Cells[0,sg1.Row];
   Form3.Visible:=False;
   Form3.Show;
   Form3.Timer1.Enabled:=True;
  end;
end;

end.
