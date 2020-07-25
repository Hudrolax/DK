unit zapros1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP;

type
  TForm6 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    ftp: TIdFTP;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.Button2Click(Sender: TObject);
begin
Form6.Visible:=False;
end;

procedure TForm6.Button1Click(Sender: TObject);
var f:textfile;
s:string;
begin
 // ������� �� ���������, ���� �� ������� �� ���� �����.
 if (not CheckBox1.Checked) and (not CheckBox2.Checked) and
  (not CheckBox3.Checked) and (not CheckBox4.Checked) then
  begin
   ShowMessage('�� �� ������� �� ����� �����!');
   Exit;
  end;
  // ������� ������� ���� �������
  try
   AssignFile(f,'reloadtrz.txt');
   Rewrite(f);
   Writeln(f,'<d>');
   Writeln(f,datetostr(DateTimePicker1.Date)+';'+datetostr(DateTimePicker2.Date));
   if CheckBox1.Checked then Writeln(f,'1');
   if CheckBox2.Checked then Writeln(f,'2');
   if CheckBox3.Checked then Writeln(f,'3');
   if CheckBox4.Checked then Writeln(f,'4');
   CloseFile(f);
  except
    ShowMessage('�� ���� ������� ���� reloadtrz.txt!');
    end;

  // ���������� ��� �� FTP
 try
  ftp.Host:='10.10.61.10';
  ftp.Port:=21;
  ftp.Username:='dk';
  ftp.Password:='dk';
  ftp.Connect;
  if ftp.Connected then
  begin
   ftp.ChangeDir(Label2.Caption);
   ftp.put('reloadtrz.txt','reloadtrz.txt',false);
   DeleteFile('reloadtrz.txt');
   ftp.Disconnect;
   ShowMessage('������ �� ������� '+label2.Caption+' ���������.');
   Form6.Visible:=False;
  end;
 except
   ShowMessage('�� ���� ������������ � FTP 10.10.61.10!');
   end;
end;

end.
