unit Unit16;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm16 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    LabeledEdit1: TLabeledEdit;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form16: TForm16;

implementation

{$R *.dfm}

procedure TForm16.Button2Click(Sender: TObject);
begin
 ListBox1.Clear;
 LabeledEdit1.Clear;
 ComboBox1.Clear;

 DateTimePicker1.Date:=Date;
 Form16.Visible:=False;
end;

procedure TForm16.Button1Click(Sender: TObject);
begin
 if LabeledEdit1.Text='' then
  begin
     ShowMessage('�� �� ������� ����� ���������!');
     Exit;
  end;
if (ComboBox1.Items.Strings[ComboBox1.ItemIndex]<>'') then
   ListBox1.Items.Append('"'+ComboBox1.Items.Strings[ComboBox1.ItemIndex]+'","'+LabeledEdit1.Text+'","'+datetostr(DateTimePicker1.Date)+'"')
   else ShowMessage('�� �� ������� ��� ���������!');
end;

procedure TForm16.Button3Click(Sender: TObject);
var f:TextFile;
i:integer;
begin
 if ListBox1.Count>0 then
 try
  AssignFile(f,'getdocp.f');
  Rewrite(f);
  for i:=0 to ListBox1.Count-1 do
    Writeln(f,ListBox1.Items.Strings[i]);

  CloseFile(f);
  ShowMessage('������ ���������! ������������ � ��������� ��� ��������� ����������.');
  ShowMessage('��������� ����� �������� � C:\��������������\');
   ListBox1.Clear;
 LabeledEdit1.Clear;
 ComboBox1.Clear;

 DateTimePicker1.Date:=Date;
 Form16.Visible:=False;
  except
    ShowMessage('��� ������� � �����!');
    end else
    ShowMessage('�� �� ��������� ������ ��� �������!');
end;

end.
