unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBF, StdCtrls,Gvar;

type
  TForm3 = class(TForm)
    Timer1: TTimer;
    StringGrid1: TStringGrid;
    Button1: TButton;
    DBF: TDBF;
    Button2: TButton;
    Label1: TLabel;
    Timer2: TTimer;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}
 // Процедура для POS01


procedure flood(M:integer);
var i,j,row:Integer;
begin
 row := Form3.StringGrid1.Row;
  // Очистка таблиц
 for i:=0 to form3.StringGrid1.RowCount-1 do
  for j:=0 to Form3.StringGrid1.ColCount-1 do
    Form3.StringGrid1.Cells[j,i]:='';

    // Заполнение заголовков
 Form3.StringGrid1.Cells[0,0]:='№';
 Form3.StringGrid1.Cells[1,0]:='Имя';
 Form3.StringGrid1.Cells[2,0]:='Дата';
 Form3.StringGrid1.Cells[3,0]:='Статус';
 Form3.StringGrid1.Cells[4,0]:='Дата отправки';
   try
   Form3.DBF.TableName:='base\upload'+inttostr(m)+'.dbf';
   Form3.DBF.Exclusive:=false;
   Form3.DBF.Open;
  except
    end;

  try
   if Form3.DBF.RecordCount<> 0 then begin

     Form3.DBF.First;
    for i:=1 to Form3.DBF.RecordCount do begin
     Form3.StringGrid1.RowCount:=Form3.DBF.RecordCount+1;
     Form3.StringGrid1.Cells[0,i]:=inttostr(i);
     Form3.StringGrid1.Cells[1,i]:=Form3.dbf.GetFieldData(1);
     Form3.StringGrid1.Cells[2,i]:=Form3.dbf.GetFieldData(2);
     if (Form3.DBF.GetFieldData(3)='1') then
       Form3.StringGrid1.Cells[3,i]:='Отправлен';
     try
      Form3.StringGrid1.Cells[4,i]:=Form3.dbf.GetFieldData(4);
     except
       end;
     Form3.DBF.Next;
     end;
   end;
  except
    end;

  try
   Form3.dbf.Close;
  except
    end;
  Form3.StringGrid1.Row := row;  
end;


procedure TForm3.Button1Click(Sender: TObject);
begin
 if ListBox1.ItemIndex<>-1 then
  flood(ListBox1.ItemIndex+1);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
Form3.Visible:=False;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
var i,j:integer;
begin
Timer1.Enabled:=False;
  Listbox1.Clear;
  ListBox1.ItemIndex:=-1;
  for i:=1 to 5 do
    if Magaz[i].FTPDir<>'' then
      ListBox1.Items.Append(inttostr(i)+' - '+Magaz[i].Name);

   // Очистка таблиц
 for i:=0 to form3.StringGrid1.RowCount-1 do
  for j:=0 to Form3.StringGrid1.ColCount-1 do
    Form3.StringGrid1.Cells[j,i]:='';

   // Заполнение заголовков
 Form3.StringGrid1.Cells[0,0]:='№';
 Form3.StringGrid1.Cells[1,0]:='Имя';
 Form3.StringGrid1.Cells[2,0]:='Дата';
 Form3.StringGrid1.Cells[3,0]:='Статус';
 Form3.StringGrid1.Cells[4,0]:='Дата отправки';

end;

procedure TForm3.ListBox1Click(Sender: TObject);
begin
 if ListBox1.ItemIndex<>-1 then
  flood(ListBox1.ItemIndex+1);
end;

procedure TForm3.Timer2Timer(Sender: TObject);
begin
if ListBox1.ItemIndex<>-1 then
  flood(ListBox1.ItemIndex+1);
end;

procedure TForm3.FormHide(Sender: TObject);
begin
 timer1.Enabled:=false;
 timer2.Enabled:=false;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
 timer2.Enabled:=true;
end;

end.
