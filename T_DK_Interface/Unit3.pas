unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBF, StdCtrls,Gvar;

type
  TForm3 = class(TForm)
    Timer1: TTimer;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    Button1: TButton;
    DBF: TDBF;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
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
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
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
procedure pos01;
var
i,j,m:Integer;
begin
  try
  j:=1;
  m:=0;
   if Form3.DBF.RecordCount<> 0 then begin
        Form3.DBF.First;
    for i:=1 to Form3.DBF.RecordCount do begin
     if Copy(Form3.DBF.GetFieldData(1),2,1)='1' then
       m:=m+1;
     Form3.DBF.Next;
     end;
    if m>20 then
    Form3.StringGrid1.RowCount:=m+1;


     Form3.DBF.First;
    for i:=1 to Form3.DBF.RecordCount do begin
     if Copy(Form3.DBF.GetFieldData(1),2,1)='1' then
     begin
       if j=Form3.DBF.RecordCount then Form3.StringGrid1.RowCount:=Form3.StringGrid1.RowCount+1;
      Form3.StringGrid1.Cells[0,j]:=inttostr(j);
        if IsDigit(Copy(Form3.dbf.GetFieldData(1),5,4)) then
      Form3.StringGrid1.Cells[1,j]:=inttostr(strtoint(Copy(Form3.dbf.GetFieldData(1),5,4)));
      Form3.StringGrid1.Cells[2,j]:=Form3.dbf.GetFieldData(2);
      if Form3.dbf.GetFieldData(3)='1' then
       Form3.StringGrid1.Cells[3,j]:='Отправлен';
       j:=j+1;
     end;
     Form3.DBF.Next;
     end;
    end;
   except
    end;
  end;

 // Процедура для POS02
procedure pos02;
var
i,j,m:Integer;
begin
  try
  j:=1;
  m:=0;
   if Form3.DBF.RecordCount<> 0 then begin
        Form3.DBF.First;
    for i:=1 to Form3.DBF.RecordCount do begin
     if Copy(Form3.DBF.GetFieldData(1),2,1)='2' then
       m:=m+1;
     Form3.DBF.Next;
       end;
    if m>20 then
    Form3.StringGrid2.RowCount:=m+1;

     Form3.DBF.First;
    for i:=1 to Form3.DBF.RecordCount do begin
     if Copy(Form3.DBF.GetFieldData(1),2,1)='2' then
     begin
      Form3.StringGrid2.Cells[0,j]:=inttostr(j);
        if IsDigit(Copy(Form3.dbf.GetFieldData(1),5,4)) then
      Form3.StringGrid2.Cells[1,j]:=inttostr(strtoint(Copy(Form3.dbf.GetFieldData(1),5,4)));
      Form3.StringGrid2.Cells[2,j]:=Form3.dbf.GetFieldData(2);
      if Form3.dbf.GetFieldData(3)='1' then
       Form3.StringGrid2.Cells[3,j]:='Отправлен';
       j:=j+1;
     end;
     Form3.DBF.Next;
     end;
   end;
  except
    end;
  end;

  // Процедура для POS03
procedure pos03;
var
i,j,m:Integer;
begin
  try
  j:=1;
  m:=0;
   if Form3.DBF.RecordCount<> 0 then begin
        Form3.DBF.First;
    for i:=1 to Form3.DBF.RecordCount do begin
     if Copy(Form3.DBF.GetFieldData(1),2,1)='3' then

       m:=m+1;
    Form3.DBF.Next;
       end;
    if m>20 then
    Form3.StringGrid3.RowCount:=m+1;

     Form3.DBF.First;
    for i:=1 to Form3.DBF.RecordCount do begin
     if Copy(Form3.DBF.GetFieldData(1),2,1)='3' then
     begin
      Form3.StringGrid3.Cells[0,j]:=inttostr(j);
        if IsDigit(Copy(Form3.dbf.GetFieldData(1),5,4)) then
      Form3.StringGrid3.Cells[1,j]:=inttostr(strtoint(Copy(Form3.dbf.GetFieldData(1),5,4)));
      Form3.StringGrid3.Cells[2,j]:=Form3.dbf.GetFieldData(2);
      if Form3.dbf.GetFieldData(3)='1' then
       Form3.StringGrid3.Cells[3,j]:='Отправлен';
       j:=j+1;
     end;
     Form3.DBF.Next;
     end;
   end;
  except
    end;
  end;

  // Процедура для POS04
procedure pos04;
var
i,j,m:Integer;
begin
  try
  j:=1;
  m:=0;
   if Form3.DBF.RecordCount<> 0 then begin
    Form3.DBF.First;
    for i:=1 to Form3.DBF.RecordCount do begin
     if Copy(Form3.DBF.GetFieldData(1),2,1)='4' then
       m:=m+1;
     Form3.DBF.Next;
       end;
    if m>20 then   
    Form3.StringGrid4.RowCount:=m+1;

     Form3.DBF.First;
    for i:=1 to Form3.DBF.RecordCount do begin
     if Copy(Form3.DBF.GetFieldData(1),2,1)='4' then
     begin
      Form3.StringGrid4.Cells[0,j]:=inttostr(j);
        if IsDigit(Copy(Form3.dbf.GetFieldData(1),3,6)) then
      Form3.StringGrid4.Cells[1,j]:=inttostr(strtoint(Copy(Form3.dbf.GetFieldData(1),3,6)));
      Form3.StringGrid4.Cells[2,j]:=Form3.dbf.GetFieldData(2);
      if Form3.dbf.GetFieldData(3)='1' then
       Form3.StringGrid4.Cells[3,j]:='Отправлен';
       j:=j+1;
     end;
     Form3.DBF.Next;
     end;
   end;
  except
    end;
  end;

procedure TForm3.Button1Click(Sender: TObject);
var i,j:Integer;
begin
 try
  // Очистка таблиц
 for i:=1 to form3.StringGrid1.RowCount-1 do
  for j:=1 to Form3.StringGrid1.ColCount-1 do
    Form3.StringGrid1.Cells[i,j]:='';

 for i:=1 to form3.StringGrid2.RowCount-1 do
  for j:=1 to Form3.StringGrid2.ColCount-1 do
    Form3.StringGrid2.Cells[i,j]:='';

 for i:=1 to form3.StringGrid3.RowCount-1 do
  for j:=1 to Form3.StringGrid3.ColCount-1 do
    Form3.StringGrid3.Cells[i,j]:='';

 for i:=1 to form3.StringGrid4.RowCount-1 do
  for j:=1 to Form3.StringGrid4.ColCount-1 do
    Form3.StringGrid4.Cells[i,j]:='';

  Form3.DBF.TableName:='base\upload.dbf';
  Form3.DBF.Exclusive:=false;
  Form3.DBF.Open;

  pos01;
  pos02;
  pos03;
  pos04;

  Form3.dbf.Close;
  except
   end;

end;

procedure TForm3.Button2Click(Sender: TObject);
begin
Form3.Visible:=False;
end;

procedure TForm3.Timer2Timer(Sender: TObject);
begin
Timer2.Enabled:=False;
 try
  Form3.DBF.TableName:='base\upload.dbf';
  Form3.DBF.Exclusive:=false;
  Form3.DBF.Open;

  pos01;
  pos02;
  pos03;
  pos04;

  Form3.dbf.Close;
  except
   end;
end;

end.
