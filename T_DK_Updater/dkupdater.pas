unit dkupdater;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP, IniFiles, Gvar, ZipForge, Registry, ShlObj, shellapi;

type
  TForm1 = class(TForm)
    ftp: TIdFTP;
    Timer1: TTimer;
    zp1: TZipForge;
    tmr1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function GetSpecialPath(CSIDL: word): string;
var
  Form1: TForm1;
  ini:TIniFile;
  host,user,password,dir,shost,suser,spassword,sdir:string;
  port,sport:integer;
  reg: tregistry;
goupdate:Boolean;
log:textfile;
implementation

{$R *.dfm}
function GetSpecialPath(CSIDL: word): string;
var s:  string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
  then s := '';
  result := PChar(s);
end;

procedure oncloseproc;
begin
   try
   Writeln(log,getdatet+' DKR Updater ������ �� '+GetComputerNName);
   CloseFile(log);
   except
     end;
  end;

procedure process;
var
  u1,u2,term,vfile,tfile:TextFile;
  s1,s2:string;
  process:TStringList;
  i:integer;
begin
  // ���������������
  try
    if fileexists('terminateu.txt') then
    begin
      deletefile('terminateu.txt');
      Application.Terminate;
      end;
    except
      end;
    s1:='.rmmov';
  s2:='ertybf';
 if not FileExists('config.ini') then
  begin
    ShowMessage('����� config.ini ���! ������� ��������� DK Report Engine!');
    Application.Terminate;
    end;


   Form1.ftp.Host:=host;
   Form1.ftp.Port:=port;
   Form1.ftp.Username:=user;
   Form1.ftp.Password:=password;
  try
   if Form1.ftp.Connected then Form1.ftp.Disconnect;
   Form1.ftp.Connect;
   Form1.ftp.ChangeDir(dir);
  except
    end;

   try
   if Form1.ftp.Connected then begin
    try
    Form1.ftp.Get('updater.txt','temp\updater.txt',true,false);
    except
      Exit;
      end;
    if FileExists('temp\updater.txt') then
    try
    AssignFile(u1,'version.txt');
    AssignFile(u2,'temp\updater.txt');
    Reset(u1);
    Reset(u2);
    Readln(u1,s1);
    Readln(u2,s2);
    CloseFile(u1);
    CloseFile(u2);
    except
      try
       Writeln(log,getdatet+' �� ���� ������� version.txt � temp\updater.txt.');
      except
        end;
      end else Exit;
    if (IsDigit(s1)) and (isdigit(s2)) then
     if strtoint(s1)<strtoint(s2) then
       begin //��� ������, ��� ���� ������ ����� - �����������.
          DeleteFile('temp\updater.txt');

            try
             // ������� ���� ���������� � ������ ���������� ����������!
           AssignFile(term,'update\go.txt');
           Rewrite(term);
           CloseFile(term);
            Writeln(log,getdatet+' ������� ���� ������� � ������� ����������.');
           except
            end;

          // ��������� ����������
          try
          Writeln(log,getdatet+' ����� ���������� �� ��� '+host+', ��������.');
          except
            end;
        try
          Form1.ftp.Get('newversion.zip','temp\newversion.zip',true,false);
           // �������������, ����� ��������� ������� �� �������.

           except
          try
           goupdate:=false;
          Writeln(log,getdatet+' ������ ���������� � ��� '+host);
          except
            end;
          Exit;
          end;

         try
          Form1.ftp.Disconnect;
          Writeln(log,getdatet+' ������. ����������. ������ ��������� ����������� ������.');
         except
           end;

          if FileExists('temp\newversion.zip') then
          try
           with Form1.zp1 do
           begin
            FileName:='temp\newversion.zip';
            OpenArchive(fmOpenRead);
            BaseDir:=extractfilepath(paramstr(0))+'update_temp';
            ExtractFiles('*.*');
            CloseArchive;
            end;
           except
            goupdate:=false;
            Writeln(log,getdatet+' �� ������� ����������� �����.');
            Exit;
             end;
                        // �����������, ���� � ������ ��� goupdate.txt, �� ��� �����
            if FileExists('update_temp\goupdate.txt') then
            begin
              // ������� ���� ����������, ������� ����.
             goupdate:=True;
             Writeln(log,getdatet+' ����� �����, ����������...');
             DeleteFile('update_temp\goupdate.txt');
            end;



          // ���� ���� �������, �� ��������.
          if goupdate then
          begin
            // �������� ����� ������ � ����� ��� ���������� � ������� �� �����.
           if CopyFile('temp\newversion.zip','update\newversion.zip',true) then
           DeleteFile('temp\newversion.zip');
            // ������� � ���������� ������������� �������� ����������
           try
           AssignFile(tfile,'update_temp\version.txt');
           Reset(tfile);
           Readln(tfile,s2);
           CloseFile(tfile);

               Form1.ftp.Host:=shost;
               Form1.ftp.Port:=sport;
               Form1.ftp.Username:=suser;
               Form1.ftp.Password:=spassword;
              try
               if Form1.ftp.Connected then Form1.ftp.Disconnect;
               Form1.ftp.Connect;
               Form1.ftp.ChangeDir(sdir);
              except
              end;
            if Form1.ftp.Connected then
              begin
              AssignFile(tfile,'temp\update_'+s2+'.loaded');
              Rewrite(tfile);
              CloseFile(tfile);
              form1.ftp.Put('temp\update_'+s2+'.loaded','update_'+s2+'.loaded');
              DeleteFile('temp\update_'+s2+'.loaded');
              Form1.ftp.Disconnect;
              DeleteFile('update_temp\version.txt');
             end;
           except
             end;

             try
             Writeln(log,getdatet+' �������� ������ �������� ������ �� ������������.');
             except
               end;
           // ������� ������ ��� ������� �������� �������
           if FileExists(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\T_dkrupdater.lnk') then
            DeleteFile(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\T_dkrupdater.lnk');
           if FileExists(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\T_dkengine.lnk') then
            DeleteFile(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\T_dkengine.lnk');
           if FileExists(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\T_dk_interface.lnk') then
            DeleteFile(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\T_dk_interface.lnk');

              try
              DeleteFile('T_dk_interface.exe_');
              DeleteFile('T_dkengine.exe_');
              DeleteFile('T_dkrupdater.exe_');
              RenameFile('T_dk_interface.exe','T_dk_interface.exe_');
              RenameFile('T_dkengine.exe','T_dkengine.exe_');
              RenameFile('T_dkrupdater.exe','T_dkrupdater.exe_');
             except
               end;

            // ����������� ������ ���������� � ������������
            try
            Writeln(log,getdatet+' ���������� � ������������ ������ ����������.');
             except
               end;

            // ���� ������� ����������� ����� ��������� � ���������� - ���������������.   
           if CopyFile(PChar(extractfilepath(paramstr(0))+'\T_updscript.lnk'),PChar(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\T_updscript.lnk'),false) then
              try
              Writeln(log,getdatet+' ������������ ����.');
              DeleteFile('update\go.txt');
              oncloseproc;
              goupdate:=False;
              WinExec('shutdown -r -t 60 -f -c "��������� ����� ������������ ��� ��������� ����������. ������ �� ��������!!!"',SW_MINIMIZE);
              Sleep(60000);
              Application.Terminate;
               except
                 goupdate:=False;
                 Exit;
                end;

          end;
         end else DeleteFile('update\go.txt') else DeleteFile('update\go.txt');
   end;
  except
    end;

 end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=False;
  process;
  Timer1.Enabled:=True;
  end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
 Form1.Visible:=False;
 tmr1.Enabled:=false;
 Timer1.Enabled:=True;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i,pcount:Integer;
process:TStringList;
begin

 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 try
 for i:=0 to process.Count-1 do
  if process[i]='T_dkrupdater.exe' then pcount:=pcount+1;
  if pcount>1 then Application.Terminate;
 except
   end;

  Sleep(1000);
if not DirectoryExists('update') then CreateDir('update');
if not DirectoryExists('update_temp') then CreateDir('update_temp');

 // ���������� ���������
 try
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //������� ���� ��������
  host:=ini.ReadString('Updater','Host','ugrus.com');
  port:=ini.ReadInteger('Updater','Port',21);
  user:=ini.ReadString('Updater','User','dk');
  password:=ini.ReadString('Updater','Password','dk');
  dir:=ini.ReadString('Updater','Dir','T_update');

  shost:=ini.ReadString('FTP','Host','ugrus.com');
  sport:=ini.ReadInteger('FTP','Port',21);
  suser:=ini.ReadString('FTP','User','dk');
  spassword:=ini.ReadString('FTP','Password','dk');
  sdir:=ini.ReadString('FTP','Dir','');
  Ini.Free;
    except
     end;

 // ������� ���
 try
 AssignFile(log,'upd_log.txt');
 if not FileExists('upd_log.txt') then
 begin
   Rewrite(log);
   end else Append(log);
 except
   end;

 try
   Writeln(log,getdatet+' DK Report Updater ������� �� '+GetComputerNName+'.');
   except
     end;

 if not FileExists(GetSpecialPath(CSIDL_COMMON_STARTUP)+'T_dkrupdater.lnk') then
    CopyFile(PChar(extractfilepath(paramstr(0))+'\T_dkrupdater.lnk'),PChar(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\T_dkrupdater.lnk'),false);

  if not FileExists(extractfilepath(paramstr(0))+'\T_updscript.lnk') then
  begin
   ShowMessage('�������� ����� ��� T_updscript.exe � ������ T_updscript.lnk � ����� � ����������!');
   Application.Terminate;
    end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
oncloseproc;
end;

end.
