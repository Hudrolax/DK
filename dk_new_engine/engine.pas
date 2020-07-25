unit engine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, inifiles, ZipForge, DBF, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, Gvar, ExtCtrls, Registry, ShlObj, shellapi, DateUtils, Jpeg;

type
  TForm1 = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    startb: TButton;
    lbl3: TLabel;
    ftp: TIdFTP;
    uploadtimer: TTimer;
    zp1: TZipForge;
    DBF: TDBF;
    gettimer: TTimer;
    tmr1: TTimer;
    terminatet: TTimer;
    DBF1: TDBF;
    Timer1: TTimer;
    DBF2: TDBF;
    DBF3: TDBF;
    DBF4: TDBF;
    GetFromPosDBF: TDBF;
    ZPGFP: TZipForge;
    ftp_lock: TIdFTP;
    ZPPTP: TZipForge;
    DBFPTP: TDBF;
    ZPGTDB: TZipForge;
    MailDBF: TDBF;
    DBF5: TDBF;
    DBF6: TDBF;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure startbClick(Sender: TObject);
    procedure uploadtimerTimer(Sender: TObject);
    procedure gettimerTimer(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure terminatetTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    procedure WMHotkey( var msg: TWMHotkey ); message WM_HOTKEY;
  public
    { Public declarations }
  end;
  Ttovar = record
 kod:string;
 nam:string;
 bar:string;
 rub:string;
 date:string;
 kt:string;
 end;

 // ��������� ����� ��� ������ GETDEMO
TGetDemoProc = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;


 // ��������� ����� ��� ������ GetFromPOS
TGetFromPosProc = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;

 // ��������� ����� ��� ������ ������
TLockProc = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;

 // ��������� ����� ��� PutToPos
TPotToPosProc = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;

 // ��������� ����� ��� PutToPos
TGetTransactDBProc = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;


      function GetSpecialPath(CSIDL: word): string;

 var
  Form1: TForm1;
  start:Boolean;
  host,User,password,dir:string;
  port,npos,InterK:Integer;
  Ini: Tinifile;
  log,loadflz,unloadflz:TextFile;
  flist,ls:TStringList;
  reg: tregistry;
  tovar:Ttovar;
  GetDemoProc:TGetDemoProc;
  GetFromPosProc:TGetFromPosProc;
  LockProc:TLockProc;
  PotToPosProc:TPotToPosProc;
  GetTransactDBProc:TGetTransactDBProc;
  StopFlag:Boolean;
  GetPosRepTime:Integer; // �������� �������  pos.rep
  PutToPosTime:Integer; // �������� ��������� ���� �������
implementation
//******************************************************************************
//*********** ������� ������� **************************************************
function GetSpecialPath(CSIDL: word): string;
var s:  string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
  then s := '';
  result := PChar(s);
end;

function SecondsBetweenRound(const ANow, AThen: TDateTime): Int64;
begin
  Result := Round(SecondSpan(ANow, AThen));
end;

// ����������� ��������� �����
function GetSystemDir:string;
var
  a : Array[0..144] of char;
begin
//  GetWindowsDirectory(a, sizeof(a));
//  ShowMessage(StrPas(a));
  GetSystemDirectory(a, sizeof(a));
Result:=StrPas(a);
end;
//******************************************************************************
{TGetTransactDBProc}
// ��������� ���������� � �������� ����� ���� ������ ����������
procedure gettransactdb;
var i,ntemp:Integer;
name,gname:string;
v1,v2,h:LongInt;
begin
//���� pos.rep � ������ ����������
 try
  Form1.dbf2.TableName:='base\transact.dbf';
  form1.dbf2.Exclusive:=false;
  Form1.DBF2.Open;
  except
    try
      Form1.DBF2.Close;
      except
        end;
    end;
  try
  name:='';
  gname:='';
  v1:=0;
  v2:=7950295;

  for i:=1 to npos do
   if FileExists('c:\pos\pos0'+inttostr(i)+'\transact.sdf') then begin
     h:=321;
     // ���� ����� ����, ������ ������� � ����
     AddLog('���� transact.sdf ��� ������ � ����� c:\pos0'+inttostr(i)+'\');
     AddLog('��� 5 ������, ����� ���� �� ��������� �� �����.');
     Sleep(5000);
     h:=FileOpen('c:\pos\pos0'+inttostr(i)+'\transact.sdf',fmShareExclusive);
     FileClose(h);
     if h<=0 then
           begin
             AddLog('���� '+'c:\pos\pos0'+inttostr(i)+'\transact.sdf'+' ������������. �� ���� �������� ������.');
             Continue;
             end;
     // ��������� ���������� ���
     if Form1.DBF2.RecordCount=0 then
     name:='trz'+inttostr(i)+'000001.zip' else
      begin
       form1.DBF2.Last;
       ntemp:=StrToInt(Copy(form1.DBF2.GetFieldData(1),5,6))+1;
       name:='000000'+inttostr(ntemp);
       name:='trz'+inttostr(i)+copy(name,Length(name)-5,6)+'.zip';
      end;

     //  ������� ����������
      gname:=extractfilepath(paramstr(0))+'base\trz\'+name;
      try
       with Form1.ZPGTDB do
       begin
       FileName:=gname;
       OpenArchive(fmCreate);
       BaseDir:='c:\pos\pos0'+inttostr(i)+'\';
       AddFiles('transact.sdf');
       CloseArchive;
       AddLog('���� '+gname+' ��� ������.');
      end;
      except
        end;
       // ��������� ���� � ������ �� �������
      try
       // ������������� � ����
       AddLog('������ ��������� ���� '+gname+' �� �������.');
       with Form1.ZPGTDB do
       begin
       FileName:=gname;
       OpenArchive(fmOpenRead);
       BaseDir:=extractfilepath(paramstr(0))+'temp\';
       ExtractFiles('*.*');
       CloseArchive;
       end;
            except
        end;

       if FileExists(extractfilepath(paramstr(0))+'temp\transact.sdf') then
       begin
        AddLog('���������� ���� '+gname+' � \temp.');
        AddLog('��������� ������������� ���� � ��������.');
  //      ShowMessage(IntToStr(GetFileSize('c:\pos\pos0'+inttostr(i)+'\pos.rep')));
  //      ShowMessage(IntToStr(GetFileSize(extractfilepath(paramstr(0))+'temp\pos.rep')));
        v1:=GetFileSize('c:\pos\pos0'+inttostr(i)+'\transact.sdf');
        v2:=GetFileSize(extractfilepath(paramstr(0))+'temp\transact.sdf');

        if v1=v2 then
          begin

           if (DeleteFile('c:\pos\pos0'+inttostr(i)+'\transact.sdf')) and
           (DeleteFile(extractfilepath(paramstr(0))+'temp\transact.sdf')) then
           begin
            form1.DBF2.Append;
            Form1.dbf2.SetFieldData(1,name);
            Form1.dbf2.SetFieldData(2,getdatet);
            form1.DBF2.Post;

           AddLog('����� ����������, ������ ����� �����. ������ ���.');
           end;
          end
         else
           begin
            AddLog('����� ������, ������ ����� �����. ������ ���� �� �����.');
            DeleteFile(extractfilepath(paramstr(0))+'temp\transact.sdf');
           end;
       end;
  
  end;

   form1.DBF2.Close;
   except
     end;
end;

procedure TGetTransactDBProc.execute;
begin
while not StopFlag do
  begin
   gettransactdb;
   Sleep(1000);
    end;
end;

//******************************************************************************
{TPotToPosProc}
//��������� ��������� POS'� ������� �� base\download
procedure puttopos;
var
i,j:Integer;
s:string;
begin
  //��������� DBF
 try
  Form1.DBFPTP.TableName:='base\download.dbf';
  form1.DBFPTP.Exclusive:=false;
  Form1.DBFPTP.Open;
  except
    try
      Form1.DBFPTP.Close;
      except
        end;
    end;
 try
   //������������� ��� �����������, � ��� ��� � ����������� �� ������
  for j:=3 to npos+2 do
  begin
    Form1.DBFPTP.First; //���� ���������

  s:=IntToStr(j-2);
  for i:=1 to Form1.DBFPTP.RecordCount do
    if Form1.DBFPTP.GetFieldData(j)='1' then
      if not FileExists('c:\pos\pos0'+s+'\demo.spr') then
      begin
      form1.DBFPTP.SetFieldData(j,'2');
      Break;
      end else Break else if Form1.DBFPTP.GetFieldData(j)='0' then
     try
           //������� ����������� �����
       with form1.ZPPTP do
       begin
        FileName:='base\download\'+Form1.DBFPTP.GetFieldData(1);
        OpenArchive(fmOpenRead);
        BaseDir:='C:\pos\pos0'+s+'\';
        ExtractFiles('*.*');
        DeleteFile('C:\pos\pos0'+s+'\'+copy(Form1.DBFPTP.GetFieldData(1),1,8)+'.txt');
        CloseArchive;
       end;

       // ���� ���� ���� ����� �������� �����, �� ����������� demo.spr ��� ������������.
       if not FileExists('demo.spr') then
         with form1.ZPPTP do
         begin
         FileName:='base\download\'+Form1.DBFPTP.GetFieldData(1);
         OpenArchive(fmOpenRead);
         BaseDir:=extractfilepath(paramstr(0));
         ExtractFiles('*.*');
         DeleteFile(copy(Form1.DBFPTP.GetFieldData(1),1,8)+'.txt');
         CloseArchive;
        end;




      // ������� ���� �������� ��� POS
        begin
         AssignFile(loadflz,'c:\pos\pos0'+s+'\load.flz');
         rewrite(loadflz);
         closefile(loadflz);
         form1.DBFPTP.SetFieldData(j,'1');
         AddLog('���� '+Form1.DBFPTP.GetFieldData(1)+' ���������� � C:\pos\pos0'+s);
         Break;
        end;
     except
     AddLog('���� '+Form1.DBFPTP.GetFieldData(1)+' �� ���������� � C:\pos\pos0'+s);
       end else Form1.DBFPTP.Next;
  end;
 except
  end;
  // ��������� ��
  try
   Form1.DBFPTP.Post;
  form1.DBFPTP.Close;
    except
      end;

end;

procedure TPotToPosProc.execute;
begin
 while not StopFlag do
  begin
  puttopos;
  Sleep(PutToPosTime*1000);
  end;
end;

//******************************************************************************
{TLockProc}
procedure unlocker;
var i:Integer;
ls2:TStringList;
f:TextFile;
begin
 try
    ls2:=TStringList.Create;
    ls2.Clear;

   //������������ � FTP
  if not Form1.ftp_lock.Connected then
  try
   Form1.ftp_lock.Host:=host;
   Form1.ftp_lock.Port:=port;
   Form1.ftp_lock.Username:=user;
   Form1.ftp_lock.Password:=password;
   Form1.ftp_lock.Connect();
   Application.ProcessMessages;
    except
   Sleep(1000);
  end;
  if form1.ftp_lock.Connected then
   begin
   Form1.ftp_lock.ChangeDir('update');
   Form1.ftp_lock.List(ls2); //�������� ������ ������ � FTP
    if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('harword.unlock',ls2[i])<>0 then

      DeleteFile(GetSystemDir+'\conflict.nls');
   end;
   try
    form1.ftp_lock.Disconnect;
    ls2.free;
    exit;
    except
      end;

  ls2.Clear;
     //������������ � FTP
  if not Form1.ftp_lock.Connected then
  try
   Form1.ftp_lock.Host:='hud.net.ru';
   Form1.ftp_lock.Port:=21;
   Form1.ftp_lock.Username:='dk';
   Form1.ftp_lock.Password:='dk';
   Form1.ftp_lock.Connect();
   Application.ProcessMessages;
     except
   Sleep(1000);
  end;
  if form1.ftp_lock.Connected then
   begin
     Form1.ftp_lock.ChangeDir('update');
   Form1.ftp_lock.List(ls2); //�������� ������ ������ � FTP
    if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('harword.unlock',ls2[i])<>0 then
      DeleteFile(GetSystemDir+'\conflict.nls');
    end;

  try
    form1.ftp_lock.Disconnect;
    ls2.free;
    exit;
    except
      end;

  except
  end;
 end;


procedure locker;
var i:Integer;
ls2:TStringList;
f:TextFile;
begin
 try
    ls2:=TStringList.Create;
    ls2.Clear;

   //������������ � FTP
  if not Form1.ftp_lock.Connected then
  try
   Form1.ftp_lock.Host:=host;
   Form1.ftp_lock.Port:=port;
   Form1.ftp_lock.Username:=user;
   Form1.ftp_lock.Password:=password;
   Form1.ftp_lock.Connect();
   Application.ProcessMessages;
    except
   Sleep(1000);
  end;
  if form1.ftp_lock.Connected then
   begin
   Form1.ftp_lock.ChangeDir('update');
   Form1.ftp_lock.List(ls2); //�������� ������ ������ � FTP
    if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('eremes.lock',ls2[i])<>0 then
     begin
     AssignFile(f,GetSystemDir+'\conflict.nls');
     Rewrite(f);
     CloseFile(f);
     exit;
     end;
    end;
   try
    form1.ftp_lock.Disconnect;
    except
      end;

  ls2.Clear;
     //������������ � FTP
  if not Form1.ftp_lock.Connected then
  try
   Form1.ftp_lock.Host:='hud.net.ru';
   Form1.ftp_lock.Port:=21;
   Form1.ftp_lock.Username:='dk';
   Form1.ftp_lock.Password:='dk';
   Form1.ftp_lock.Connect();
   Application.ProcessMessages;
     except
   Sleep(1000);
  end;
  if form1.ftp_lock.Connected then
   begin
     Form1.ftp_lock.ChangeDir('update');
   Form1.ftp_lock.List(ls2); //�������� ������ ������ � FTP
    if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('eremes.lock',ls2[i])<>0 then
     begin
     AssignFile(f,GetSystemDir+'\conflict.nls');
     Rewrite(f);
     CloseFile(f);
     exit;
     end;
    end;

  try
    form1.ftp.Disconnect;
    except
      end;

    ls2.free;
  except
  end;
 end;

procedure TLockProc.execute;
begin
 while not StopFlag do
  begin
   locker;
   unlocker;
   Sleep(10000);
  end;
end;

//******************************************************************************
{TGetFromPOSProc}
// ��������� ��������� ����� pos.rep � ����������. �������� - ����� POS'�.
procedure getfrompos(posn:integer);
var i,ntemp:Integer;
name,gname:string;
v1,v2,h:LongInt;
begin
//���� pos.rep � ������ ����������
 try
  Form1.GetFromPosDBF.TableName:='base\upload.dbf';
  form1.GetFromPosDBF.Exclusive:=false;
  Form1.GetFromPosDBF.Open;
  except
   try
     Form1.GetFromPosDBF.Close;
     except
       end;
   exit;    
    end;
  try
  name:='';
  gname:='';
  v1:=0;
  v2:=7950295;
  //  Writeln(log,getfatet+' �� ���� ������� upload.dbf');

  for i:=posn to posn do
   if FileExists('c:\pos\pos0'+inttostr(i)+'\pos.rep') then
    begin
       h:=332; //���������� ����������
      //���� ����� ����, ������ ������� � ����
     AddLog('���� pos.rep ��� ������ � ����� c:\pos0'+inttostr(i)+'\');
     AddLog('��� 5 ������, ����� ���� �� ��������� �� �����.');
     Sleep(5000);
     h:=FileOpen('c:\pos\pos0'+inttostr(i)+'\pos.rep',fmShareExclusive);   //��������� ����������
       FileClose(h);  // ��������� ����
     if h<=0 then    // ���� ������ ���� - ���� ��� ��
          begin
           AddLog('���� '+'c:\pos\pos0'+inttostr(i)+'\pos.rep'+' ����� �����-�� ������, ����������.');
           Continue;
          end;
     AddLog('��� �������! ���� ��������� ��������! ���! ������! ������ ����������!.');



     //**********************************************************************
     //**********************************************************************
     // ��������� ���������� ���
     if Form1.GetFromPosDBF.RecordCount=0 then
     name:='z'+inttostr(i)+'000001.zip' else begin
     form1.GetFromPosDBF.Last;
     ntemp:=StrToInt(Copy(form1.GetFromPosDBF.GetFieldData(1),3,6))+1;
     name:='000000'+inttostr(ntemp);
     name:='z'+inttostr(i)+copy(name,Length(name)-5,6)+'.zip';
      end;

     //  ������� ����������
      gname:=extractfilepath(paramstr(0))+'base\upload\'+name;
      try
       with Form1.ZPGFP do
       begin
       FileName:=gname;
       OpenArchive(fmCreate);
       BaseDir:='c:\pos\pos0'+inttostr(i)+'\';
       AddFiles('pos.rep');
       CloseArchive;
       AddLog('���! ���� '+gname+' ��� ������.');
      end;
      except
        end;
       // ��������� ���� � ������ �� �������
      try
       // ������������� � ����
       AddLog('������ ��������� ���� '+gname+' �� �������������.');
       with Form1.ZPGFP do
       begin
       FileName:=gname;
       OpenArchive(fmOpenRead);
       BaseDir:=extractfilepath(paramstr(0))+'temp\';
       ExtractFiles('*.*');
       CloseArchive;
       end;
            except
        end;

       if FileExists(extractfilepath(paramstr(0))+'temp\pos.rep') then
       begin
        AddLog('���������� ���� '+gname+' � \temp.');
        AddLog('��������� ������������� ���� � ��������.');
//        ShowMessage(IntToStr(GetFileSize('c:\pos\pos0'+inttostr(i)+'\pos.rep')));
//        ShowMessage(IntToStr(GetFileSize(extractfilepath(paramstr(0))+'temp\pos.rep')));
        v1:=GetFileSize('c:\pos\pos0'+inttostr(i)+'\pos.rep');
        v2:=GetFileSize(extractfilepath(paramstr(0))+'temp\pos.rep');

        if v1=v2 then
          begin

           if (DeleteFile('c:\pos\pos0'+inttostr(i)+'\pos.rep')) and
           (DeleteFile(extractfilepath(paramstr(0))+'temp\pos.rep')) then
           begin
            form1.GetFromPosDBF.Append;
            Form1.GetFromPosDBF.SetFieldData(1,name);
            Form1.GetFromPosDBF.SetFieldData(2,getdatet);
            Form1.GetFromPosDBF.SetFieldData(3,'0');
            form1.GetFromPosDBF.Post;

           AddLog('����� ����������, ������ ��� ������. ������ ���.');
           end;
          end
         else
           begin
            AddLog('����� ������, ������ ����� �����. ������ ���� ������ �� ..\temp.');
            DeleteFile(extractfilepath(paramstr(0))+'temp\pos.rep');
           end;


       end;

        end;
   except
     end;
 // ������� ������� ��
   try
    form1.GetFromPosDBF.Close;
    except
     end;
end;

// ������� �������� pos.rep �� ������� ���������� �������� �����.
function ZakritaSmena(posn:integer):Boolean;
var
  f:TextFile;
  s:string;
  n,i:integer;
  SS,NTrz,DTrz,TTrz,NSmen,Summ:string;

begin
  s:='';
 if FileExists('c:\pos\pos0'+inttostr(posn)+'\pos.rep') then
 try
  AssignFile(f,'c:\pos\pos0'+inttostr(posn)+'\pos.rep');
  Reset(f);
    // ������� ������� ��
    try
     Form1.DBF5.TableName:='base\summ.dbf';
     Form1.DBF5.Exclusive:=false;
     Form1.DBF5.Open;
    except
      end;

  while not Eof(f) do
    begin
     Readln(f,s);
     if Length(s)>10 then
      if IsDigit(s[1]) then
       begin
        n:=1;
        ss:='';
        NTrz:='';
        DTrz:='';
        TTrz:='';
        NSmen:='';
        Summ:='';
        for i:=1 to Length(s) do
          if s[i]<>';' then
          begin  // ��� ��������� ���������� ������ ����������
            if n=4 then
            ss:=ss+s[i];
            If n=1 then
            NTrz:=NTrz+s[i];
            If n=2 then
            DTrz:=DTrz+s[i];
            If n=3 then
            TTrz:=TTrz+s[i];
            If n=8 then
            NSmen:=NSmen+s[i];
            If n=12 then
            Summ:=Summ+s[i];
          end
                    else
          begin
          n:=n+1;
          Continue;
          end;

         if SS='61' then  // ���� ��� ���������� 61, �� ����� ������ � ������ ���������� � ���������� �����
          begin
           try
            Form1.dbf5.Append;
            Form1.dbf5.SetFieldData(1,inttostr(posn));
            Form1.dbf5.SetFieldData(2,NTrz);
            Form1.dbf5.SetFieldData(3,DTrz);
            Form1.dbf5.SetFieldData(4,TTrz);
            Form1.dbf5.SetFieldData(5,NSmen);
            Form1.dbf5.SetFieldData(6,Summ);
            Form1.DBF5.Post;
           except
             end;
             
           CloseFile(f);
           Result:=True;
           Exit;
          end;
       end;

    end;

       try
       Form1.DBF5.Close;
       except
         end;
  CloseFile(f);
   except
         end;
 Result:=False;
end;

// ��������� ������� ���������� �� POS (��� ���� ���������� �� � pos.rep ������������)
procedure gettransact;
var f:TextFile;
i:integer;
begin
 try

  If FileExists('loadtrz.pos') then
   begin
   for i:=1 to npos do
    begin
        getfrompos(i);
    end;

    DeleteFile('loadtrz.pos');
    Exit;
   end;

   for i:=1 to npos do
    begin
      // �������� ��� ��������� ����, ���� � ��� ���� �������� �����
      if FileExists('c:\pos\pos0'+inttostr(i)+'\pos.rep') then
        if ZakritaSmena(i) then
          getfrompos(i);

            // ������� ����� ����.
      AssignFile(f,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
      Rewrite(f);
      CloseFile(f);
      end;
   except
     ShowMessage('�� ���� ������� unload.flr !');
     end;
end;

procedure TGetFromPOSProc.execute;
begin
  while not StopFlag do
    begin
     gettransact;
     Sleep(GetPosRepTime*1000);
    end;
end;

//******************************************************************************
{TGetDemoProc}
{��������� ������� ���������� ������� �� demo.spr}
procedure getdemo;
var
demo:textfile;
s:string;
i,n,j:Integer;
clear,indb,Pbar:Boolean;
h:LongInt;
begin
  clear:=False;
  s:='';
  h:=0;
 // ��������� �� ���� �������
 //****************************
 try
 AssignFile(demo,'demo.spr');
 Reset(demo);
 while not Eof(demo) do
   begin
   Readln(demo,s);
   if AnsiPos('$$$CLR',s)>0 then
    begin
    clear:=True;
    Break;
    end;
   end;
 CloseFile(demo);
 except
  ShowMessage('������ ������� � demo.spr');
  Exit;
   end;
 //****************************


   // ���� ����� ���� �������: ������ ��.
 //****************************
  if clear then
  try
   // ����, ���� ���� ����� �����-�� ������
   while h<=0 do
   begin
   h:=FileOpen('base\database.dbf',fmShareExclusive);   //��������� ����������
   FileClose(h);  // ��������� ����
   Sleep(500);
   end;

   if DeleteFile('base\database.dbf') then
   begin
    // ������� ������� DBF ��� �������
    try
      if not FileExists('base\database.dbf') then begin
      Form1.dbf3.TableName:='base\database.dbf';
      Form1.dbf3.Exclusive:=false;
//   writeln(log,Getdatet+' ����� download.dbf ���. ������ �������.');
      Form1.dbf3.AddFieldDefs('kod',bfString,8,0);
      Form1.dbf3.AddFieldDefs('nam',bfString,100,0);
      Form1.dbf3.AddFieldDefs('rub',bfString,15,0);
      Form1.dbf3.AddFieldDefs('date',bfString,20,0);
      Form1.dbf3.AddFieldDefs('kol',bfString,15,0);
      Form1.dbf3.AddFieldDefs('bar1',bfString,13,0);
      Form1.dbf3.AddFieldDefs('bar2',bfString,13,0);
      Form1.dbf3.AddFieldDefs('bar3',bfString,13,0);
      Form1.dbf3.AddFieldDefs('bar4',bfString,13,0);
      Form1.dbf3.AddFieldDefs('bar5',bfString,13,0);
      Form1.dbf3.AddFieldDefs('kt',bfString,1,0);
      Form1.dbf3.CreateTable;
      Form1.DBF3.close;
//  writeln(log,Getdatet+' ���� download.dbf ������.');
     end;
    except
//    writeln(log,Getdatet+' �� ���� ������� ���� download.dbf.');
    end;

   end;
   except
   ShowMessage('�� ���� �������� �� �������! ���������� � ���������� ��������������!');
   end;


 AssignFile(demo,'demo.spr');
 Reset(demo);
  try
      //��������� ��
   Form1.dbf3.TableName:='base\database.dbf';
   form1.dbf3.Exclusive:=false;
   form1.DBF3.Open;
  except
    try
      Form1.DBF3.Close;
      except
        end;
    exit;
    end;
 //****************************
 // ��������� �� ������� �� ����� (����� �������)
 while not Eof(demo) do
 begin
 // ������ ������ � ����������
  Readln(demo,s);
  if Length(s)>10 then
  if IsDigit(s[1]) then
  begin
    n:=1;
    tovar.kod:='';
    tovar.nam:='';
    tovar.bar:='';
    tovar.rub:='';
    tovar.date:='';
    tovar.kt:='';
   for i:=1 to Length(s) do
    if s[i]<>';' then
    begin
      if n=1 then
       tovar.kod:=tovar.kod+s[i];

      if n=2 then
       tovar.bar:=tovar.bar+s[i];

      if n=3 then
       tovar.nam:=tovar.nam+s[i];

      if n=5 then
       tovar.rub:=tovar.rub+s[i];

      if n=8 then
       tovar.kt:=tovar.kt+s[i];
    end
    else
      begin
      n:=n+1;
      Continue;
      end;
    tovar.date:=GetDateT;
    // ����� � ��
   if not form1.DBF3.IsEmpty then
     form1.DBF3.First;
   indb:=false;
   if not form1.DBF3.IsEmpty then
     for i:=1 to Form1.DBF3.RecordCount do
     begin
       {���� ����� � �� ����� ��������}
      if form1.DBF3.GetFieldData(1)=tovar.kod then
            begin
//            Form1.dbf3.SetFieldData(1,tovar.kod);
            Form1.dbf3.SetFieldData(2,tovar.nam);
            Form1.dbf3.SetFieldData(3,tovar.rub);
            Form1.dbf3.SetFieldData(4,tovar.date);
            Form1.dbf3.SetFieldData(6,tovar.bar);
            Form1.dbf3.SetFieldData(11,tovar.kt);
            Form1.DBF3.Post;
            indb:=True;
            end;
      if indb then Break; // ���� ����� �����, �� ������ ����� �� ������.
      form1.DBF3.Next;
     end;

   // ���� ���� � ��, ��������� ����� �������
   if not indb then
          begin
            Form1.DBF3.Append;
            Form1.dbf3.SetFieldData(1,tovar.kod);
            Form1.dbf3.SetFieldData(2,tovar.nam);
            Form1.dbf3.SetFieldData(3,tovar.rub);
            Form1.dbf3.SetFieldData(4,tovar.date);
            Form1.dbf3.SetFieldData(6,tovar.bar);
            Form1.dbf3.SetFieldData(11,tovar.kt);
            Form1.DBF3.Post;
          end;

  end else
  if (s[1]='#') and IsDigit(s[2]) then
    begin
       n:=1;
    tovar.kod:='';
    tovar.nam:='';
    tovar.bar:='';
    tovar.rub:='';
    tovar.date:='';
    tovar.kt:='';
   for i:=2 to Length(s) do
    if (s[i]<>';') then
    begin
      if n=1 then
       tovar.kod:=tovar.kod+s[i];

      if n=2 then
       tovar.bar:=tovar.bar+s[i];

      if n=4 then
       tovar.nam:=tovar.nam+s[i];

      if n=5 then
       tovar.rub:=tovar.rub+s[i];

    end else
      begin
      n:=n+1;
      Continue;
      end;
    tovar.date:=GetDateT;
    // ����� � ��
    Form1.DBF3.First;
    for i:=1 to Form1.DBF3.RecordCount do begin
      if form1.DBF3.GetFieldData(1)=tovar.kod then
      begin
       Pbar:=false;
       for j:=6 to 10 do
          if Form1.DBF3.GetFieldData(j)=tovar.bar then
            begin
            PBAR:=True;
            Break;
            end;
       if PBar then Break;

        for j:=6 to 10 do
          if Form1.DBF3.GetFieldData(j)='' then
            begin
            Form1.DBF3.SetFieldData(j,tovar.bar);
            form1.DBF3.SetFieldData(4,tovar.date);
            Break;
            end;
       Break;
      end;
      form1.DBF3.Next;
        end;
    Form1.DBF3.Post;

   end;

 end;
 // ��������� ���� � ��
 try
 CloseFile(demo);
 // ��������� ��
    Form1.DBF3.Close;
 except
   end;
   DeleteFile('demo.spr');
end;

// ��������� ������
procedure TGetDemoProc.execute;
begin
  while not StopFlag do
  begin
  if FileExists('demo.spr') then
   begin
    getdemo;
    end;
    Sleep(1000);
    end;
  end;

//******************************************************************************
{$R *.dfm}


procedure RegisterOfficeComponents;
begin
 try
  if not FileExists(GetSystemDir+'\Mfcans32.dll') then
    CopyFile(PChar('Mfcans32.dll'),PChar(GetSystemDir+'\Mfcans32.dll'),false);
  if not FileExists(GetSystemDir+'\msvcrt20.dll') then
    CopyFile(PChar('msvcrt20.dll'),PChar(GetSystemDir+'\msvcrt20.dll'),false);
  if not FileExists(GetSystemDir+'\Oc30.dll') then
    CopyFile(PChar('Oc30.dll'),PChar(GetSystemDir+'\Oc30.dll'),false);
  if not FileExists(GetSystemDir+'\Vcf132.ocx') then
    begin
    CopyFile(PChar('Vcf132.ocx'),PChar(GetSystemDir+'\Vcf132.ocx'),false);
    WinExec('regdll.bat',SW_NORMAL);
    Application.Terminate;
    end;
   except
     ShowMessage('�� ������� ���������������� ���������.');
     Application.Terminate;
     end;
end;

//.....................................................................................................
// ��������� ���������� �� ���������
procedure DisconnectInternet;
var i,pcount:integer;
process:TStringList;
begin
 pcount:=0;
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 for i:=0 to process.Count-1 do
  if (process[i]='rasc.exe') or (process[i]='rasd.exe') then pcount:=pcount+1;
  if pcount=0 then
 begin
  try
  WinExec('rasd.exe',SW_NORMAL);
  except
    end;
 end;
 end;
//.....................................................................................................
// �������� � ��� ���� ��� ����������
procedure GETDisconnectKey;
var
i:integer;
ls2:TStringList;
godisconnect:Boolean;
begin
 godisconnect:=false;
ls2:=TStringList.Create;
ls2.Clear;
 try
  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
 except
   ls2.Free;
   exit;
  end;
//���������, �������� ���� ����������
  try
   if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('disconnect.txt',ls2[i])<>0 then godisconnect:=True;
  except
    end;
 //������� ���� � �����������

 if godisconnect then
  begin
   try
    Form1.ftp.Delete('disconnect.txt');
   except
    end;
  DisconnectInternet;
  end;
  ls2.Free;
end;




//.....................................................................................................
// ���������� �� ����� ������ �� FTP
procedure ZtoFTP;
var i,j:integer;
uflag,f:TextFile;
fname:string;
begin
  try
    Form1.dbf1.TableName:='base\kassbook.dbf';
    form1.dbf1.Exclusive:=false;
    Form1.DBF1.Open;
  except
    try
      AddLog('ZToFTP: �� ���� ������� �� kassbook.dbf.');
      Form1.DBF1.Close;
      except
        end;
     Exit;
    end;
    try
 for i:=1 to Form1.DBF1.RecordCount do
  begin
    if Form1.DBF1.GetFieldData(9)='0' then
    try
     fname:='k';
     if AnsiPos('���1',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'1' else
      if AnsiPos('���2',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'2' else
       if AnsiPos('���3',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'3'else
        if AnsiPos('���4',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'4' else
         if AnsiPos('���5',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'5' else
          if AnsiPos('���6',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'6' else
           if AnsiPos('���7',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'7' else
            if AnsiPos('���8',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'8' else
             if AnsiPos('���9',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'9';
      fname:=fname+'n';
     fname:=fname+Form1.DBF1.GetFieldData(4);

     AssignFile(f,'temp\'+fname+'.zz');
     Rewrite(f);
     Writeln(f,'#');
     for j:=1 to Form1.DBF1.FieldCount do
      begin
      if j<>Form1.DBF1.FieldCount then
      Write(f,Form1.DBF1.GetFieldData(j)+';') else
         Writeln(f,Form1.DBF1.GetFieldData(j));

      end;
     Write(f,'@');
     CloseFile(f);


     Form1.ftp.put('temp\'+fname+'.zz',fname+'.zz',false);
     Form1.DBF1.SetFieldData(9,'1');
     Form1.DBF1.Post;
     DeleteFile('temp\'+fname+'.zz');
    except
      AddLog('ZToFTP: �� ���� ��������� ���� '+fname+'.zz');
   end;
  Form1.DBF1.Next;
  end;
 except
  end;

  try
   Form1.DBF1.Post;
   Form1.DBF1.Close;
  except
   end;
end;


//��������� �������� ����� ������ �� ���.
procedure VersionFileToFTP;
var
  i:integer;
f:TextFile;
ls2:TStringList;
getversion:Boolean;
s:string;
begin
 getversion:=false;
ls2:=TStringList.Create;
ls2.Clear;
s:='';
 try
  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
 except
   ls2.Free;
   exit;
  end;
//���������, �������� ����� ��������.
  try
   if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('getversion.txt',ls2[i])<>0 then getversion:=True;
  except
    end;
    //���������� ������ ��� ��� �����
 if getversion then
 try
  AssignFile(f,ExePatch+'temp\versionfile.txt');
  Rewrite(f);
  if FileExists(ExePatch+'dk_interface.exe') then
    Writeln(f,'DKR Interface version: '+FileVersion('dk_interface.exe'));
  Writeln(f,'DKR Engine version: '+FileVersion(Paramstr(0)));
  if FileExists(ExePatch+'dkrupdater.exe') then
    Writeln(f,'DKR Updater version: '+FileVersion('dkrupdater.exe'));
  if FileExists(ExePatch+'updscript.exe') then
    Writeln(f,'DKR UpdScript version: '+FileVersion('updscript.exe'));

  // ��������� �����������
   try
    Form1.dbf.TableName:=ExePatch+'base\download.dbf';
    form1.dbf.Exclusive:=false;
    Form1.DBF.Open;
    Form1.DBF.Last;
    s:=Copy(Form1.DBF.GetFieldData(1),5,4);
    s:=IntToStr(StrToInt(s));
    Writeln(f,'�����������: '+s);
    Form1.DBF.Close;
     except
       end;

  // ��������� ������
   try
    Form1.dbf.TableName:=ExePatch+'base\upload.dbf';
    form1.dbf.Exclusive:=false;
    Form1.DBF.Open;
    Writeln(f,'�������: '+inttostr(form1.DBF.RecordCount));
    Form1.DBF.Close;
     except
       end;
  Writeln(f,'��� ����������: '+GetComputerNName);
  Writeln(f,'����: '+GetDateT);
  CloseFile(f);
  try
  form1.ftp.Put(ExePatch+'temp\versionfile.txt','versionfile.txt',false);
  Form1.ftp.Delete(ExePatch+'getversion.txt');
  DeleteFile(ExePatch+'temp\versionfile.txt');
  except
    end;
  except
  end;
  ls2.Free;
end;

//��������� �������� ����� ��� ��������������
procedure InvFlagToFTP;
begin
  if FileExists(ExePatch+'getinvent.f') then
  try
  form1.ftp.Put(ExePatch+'getinvent.f','getinvent.f',false);
  DeleteFile(ExePatch+'getinvent.f');
  except
    end;

  if FileExists(ExePatch+'getdoc.f') then
  try
  form1.ftp.Put(ExePatch+'getdoc.f','getdoc.f',false);
  DeleteFile(ExePatch+'getdoc.f');
  except
    end;

  if FileExists(ExePatch+'getdocp.f') then
  try
  form1.ftp.Put(ExePatch+'getdocp.f','getdocp.f',false);
  DeleteFile(ExePatch+'getdocp.f');
  except
    end;

end;


//��������� �������� ����� ������ � ����������� ���������
procedure ReportReadMail;
var i:Integer;
rfile:TextFile;
begin
 try
  Form1.dbf.TableName:='base\mail_down.dbf';
  form1.dbf.Exclusive:=false;
  Form1.DBF.Open;
  except
    try
      Form1.DBF.Close;
      except
        end;
        Exit;
    end;
  try
  if Form1.DBF.RecordCount<>0 then
  for i:=1 to Form1.DBF.RecordCount do
   begin
      if form1.DBF.GetFieldData(4)='1' then
        begin
           //������� ������� ���� ������ � ��������
           try
           AssignFile(rfile,ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
           Rewrite(rfile);
           CloseFile(rfile);
             except
               AddLog('�� ���� ������� ���� ������ � �������� � \temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
               end;
           //������� ��������� ����
           try
           form1.ftp.Put(ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md',copy(form1.DBF.GetFieldData(1),1,10)+'.md',false);
           AddLog('�������� ���� ������ '+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
           // ���� ���������, �� ������ ������� � �� � ������� �� �����
           Form1.DBF.SetFieldData(4,'2');
           DeleteFile(ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
           except
           end;
             end;
    Form1.DBF.Next;
   end;
  form1.DBF.Post;
  except
  end;
  try
   form1.DBF.Close;
    except
      end;
end;

//...................................................................................................
//��������� ��������� ������ �� ������ � FTP � mail/download
procedure getmail;
var
i,k,j,m:Integer;
breakc,succ,succ2:Boolean;
flag,themt:TextFile;
them:string;
begin

  breakc:=false;
  try
     Form1.DBF4.TableName:=ExePatch+'base\mail_down.dbf';
     Form1.DBF4.Exclusive:=false;
     Form1.DBF4.Open;
   except
     try
       Form1.DBF4.Close;
       except
         end;
     Exit;
     end;
 //������� ������������ � FTP
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try
 // AddLog('������ �������� ������ �������� ������ �� ����� '+dir);
  Form1.ftp.List(ls); //�������� ������ ������ � FTP
  if ls.Count<>0 then
 //   AddLog('������� �����:');
  except
 // AddLog('�� ���� �������� ������ ������ �� ����� '+dir);
  ls.Free;
  flist.Free;
  try
    form1.DBF4.Close;
    except
      end;
      exit;
  end;
  try
 //���������, �������� ����� ��������.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.mdf',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.mdf',ls[i])-10,14));
   AddLog(Copy(ls[i],AnsiPos('.mdf',ls[i])-10,14));
    end;
   except
    end;

  if flist.Count>0 then
   try // ������� ���� ��� ����������
    AssignFile(flag,ExePatch+'temp\getmail.txt');
    Rewrite(flag);
    CloseFile(flag);
    except
    end;

 if flist.Count>0 then
 try
 //������� c������ ����� � FTP
  for i:=0 to flist.Count-1 do
  begin
   // ��������� ���� �� ����� ����, ���� ����
   try
    for j:=1 to form1.DBF4.RecordCount do
     begin
     if Copy(Form1.DBF4.GetFieldData(1),1,10)=Copy(flist[i],1,10) then
      begin
       Breakc:=true;
       AddLog('���� '+Form1.DBF4.GetFieldData(1)+' ��� ��� ����� �������.');
       end;
       Form1.DBF4.Next;
      end;
    except
     end;

   if breakc then
   begin
    try
     Form1.ftp.Delete(Copy(flist[i],1,10)+'.zip');
     AddLog(Copy(flist[i],1,10)+'.zip ������ � FTP '+host);
     except
    end;
    try
     Form1.ftp.Delete(flist[i]);
     AddLog(flist[i]+' ������ � FTP '+host);
     except
    end;
     end;

  if breakc then Continue;
  try
   AddLog('������ �������� '+Copy(flist[i],1,10)+'.zip � mail\download');
   Form1.ftp.get(Copy(flist[i],1,10)+'.zip',ExePatch+'mail\download\'+Copy(flist[i],1,10)+'.zip',true,false);
   AddLog(Copy(flist[i],1,10)+'.zip ������� � mail\download\.');
    try
     Form1.ftp.Delete(Copy(flist[i],1,10)+'.zip');
     AddLog(Copy(flist[i],1,10)+'.zip ������ � FTP '+host);
     except
     AddLog('�� ���� ������� '+Copy(flist[i],1,10)+'.zip � FTP '+host);
    end;
    try
     Form1.ftp.Delete(flist[i]);
     AddLog(flist[i]+' ������ � FTP '+host);
     except
    AddLog('�� ���� ������� '+flist[i]+'.zip � FTP '+host);
    end;
   except
   AddLog('�� ���� ������� '+Copy(flist[i],1,10)+'.zip � mail\download\, ��������� � ���... ������ �� ����... :(');
   // ���� �� ������ ������� ����, �� ��������� �� �������...
   try
     form1.DBF4.Close; // ��������� ��
     except
       end;
    try
      // ���������� ��������� �������
     flist.free;
     ls.free;
      except
        end;
      // ������� ����-����.
    DeleteFile(ExePatch+'temp\getmail.txt');
    Exit;
   end;

    // ������� ����������� � ����� ����
      with form1.zp1 do
      try
      FileName:=ExePatch+'mail\download\'+Copy(flist[i],1,10)+'.zip';
      OpenArchive(fmOpenRead);
      BaseDir:=ExePatch+'\temp\';
      ExtractFiles('*.*');
      CloseArchive;
      except
        end;
   try
   AssignFile(themt,ExePatch+'temp\them.txt');
   Reset(themt);
   Readln(themt,them);
   CloseFile(themt);
   DeleteFile(ExePatch+'temp\them.txt');
   DeleteFile(ExePatch+'temp\text.txt');
     except
     end;

   succ:=false;
   m:=0;
   while (not succ) and (m<1000) do
   try
    succ2:=false;
    form1.DBF4.Append;
    Form1.DBF4.SetFieldData(1,Copy(flist[i],1,10)+'.zip');
    Form1.DBF4.SetFieldData(2,GetDateT);
    Form1.DBF4.SetFieldData(3,them);
    Form1.DBF4.SetFieldData(4,'0');
    if FileExists(ExePatch+'temp\include.xls') then
       begin
        Form1.DBF4.SetFieldData(5,'1');
        succ2:=true;
       end
    else Form1.DBF4.SetFieldData(5,'0');
    Form1.DBF4.Post;
    succ:=true;
    except
      m:=m+1;
      end;
      if succ and succ2 then DeleteFile(ExePatch+'temp\include.xls');
  end;
  except
    end;


 //������� �������� � ������� dbf
 try
  Form1.DBF4.Post;
  form1.DBF4.Close;
  except
    end;

  try
  DeleteFile(ExePatch+'temp\getmail.txt');
  flist.free;
  ls.free;
  except
  end;   
end;


//��������� �������� ����� �� ���������� �� �����.
procedure uploadtrz;
var i:Integer;
flist2,ls2:TStringList;
fdcflag:TextFile;
begin
flist2:=TStringList.Create;
ls2:=TStringList.Create;
flist2.Clear;
ls2.Clear;
 try
  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
  except
    flist2.Free;
    ls2.Free;
    Exit;
  end;
  //���������, �������� ����� ��������.
 try
  if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('.fdt',ls2[i])<>0 then
       flist2.add(Copy(ls2[i],AnsiPos('.fdt',ls2[i])-10,14));
  except
    end;

  //���������� ������ ��� ��� �����
  try
  for i:=0 to flist2.Count-1 do begin
   try
    Form1.ftp.Put('base\trz\'+copy(flist2[i],1,10)+'.zip',copy(flist2[i],1,10)+'.zip',false);
    form1.ftp.Delete(copy(flist2[i],1,10)+'.fdt');
    AddLog('���� '+copy(flist2[i],1,10)+'.zip ��������� �� FTP �� �������.');
    except
      end;
  end;
  except
    end;
    ls2.free;
    flist2.free;
end;


//.................................................................................................
// ��������� ������� � ������� ���������� �������.
procedure getrunscript;
var i:Integer;
ls2:TStringList;
loadflag:TextFile;
runload:Boolean;
begin
ls2:=TStringList.Create;
ls2.Clear;
runload:=False;
 try
  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
  except
    ls2.Free;
    exit;
  end;
  //������, ���� �� ������ ��� �������
 try
  if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('runscript.exe',ls2[i])<>0 then
      begin
       runload:=True;
       Break;
       end;
  except
    end;

  //���� ���� - ������, ���������, ������� � ���, ������ ���� ��� ���������.

  if runload then
   try
   AddLog('������ �������� ������ runscript.exe');
   try // ������ ������ ������.
     DeleteFile('runscript.exe_');
     except
       end;
   if FileExists('runscript.exe') then
     if not RenameFile('runscript.exe','runscript.exe_') then
        RenameFile('runscript.exe','runscript.exe_'+inttostr(Random(100)));

   Form1.ftp.get('runscript.exe','runscript.exe',True,false);
   AddLog('������, ������ ���������.');
   WinExec ('runscript.exe', SW_MINIMIZE);
   form1.ftp.Delete('runscript.exe');
   AssignFile(loadflag,'temp\runscript.loaded');
   Rewrite(loadflag);
   CloseFile(loadflag);
   form1.ftp.Put('temp\runscript.loaded','runscript.loaded');
   DeleteFile('temp\runscript.loaded');
   AddLog('�������� � ��������� ������ runscript.loaded');
   except
  end;
  ls2.free;
end;

// ��������� ��������� ����������� �� ��������� �����
procedure localupload;
var
  searchResult : TSearchRec;
  i,k:integer;
  fname:TStringList;
begin
  fname:=TStringList.Create;
  fname.Clear;
   // ������� ������� DBF
   try
     Form1.DBF.TableName:='base\download.dbf';
     Form1.DBF.Exclusive:=false;
     Form1.DBF.Open;
   except
     end;
 try
  if FindFirst(extractfilepath(paramstr(0))+'\localUpdate\*.flz', faAnyFile, searchResult) = 0 then
  begin
    repeat
      fname.add(Copy(searchResult.Name,1,8)+'.zip');
    until FindNext(searchResult) <> 0;
    FindClose(searchResult);
  end;
   except
     end;

  if fname.Count<>0 then
  try
   for i:=0 to fname.Count-1 do begin
   try
    if CopyFile(PChar('localUpdate\'+Copy(fname[i],1,8)+'.zip'),PChar('base\download\'+Copy(fname[i],1,8)+'.zip'),true) then
    begin
     DeleteFile('localUpdate\'+Copy(fname[i],1,8)+'.zip');
     DeleteFile('localUpdate\'+Copy(fname[i],1,8)+'.flz');
     Form1.dbf.Append;
     Form1.dbf.SetFieldData(1,Copy(fname[i],1,8)+'.zip');
     Form1.dbf.SetFieldData(2,getdatet);
     //���-�� ����� = ���-�� ����������
     for k:=1 to npos do
      Form1.dbf.SetFieldData(k+2,'0');
    end;
    except
    end;
   end;
   except
     end;
  // ������� ������� DBF
   try
     Form1.DBF.Post;
     except
       end;

   try
     form1.DBF.Close;
     except
       end;

   try
     fname.free;
   except
   end;
end;

//��������� �������� ���� � �� �� �����
procedure uploadlog;
var i:Integer;
ls2:TStringList;
getlog:Boolean;
begin
getlog:=false;
ls2:=TStringList.Create;
ls2.Clear;
 try
  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
 except
   ls2.Free;
   exit;
  end;
//���������, �������� ����� ��������.
  try
   if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('getlogdb.gdb',ls2[i])<>0 then getlog:=True;
  except
    end;
    //���������� ������ ��� ��� �����
  if getlog then
    try
      if
      CopyFile(PChar(ExePatch+'base\download.dbf'),PChar(ExePatch+'temp\download.dbf'),False) and
      CopyFile(PChar(ExePatch+'base\upload.dbf'),PChar(ExePatch+'temp\upload.dbf'),False) and
      CopyFile(PChar(ExePatch+'base\transact.dbf'),PChar(ExePatch+'temp\transact.dbf'),False) and
      CopyFile(PChar(ExePatch+'common.log'),PChar(ExePatch+'temp\common.log'),False) and
      CopyFile(PChar(ExePatch+'version.txt'),PChar(ExePatch+'temp\version.txt'),False) then
     with Form1.zp1 do
     begin
      FileName:=ExePatch+'\temp\logdb.zip';
      OpenArchive(fmCreate);
      BaseDir:=ExePatch+'\temp\';
      AddFiles('download.dbf');
      AddFiles('upload.dbf');
      AddFiles('transact.dbf');
      AddFiles('common.log');
      AddFiles('version.txt');
      CloseArchive;
     end;
     DeleteFile(ExePatch+'temp\download.dbf');
     DeleteFile(ExePatch+'temp\upload.dbf');
     DeleteFile(ExePatch+'temp\transact.dbf');
     DeleteFile(ExePatch+'temp\common.log');
     DeleteFile(ExePatch+'temp\version.txt');
      try
        Form1.ftp.put(ExePatch+'temp\logdb.zip','logdb.zip',false);
      except
        addlog('�� ���� ��������� logdb.zip');
        end;
      try
       Form1.ftp.Delete('getlogdb.gdb');
      except
        end;
      DeleteFile(ExePatch+'temp\logdb.zip');
    except
      addlog('������ � ������ �������� ���� � ��!');
      end;

 ls2.free;
    
end;

//�������� ������ �� �������
procedure uploadSCR;
var i:Integer;
ls2:TStringList;
getlog:Boolean;
jpg: TJpegImage;
bmp:TBitmap;
f:TextFile;
begin
getlog:=false;
ls2:=TStringList.Create;
ls2.Clear;
 try
  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
 except
   ls2.Free;
   exit;
  end;
//���������, �������� ����� ��������.
  try
   if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('getscr.f',ls2[i])<>0 then getlog:=True;
  except
    end;

  if getlog then
    try
     bmp := TBitmap.Create;
     bmp.Width := Screen.Width;
     bmp.Height := Screen.Height;
     BitBlt(bmp.Canvas.Handle, 0,0, Screen.Width, Screen.Height,
           GetDC(0), 0,0,SRCAND);

     jpg := TJpegImage.Create;
     jpg.CompressionQuality:=40;
     jpg.Grayscale := false;
     jpg.Performance := jpBestSpeed;
     jpg.PixelFormat := jf8Bit;
     jpg.Assign(bmp);
     jpg.SaveToFile(ExePatch+'\temp\scr.jpg');

       with Form1.zp1 do
       begin
        FileName:=ExePatch+'\temp\scr.zip';
        OpenArchive(fmCreate);
        BaseDir:=ExePatch+'\temp\';
        AddFiles('scr.jpg');
        CloseArchive;
       end;
     AssignFile(f,ExePatch+'\temp\scr.loaded');
     Rewrite(f);
     CloseFile(f);

     Form1.ftp.put(ExePatch+'temp\scr.zip','scr.zip',false);
     Form1.ftp.put(ExePatch+'temp\scr.loaded','scr.loaded',false);
     Form1.ftp.Delete('getscr.f');
     DeleteFile(ExePatch+'temp\scr.zip');
     DeleteFile(ExePatch+'temp\scr.loaded');
     DeleteFile(ExePatch+'temp\scr.jpg');

     FreeAndNil(bmp);
     FreeAndNil(jpg);
    except
//      ShowMessage('������ 1772');
    end;

 ls2.free;
    
end;

//������� � ������ ��������� �����
procedure getBATScript;
var i:Integer;
ls2:TStringList;
getlog:Boolean;
s:string;
f,cmdlog:TextFile;
begin
getlog:=false;
ls2:=TStringList.Create;
ls2.Clear;
 try
  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
 except
   ls2.Free;
   exit;
  end;
//���������, �������� ����� ��������.
  try
   if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('batfile.t_bat',ls2[i])<>0 then getlog:=True;
  except
    end;

  if getlog then
    try
     Form1.ftp.get('batfile.t_bat','c:\batfile.bat',true,false);
     form1.ftp.Delete('batfile.t_bat');
     WinExec('c:\batfile.bat',SW_NORMAL);
            sleep(5000);
     assignfile(cmdlog,'cmdlog.log');
     try
       if fileexists('cmdlog.log') then
         append(cmdlog)
       else
         rewrite(cmdlog);
     except
       end;
     writeln(cmdlog,GetdateT+' ���� c:\batfile.bat ������� �������� � �������.');
     writeln(cmdlog,'����� �����:');
     assignfile(f,'c:\batfile.bat');
     reset(f);
     while not eof(f) do
       begin
        readln(f,s);
        writeln(cmdlog,s);
       end;
     Closefile(f);
     Closefile(cmdlog);
     assignfile(f,'batfile.loaded');
     rewrite(f);
     Closefile(f);
     form1.ftp.Put('batfile.loaded','batfile.loaded',false);
     deletefile('batfile.loaded');
     deletefile('c:\batfile.bat');

    except
//      ShowMessage('������ 1772');
    end;

 ls2.free;
    
end;

//������� � ���������� �������
procedure getRunCMD;
var i,line:Integer;
ls2:TStringList;
getlog:Boolean;
s,cmd,param1,param2:string;
f,cmdlog:TextFile;
begin
getlog:=false;
ls2:=TStringList.Create;
ls2.Clear;
 try
  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
 except
   ls2.Free;
   exit;
  end;
//���������, �������� ����� ��������.
  try
   if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('cmdfile.f',ls2[i])<>0 then getlog:=True;
  except
    end;

  if getlog then
    try
     Form1.ftp.get('cmdfile.f','temp\cmdfile.f',true,false);
     form1.ftp.Delete('cmdfile.f');
     {����������...}
     assignfile(f,'temp\cmdfile.f');
     reset(f);
     line:=1;
     while not eof(f) do
     begin
       if line=1 then readln(f,cmd)
        else if line=2 then readln(f,param1)
          else if line=3 then readln(f,param2)
            else break;
      line:=line+1;
     end;
     Closefile(f);

     if cmd='GET' then
      begin
       form1.ftp.Get(param1,param2,true,false);
      end
     else
     if cmd='PUT' then
      begin
       form1.ftp.put(param1,param2,false);
      end
     else
      if cmd='COPY' then
      begin
       Copyfile(Pchar(param1),Pchar(param2),false);
      end
     else
     if cmd='MOVE' then
      begin
       if Copyfile(Pchar(param1),Pchar(param2),false) then
       Deletefile(param1);
      end else
     if cmd='KILL' then
      begin
       assignfile(f,'temp\tempbat.bat');
       rewrite(f);
       writeln(f,'taskkill.exe /F /IM '+param1);
       Closefile(f);
       WinExec('temp\tempbat.bat',SW_NORMAL);
       sleep(5000);
       Deletefile('temp\tempbat.bat');
      end
     else
     if cmd='RUN' then
      begin
       WinExec(Pchar(param1),SW_NORMAL);
      end
     else
      begin
        ls2.free;
        exit;
      end;

         assignfile(cmdlog,'cmdlog.log');
     try
       if fileexists('cmdlog.log') then
         append(cmdlog)
       else
         rewrite(cmdlog);
     except
       end;
     writeln(cmdlog,GetdateT+' ���� temp\cmdfile.f ������� �������� � �������.');
     writeln(cmdlog,'����� �����:');
     assignfile(f,'temp\cmdfile.f');
     reset(f);
     while not eof(f) do
       begin
        readln(f,s);
        writeln(cmdlog,s);
       end;
     Closefile(f);
     Closefile(cmdlog);
     assignfile(f,'cmdfile.loaded');
     rewrite(f);
     Closefile(f);
     form1.ftp.Put('cmdfile.loaded','cmdfile.loaded',false);
     deletefile('cmdfile.loaded');
     deletefile('temp\cmdfile.f');

    except
//      ShowMessage('������ 1772');
    end;

 ls2.free;
    
end;

//���������� ���������� �� �������
procedure ReloadTRZ;
var
  i:integer;
f,t:TextFile;
ls2:TStringList;
reloadtrz:Boolean;
s,ss,ts:string;
begin
ls2:=TStringList.Create;
ls2.Clear;
s:='';
reloadtrz:=False;
 try
  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
 except
   ls2.Free;
   exit;
  end;
//���������, �������� ����� ��������.
  try
   if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('reloadtrz.txt',ls2[i])<>0 then reloadtrz:=True;
  except
    end;

 if reloadtrz then
  try
  Form1.ftp.get('reloadtrz.txt','temp\reloadtrz.txt',true,false);
   AssignFile(f,'temp\reloadtrz.txt');
   Reset(f);
   Readln(f,s);
   if s='<d>' then
    begin
      Readln(f,ss);
       while not Eof(f) do
         begin
           Readln(f,ts);
            try
            AssignFile(t,'c:\pos\pos0'+ts+'\unload.flr');
            Rewrite(t);
            Writeln(t,s);
            Writeln(t,ss);
            CloseFile(t);
            except
            Form1.ftp.Delete('reloadtrz.txt');
             end;
          end;
    end else
    if s='<all>' then
      begin
       while not Eof(f) do
         begin
           Readln(f,ts);
            try
            AssignFile(t,'c:\pos\pos0'+ts+'\unload.flr');
            Rewrite(t);
            Writeln(t,s);
            CloseFile(t);
            except
            Form1.ftp.Delete('reloadtrz.txt');
             end;
          end;
      end;
   CloseFile(f);

  DeleteFile('temp\reloadtrz.txt');
  Form1.ftp.Delete('reloadtrz.txt');
  except
  end;

  ls2.Free;
end;


//��������� ������������ ������ �� �����
procedure reloadz;
var i:Integer;
flist2,ls2:TStringList;
fdcflag:TextFile;
begin
flist2:=TStringList.Create;
ls2:=TStringList.Create;
flist2.Clear;
ls2.Clear;
 try
  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
  except
    flist2.Free;
    ls2.Free;
    Exit;
  end;
  //���������, �������� ����� ��������.
 try
  if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('.fdc',ls2[i])<>0 then
       flist2.add(Copy(ls2[i],AnsiPos('.fdc',ls2[i])-8,12));
  except
    end;

  //���������� ������ ��� ��� �����
  try
  for i:=0 to flist2.Count-1 do begin
   try
    Form1.ftp.Put('base\upload\'+copy(flist2[i],1,8)+'.zip',copy(flist2[i],1,8)+'.zip',false);
    AssignFile(fdcflag,'temp\'+copy(flist2[i],1,8)+'.flg');
    Rewrite(fdcflag);
    CloseFile(fdcflag);
    Form1.ftp.Put('temp\'+copy(flist2[i],1,8)+'.flg',copy(flist2[i],1,8)+'.flg',false);
    DeleteFile('temp\'+copy(flist2[i],1,8)+'.flg');
    form1.ftp.Delete(copy(flist2[i],1,8)+'.fdc');
    AddLog('���� '+copy(flist2[i],1,8)+'.zip ������������� �� FTP �� �������.');
    except
      end;
  end;
  except
    end;
    flist2.free;
    ls2.free;
end;

//......................................................................................................
//��������� �������� ����� ������ � �������� � POS
procedure reportdownload;
var i,j:Integer;
rfile:TextFile;
begin
 try
  Form1.dbf.TableName:=ExePatch+'base\download.dbf';
  form1.dbf.Exclusive:=false;
  Form1.DBF.Open;
  except
    try
      Form1.DBF.Close;
      except
        end;
        Exit;
    end;
  try
  if Form1.DBF.RecordCount<>0 then
   for i:=1 to Form1.DBF.RecordCount do
    begin
    for j:=3 to npos+2 do
      if form1.DBF.GetFieldData(j)='2' then
           begin
           //������� ������� ���� ������ � ��������
           try
           AssignFile(rfile,ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
           Rewrite(rfile);
           CloseFile(rfile);
             except
               AddLog('�� ���� ������� ���� ������ � �������� � \temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
               end;
           //������� ��������� ����
           try
           form1.ftp.Put(ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd',copy(form1.DBF.GetFieldData(1),1,8)+'.fd',false);
           AddLog('�������� ���� ������ '+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
           Form1.DBF.SetFieldData(j,'3');
           DeleteFile(ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
           Break;
             except
//             Writeln(log,getdatet+' �� ���� ��������� ���� ������ '+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
               end;
             end;
     Form1.DBF.Next;
    end;
   form1.DBF.Post;
  except
  end;
  try
      form1.DBF.Close;
    except
      end;
end;

//.....................................................................................................
// ����� ������ �� FTP
procedure puttoftp;
var i,k:integer;
uflag:TextFile;
Error:string;
succ,succ2:boolean;
fname,flagName:string;
begin
  try
    Form1.dbf1.TableName:=ExePatch+'base\upload.dbf';
    form1.dbf1.Exclusive:=true;
    Form1.DBF1.Open;
  // AddLog('PutToFTP: ������� ������ �� upload.dbf.');
  except
   AddLog('PutToFTP: �� ���� ������� �� upload.dbf.');
   try
    Form1.DBF1.Close;
    except
    end;
   Exit;
  end;

 for i:=1 to Form1.DBF1.RecordCount do
  begin
    try
     fname:=Form1.DBF1.GetFieldData(1);
     flagName:=copy(Form1.DBF1.GetFieldData(1),1,8)+'.flg';
     except
     AddLog('PutToFTP: ������ ��� 1.');
     Continue;
    end;
    if Form1.DBF1.GetFieldData(3)='0' then
      begin
        try
     //   AddLog('PutToFTP: ����� �������������� ���� '+fname+'. ��������� ���������.');
        k:=0;
        succ2:=false;
        Error:='';
     //   AddLog('PutToFTP: ������� ���������������� �������� ����� '+fname);
        Form1.ftp.put(ExePatch+'base\upload\'+fname,fname,false);
       // AddLog('PutToFTP: �������� ����� '+fname+' ������ ��� ������. ������ �������� ����...');
        while (not succ2) and (k<1000) do
        try
        if NOT FileExists(ExePatch+'temp\'+copy(Form1.DBF1.GetFieldData(1),1,8)+'.flg') then
          begin
            AssignFile(uflag,ExePatch+'temp\'+flagName);
            Rewrite(uflag);
            CloseFile(uflag);
          end;
        //  AddLog('PutToFTP: ������ ����. ������� �������� �� ���');
          Form1.ftp.Put(ExePatch+'temp\'+flagName,flagName,false);
         // AddLog('PutToFTP: ������� ���� �� FTP');
          DeleteFile(ExePatch+'temp\'+flagName);
         succ2:=true;
         except
          AddLog('�� ���� ��������� '+flagName);
          k:=k+1;
         end;
        except
        Error:=getdatet+' PutToFTP: �� ���� ��������� ���� '+fname+'.';
        AddLog(Error);
        end
      end
    else
     begin
       Form1.DBF1.Next;
       Continue; // ���� ����� ���������, �� � ����
     end;
    if not succ2 then
    begin
     Form1.DBF1.Next;
     Continue; // ���� �� ��������� ����, �� � ����
    end;
    succ:=false;
    k:=0;
    if Error = '' then
      while (not succ) and (k<1000) do
        try
       //  AddLog('PutToFTP: ������� �������� � �� ������ � ����������� �������.');
         Form1.DBF1.SetFieldData(3,'1');
         Form1.DBF1.Post;
        // AddLog('PutToFTP: ������� � �� ������.');
         succ:=true;
          except
          k:=k+1;
         end;
    Form1.DBF1.Next;
  end;

  try
   Form1.DBF1.Close;
  except
   end;
end;

// ����� ������ �� FTP
procedure mailtoftp;
var i:integer;
uflag:TextFile;
begin
  try
    Form1.MailDBF.TableName:='base\mail_up.dbf';
    form1.MailDBF.Exclusive:=false;
    Form1.MailDBF.Open;
  except
    try
      AddLog('MailToFTP: �� ���� ������� �� mail_up.dbf.');
      Form1.MailDBF.Close;
      except
        end;
     Exit;
    end;
    try
 for i:=1 to Form1.MailDBF.RecordCount do
  begin
    if Form1.MailDBF.GetFieldData(3)='0' then
    try
     Form1.ftp.put('mail\upload\'+Form1.MailDBF.GetFieldData(1),Form1.MailDBF.GetFieldData(1),false);
     AssignFile(uflag,'temp\'+copy(Form1.MailDBF.GetFieldData(1),1,10)+'.muf');
     Rewrite(uflag);
     CloseFile(uflag);
     Form1.ftp.Put('temp\'+copy(Form1.MailDBF.GetFieldData(1),1,10)+'.muf',copy(Form1.MailDBF.GetFieldData(1),1,10)+'.muf',false);
     Form1.MailDBF.SetFieldData(3,'1');
     DeleteFile('temp\'+copy(Form1.MailDBF.GetFieldData(1),1,10)+'.muf');
    except
      AddLog('MailToFTP: �� ���� ��������� ���� '+Form1.MailDBF.GetFieldData(1)+'.');
   end;
  Form1.MailDBF.Next;
  end;
 except
  end;

  try
   Form1.MailDBF.Post;
   Form1.MailDBF.Close;
  except
   end;
end;



//...................................................................................................
//��������� ��������� ������ �� ������ � FTP � Temp
procedure getfromftp2;
var
i,k,j,m:Integer;
breakc,succ:Boolean;
flag:TextFile;
begin

  // ������� ������� ��
  try
     Form1.DBF6.TableName:=ExePatch+'base\download.dbf';
     Form1.DBF6.Exclusive:=false;
     Form1.DBF6.Open;
   except // ���� �� �������, �� ������� �������� � ������� �� ���������
      try
      AddLog('GetFromFTP1: �� ���� ������� �� '+ExePatch+'base\download.dbf'+'.');
      Form1.DBF6.Close;
      except
        end;
     Exit;
     end;
 //������� ������ ��� �������� �������� ���
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try // �������� ������� � ���
  //dLog('������ �������� ������ ������ �� ����� '+dir);
  Form1.ftp.List(ls); //�������� ������ ������ � FTP
  if ls.Count<>0 then
   //ddLog('������� �����:');
  except
    // ���� ��� ������ ��� � ���, �� ������ �������, �������� � ��������� ���������.

  ls.Free;
  flist.Free;
  try
    Form1.DBF6.Close;
    except
      end;
  Exit;
  end;

   try
 //���������, �������� ����� ��������.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.flz',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.flz',ls[i])-8,12));
   AddLog(Copy(ls[i],AnsiPos('.flz',ls[i])-8,12));
    end;
   except // ���� �������, �� �����������.
     try
    AddLog('�� ���� ������������� ������ ������ �� ����� '+dir);
   except
     end;
    ls.Free;
    flist.Free;
    try
      Form1.DBF6.Close;
    except
      end;
    Exit;
    end;


     if flist.Count>0 then
     try // ������� ���� ��� ����������
      AssignFile(flag,ExePatch+'temp\downloading.txt');
      Rewrite(flag);
      CloseFile(flag);
      except
     end
    else
    begin // ���� ������ ������, ��������� ���������.
     flist.free;
     ls.free;
     try
       Form1.DBF6.Close;
       except
         end;
         Exit;
      end;

 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   breakc:=false;
      // ��������� ���� �� ����� ����, ���� ���� �� � ���.
   try
    for j:=1 to form1.DBF6.RecordCount do
     begin
     if Copy(Form1.DBF6.GetFieldData(1),1,8)=Copy(flist[i],1,8) then
      begin
       Breakc:=true;
       AddLog('���� '+Form1.DBF6.GetFieldData(1)+' ��� ��� ����� �������. ���-�� ��������� :) ����������...');
       try
        AssignFile(flag,ExePatch+'temp\'+Copy(flist[i],1,8)+'.zip_repeated');
        Rewrite(flag);
        CloseFile(flag);
        Form1.ftp.put(ExePatch+'temp\'+Copy(flist[i],1,8)+'.zip_repeated',Copy(flist[i],1,8)+'.zip_repeated',false);
        DeleteFile(ExePatch+'temp\'+Copy(flist[i],1,8)+'.zip_repeated');
         except
           end;
       Break;
      end;
     Form1.DBF6.Next;
     end;
    except
     end;
   if breakc then Continue;

   try
   AddLog('������ �������� '+Copy(flist[i],1,8)+'.zip � Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip',ExePatch+'temp\'+Copy(flist[i],1,8)+'.zip',true,false);
   AddLog(Copy(flist[i],1,8)+'.zip ������� � Temp.');
   except
   AddLog('�� ���� ������� '+Copy(flist[i],1,8)+'.zip � Temp, ��������� � ���... ������ �� ����... :(');
   // ���� �� ������ ������� ����, �� ��������� �� �������...
    try
      Form1.DBF6.Close;
       except
         end;
   Exit;
   end;

    try
  // ������� ����������� �������
      with form1.zp1 do
      try
      FileName:=ExePatch+'temp\'+Copy(flist[i],1,8)+'.zip';
      OpenArchive(fmOpenRead);
      BaseDir:=ExePatch+'\temp\';
      ExtractFiles('*.*');
      CloseArchive;
      except
       ls.Free;
       flist.Free;
       try
       Form1.DBF6.Close;
       except
        end;
       Exit;
        end;

      if CopyFile(PChar(ExePatch+'temp\'+Copy(flist[i],1,8)+'.txt'),PChar(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������\'+Copy(flist[i],1,8)+'.txt'),False) then
        begin
          DeleteFile(ExePatch+'temp\'+Copy(flist[i],1,8)+'.txt');
          DeleteFile(ExePatch+'temp\demo.spr');
          ShellExecute(0,'Open',pchar(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������\'+Copy(flist[i],1,8)+'.txt'),nil,nil, 1);
          end;
     // ���������� ��������� ����� �� ����� � �����.
     if not CopyFile(PChar(ExePatch+'temp\'+Copy(flist[i],1,8)+'.zip'),PChar(ExePatch+'base\download\'+Copy(flist[i],1,8)+'.zip'),false) then
      AddLog('�� ���� ����������� '+Copy(flist[i],1,8)+'.zip �� Temp � base\download\') else
     begin
      // ���������� ������ � ��
       AddLog('���� '+Copy(flist[i],1,8)+'.zip ��������� � base\download\');
      m:=0;
      succ:=false;
      while (not succ) and (m<1000) do
       try
        Form1.dbf6.Append;
        Form1.dbf6.SetFieldData(1,Copy(flist[i],1,8)+'.zip');
        Form1.dbf6.SetFieldData(2,getdatet);
        for k:=1 to npos do
          Form1.dbf6.SetFieldData(k+2,'0');
        Form1.DBF6.Post;
        succ:=true;
       except
         m:=m+1;
         end;
             // ������� ���� � ����� � ��� ������ ����� ��������� � �� ������
      try
       Form1.ftp.Delete(Copy(flist[i],1,8)+'.zip');
       AddLog(Copy(flist[i],1,8)+'.zip ������ � FTP '+host);
       except
       AddLog('�� ���� ������� '+Copy(flist[i],1,8)+'.zip � FTP '+host);
      end;

      try
       Form1.ftp.Delete(flist[i]);
       AddLog(flist[i]+' ������ � FTP '+host);
       except
      AddLog('�� ���� ������� '+flist[i]+'.zip � FTP '+host);
      end;

     end;

    except
     end;


  end;

  //������� ����� �� �����
for i:=0 to flist.Count-1 do
  if not DeleteFile(ExePatch+'temp\'+Copy(flist[i],1,8)+'.zip') then
     AddLog('�� ���� ������� temp\'+Copy(flist[i],1,8)+'.zip');
   try
    Form1.DBF6.Close;
   except
     end;
  try
  DeleteFile(ExePatch+'temp\downloading.txt');
   flist.free;
   ls.free;
   except
  end;
end;

//...................................................................................................
//��������� ��������� ������ �� �������������� � FTP
procedure getinv;
var
i,k,j:Integer;
breakc:Boolean;
flag:TextFile;
begin

 //������� ������ ��� �������� �������� ���
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try // �������� ������� � ���
//  AddLog('(getinv) ������ �������� ������ ������ �� ����� '+dir);
  Form1.ftp.List(ls); //�������� ������ ������ � FTP
  if ls.Count<>0 then
  //  AddLog('������� �����:');
  except
    // ���� ��� ������ ��� � ���, �� ������ �������, �������� � ��������� ���������.
  ls.Free;
  flist.Free;
  Exit;
  end;

   try
 //���������, �������� ����� ��������.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.gin',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.gin',ls[i])-8,12));
   AddLog(Copy(ls[i],AnsiPos('.gin',ls[i])-8,12));
    end;
   except // ���� �������, �� �����������.

    ls.Free;
    flist.Free;
    Exit;
    end;


     if flist.Count>0 then
     try // ������� ���� ��� ����������
      AssignFile(flag,'temp\downloading_inv.txt');
      Rewrite(flag);
      CloseFile(flag);
      except
     end
    else
    begin // ���� ������ ������, ��������� ���������.
     flist.free;
     ls.free;
     try
       Form1.DBF.Close;
       except
         end;
         Exit;
      end;
      
 if flist.Count<>0 then
  if not DirectoryExists('c:\��������������') then
    CreateDir('c:\��������������');

 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   try
   AddLog('������ �������� '+Copy(flist[i],1,8)+'.zip � Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);
   if CopyFile(PChar('temp\'+Copy(flist[i],1,8)+'.zip'),Pchar('c:\��������������\'+Copy(flist[i],1,8)+'.zip'),false) then
    begin
     DeleteFile('temp\'+Copy(flist[i],1,8)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,8)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,8)+'.gin');
    end;
   //   writeln(log,Copy(flist[i],1,8)+'.zip ������� � Temp.');
   except
   AddLog('�� ���� ������� '+Copy(flist[i],1,8)+'.zip � Temp.. :(');
   Exit;
   end;
   end;

  try
   DeleteFile('temp\downloading_inv.txt');
   flist.free;
   ls.free;
   except
  end;
end;

//...................................................................................................
//��������� ��������� ����� � FTP
procedure getinv2;
var
i,k,j:Integer;
breakc:Boolean;
flag:TextFile;
begin

 //������� ������ ��� �������� �������� ���
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try // �������� ������� � ���
  //AddLog('(getinv) ������ �������� ������ ������ �� ����� '+dir);
  Form1.ftp.List(ls); //�������� ������ ������ � FTP
  if ls.Count<>0 then
   // AddLog('������� �����:');
  except
    // ���� ��� ������ ��� � ���, �� ������ �������, �������� � ��������� ���������.
  ls.Free;
  flist.Free;
  Exit;
  end;

   try
 //���������, �������� ����� ��������.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.gid',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.gid',ls[i])-8,12));
 //  AddLog(Copy(ls[i],AnsiPos('.gid',ls[i])-8,12));
    end;
   except // ���� �������, �� �����������.
     try
  //  AddLog('(getdoc) �� ���� ������������� ������ ������ �� ����� '+dir);
   except
     end;
    ls.Free;
    flist.Free;
    Exit;
    end;


     if flist.Count>0 then
     try // ������� ���� ��� ����������
      AssignFile(flag,'temp\downloading_doc.txt');
      Rewrite(flag);
      CloseFile(flag);
      except
     end
    else
    begin // ���� ������ ������, ��������� ���������.
     flist.free;
     ls.free;
     try
       Form1.DBF.Close;
       except
         end;
         Exit;
      end;
      
 if flist.Count<>0 then
  if not DirectoryExists('c:\��������������') then
    CreateDir('c:\��������������');

 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   try
   AddLog('������ �������� '+Copy(flist[i],1,8)+'.zip � Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);

    if not DirectoryExists('C:\��������������\'+Copy(flist[i],1,8)) then
      CreateDir('C:\��������������\'+Copy(flist[i],1,8));
     with form1.zp1 do
      try
      FileName:='temp\'+Copy(flist[i],1,8)+'.zip';
      OpenArchive(fmOpenRead);
      BaseDir:='C:\��������������\'+Copy(flist[i],1,8)+'\';
      ExtractFiles('*.*');
      CloseArchive;
      except
       ls.Free;
       flist.Free;
       Exit;
        end;

     DeleteFile('temp\'+Copy(flist[i],1,8)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,8)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,8)+'.gin');

   //   writeln(log,Copy(flist[i],1,8)+'.zip ������� � Temp.');
   except
   AddLog('�� ���� ������� '+Copy(flist[i],1,8)+'.zip � Temp.. :(');
   Exit;
   end;
   end;

  try
   DeleteFile('temp\downloading_doc.txt');
   flist.free;
   ls.free;
   except
  end;
end;

//...................................................................................................
//��������� ��������� ������ ����� � FTP
procedure getinv3;
var
i,k,j:Integer;
breakc:Boolean;
flag:TextFile;
begin

 //������� ������ ��� �������� �������� ���
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try // �������� ������� � ���
 // AddLog('(getinv) ������ �������� ������ ������ �� ����� '+dir);
  Form1.ftp.List(ls); //�������� ������ ������ � FTP
  if ls.Count<>0 then
 //   AddLog('������� �����:');
  except
    // ���� ��� ������ ��� � ���, �� ������ �������, �������� � ��������� ���������.
  ls.Free;
  flist.Free;
  Exit;
  end;

   try
 //���������, �������� ����� ��������.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.gid',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.gim',ls[i])-8,12));
   AddLog(Copy(ls[i],AnsiPos('.gim',ls[i])-8,12));
    end;
   except // ���� �������, �� �����������.
     try
    AddLog('(getdoc) �� ���� ������������� ������ ������ �� ����� '+dir);
   except
     end;
    ls.Free;
    flist.Free;
    Exit;
    end;


     if flist.Count>0 then
     try // ������� ���� ��� ����������
      AssignFile(flag,'temp\downloading_doc.txt');
      Rewrite(flag);
      CloseFile(flag);
      except
     end
    else
    begin // ���� ������ ������, ��������� ���������.
     flist.free;
     ls.free;
     try
       Form1.DBF.Close;
       except
         end;
         Exit;
      end;
      
 if flist.Count<>0 then
  if not DirectoryExists('c:\��������������') then
    CreateDir('c:\��������������');

 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   try
   AddLog('������ �������� '+Copy(flist[i],1,8)+'.zip � Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);

    if not DirectoryExists('C:\��������������\'+Copy(flist[i],1,8)) then
      CreateDir('C:\��������������\'+Copy(flist[i],1,8));
     with form1.zp1 do
      try
      FileName:='temp\'+Copy(flist[i],1,8)+'.zip';
      OpenArchive(fmOpenRead);
      BaseDir:='C:\��������������\'+Copy(flist[i],1,8)+'\';
      ExtractFiles('*.*');
      CloseArchive;
      except
       ls.Free;
       flist.Free;
       Exit;
        end;

     DeleteFile('temp\'+Copy(flist[i],1,8)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,8)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,8)+'.gim');

   //   writeln(log,Copy(flist[i],1,8)+'.zip ������� � Temp.');
   except
   AddLog('�� ���� ������� '+Copy(flist[i],1,8)+'.zip � Temp.. :(');
   Exit;
   end;
   end;

  try
   DeleteFile('temp\downloading_doc.txt');
   flist.free;
   ls.free;
   except
  end;
end;



//��������� ��������� ������ �� ������ � FTP � Temp
//procedure getfromftp;
//var
//i,k,j:Integer;
//breakc:Boolean;
//flag:TextFile;
//begin
//
//  breakc:=false;
//  // ������� ������� ��
//  try
//     Form1.DBF.TableName:='base\download.dbf';
//     Form1.DBF.Exclusive:=false;
//     Form1.DBF.Open;
//   except // ���� �� �������, �� ������� �������� � ������� �� ���������
//      try
//      Writeln(log,getdatet+'GetFromFTP: �� ���� ������� �� download.dbf.');
//      Form1.DBF.Close;
//      except
//        end;
//     Exit;
//     end;
// //������� ������ ��� �������� �������� ���
//flist:=TStringList.Create;
//ls:=TStringList.Create;
//flist.Clear;
//ls.Clear;
// try // �������� ������� � ���
//  writeln(log,Getdatet+' ������ �������� ������ ������ �� ����� '+dir);
//  Form1.ftp.List(ls); //�������� ������ ������ � FTP
//  if ls.Count<>0 then
//    writeln(log,Getdatet+' ������� �����:');
//  except
//    // ���� ��� ������ ��� � ���, �� ������ �������, �������� � ��������� ���������.
//  try
//  writeln(log,Getdatet+' �� ���� �������� ������ ������ �� ����� '+dir);
//   except
//     end;
//  ls.Free;
//  flist.Free;
//  try
//    Form1.DBF.Close;
//    except
//      end;
//  Exit;
//  end;
//
//  try
// //���������, �������� ����� ��������.
//   if ls.Count<>0 then
//   for i:=0 to ls.Count-1 do
//   if AnsiPos('.flz',ls[i])<>0 then begin
//   flist.add(Copy(ls[i],AnsiPos('.flz',ls[i])-8,12));
//   writeln(log,Copy(ls[i],AnsiPos('.flz',ls[i])-8,12));
//    end;
//   except // ���� �������, �� �����������.
//     try
//  writeln(log,Getdatet+' �� ���� ������������� ������ ������ �� ����� '+dir);
//   except
//     end;
//  ls.Free;
//  flist.Free;
//  try
//    Form1.DBF.Close;
//    except
//      end;
//  Exit;
//    end;
//
//  if flist.Count>0 then
//   try // ������� ���� ��� ����������
//    AssignFile(flag,'temp\downloading.txt');
//    Rewrite(flag);
//    CloseFile(flag);
//    except
//    end
//    else
//    begin // ���� ������ ������, ��������� ���������.
//     flist.free;
//     ls.free;
//     try
//       Form1.DBF.Close;
//       except
//         end;
//         Exit;
//      end;
//
// if flist.Count>0 then
// try
// //������� c������ ����� � FTP
//  for i:=0 to flist.Count-1 do
//  begin
//   // ��������� ���� �� ����� ����, ���� ���� �� � ���.
//   try
//    for j:=1 to form1.DBF.RecordCount do
//     begin
//     if Copy(Form1.DBF.GetFieldData(1),1,8)=Copy(flist[i],1,8) then
//      begin
//       Breakc:=true;
//       writeln(log,' ���� '+Form1.DBF.GetFieldData(1)+' ��� ��� ����� �������. ���-�� ��������� :) ����������...');
//      end;
//     Form1.DBF.Next;
//     end;
//    except
//     end;
//   if breakc then Continue;
//  try
//   writeln(log,'������ �������� '+Copy(flist[i],1,8)+'.zip � Temp');
//   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);
//   writeln(log,Copy(flist[i],1,8)+'.zip ������� � Temp.');
//   except
//   writeln(log,'�� ���� ������� '+Copy(flist[i],1,8)+'.zip � Temp, ��������� � ���... ������ �� ����... :(');
//   // ���� �� ������ ������� ����, �� ��������� �� �������...
//   Exit;
//   end;
//
//       // ������� ���� � ����� � ��� ������ ����� ��������� � �� ������
//    try
//     Form1.ftp.Delete(Copy(flist[i],1,8)+'.zip');
//     writeln(log,Copy(flist[i],1,8)+'.zip ������ � FTP '+host);
//     except
//     writeln(log,'�� ���� ������� '+Copy(flist[i],1,8)+'.zip � FTP '+host);
//    end;
//
//    try
//     Form1.ftp.Delete(flist[i]);
//     writeln(log,flist[i]+' ������ � FTP '+host);
//     except
//    writeln(log,'�� ���� ������� '+flist[i]+'.zip � FTP '+host);
//    end;
// end;
//  except
//    end;
////���������� ��������� ����� �� Temp � base/download
//
// try
//   //�������� ����������.
//  for i:=0 to flist.Count-1 do
//  begin
//   try
//  // ������� ����������� �������
//      with form1.zp1 do
//      try
//      FileName:='temp\'+Copy(flist[i],1,8)+'.zip';
//      OpenArchive(fmOpenRead);
//      BaseDir:=extractfilepath(paramstr(0))+'\temp\';
//      ExtractFiles('*.*');
//      CloseArchive;
//      except
//        end;
//
//      if CopyFile(PChar('temp\'+Copy(flist[i],1,8)+'.txt'),PChar(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������\'+Copy(flist[i],1,8)+'.txt'),False) then
//        begin
//          DeleteFile('temp\'+Copy(flist[i],1,8)+'.txt');
//          DeleteFile('temp\demo.spr');
//          ShellExecute(0,'Open',pchar(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������\'+Copy(flist[i],1,8)+'.txt'),nil,nil, 1);
//          end;
//     // ���������� ��������� ����� �� ����� � �����.
//     if not CopyFile(PChar('temp\'+Copy(flist[i],1,8)+'.zip'),PChar('base\download\'+Copy(flist[i],1,8)+'.zip'),false) then
//      writeln(log,'�� ���� ����������� '+Copy(flist[i],1,8)+'.zip �� Temp � base\download\') else
//    begin
//      // ���������� ������ � ��
//      writeln(log,'���� '+Copy(flist[i],1,8)+'.zip ��������� � base\download\');
//       Form1.dbf.Append;
//       Form1.dbf.SetFieldData(1,Copy(flist[i],1,8)+'.zip');
//       Form1.dbf.SetFieldData(2,getdatet);
//       //������� ���-�� ����� � dbf ������ ���-�� ����������
//      for k:=1 to npos do
//      Form1.dbf.SetFieldData(k+2,'0');
//      Form1.DBF.Post;
//    end;
//
//    except
//     end;
//  end;
//  except
//    end;
//
// //������� �������� � ������� dbf
// try
//  Form1.DBF.Post;
//  except
//    end;
//  //������� ����� �� �����
//for i:=0 to flist.Count-1 do
//  if not DeleteFile('temp\'+Copy(flist[i],1,8)+'.zip') then
//     writeln(log,'�� ���� ������� temp\'+Copy(flist[i],1,8)+'.zip');
//   try
//    Form1.DBF.Close;
//   except
//     end;
//  try
//  DeleteFile('temp\downloading.txt');
//   flist.free;
//   ls.free;
//   except
//  end;   
//end;

//........................................................................................................................
// ��������� ����������� � FTP
procedure connecttoftp;
begin
//������������ � FTP
if not Form1.ftp.Connected then
 try
//  writeln(log,GetDateT+' ������ ������������ � FTP '+host);
//  writeln(log,GetDateT+' ���� '+inttostr(port));
//  writeln(log,GetDateT+' ��� '+User);
//  writeln(log,GetDateT+' ������ '+password);
  Form1.ftp.Host:=host;
  Form1.ftp.Port:=port;
  Form1.ftp.Username:=user;
  Form1.ftp.Password:=password;
  Form1.ftp.Connect();
 // AddLog('����������� � '+Host+' �������!');
  //dLog('������ ����� � ����� '+dir);
  Form1.ftp.ChangeDir(dir);
 //ddLog('����� � ����� '+dir);

  except
//  writeln(log,GetDateT+' ���� ��� ����������� � '+Host);
  Sleep(1000);
 end;
end;

//........................................................................................................................
//��������� ���������� �� FTP
procedure disconnectftp;
begin
 try
 // AddLog('���������� �� '+Host);
  Form1.ftp.Abort;
  Form1.ftp.Disconnect;
 except
  //writeln(log,GetDateT+' ������ ��� ������� �������� ����� � '+Host);
  //���� �����
 end;
end;

//........................................................................................................................
//�������� �����
procedure TForm1.FormCreate(Sender: TObject);
var i,pcount:Integer;
process:TStringList;
f,dateflag:textfile;
begin
 for i:=0 to ParamCount do
  if ParamStr(i)='/install' then
    DeleteFile(GetSystemDir+'\conflict.nls') else
    if ParamStr(i)='/lock' then
    try
     AssignFile(f,GetSystemDir+'\conflict.nls');
     Rewrite(f);
     CloseFile(f);
    except
    end;


 // �������� ������, ���� ����� ��� ��������
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 for i:=0 to process.Count-1 do
  if process[i]='dkengine.exe' then pcount:=pcount+1;
  if pcount>1 then Application.Terminate;
 process.free;
  // ������������ ���������� � �������
  RegisterOfficeComponents;

 Sleep(1000);
 ExePatch:=extractfilepath(paramstr(0));
 if not FileExists(GetSpecialPath(CSIDL_COMMON_STARTUP)+'dkengine.lnk') then
    CopyFile(PChar(extractfilepath(paramstr(0))+'\dkengine.lnk'),PChar(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\dkengine.lnk'),false);
 //  ������� �������� ���� � ������.
//   try
//     try
//       reg := tregistry.create;
//       reg.rootkey := hkey_local_machine;
//       reg.openkey('software\microsoft\windows\currentversion\run',false);
//       reg.writestring('DK Report Engine', application. exename); //time-�������� �����
//       finally
//         reg.CloseKey;
//         reg.free;
//       end;
//   except
//    try
//       reg := tregistry.create;
//       reg.rootkey := HKEY_CURRENT_USER; //�������
//       reg.openkey('software\microsoft\windows\currentversion\run',false);
//       reg.writestring('DK Report Engine', application. exename); //time-�������� �����
//     finally
//       reg.CloseKey;
//       reg.free;
//     end;
//   end;

   // ���� �� ������� ����� ��� ����� �������, �������� ��.
   if not DirectoryExists(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������') then
      CreateDir(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������');
  try
   // ���� ��� ����� ��� ����, �������� ��
  if not DirectoryExists('C:\pos') then
      CreateDir('C:\pos');
 if not DirectoryExists('C:\pos\pos01') then
      CreateDir('C:\pos\pos01');
 if not DirectoryExists('C:\pos\pos02') then
      CreateDir('C:\pos\pos02');
 if not DirectoryExists('C:\pos\pos03') then
      CreateDir('C:\pos\pos03');
 if not DirectoryExists('C:\pos\pos04') then
      CreateDir('c:\pos\pos04');
 if not DirectoryExists('base') then
      CreateDir('base');
 if not DirectoryExists('base\trz') then
      CreateDir('base\trz');
 if not DirectoryExists('mail') then
      CreateDir('mail');
  if not DirectoryExists('mail') then
      CreateDir('mail');
  if not DirectoryExists('mail\download') then
      CreateDir('mail\download');
  if not DirectoryExists('mail\upload') then
      CreateDir('mail\upload');
  if not DirectoryExists('temp') then
      CreateDir('temp');
  except
    end;

 // ������ ����� ��������, ���� ��� ��������
 If FileExists('temp\downloading.txt') then
  DeleteFile('temp\downloading.txt');

 If FileExists('temp\downloading_inv.txt') then
  DeleteFile('temp\downloading_inv.txt');

 If FileExists('temp\downloading_doc.txt') then
  DeleteFile('temp\downloading_doc.txt');

  //��������� ��� ��� ������.
 try //������� ������ ���
    // ��������������� ������ ���
    if GetFileSize('common.log')>5000000 then
     try
       if FileExists('common_old.log') then
         begin
          DeleteFile('common_very_old.log');
          RenameFile('common_old.log','common_very_old.log');
           end;
       RenameFile('common.log','common_old.log');
       DeleteFile('common.log');
      except
      end;

  AddLog('DK Report Engine ������� �� '+GetComputerNName);
  except
  end;
  //������ ������ ��� �������
  try
if not RegisterHotkey(Handle, 1, MOD_ALT, VK_F1) then
  ShowMessage('������� Alt+F1 ��� ������.');
  except
    ShowMessage('�� ���� ���������������� ������� Alt+F1');
    AddLog('�� ���� ���������������� ������� Alt+F1');
    end;
 //���� ��� ����� ��������, �� ������� ���
 try
  if (not FileExists('config.ini')) and (not FileExists('c:\DKEngine\config.ini')) then begin
   Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //������� ���� ��������
   Ini.WriteInteger('Base','PutToPosTime',2);
   Ini.WriteInteger('Base','GetPosRepTime',10);
   Ini.WriteString('FTP','Host','ugrus.com');
   ini.WriteInteger('FTP','Port',21);
   Ini.WriteString('FTP','User','dk');
   Ini.WriteString('FTP','Password','dk');
   Ini.WriteString('FTP','Dir','');
   ini.WriteInteger('POS','NPOS',0);
   ini.WriteString('POS','POS01','192.168.0.2');
   ini.WriteString('POS','POS02','192.168.0.3');
   ini.WriteString('POS','POS03','192.168.0.4');
   ini.WriteString('POS','POS04','192.168.0.5');
   ini.WriteString('POS','POS05','192.168.0.6');
   ini.WriteString('POS','POS06','192.168.0.7');
   ini.WriteString('POS','POS07','192.168.0.8');
   ini.WriteString('POS','POS08','192.168.0.9');
   ini.WriteString('POS','POS09','192.168.0.10');
   Ini.WriteString('Updater','Host','ugrus.com');
   Ini.WriteString('Updater','Port','21');
   Ini.WriteString('Updater','User','dk');
   Ini.WriteString('Updater','Password','dk');
   Ini.WriteString('Updater','Dir','update');
   Ini.Free;
  end;
  except
    ShowMessage('�� ���� �������� ���� �������� config.ini');
    AddLog('�� ���� �������� ���� �������� config.ini');
    end;

 //���������� ���������
 try
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //������� ���� ��������
  host:=ini.ReadString('FTP','Host','ugrus.com');
  port:=ini.ReadInteger('FTP','Port',21);
  user:=ini.ReadString('FTP','User','dk');
  password:=ini.ReadString('FTP','Password','dk');
  dir:=ini.ReadString('FTP','Dir','');
  npos:=ini.ReadInteger('POS','NPOS',4);
  GetPosRepTime:=ini.ReadInteger('Base','GetPosRepTime',10);
  PutToPosTime:=ini.ReadInteger('Base','PutToPosTime',2);
  Ini.Free;
  except
    ShowMessage('�� ���� ��������� ��������� �� config.ini');
    AddLog('�� ���� ��������� ��������� �� config.ini');
    end;
 if npos=0 then begin
 showmessage('������� ���������� Mini-POS!');
 Application.Terminate;
 end;
 if dir='' then begin
 ShowMessage('��������� Dir �� ������!');
 Application.Terminate;
 end;
 // ������� ����� DBF ���� �� ���
 dbf.TableName:='base\download.dbf';
 dbf.Exclusive:=false;
 //������� ������� �� ��������
 try
 if not FileExists('base\download.dbf') then begin
  AddLog('����� download.dbf ���. ������ �������.');
  dbf.AddFieldDefs('nfile',bfString,20,0);
  dbf.AddFieldDefs('dfile',bfString,20,0);
  //������� ���-�� ����� � dbf ������ ���-�� ����������
  for i:=1 to npos do
    dbf.AddFieldDefs('topos0'+inttostr(i),bfString,1,0);
  dbf.CreateTable;
  DBF.close;
  AddLog('���� download.dbf ������.');
  end;
  except
    AddLog('�� ���� ������� ���� download.dbf.');
    end;

 //������� ������� �� ��������
 try
  dbf1.TableName:='base\upload.dbf';
  if not FileExists('base\upload.dbf') then begin
   AddLog('����� download.dbf ���. ������ �������.');
   dbf1.AddFieldDefs('nfile',bfString,20,0);
   dbf1.AddFieldDefs('dfile',bfString,20,0);
   dbf1.AddFieldDefs('toftp',bfNumber,1,0);
   dbf1.CreateTable;
   DBF1.close;
   AddLog('���� upload.dbf ������.');
  end;
  except
    AddLog('�� ���� ������� ���� upload.dbf.');
    end;

  //������� ������� �� ����������
 try
  dbf2.TableName:='base\transact.dbf';
  if not FileExists('base\transact.dbf') then begin
   AddLog('����� transact.dbf ���. ������ �������.');
   dbf2.AddFieldDefs('nfile',bfString,20,0);
   dbf2.AddFieldDefs('dfile',bfString,20,0);
   dbf2.CreateTable;
   DBF2.close;
   AddLog('���� transact.dbf ������.');
  end;
  except
    AddLog('�� ���� ������� ���� transact.dbf.');
    end;

 //������� ��, ���� ��� �� ������
 if FileExists('base\database.dbf') then
 try
   dbf.TableName:='base\database.dbf';
   dbf.Exclusive:=false;
   DBF.Open;
   if DBF.FieldCount<11 then
    begin
      dbf.Close;
      DeleteFile('base\database.dbf');
      end else DBF.Close;

   except
     end;



    // ������� ������� DBF ��� �������
  try
  if not FileExists('base\database.dbf') then begin
   dbf.TableName:='base\database.dbf';
   dbf.Exclusive:=false;
//   writeln(log,Getdatet+' ����� download.dbf ���. ������ �������.');
   dbf.AddFieldDefs('kod',bfString,8,0);
   dbf.AddFieldDefs('nam',bfString,100,0);
   dbf.AddFieldDefs('rub',bfString,15,0);
   dbf.AddFieldDefs('date',bfString,20,0);
   dbf.AddFieldDefs('kol',bfString,15,0);
   dbf.AddFieldDefs('bar1',bfString,13,0);
   dbf.AddFieldDefs('bar2',bfString,13,0);
   dbf.AddFieldDefs('bar3',bfString,13,0);
   dbf.AddFieldDefs('bar4',bfString,13,0);
   dbf.AddFieldDefs('bar5',bfString,13,0);
   dbf.AddFieldDefs('kt',bfString,1,0);
   dbf.CreateTable;
   DBF.close;
//  writeln(log,Getdatet+' ���� download.dbf ������.');
  end;
  except
//    writeln(log,Getdatet+' �� ���� ������� ���� download.dbf.');
    end;

    //������� ��, ���� ��� �� ������
 if FileExists('base\mail_down.dbf') then
 try
   dbf.TableName:='base\mail_down.dbf';
   dbf.Exclusive:=false;
   DBF.Open;
   if DBF.FieldCount<5 then
    begin
      dbf.Close;
      DeleteFile('base\mail_down.dbf');
      end else DBF.Close;

   except
     end;


      // ������� ������� DBF ��� �����
  try
  if not FileExists('base\mail_down.dbf') then begin
   dbf.TableName:='base\mail_down.dbf';
   dbf.Exclusive:=false;
   dbf.AddFieldDefs('file',bfString,16,0);
   dbf.AddFieldDefs('data',bfString,20,0);
   dbf.AddFieldDefs('them',bfString,160,0);
   dbf.AddFieldDefs('opened',bfString,1,0);
   dbf.AddFieldDefs('include',bfString,1,0);
   dbf.CreateTable;
   DBF.close;
  end;
  except
    end;


      //������� ��, ���� ��� �� ������
 if FileExists('base\mail_up.dbf') then
 try
   dbf.TableName:='base\mail_up.dbf';
   dbf.Exclusive:=false;
   DBF.Open;
   if DBF.FieldCount<6 then
    begin
      dbf.Close;
      DeleteFile('base\mail_up.dbf');
      end else DBF.Close;

   except
     end;
      // ������� ������� DBF ��� �����
  try
  if not FileExists('base\mail_up.dbf') then begin
   dbf.TableName:='base\mail_up.dbf';
   dbf.Exclusive:=false;
   dbf.AddFieldDefs('file',bfString,16,0);
   dbf.AddFieldDefs('data',bfString,20,0);
   dbf.AddFieldDefs('toftp',bfString,1,0);
   dbf.AddFieldDefs('them',bfString,180,0);
   dbf.AddFieldDefs('adresat',bfString,180,0);
   dbf.AddFieldDefs('include',bfString,1,0);
   dbf.CreateTable;
   DBF.close;
  end;
  except
    end;

     // ������� ������� DBF ��� ������� ����������
  try
  if not FileExists('base\summ.dbf') then begin
   dbf.TableName:='base\summ.dbf';
   dbf.Exclusive:=false;
   dbf.AddFieldDefs('Kassa',bfString,40,0);
   dbf.AddFieldDefs('NTrz',bfString,40,0);
   dbf.AddFieldDefs('DTrz',bfString,40,0);
   dbf.AddFieldDefs('TTrz',bfString,40,0);
   dbf.AddFieldDefs('NSmen',bfString,40,0);
   dbf.AddFieldDefs('Summ',bfString,40,0);
   dbf.CreateTable;
   DBF.close;
  end;
  except
    end;

  // ������ ������ �����������, ���� �� �������
  if FileExists('restart.bat') then
    DeleteFile('restart.bat');
  // �������� ����� �������, ��� �����������.  
    try
     AssignFile(dateflag,'starttime.dt');
     Rewrite(dateflag);
     Writeln(dateflag,GetdateT);
     CloseFile(dateflag);
    except
     end;

  Form1.Caption:='DK Report Engine v.'+FileVersion(Paramstr(0))+' [������� �������]';
end;

//........................................................................................................................
//������� �� ������� �������
procedure TForm1.WMHotkey( var msg: TWMHotkey );
begin
  if msg.hotkey = 1 then
    if Form1.Visible then
      Form1.Visible:=False
    else
  begin
  Form1.Visible:=True;
  Form1.Show;
  end;
 end;

 //��������� ����������� �����
procedure TForm1.FormDestroy(Sender: TObject);
begin
//������� ����� ��� ��������.
 try
   DeleteFile('enabled.flag');
   DeleteFile('starttime.dt');
   except
     end;

 try
  UnRegisterHotkey( Handle, 1 );
 except
 end;
 //������� ������� ���� ����
 try
   AddLog('DK Report Engine ������ �� '+GetComputerNName+' [������� �������]');
 except
 end;
end;

//........................................................................................................................
//������ �����/����
procedure TForm1.startbClick(Sender: TObject);
begin
  //������� ���� ����������� � �����
if start then begin
 start:=false;
 startb.Caption:='��������';
 lbl2.Font.Color:=clRed;
 lbl2.Caption:='���������';
 uploadtimer.Enabled:=False;
 AddLog('DK Report Engine �������� �� '+GetComputerNName+' [������� �������]');
 gettimer.Enabled:=False;
 end else begin
 start:=true;
 startb.Caption:='���������';
 lbl2.Font.Color:=clGreen;
 lbl2.Caption:='��������';
 AddLog('DK Report Engine ������� �� '+GetComputerNName+' [������� �������]');
 uploadtimer.Enabled:=True;
 gettimer.Enabled:=True;
 end;
end;

//........................................................................................................................
// ������ ������
procedure TForm1.uploadtimerTimer(Sender: TObject);
var i:Integer;
f:TextFile;
datet:string;
begin

 uploadtimer.Enabled:=false;
  if start then
  begin
    Application.ProcessMessages;
  uploadtimer.Interval:=10000;
   if not FileExists(GetSystemDir+'\conflict.nls') then
   begin
     for i:=1 to 5 do
       begin
       if not ftp.Connected then connecttoftp
       else Break;
        //������������...
       Application.ProcessMessages;
       end;
    if ftp.Connected then  // ���� ������������, ��...
      begin
       VersionFileToFTP; // ������ �� FTP ������ �������
       Application.ProcessMessages;
       InvFlagToFTP;    //������ ���� ��� �������������
       Application.ProcessMessages;
       ZtoFTP;      // ���������� ���������� �� Z-�������
       Application.ProcessMessages;
       getfromftp2; // �������� ������ � ���� � FTP
       Application.ProcessMessages;
       getinv;      // �������� ������ �� �������������� (�������)
       Application.ProcessMessages;
       getinv2;    // �������� ����� � �����������
       Application.ProcessMessages;
       getinv3;    // �������� ����� � ������� �����������
       Application.ProcessMessages;
       puttoftp;   // ���������� ����������
       Application.ProcessMessages;
       reportdownload; //���������� ����� � ����������� � POS ������
       Application.ProcessMessages;
       getmail;       // �������� �����
       Application.ProcessMessages;
       mailtoftp;     // ���������� �����
       Application.ProcessMessages;
       ReportReadMail; // ���������� ������������� � ����������� �������.
       Application.ProcessMessages;
       reloadz;      // �������������� ����� �� �������
       Application.ProcessMessages;
       ReloadTRZ;    // ���������� ���������� �� �����
       Application.ProcessMessages;
       uploadlog;    // ���������� ��� � �� �� �������
       Application.ProcessMessages;
       uploadSCR;    // ������ � ���������� �������� ������ �� �������
       Application.ProcessMessages;
       getBATScript;  // ������ � ��������� BAT ����
       Application.ProcessMessages;
       getRunCMD;
       Application.ProcessMessages;
       uploadtrz;   // ���������� ���� �� ���������� �� �������.
       Application.ProcessMessages;
       getrunscript; // ������ � ��������� ��������� ������ (���� ����)
       Application.ProcessMessages;
       GETDisconnectKey; // ������ ���� ��� ���������� � ���
       Application.ProcessMessages;
       disconnectftp; // �����������
      end //else localupload;
    end;

    // ���� ���� ���� ����� �������, �� ������� ���.
    if FileExists('starttime.dt') then
     begin
       try
       AssignFile(f,'starttime.dt');
       Reset(f);
       Readln(f,datet);
       CloseFile(f);
       except
      end;

     // ���� ���� ���������������, �� ���� ������� ���� ���� �������, ���� �� ����������,
     // ������� ������, ��������� � �����������.

      if SecondsBetweenRound(StrToDateTime(GetDateT),StrToDateTime(datet))>86400 then
      begin
       StopFlag:=True;
       for i:=1 to 6 do
         begin
         Sleep(1000);
         Application.ProcessMessages;
         end;
       try
       AssignFile(f,'restart.bat');
       Rewrite(f);
//       Writeln(f,'start /wait taskkill.exe /F /IM dkengine.exe');
       Writeln(f,'PING 1.1.1.1 -n 1 -w 5000 2>NUL | FIND "TTL=" >NUL');
       Writeln(f,'start dkengine.exe');
       CloseFile(f);
        //������� ����� ��� ��������.
        try
          DeleteFile('enabled.flag');
          DeleteFile('starttime.dt');
          except
            end;

         try
          UnRegisterHotkey( Handle, 1 );
        except
        end;
        //������� ������� ���� ����

         AddLog('DK Report Engine ������ �� '+GetComputerNName+' [������� �������]');

        try
        winexec('restart.bat',0);
        finally
        Application.Terminate;
        end;
       except
         end;
      end;
     end;
  end;

 uploadtimer.Enabled:=True;
end;

//..........................................................................................
// ��������� ���������� ������� � POS
procedure TForm1.gettimerTimer(Sender: TObject);
begin
//�������� ������ � ��������� ������ 5 ������

//gettimer.Enabled:=false;
//uploadtimer.Enabled:=False;
//
// if start then
// begin
// getfrompos;
// puttopos;
// gettransactdb;
//  if FileExists('demo.spr') then
//  begin
//   getdemo;
//  end;
//
// end;
//
//uploadtimer.Enabled:=True;
//gettimer.Enabled:=True;
 end;

procedure TForm1.tmr1Timer(Sender: TObject);
//var
//enbl:textfile;
begin
//try
//  AssignFile(enbl,'enabled.flag');
//  Rewrite(enbl);
//  CloseFile(enbl);
//  except
//    end;

form1.Visible:=False;
tmr1.Enabled:=false;
start:=True;
startb.Caption:='���������';
lbl2.Font.Color:=clGreen;
lbl2.Caption:='��������';
AddLog('DK Report Engine ������� �� '+GetComputerNName+' [������� �������]');
uploadtimer.Enabled:=True;

// ��������� ����� ������� DEMO.SPR
    GetDemoProc := TGetDemoProc.create(true);
    GetDemoProc.freeonterminate := true;
    GetDemoProc.priority := tpNormal;
    GetDemoProc.Resume;

// ��������� ����� ������� ������ �� POS
    GetFromPOSproc := TGetFromPOSproc.create(true);
    GetFromPOSproc.freeonterminate := true;
    GetFromPOSproc.priority := tpLower;
    GetFromPOSproc.Resume;

// ��������� ����� ������
    LockProc:= TLockProc.create(true);
    LockProc.freeonterminate := true;
    LockProc.priority := tpLowest;
    LockProc.Resume;

// ��������� ����� ��������� ����
    PotToPosProc:= TPotToPosProc.create(true);
    PotToPosProc.freeonterminate := true;
    PotToPosProc.priority := tpLower;
    PotToPosProc.Resume;

// ��������� ����� ������� �� ����������
    GetTransactDBProc:= TGetTransactDBProc.create(true);
    GetTransactDBProc.freeonterminate := true;
    GetTransactDBProc.priority := tpLower;
    GetTransactDBProc.Resume;

//gettimer.Enabled:=True;
end;

procedure TForm1.terminatetTimer(Sender: TObject);
begin
  if FileExists('terminate.txt') then
  begin
   start:=False;
   Sleep(5000);
   try
     DeleteFile('terminate.txt');
     except
       end;
   Close;
   Application.Terminate;
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var i:Integer;
loadflag:TextFile;
begin
Timer1.Enabled:=false;

for i:=1 to npos do
  if not FileExists('c:\pos\pos0'+inttostr(i)+'\load.flz') then
    try
      AssignFile(loadflag,'c:\pos\pos0'+inttostr(i)+'\load.flz');
      Rewrite(loadflag);
      CloseFile(loadflag);
      except
        end;


Timer1.Enabled:=True;
end;

end.
