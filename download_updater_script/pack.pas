unit pack;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, inifiles, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, ZipForge, ShlObj, ActiveX, ComObj, StdCtrls ;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    zp1: TZipForge;
    ftp: TIdFTP;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure CreateShotCut(SourceFile, ShortCutName, SourceParams: String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ini:TIniFile;
  host,dir,dirmag,user,pass:string;
  port:Integer;
  zippacked,putted:Boolean;

implementation

{$R *.dfm}


procedure TForm1.CreateShotCut(SourceFile, ShortCutName, SourceParams: String);
var
IUnk: IUnknown;
ShellLink: IShellLink;
ShellFile: IPersistFile;
tmpShortCutName: string;
WideStr: WideString;
i: Integer;
begin
IUnk := CreateComObject(CLSID_ShellLink);
ShellLink := IUnk as IShellLink;
ShellFile  := IUnk as IPersistFile;

 ShellLink.SetPath(PChar(SourceFile));
ShellLink.SetArguments(PChar(SourceParams));
ShellLink.SetWorkingDirectory(PChar(ExtractFilePath(SourceFile)));

 ShortCutName := ChangeFileExt(ShortCutName,'.lnk');
if fileexists(ShortCutName) then
begin
ShortCutName := copy(ShortCutName,1,length(ShortCutName)-4);
i := 1;
repeat
tmpShortCutName := ShortCutName +'(' + inttostr(i)+ ').lnk';
inc(i);
until not fileexists(tmpShortCutName);
WideStr := tmpShortCutName;
end
else
WideStr := ShortCutName;
ShellFile.Save(PWChar(WideStr),False);
end;


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
    Form1.ftp.ChangeDir(dirmag);
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
var i:Integer;
ls2:TStringList;
loadflag:TextFile;
runload:Boolean;
termfile:TextFile;
WorkTable:String;
Find:_WIN32_FIND_DATAA;
P:PItemIDList;
C:array [0..1000] of char;
yesfile:TextFile;
begin
ls2:=TStringList.Create;
ls2.Clear;
runload:=False;
 try
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
  except
  end;
  //Глядим, есть ли скрипт для запуска
 try
  if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('dkrupdater.zip',ls2[i])<>0 then
      begin
       runload:=True;
       Break;
       end;
  except
    end;

  //Если есть - качаем, запускаем, удаляем с фтп, кладем флаг что запустили.

  if runload then
  begin
   if not FileExists('temp\yesfile.txt') then
   try
  // Writeln(log,getdatet+' Пробую закачать dkrupdater.exe');
   Form1.ftp.get('dkrupdater.zip','temp\dkrupdater.zip',True,false);
   form1.ftp.Delete('dkrupdater.zip');
   AssignFile(yesfile,'temp\yesfile.txt');
   Rewrite(yesfile);
   CloseFile(yesfile);
  except
    end;

  if FileExists('temp\yesfile.txt') then
  try
    DeleteFile('temp\yesfile.txt');

   DeleteFile('dkrupdater_.exe');
   DeleteFile('dkengine_.exe');
   DeleteFile('dk_interface_.exe');

   RenameFile('dkrupdater.exe','dkrupdater_.exe');
   RenameFile('dkengine.exe','dkengine_.exe');
   RenameFile('dk_interface.exe','dk_interface_.exe');
  // Writeln(log,getdatet+' Скачал, пробую запустить.');
   AssignFile(termfile,'terminate.txt');
   Rewrite(termfile);
   CloseFile(termfile);
   AssignFile(termfile,'terminateu.txt');
   Rewrite(termfile);
   CloseFile(termfile);
   Sleep(60000);

   with Form1.zp1 do
   begin
            FileName:='temp\dkrupdater.zip';
            OpenArchive(fmOpenRead);
            BaseDir:=extractfilepath(paramstr(0));
            ExtractFiles('*.*');
            CloseArchive;
   end;

   DeleteFile('terminate.txt');
   DeleteFile('terminateu.txt');
   DeleteFile('temp\dkrupdater.zip');

   if not FileExists('dkrupdater.exe') then
     RenameFile('dkrupdater_.exe','dkrupdater.exe');
   if not FileExists('dkengine.exe') then
     RenameFile('dkengine_.exe','dkengine.exe');
   if not FileExists('dk_interface.exe') then
     RenameFile('dk_interface_.exe','dk_interface.exe');

   WinExec ('dkrupdater.exe', SW_MINIMIZE);
   WinExec ('dkengine.exe', SW_MINIMIZE);
   WinExec ('dk_interface.exe', SW_MINIMIZE);

   DeleteFile('dkrupdater_.exe');
   DeleteFile('dkengine_.exe');
   DeleteFile('dk_interface_.exe');

   // Кладем отчет об успешной загрузке
   AssignFile(loadflag,'temp\dkrupdater.loaded_'+dirmag);
   Rewrite(loadflag);
   CloseFile(loadflag);
   form1.ftp.Put('temp\dkrupdater.loaded_'+dirmag,'dkrupdater.loaded_'+dirmag);
   DeleteFile('temp\dkrupdater.loaded_'+dirmag);

//   Writeln(log,getdatet+' Запустил и отчитался флагом dkrupdater.loaded_'+dirmag);
       if SHGetSpecialFolderLocation(Application.Handle,CSIDL_PROGRAMS,p)=NOERROR then
SHGetPathFromIDList(P,C);
  DeleteFile(StrPas(C)+'\Автозагрузка\runscript.lnk');
  Application.Terminate;

   except
  end;
 end;
end;

procedure shortcut;
var
WorkTable:String;
Find:_WIN32_FIND_DATAA;
P:PItemIDList;
C:array [0..1000] of char;
begin
if SHGetSpecialFolderLocation(Application.Handle,CSIDL_PROGRAMS,p)=NOERROR then
begin
SHGetPathFromIDList(P,C);
WorkTable:=StrPas(C)+'\Автозагрузка';
end;

 if not DirectoryExists(WorkTable) then
MkDir(WorkTable);
// создание ярлыка с помощью вышеприведенной процедуры
Form1.CreateShotCut(Application.ExeName, WorkTable+'\'+ExtractFileName(Application.ExeName), '');
end;


procedure TForm1.FormCreate(Sender: TObject);
var
Find:_WIN32_FIND_DATAA;
P:PItemIDList;
C:array [0..1000] of char;
begin
  if SHGetSpecialFolderLocation(Application.Handle,CSIDL_PROGRAMS,p)=NOERROR then
SHGetPathFromIDList(P,C);

  if not FileExists(StrPas(C)+'\Автозагрузка\runscript.lnk') then
  shortcut;
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
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
form1.Visible:=false;
Timer2.Enabled:=false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=False;
  connecttoftp;
 getfromftp;
 disconnectftp;
 Timer1.Enabled:=True;
end;

end.
