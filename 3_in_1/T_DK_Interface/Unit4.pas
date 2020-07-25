unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBF, Gvar, ExtCtrls;

type
  TForm4 = class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    DBF: TDBF;
    Label1: TLabel;
    Timer1: TTimer;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    Timer2: TTimer;
    Label4: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure flood(M:integer;P:integer);
var i,j,row:Integer;
begin
  row := form4.StringGrid1.Row;
  // Очистка таблиц
 for i:=0 to form4.StringGrid1.RowCount-1 do
  for j:=0 to Form4.StringGrid1.ColCount-1 do
    Form4.StringGrid1.Cells[j,i]:='';

    // Заполнение заголовков
 Form4.StringGrid1.Cells[0,0]:='№';
 Form4.StringGrid1.Cells[1,0]:='Дата';
 Form4.StringGrid1.Cells[2,0]:='Статус';
   try
   Form4.DBF.TableName:='base\download'+inttostr(m)+'.dbf';
   Form4.DBF.Exclusive:=false;
   Form4.DBF.Open;
  except
    end;

   try
   if Form4.DBF.RecordCount<> 0 then begin

     Form4.DBF.First;
    for i:=1 to Form4.DBF.RecordCount do begin
     Form4.StringGrid1.RowCount:=Form4.DBF.RecordCount+1;
      if IsDigit(Copy(Form4.dbf.GetFieldData(1),5,4)) then
        Form4.StringGrid1.Cells[0,i]:=inttostr(strtoint(Copy(Form4.dbf.GetFieldData(1),5,4)));
      Form4.StringGrid1.Cells[1,i]:=Form4.dbf.GetFieldData(2);
      if (Form4.DBF.GetFieldData(2+P)='2') or (Form4.DBF.GetFieldData(2+P)='3') then
       Form4.StringGrid1.Cells[2,i]:='Загружено';
      Form4.DBF.Next;
     end;
   end;
  except
    end;

  try
   Form4.dbf.Close;
  except
    end;
  form4.StringGrid1.Row := Row;  
end;



procedure TForm4.Button2Click(Sender: TObject);
begin
Form4.Visible:=False;
end;

procedure TForm4.Button1Click(Sender: TObject);
var
  i,j:integer;
begin
if (Listbox2.ItemIndex>-1) AND (Listbox2.ItemIndex<8) then
  flood(Listbox1.ItemIndex+1,strtoint(Copy(Listbox2.Items.Strings[Listbox2.ItemIndex],Length(Listbox2.Items.Strings[Listbox2.ItemIndex]),1)));
end;

procedure TForm4.Timer1Timer(Sender: TObject);
var i,j:integer;
begin
  Timer1.Enabled:=False;
  Listbox1.Clear;
  Listbox2.Clear;
  ListBox1.ItemIndex:=-1;
  ListBox2.ItemIndex:=-1;
  for i:=1 to 5 do
    if Magaz[i].FTPDir<>'' then
      ListBox1.Items.Append(inttostr(i)+' - '+Magaz[i].Name);

   // Очистка таблиц
 for i:=0 to form4.StringGrid1.RowCount-1 do
  for j:=0 to Form4.StringGrid1.ColCount-1 do
    Form4.StringGrid1.Cells[j,i]:='';

   // Заполнение заголовков
 Form4.StringGrid1.Cells[0,0]:='№';
 Form4.StringGrid1.Cells[1,0]:='Дата';
 Form4.StringGrid1.Cells[2,0]:='Статус';

      //  try
//  Form4.DBF.TableName:='base\download.dbf';
//  Form4.DBF.Exclusive:=false;
//  Form4.DBF.Open;
//
//  pos04;
//
//  Form4.dbf.Close;
//  except
//   end;
end;

procedure TForm4.ListBox1Click(Sender: TObject);
var i,j:integer;
begin
 Listbox2.Clear;

 // Очистка таблиц
 for i:=0 to form4.StringGrid1.RowCount-1 do
  for j:=0 to Form4.StringGrid1.ColCount-1 do
    Form4.StringGrid1.Cells[j,i]:='';

   // Заполнение заголовков
 Form4.StringGrid1.Cells[0,0]:='№';
 Form4.StringGrid1.Cells[1,0]:='Дата';
 Form4.StringGrid1.Cells[2,0]:='Статус';
 
 if (Listbox1.ItemIndex>-1) AND (Listbox1.ItemIndex<5) then
  for i:=1 to 9 do
   if Magaz[listbox1.ItemIndex+1].pos[i]<>'' then
    Listbox2.Items.Append('POS 0'+inttostr(i));

end;

procedure TForm4.ListBox2Click(Sender: TObject);
begin
 if (Listbox2.ItemIndex>-1) AND (Listbox2.ItemIndex<8) then
  flood(Listbox1.ItemIndex+1,strtoint(Copy(Listbox2.Items.Strings[Listbox2.ItemIndex],Length(Listbox2.Items.Strings[Listbox2.ItemIndex]),1)));
end;

procedure TForm4.Timer2Timer(Sender: TObject);
begin
 if (Listbox2.ItemIndex>-1) AND (Listbox2.ItemIndex<8) then
  flood(Listbox1.ItemIndex+1,strtoint(Copy(Listbox2.Items.Strings[Listbox2.ItemIndex],Length(Listbox2.Items.Strings[Listbox2.ItemIndex]),1)))
end;

procedure TForm4.FormHide(Sender: TObject);
begin
 timer1.Enabled:=false;
 timer2.Enabled:=false;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
 timer2.Enabled:=true;
end;

end.
