unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBF, Gvar, ExtCtrls;

type
  TForm4 = class(TForm)
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    DBF: TDBF;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
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
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure pos01;
var i:Integer;
begin
   try
   if Form4.DBF.RecordCount<> 0 then begin

     Form4.DBF.First;
    for i:=1 to Form4.DBF.RecordCount do begin
     Form4.StringGrid1.RowCount:=Form4.DBF.RecordCount+1;
      if IsDigit(Copy(Form4.dbf.GetFieldData(1),5,4)) then
        Form4.StringGrid1.Cells[0,i]:=inttostr(strtoint(Copy(Form4.dbf.GetFieldData(1),5,4)));
      Form4.StringGrid1.Cells[1,i]:=Form4.dbf.GetFieldData(2);
      if (Form4.DBF.GetFieldData(3)='2') or (Form4.DBF.GetFieldData(3)='3') then
       Form4.StringGrid1.Cells[2,i]:='Загружено';
      Form4.DBF.Next;
     end;
   end;
  except
    end;
end;

procedure pos02;
var i:Integer;
begin
   try
   if Form4.DBF.RecordCount<> 0 then begin

     Form4.DBF.First;
    for i:=1 to Form4.DBF.RecordCount do begin
           Form4.StringGrid2.RowCount:=Form4.DBF.RecordCount+1;
      if IsDigit(Copy(Form4.dbf.GetFieldData(1),5,4)) then
        Form4.StringGrid2.Cells[0,i]:=inttostr(strtoint(Copy(Form4.dbf.GetFieldData(1),5,4)));
      Form4.StringGrid2.Cells[1,i]:=Form4.dbf.GetFieldData(2);
      if (Form4.DBF.GetFieldData(4)='2') or (Form4.DBF.GetFieldData(4)='3') then
       Form4.StringGrid2.Cells[2,i]:='Загружено';
      Form4.DBF.Next;
     end;
   end;
  except
    end;
end;

procedure pos03;
var i:Integer;
begin
   try
   if Form4.DBF.RecordCount<> 0 then begin
     Form4.StringGrid3.RowCount:=Form4.DBF.RecordCount+1;
     Form4.DBF.First;
    for i:=1 to Form4.DBF.RecordCount do begin
      if IsDigit(Copy(Form4.dbf.GetFieldData(1),5,4)) then
        Form4.StringGrid3.Cells[0,i]:=inttostr(strtoint(Copy(Form4.dbf.GetFieldData(1),5,4)));
      Form4.StringGrid3.Cells[1,i]:=Form4.dbf.GetFieldData(2);
      if (Form4.DBF.GetFieldData(5)='2') or (Form4.DBF.GetFieldData(5)='3') then
       Form4.StringGrid3.Cells[2,i]:='Загружено';
      Form4.DBF.Next;
     end;
   end;
  except
    end;
end;

procedure pos04;
var i:Integer;
begin
   try
   if Form4.DBF.RecordCount<> 0 then begin
     Form4.StringGrid4.RowCount:=Form4.DBF.RecordCount+1;
     Form4.DBF.First;
    for i:=1 to Form4.DBF.RecordCount do begin
      if IsDigit(Copy(Form4.dbf.GetFieldData(1),5,4)) then
        Form4.StringGrid4.Cells[0,i]:=inttostr(strtoint(Copy(Form4.dbf.GetFieldData(1),5,4)));
      Form4.StringGrid4.Cells[1,i]:=Form4.dbf.GetFieldData(2);
      if (Form4.DBF.GetFieldData(6)='2') or (Form4.DBF.GetFieldData(6)='3') then
       Form4.StringGrid4.Cells[2,i]:='Загружено';
      Form4.DBF.Next;
     end;
   end;
  except
    end;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
Form4.Visible:=False;
end;

procedure TForm4.Button1Click(Sender: TObject);
var
  i,j:integer;
begin
  try
  // Очистка таблиц
 for i:=1 to form4.StringGrid1.RowCount-1 do
  for j:=1 to Form4.StringGrid1.ColCount-1 do
    Form4.StringGrid1.Cells[i,j]:='';

 for i:=1 to form4.StringGrid2.RowCount-1 do
  for j:=1 to Form4.StringGrid2.ColCount-1 do
    Form4.StringGrid2.Cells[i,j]:='';

 for i:=1 to form4.StringGrid3.RowCount-1 do
  for j:=1 to Form4.StringGrid3.ColCount-1 do
    Form4.StringGrid3.Cells[i,j]:='';

 for i:=1 to form4.StringGrid4.RowCount-1 do
  for j:=1 to Form4.StringGrid4.ColCount-1 do
    Form4.StringGrid4.Cells[i,j]:='';

  Form4.DBF.TableName:='base\download.dbf';
  Form4.DBF.Exclusive:=false;
  Form4.DBF.Open;

  pos01;
  pos02;
  pos03;
  pos04;

  Form4.dbf.Close;
  except
   end;

end;

procedure TForm4.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=False;
  try
  Form4.DBF.TableName:='base\download.dbf';
  Form4.DBF.Exclusive:=false;
  Form4.DBF.Open;

  pos01;
  pos02;
  pos03;
  pos04;

  Form4.dbf.Close;
  except
   end;
end;

end.
