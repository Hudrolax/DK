unit pack;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, ExtCtrls, inifiles, IdBaseComponent, IdComponent,
  IdFTP, StdCtrls, IdTCPConnection, IdTCPClient ;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    ftp: TIdFTP;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ini:TIniFile;
  host,dir,dirmag,user,pass:string;
  port:Integer;
  VseOK:boolean;

implementation

{$R *.dfm}

//........................................................................................................................
// Процедура подключения к FTP
procedure connecttoftp;
begin
//подключаемся к FTP
if not Form1.ftp.Connected then
 try
  Form1.ftp.Host:=host;
  Form1.ftp.Port:=port;
  Form1.ftp.Username:=user;
  Form1.ftp.Password:=pass;
  Form1.ftp.Connect();
  if form1.ftp.Connected then
    Form1.ftp.ChangeDir(dir);
  except
 end;
end;

//........................................................................................................................
//Процедура отключения от FTP
procedure disconnectftp;
begin
 try
  Form1.ftp.Abort;
  Form1.ftp.Disconnect;
 except
 end;
end;

procedure getfromftp;
var
loadflag:TextFile;
begin
  try
   Form1.ftp.get('config.ini','config.ini',True,false);
   VseOK:=true;
   Form1.ftp.Delete('T_runscript.exe');
   Form1.ftp.Delete('config.ini');

   AssignFile(loadflag,'temp\dkrupdater.loaded_'+dirmag);
   Rewrite(loadflag);
   CloseFile(loadflag);
   form1.ftp.Put('temp\dkrupdater.loaded_'+dirmag,'dkrupdater.loaded_'+dirmag);
   DeleteFile('temp\dkrupdater.loaded_'+dirmag);
   except
  end;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
 timer1.Enabled:=false;
 connecttoftp;
 getfromftp;
 disconnectftp;
 If NOT VseOK then
  begin
    timer1.Enabled:=true;
    end else Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 try
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //создаем файл настроек
  host:=ini.ReadString('FTP','Host','ugrus.com');
  port:=ini.ReadInteger('FTP','Port',21);
  user:=ini.ReadString('FTP','User','dk');
  pass:=ini.ReadString('FTP','Password','dk');
  dir:=ini.ReadString('Updater','Dir','update');
  dirmag:=ini.ReadString('FTP','Dir','dk099');
  Ini.Free;
    except
     end;
     VseOK:=false;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
form1.Visible:=false;
Timer2.Enabled:=false;
end;

end.
