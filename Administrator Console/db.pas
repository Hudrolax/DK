unit db;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBF, Clipbrd, ExtCtrls, Gvar;

type
  TForm5 = class(TForm)
    sg1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    DBF: TDBF;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure sg1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sg1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}
// *****************************************************************************
{��������� ����������� �� ������� � �����}
// *****************************************************************************
procedure CopyToBuff;
var s:string;
i,j:Integer;
begin
   s := '';
    for i := Form5.sg1.Selection.Top to Form5.sg1.Selection.Bottom do begin
      for j := Form5.sg1.Selection.Left to form5.sg1.Selection.Right do
        s := s + form5.sg1.Cells[j,i] + #9;
      s:= s+#13#10;
    end;
    Clipboard.AsText:= s;
end;

// *****************************************************************************
{��������� ����������� �� ������ � �������}
// *****************************************************************************
procedure CopyFromBuff;
var s,ss:string;
i,j,NextC,NextR:Integer;
begin
  s:=Clipboard.Astext;
  ss:='';
  NextC:=Form5.sg1.Col;
  NextR:=Form5.sg1.Row;

  for i:=1 to Length(s) do
    if (s[i]<>#9) and (s[i]<>#$D) and (s[i]<>#$A)then ss:=ss+s[i] else
      if s[i]=#9 then
      begin
       Form5.sg1.Cells[NextC,NextR]:=ss;
       ss:='';
       NextC:=NextC+1;
        end else
      if (s[i]=#13) and (s[i+1]=#10) then
      begin
       Form5.sg1.Cells[NextC,NextR]:=ss;
       ss:='';
       NextR:=NextR+1;
       NextC:=Form5.sg1.Col;
        end;
end;

procedure flood;
var i,j:integer;
begin
 for i:=1 to Form5.sg1.ColCount-1 do
  for j:=1 to Form5.sg1.RowCount-1 do
    Form5.sg1.Cells[j,i]:='';

   try // ������� ��
  Form5.DBF.TableName:='\\'+GSMBServ+'\MS\telephone.dbf';
  Form5.DBF.Exclusive:=true;
  Form5.DBF.Open;
  except
    ShowMessage('�� ���� ������������ � �������!');
    Exit;
    end;

 try
   for i:=1 to Form5.DBF.RecordCount do
    begin
     for j:=1 to Form5.DBF.FieldCount do
     Form5.sg1.Cells[j,i]:=Form5.DBF.GetFieldData(j);

    Form5.DBF.Next;
      end;

 except
 end;

  try
    Form5.DBF.Close;
  except
  end;

 for i:=1 to Form5.sg1.RowCount do
  if Form5.sg1.Cells[1,i]<>'' then
    Form5.sg1.Cells[0,i]:=IntToStr(i) else Break; 
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
sg1.Cells[0,0]:='�';
sg1.Cells[1,0]:='�������:';
sg1.Cells[2,0]:='�������:';
sg1.Cells[3,0]:='�����:';
sg1.Cells[4,0]:='�����:';
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
Form5.Visible:=false;
end;

procedure TForm5.Button1Click(Sender: TObject);
var i,j:Integer;
begin
 i:=0;
      //������� ������� �� ��� ������ ������������ �������

  while FileExists('\\'+GSMBServ+'\MS\telephone.dbf') do
   begin
    i:=i+1;
    DeleteFile('\\'+GSMBServ+'\MS\telephone.dbf');
    Sleep(1000);
    if i>20 then
      begin
       ShowMessage('�� ���� �������� ������ � ������� dk99.kopt.org!');
       Exit;
      end;
     end;

    try
      Form5.dbf.TableName:='\\'+GSMBServ+'\MS\telephone.dbf';
      if not FileExists('\\'+GSMBServ+'\MS\telephone.dbf') then
      begin
        Form5.dbf.AddFieldDefs('magazin',bfString,20,0);
        Form5.dbf.AddFieldDefs('phone',bfString,50,0);
        Form5.dbf.AddFieldDefs('adress',bfString,100,0);
        Form5.dbf.AddFieldDefs('firm',bfString,50,0);
        Form5.dbf.CreateTable;
        Form5.DBF.close;
      end;
      except
     ShowMessage('�� ���� ������� �� \\'+GSMBServ+'\MS\telephone.dbf');
        end;

  try // ������� ��
  Form5.DBF.TableName:='\\'+GSMBServ+'\MS\telephone.dbf';
  Form5.DBF.Exclusive:=true;
  Form5.DBF.Open;
  except
    ShowMessage('�� ���� ������������ � �������!');
    Exit;
    end;

  for i:=1 to sg1.RowCount-1 do
   if sg1.Cells[1,i]<>'' then
   begin
    dbf.Append;

    for j:=1 to sg1.ColCount-1 do
    dbf.SetFieldData(j,sg1.Cells[j,i]);

    DBF.Post;
    end else
      begin
       DBF.Post;
       DBF.Close;
       Exit;
        end;

  try
    Form5.DBF.Close;
  except
  end;
  ShowMessage('���������!');
end;

procedure TForm5.sg1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

var s,ss:string;
i,j,nextC,nextR:Integer;
begin
  // ������� ����� ��������������, ���� ��������� ���� �������� ������
 if (Key=Ord(VK_UP)) or (Key=Ord(VK_DOWN)) or (Key=Ord(VK_LEFT)) or (Key=Ord(VK_RIGHT)) then
    sg1.EditorMode:=False;

 {�������� ���������� ������ ������ � ������� �� ������� Ctrl+V ��� Shift+Ins}
 if ((ssCtrl in Shift) and (key = ord('V'))) or ((ssShift in Shift) and (key = ord(VK_INSERT))) then begin
  CopyFromBuff;
  end;

 {�������� ���������� �������� �� ������� � ����� ������ �� ������� ��������� Ctrl+C ��� Ctrl+Ins}
 if ((ssCtrl in Shift) and (key = ord('C'))) or ((ssCtrl in Shift) and (key = ord(VK_INSERT))) then begin
  CopyToBuff;
  end;


 // ������� ����������, �� ������� Delete
  if Key=Ord(VK_DELETE) then
  begin
    for i:=sg1.Selection.Left to sg1.Selection.Right do
      for j:=sg1.Selection.Top to sg1.Selection.Bottom do
        sg1.Cells[i,j]:='';
    end;

 {�������� ��� ��������� ��������������� � ������ �� ������� Enter (���� �������� ������ ���� ������)}
  if Key=Ord(VK_Return) then
   if (sg1.row=sg1.Selection.Top) and (sg1.row=sg1.Selection.Bottom) and (sg1.col=sg1.Selection.Left) and (sg1.Col=sg1.Selection.Right) then
    if sg1.EditorMode then
    begin
    sg1.EditorMode:=False;
    sg1.Options:=sg1.Options-[goEditing];
    sg1.Options:=sg1.Options-[goAlwaysShowEditor];
    end
    else
    begin
    sg1.Options:=sg1.Options+[goEditing];
    sg1.Options:=sg1.Options+[goAlwaysShowEditor];
    sg1.EditorMode:=true;
    end;




end;


procedure TForm5.sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 {��� ���������� �����, ����� ������������ �������� ��������� � ��������������}

 if (Arow=sg1.Selection.Top) and (Arow=sg1.Selection.Bottom) and (Acol=sg1.Selection.Left) and (ACol=sg1.Selection.Right) then
  sg1.Options:=sg1.Options+[goEditing] else

 sg1.Options:=sg1.Options-[goEditing];
end;

procedure TForm5.sg1DblClick(Sender: TObject);
begin
  {��� ���������� �����, ����� ������������ �������� ��������� � ��������������}
 sg1.Options:=sg1.Options+[goEditing];
 sg1.Options:=sg1.Options+[goAlwaysShowEditor];
 end;

procedure TForm5.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=False;
flood;
end;

end.
