unit settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, ExtCtrls, Gvar;

type
  TForm8 = class(TForm)
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Button1: TButton;
    Button2: TButton;
    Timer1: TTimer;
    procedure Button2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;
  ini:TIniFile;

implementation

{$R *.dfm}

procedure TForm8.Button2Click(Sender: TObject);
begin
Form8.Visible:=false;
end;

procedure TForm8.RadioButton1Click(Sender: TObject);
begin
 Edit1.Enabled:=True;
 Label2.Enabled:=True;

 //*************
 Label3.Enabled:=False;
 Label4.Enabled:=False;
 Label5.Enabled:=False;
 Label6.Enabled:=False;
 Edit2.Enabled:=False;
 Edit3.Enabled:=False;
 Edit4.Enabled:=False;
 Edit5.Enabled:=False;
 end;

procedure TForm8.RadioButton2Click(Sender: TObject);
begin
 Edit1.Enabled:=False;
 Label2.Enabled:=False;

 //*************
 Label3.Enabled:=True;
 Label4.Enabled:=True;
 Label5.Enabled:=True;
 Label6.Enabled:=True;
 Edit2.Enabled:=True;
 Edit3.Enabled:=True;
 Edit4.Enabled:=True;
 Edit5.Enabled:=True;
end;

procedure TForm8.Button1Click(Sender: TObject);
begin
 try

   Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //создаем файл настроек

   if RadioButton1.Checked then
      Ini.WriteString('Base','UpdMode','SMB');
   if RadioButton2.Checked then
      Ini.WriteString('Base','UpdMode','FTP');

   Ini.WriteString('Base','SMBServer',Edit1.Text);
   Ini.WriteString('Base','FTPServer',Edit2.Text);
   Ini.WriteInteger('Base','FTPPort',StrToInt(Edit3.Text));
   Ini.WriteString('Base','FTPUser',Edit4.Text);
   Ini.WriteString('Base','FTPPass',Edit5.Text);
   Ini.Free;

    //Подгружаем настройки
  try
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //создаем файл настроек
  GUPDMode:= ini.ReadString('Base','UpdMode','SMB');
  GSMBServ:= Ini.ReadString('Base','SMBServer','dk99');
  GFTPServ:= Ini.ReadString('Base','FTPServer','dk99');
  GFTPPort:= Ini.ReadInteger('Base','FTPPort',21);
  GFTPUser:= Ini.ReadString('Base','FTPUser','ac');
  GFTPPass:= Ini.ReadString('Base','FTPPass','ac');
  Ini.Free;
  except
    ShowMessage('Не могу загрузить настройки из config.ini');
    end;



  ShowMessage('Настройки сохранены!');
  except
    ShowMessage('Не могу записать файл настроек config.ini');
    end;
  Form8.Visible:=False;  
end;

procedure TForm8.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=False;
 if GUPDMode='SMB' then SendMessage(RadioButton1.Handle,BM_CLICK,0,0);

  if GUPDMode='FTP' then SendMessage(RadioButton2.Handle,BM_CLICK,0,0);
 end;

end.
