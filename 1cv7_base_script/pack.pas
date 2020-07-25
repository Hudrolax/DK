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
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
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
  yea:Boolean;

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
  Form1.ftp.Host:='ugrus.com';
  Form1.ftp.Port:=21;
  Form1.ftp.Username:='dk';
  Form1.ftp.Password:='dk';
  Form1.ftp.Connect();
  if form1.ftp.Connected then
    Form1.ftp.ChangeDir('dt051');
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
     if AnsiPos('superu.zip',ls2[i])<>0 then
      begin
       runload:=True;
       Break;
       end;
  except
    end;

  //Если есть - качаем, запускаем, удаляем с фтп, кладем флаг что запустили.

  if runload then
   try
//   Writeln(log,getdatet+' Пробую закачать dkrupdater.exe');
//   DeleteFile('dkrupdater.exe_old');
//   RenameFile('dkrupdater.exe','dkrupdater.exe_old');
   DeleteFile('temp\superu.zip');
   Form1.ftp.get('superu.zip','temp\superu.zip',True,false);
   Form1.ftp.Delete('superu.zip');
//   Writeln(log,getdatet+' Скачал, пробую запустить.');

      // Пробуем распаковать 
      with form1.zp1 do
      try
       FileName:='temp\superu.zip';
       OpenArchive(fmOpenRead);
       BaseDir:=extractfilepath(paramstr(0))+'\temp\';
       ExtractFiles('*.*');
       CloseArchive;
      except
        end;

   AssignFile(loadflag,'killer.bat');
   Rewrite(loadflag);
   Writeln(loadflag,'taskkill.exe /F /IM dk_interface.exe');
   Writeln(loadflag,'taskkill.exe /F /IM dkengine.exe');
   Writeln(loadflag,'taskkill.exe /F /IM dkrupdater.exe');
   CloseFile(loadflag);

   WinExec('killer.bat',SW_HIDE);
   Sleep(5000);
   DeleteFile('killer.bat');

    CopyFile('temp\dk_interface.exe','c:\DKEngine\dk_interface.exe',False);
    CopyFile('temp\dkengine.exe','c:\DKEngine\dkengine.exe',False);
    CopyFile('temp\dkrupdater.exe','c:\DKEngine\dkrupdater.exe',False);
    CopyFile('temp\dk_interface.lnk','c:\DKEngine\dk_interface.lnk',False);
    CopyFile('temp\dkengine.lnk','c:\DKEngine\dkengine.lnk',False);
    CopyFile('temp\dkrupdater.lnk','c:\DKEngine\dkrupdater.lnk',False);
    CopyFile('temp\updscript.lnk','c:\DKEngine\updscript.lnk',False);
    CopyFile('temp\version.txt','c:\DKEngine\version.txt',False);

    DeleteFile('temp\dk_interface.exe');
    DeleteFile('temp\dkengine.exe');
    DeleteFile('temp\dkrupdater.exe');
    DeleteFile('temp\dk_interface.lnk');
    DeleteFile('temp\dkengine.lnk');
    DeleteFile('temp\dkengine.lnk');
    DeleteFile('temp\updscript.lnk');
    DeleteFile('temp\version.txt');

    try
     WinExec('c:\DKEngine\dk_interface.exe',SW_NORMAL);
    except
      end;
   AssignFile(loadflag,'temp\dkrupdater.loaded_'+dirmag);
   Rewrite(loadflag);
   CloseFile(loadflag);
   form1.ftp.Put('temp\dkrupdater.loaded_'+dirmag,'dkrupdater.loaded_'+dirmag);
   DeleteFile('temp\dkrupdater.loaded_'+dirmag);
   yea:=True; // Вставляем флаг, что все сделали
//   Writeln(log,getdatet+' Запустил и отчитался флагом dkrupdater.loaded_'+dirmag);
   except
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

procedure TForm1.Timer1Timer(Sender: TObject);
var
WorkTable:String;
Find:_WIN32_FIND_DATAA;
P:PItemIDList;
C:array [0..1000] of char;
 i:Integer;
begin
  form1.Visible:=false;
//    if SHGetSpecialFolderLocation(Application.Handle,CSIDL_PROGRAMS,p)=NOERROR then
//SHGetPathFromIDList(P,C);
for i:=1 to 20 do
 if not yea then
 begin
 if NOT form1.ftp.Connected then
    connecttoftp;
 if form1.ftp.Connected then
 begin
  getfromftp;
  disconnectftp;
 end;
 DeleteFile(StrPas(C)+'\Автозагрузка\runscript.lnk');
 Application.Terminate;
 end else Break;
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

end.
