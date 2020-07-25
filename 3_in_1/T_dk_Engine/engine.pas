unit engine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, inifiles, ZipForge, DBF, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, Gvar, ExtCtrls, Registry, ShlObj, shellapi, DateUtils;

Const npos=9;
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
    DBFZayavka: TDBF;
    DBFZayavka2: TDBF;
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
  art:string;
  ed:string;
  proizvod:string;
 end;

 TMagazin = record
  Nom:integer;
  Name:string;
  Path:string;
  FTPDir:string;
  pos:array[1..npos] of string;
 end;

 TZayavka = record
  KodSklada:string;
   KodPostav:string;
  NamePostav:string;
  KodGruuz:string;
  NameGruuz:string;
  TimeZakaza:string;
  DniNedeli:string;
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
  host,User,password:string;
  port,InterK:Integer;
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
  PutToPosTime,GetPosRepTime:integer;
  Magaz:array [1..5] of TMagazin;
  PostLoadFlag:integer; // ���� ��� ��������
  EXEPath:string; // ���� � exe
  GetFromFTPTime:integer; // �������� �������� � ��� ���������
  GTPPauseTime:integer; // �����, ������� ����������� ����� ������� POS.rep
  AutoLoadTRZ:Integer; // ���� ����-�������� ����������

  
implementation
//******************************************************************************
//*********** ������� ������� **************************************************
function SetName():string;
begin
 result:=DateBezTochek(date)+TimeBezTochek(time);
end;

procedure WriteStatus(s:string);
var f:textfile;
fname:string;
i:integer;
begin

 for i:=0 to 9 do
  begin
    fname:=EXEPath+'status\'+SetName+inttostr(i)+'.txt';
   if NOT FileExists(fname) then
    Break;
    end;
 try
  AssignFile(f,fname);
  Rewrite(f);
  Write(f,s);
  CloseFile(f);
 except
   end;
end;

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
   if FileExists('c:\T_pos\pos0'+inttostr(i)+'\transact.sdf') then begin
     h:=321;
     // ���� ����� ����, ������ ������� � ����
     Writeln(log,getdatet+' ���� transact.sdf ��� ������ � ����� c:\T_pos\pos0'+inttostr(i)+'\');
     Writeln(log,getdatet+' ��� 5 ������, ����� ���� �� ��������� �� �����.');
     Sleep(5000);
     h:=FileOpen('c:\T_pos\pos0'+inttostr(i)+'\transact.sdf',fmShareExclusive);
     FileClose(h);
     if h<=0 then
           begin
             Writeln(log,getdatet+' ���� '+'c:\T_pos\pos0'+inttostr(i)+'\transact.sdf'+' ������������. �� ���� �������� ������.');
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
       BaseDir:='c:\T_pos\pos0'+inttostr(i)+'\';
       AddFiles('transact.sdf');
       CloseArchive;
       Writeln(log,getdatet+' ���� '+gname+' ��� ������.');
      end;
      except
        end;
       // ��������� ���� � ������ �� �������
      try
       // ������������� � ����
       Writeln(log,getdatet+' ������ ��������� ���� '+gname+' �� �������.');
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
        Writeln(log,getdatet+' ���������� ���� '+gname+' � \temp.');
        Writeln(log,getdatet+' ��������� ������������� ���� � ��������.');
  //      ShowMessage(IntToStr(GetFileSize('c:\pos\pos0'+inttostr(i)+'\pos.rep')));
  //      ShowMessage(IntToStr(GetFileSize(extractfilepath(paramstr(0))+'temp\pos.rep')));
        v1:=GetFileSize('c:\T_pos\pos0'+inttostr(i)+'\transact.sdf');
        v2:=GetFileSize(extractfilepath(paramstr(0))+'temp\transact.sdf');

        if v1=v2 then
          begin

           if (DeleteFile('c:\T_pos\pos0'+inttostr(i)+'\transact.sdf')) and
           (DeleteFile(extractfilepath(paramstr(0))+'temp\transact.sdf')) then
           begin
            form1.DBF2.Append;
            Form1.dbf2.SetFieldData(1,name);
            Form1.dbf2.SetFieldData(2,getdatet);
            form1.DBF2.Post;

           Writeln(log,getdatet+' ����� ����������, ������ ����� �����. ������ ���.');
           end;
          end
         else
           begin
            Writeln(log,getdatet+' ����� ������, ������ ����� �����. ������ ���� �� �����.');
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
procedure puttopos(m:integer);
var
i,j,n:Integer;
s:string;
begin
       //��������� DBF
       try
        Form1.DBFPTP.TableName:='base\download'+inttostr(m)+'.dbf';
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
          if Magaz[m].pos[j-2]<>'' then
          begin
           Form1.DBFPTP.First; //���� ���������

           s:=IntToStr(j-2);
           for i:=1 to Form1.DBFPTP.RecordCount do
            if Form1.DBFPTP.GetFieldData(j)='1' then
              if not FileExists(Magaz[m].Path+'pos0'+s+'\demo.spr') then
               begin
                form1.DBFPTP.SetFieldData(j,'2');
                Break;
               end else Break
            else
            if Form1.DBFPTP.GetFieldData(j)='0' then
             try
              //������� ����������� �����
              with form1.ZPPTP do
               begin
                FileName:=EXEPath+'base\download'+inttostr(m)+'\'+Form1.DBFPTP.GetFieldData(1);
                OpenArchive(fmOpenRead);
                BaseDir:=Magaz[m].Path+'pos0'+s+'\';
                ExtractFiles('*.*');
                DeleteFile(Magaz[m].Path+'pos0'+s+'\'+copy(Form1.DBFPTP.GetFieldData(1),1,8)+'.txt');
                CloseArchive;
               end;
              if FileExists(extractfilepath(paramstr(0))+'\temp\mag'+inttostr(m)+'\demo.spr') then
                sleep(3000);
                // ���� ���� ���� ����� �������� �����, �� ����������� demo.spr ��� ������������.
              if not FileExists(extractfilepath(paramstr(0))+'\temp\mag'+inttostr(m)+'\demo.spr') then
               with form1.ZPPTP do
                begin
                 FileName:=EXEPath+'base\download'+inttostr(m)+'\'+Form1.DBFPTP.GetFieldData(1);
                 OpenArchive(fmOpenRead);
                 BaseDir:=EXEPath+'temp\mag'+inttostr(m)+'\';
                 ExtractFiles('*.*');
                 DeleteFile(EXEPath+'temp\mag'+inttostr(m)+'\'+copy(Form1.DBFPTP.GetFieldData(1),1,8)+'.txt');
                 CloseArchive;
                end;



              WriteStatus(GetDateT+' ������� ����� '+Form1.DBFPTP.GetFieldData(1)+' ��� ����� POS 0'+inttostr(j-2)+' �������� "'+Magaz[m].Name+'"');
                // ������� ���� �������� ��� POS
              begin
               AssignFile(loadflz,Magaz[m].Path+'\pos0'+s+'\load.flz');
               rewrite(loadflz);
               closefile(loadflz);
               form1.DBFPTP.SetFieldData(j,'1');
              // Writeln(log,getdatet+' ���� '+Form1.DBFPTP.GetFieldData(1)+' ���������� � '+Magaz[m].Path+'pos0'+s);
               Break;
              end;
                           except
               Writeln(log,getdatet+' ���� '+Form1.DBFPTP.GetFieldData(1)+' �� ���������� � '+Magaz[m].Path+'pos0'+s);
             end
            else Form1.DBFPTP.Next;
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
Var m:integer;
begin
 while not StopFlag do
  begin
   FOR m:=1 to 5 do
    if Magaz[m].FTPDir<>'' then
     puttopos(m);
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
   Sleep(120000);
  end;
end;

//******************************************************************************
{TGetFromPOSProc}
procedure getfrompos(posn:integer;Mag:integer);
var i,ntemp:Integer;
name,gname:string;
v1,v2,h:LongInt;
begin
//���� pos.rep � ������ ����������
 try
  Form1.GetFromPosDBF.TableName:=EXEPath+'base\upload'+inttostr(Mag)+'.dbf';
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
   if FileExists(Magaz[Mag].Path+'\pos0'+inttostr(i)+'\pos.rep') then begin
       h:=332; //���������� ����������
     // ���� ����� ����, ������ ������� � ����
    try
     Writeln(log,getdatet+' ���� pos.rep ��� ������ � ����� '+Magaz[Mag].Path+'\pos0'+inttostr(i)+'\');
    except
    end;
     //     Writeln(log,getdatet+' ��� 5 ������, ����� ���� �� ��������� �� �����.');
     Sleep(GTPPauseTime*1000);
     h:=FileOpen(Magaz[Mag].Path+'\pos0'+inttostr(i)+'\pos.rep',fmShareExclusive);   //��������� ����������
       FileClose(h);  // ��������� ����
     if h<=0 then    // ���� ������ ���� - ���� ��� ��
          begin
           Writeln(log,getdatet+' ���� '+Magaz[Mag].Path+'\pos0'+inttostr(i)+'\pos.rep'+' ����� �����-�� ������, ����������.');
           Continue;
          end;
//     Writeln(log,getdatet+' ��� �������! ���� ��������� ��������! ���! ������! ������ ����������!.');

     // ��������� ���������� ���
     if Form1.GetFromPosDBF.RecordCount=0 then
       name:='z'+inttostr(i)+'000001.zip'
     else
      begin
       form1.GetFromPosDBF.Last;
       ntemp:=StrToInt(Copy(form1.GetFromPosDBF.GetFieldData(1),3,6))+1;
       name:='000000'+inttostr(ntemp);
       name:='z'+inttostr(i)+copy(name,Length(name)-5,6)+'.zip';
      end;

     //  ������� ����������
      gname:=EXEPath+'base\upload'+inttostr(Mag)+'\'+name;
      try
       with Form1.ZPGFP do
        begin
         FileName:=gname;
         OpenArchive(fmCreate);
         BaseDir:=Magaz[Mag].Path+'\pos0'+inttostr(i)+'\';
         AddFiles('pos.rep');
         CloseArchive;
         Writeln(log,getdatet+' ���! ���� '+gname+' ��� ������.');
        end;
      except
        end;
       // ��������� ���� � ������ �� �������
      try
       // ������������� � ����
       Writeln(log,getdatet+' ������ ��������� ���� '+gname+' �� �������������.');
       with Form1.ZPGFP do
       begin
        FileName:=gname;
        OpenArchive(fmOpenRead);
        BaseDir:=EXEPath+'temp\';
        ExtractFiles('*.*');
        CloseArchive;
       end;
            except
        end;

       if FileExists(EXEPath+'temp\pos.rep') then
       begin
        Writeln(log,getdatet+' ���������� ���� '+gname+' � \temp.');
        Writeln(log,getdatet+' ��������� ������������� ���� � ��������.');
//        ShowMessage(IntToStr(GetFileSize('c:\pos\pos0'+inttostr(i)+'\pos.rep')));
//        ShowMessage(IntToStr(GetFileSize(extractfilepath(paramstr(0))+'temp\pos.rep')));
        v1:=GetFileSize(Magaz[Mag].Path+'\pos0'+inttostr(i)+'\pos.rep');
        v2:=GetFileSize(EXEPath+'temp\pos.rep');

        if v1=v2 then
          begin

           if (DeleteFile(Magaz[Mag].Path+'\pos0'+inttostr(i)+'\pos.rep')) and
            (DeleteFile(EXEPath+'temp\pos.rep')) then
           begin
            form1.GetFromPosDBF.Append;
            Form1.GetFromPosDBF.SetFieldData(1,name);
            Form1.GetFromPosDBF.SetFieldData(2,getdatet);
            Form1.GetFromPosDBF.SetFieldData(3,'0');
            form1.GetFromPosDBF.Post;
            WriteStatus(GetDateT+' [������] ������� ����� � ����� POS 0'+inttostr(posn)+' �������� '+Magaz[Mag].Name);
//            Writeln(log,getdatet+' ����� ����������, ������ ��� ������. ������ ���.');
           end;
          end
         else
           begin
            Writeln(log,getdatet+' ����� ������, ������ ����� �����. ������ ���� ������ �� ..\temp.');
            DeleteFile(EXEPath+'temp\pos.rep');
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
function ZakritaSmena(posn:integer;Mag:integer):Boolean;
var
  f:TextFile;
  s:string;
  n,i:integer;
  SS:string;
begin
  s:='';
 if FileExists(Magaz[Mag].Path+'\pos0'+inttostr(posn)+'\pos.rep') then
 try
  AssignFile(f,Magaz[Mag].Path+'\pos0'+inttostr(posn)+'\pos.rep');
  Reset(f);
  while not Eof(f) do
    begin
     Readln(f,s);
     if Length(s)>10 then
      if IsDigit(s[1]) then
       begin
        n:=1;
        ss:='';
        for i:=1 to Length(s) do
          if s[i]<>';' then
          begin
            if n=4 then
            ss:=ss+s[i];
          end
                    else
          begin
          n:=n+1;
          Continue;
          end;
         if SS='61' then
          begin
           CloseFile(f);
           Result:=True;
           Exit;
          end;
       end;

    end;

  CloseFile(f);
   except
         end;
 Result:=False;
end;

// ��������� ������� ���������� �� POS (��� ���� ���������� �� � pos.rep ������������)
procedure gettransact(m:integer);
var f:TextFile;
i:integer;
begin
 try
   for i:=1 to npos do
    if Magaz[m].pos[i]<>'' then
     begin
      // �������� ��� ��������� ����, ���� � ��� ���� �������� �����
      if FileExists(Magaz[m].Path+'\pos0'+inttostr(i)+'\pos.rep') then
        if ZakritaSmena(i,m) then
          getfrompos(i,m);

            // ������� ����� ����.
      if not FileExists(Magaz[m].Path+'\pos0'+inttostr(i)+'\unload.flr') then
      begin
        AssignFile(f,Magaz[m].Path+'\pos0'+inttostr(i)+'\unload.flr');
        Rewrite(f);
        CloseFile(f);
      end;
      end;
   except
     ShowMessage('�� ���� ������� unload.flr !');
     end;
end;

procedure TGetFromPOSProc.execute;
var m,i:integer;
begin
  while not StopFlag do
    begin
       If FileExists(EXEPath+'loadtrz.pos') then
        begin
         for m:=1 to 5 do
          if Magaz[m].FTPDir<>'' then
           for i:=1 to npos do
            if Magaz[m].pos[i]<>'' then
             begin
              getfrompos(i,m);
             end;

         DeleteFile(EXEPath+'loadtrz.pos');
         Sleep(GetPosRepTime*1000);
         Continue;
        end;
     If AutoLoadTRZ=1 then
       FOR m:=1 to 5 do
         if Magaz[m].FTPDir<>'' then
           gettransact(m);
     Sleep(GetPosRepTime*1000);
    end;
end;

//******************************************************************************
{TGetDemoProc}
{��������� ������� ���������� ������� �� demo.spr}
procedure getdemo(m:integer);
var
demo:textfile;
s:string;
i,n,j:Integer;
clear,indb,PBar:Boolean;
h:LongInt;
begin
  If not FileExists('temp\mag'+inttostr(m)+'\demo.spr') then
    Exit;
  clear:=False;
  s:='';
  h:=0;
 // ��������� �� ���� �������
 //****************************
 try
  AssignFile(demo,'temp\mag'+inttostr(m)+'\demo.spr');
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
  ShowMessage('������ ������� � temp\mag'+inttostr(m)+'\demo.spr');
  Exit;
   end;
 //****************************


   // ���� ����� ���� �������: ������ ��.
 //****************************
  if clear then
  try
   // ����, ���� ���� ����� �����-�� ������
   while FileExists('base\database'+inttostr(m)+'.dbf') do
   begin
     DeleteFile('base\database'+inttostr(m)+'.dbf');
//   h:=FileOpen('base\database'+inttostr(m)+'.dbf',fmShareExclusive);   //��������� ����������
//   FileClose(h);  // ��������� ����
//   Sleep(500);
   end;

   //if DeleteFile('base\database'+inttostr(m)+'.dbf') then
  // begin
    // ������� ������� DBF ��� �������
    try
      if not FileExists('base\database'+inttostr(m)+'.dbf') then begin
      Form1.dbf3.TableName:='base\database'+inttostr(m)+'.dbf';
      Form1.dbf3.Exclusive:=false;
//   writeln(log,Getdatet+' ����� download.dbf ���. ������ �������.');
      Form1.dbf3.AddFieldDefs('kod',bfString,8,0);
      Form1.dbf3.AddFieldDefs('nam',bfString,120,0);
      Form1.dbf3.AddFieldDefs('rub',bfString,15,0);
      Form1.dbf3.AddFieldDefs('date',bfString,20,0);
      Form1.dbf3.AddFieldDefs('kol',bfString,15,0);
      Form1.dbf3.AddFieldDefs('bar1',bfString,13,0);
      Form1.dbf3.AddFieldDefs('bar2',bfString,13,0);
      Form1.dbf3.AddFieldDefs('bar3',bfString,13,0);
      Form1.dbf3.AddFieldDefs('bar4',bfString,13,0);
      Form1.dbf3.AddFieldDefs('bar5',bfString,13,0);
      Form1.dbf3.AddFieldDefs('kt',bfString,1,0);
      Form1.dbf3.AddFieldDefs('art',bfString,100,0);
      Form1.dbf3.AddFieldDefs('ed',bfString,100,0);
      Form1.dbf3.AddFieldDefs('proizvod',bfString,100,0);
      Form1.dbf3.CreateTable;
      Form1.DBF3.close;
  writeln(log,Getdatet+' ���� download.dbf ������.');
     end;
    except
    writeln(log,Getdatet+' �� ���� ������� ���� download.dbf.');
    end;

  // end;
   except
   ShowMessage('�� ���� �������� �� �������! ���������� � ���������� ��������������!');
   end;


 AssignFile(demo,'temp\mag'+inttostr(m)+'\demo.spr');
 Reset(demo);
  try
      //��������� ��
   Form1.dbf3.TableName:='base\database'+inttostr(m)+'.dbf';
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
    tovar.art:='';
    tovar.ed:='';
    tovar.proizvod:='';
   for i:=1 to Length(s) do
    if s[i]<>';' then
    begin
      if n=1 then
       tovar.kod:=tovar.kod + s[i];

      if n=2 then
       tovar.bar:=tovar.bar + s[i];

      if n=3 then
       tovar.nam:=tovar.nam + s[i];

      if n=5 then
       tovar.rub:=tovar.rub + s[i];

      if n=8 then
       tovar.kt:=tovar.kt + s[i];

      if n=12 then
       tovar.art:=tovar.art + s[i];

      if n=13 then
       tovar.ed:=tovar.ed + s[i];

      if n=14 then
       tovar.proizvod:=tovar.proizvod + s[i];
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
            Form1.dbf3.SetFieldData(12,tovar.art);
            Form1.dbf3.SetFieldData(13,tovar.ed);
            Form1.dbf3.SetFieldData(14,tovar.proizvod);
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
            Form1.dbf3.SetFieldData(12,tovar.art);
            Form1.dbf3.SetFieldData(13,tovar.ed);
            Form1.dbf3.SetFieldData(14,tovar.proizvod);
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
   DeleteFile('temp\mag'+inttostr(m)+'\demo.spr');
end;

// ��������� ������
procedure TGetDemoProc.execute;
var i:integer;
begin
  while not StopFlag do
  begin
   for i:=1 to 5 do
     if FileExists('temp\mag'+inttostr(i)+'\demo.spr') then
      begin
       getdemo(i);
       end;
    Sleep(3000);
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

//��������� �������� ����� ��� ��������������
procedure InvFlagToFTP;
begin
  if FileExists('getinvent.f') then
  try
  form1.ftp.Put('getinvent.f','getinvent.f',false);
  DeleteFile('getinvent.f');
  except
    end;

  if FileExists('getdoc.f') then
  try
  form1.ftp.Put('getdoc.f','getdoc.f',false);
  DeleteFile('getdoc.f');
  except
    end;

end;

procedure NomenklFlagToFTP(m:integer); // ���������� ����-������ �������� ��� ������������
begin
  if FileExists('temp/mag'+inttostr(m)+'/get_ost.txt') then
  try
  form1.ftp.Put('temp/mag'+inttostr(m)+'/get_ost.txt','get_ost.f',false);
  DeleteFile('temp/mag'+inttostr(m)+'/get_ost.txt');
  except
    end;

end;


////...................................................................................................
////��������� ��������� ����� � FTP
procedure GetZayavNomenkl(m:integer);
var
i,k,j:Integer;
Zayavka:TZayavka;
begin

 //������� ������ ��� �������� �������� ���
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try // �������� ������� � ���
  //writeln(log,Getdatet+'(GetZayavNomenkl) ������ �������� ������ ������ �� ����� '+Magaz[m].FTPDir);
  Form1.ftp.List(ls); //�������� ������ ������ � FTP
  if ls.Count<>0 then
   // writeln(log,Getdatet+' ������� �����:');
  except
    // ���� ��� ������ ��� � ���, �� ������ �������, �������� � ��������� ���������.
  writeln(log,Getdatet+'(GetZayavNomenkl) �� ���� �������� ������ ������ �� ����� '+Magaz[m].FTPDir);
  ls.Free;
  flist.Free;
  Exit;
  end;

 try
  //���������, �������� ����� ��������.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.fzf',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.fzf',ls[i])-7,11));
   writeln(log,Copy(ls[i],AnsiPos('.fzf',ls[i])-7,11));
    end;
 except // ���� �������, �� �����������.
    writeln(log,Getdatet+'(GetZayavNomenkl) �� ���� ������������� ������ ������ �� ����� '+Magaz[m].FTPDir);
    ls.Free;
    flist.Free;
    Exit;
 end;


 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   Zayavka.KodSklada:='';
   Zayavka.KodPostav:='';
   Zayavka.NamePostav:='';
   Zayavka.KodGruuz:='';
   Zayavka.NameGruuz:='';
   Zayavka.TimeZakaza:='';
   Zayavka.DniNedeli:='';
   try
   //writeln(log,'������ �������� '+Copy(flist[i],1,7)+'.zip � Temp');
    try
    DeleteFile('temp\'+Copy(flist[i],1,7)+'.zip');
    Form1.ftp.get(Copy(flist[i],1,7)+'.zip','temp\'+Copy(flist[i],1,7)+'.zip',true,false);
    except
     writeln(log,GetDateT+' �� ���� �������� � FTP '+Copy(flist[i],1,7)+'.zip');
     end;
 //  writeln(log,'������� '+Copy(flist[i],1,7)+'.zip � Temp');

     with form1.zp1 do
      try
      FileName:='temp\'+Copy(flist[i],1,7)+'.zip';
      OpenArchive(fmOpenRead);
      BaseDir:='temp\';
      ExtractFiles('*.*');
      CloseArchive;
      except
       ls.Free;
       flist.Free;
       Exit;
        end;
   // writeln(log,'���������� '+Copy(flist[i],1,7)+'.zip � Temp');

    try
     Form1.DBFZayavka.TableName:=EXEPath+'base\zayavka_BD'+inttostr(m)+'.dbf';
     Form1.DBFZayavka.Exclusive:=false;
     Form1.DBFZayavka.Open;
     Form1.DBFZayavka2.TableName:=EXEPath+'temp\'+Copy(flist[i],1,7)+'.dbf';
     Form1.DBFZayavka2.Exclusive:=false;
     Form1.DBFZayavka2.Open;
    except
     writeln(log,'(GetZayavNomenkl)�� ���� ������� '+EXEPath+'base\zayavka_BD'+inttostr(m)+'.dbf');
     writeln(log,'(GetZayavNomenkl)�� ���� ������� '+EXEPath+'temp\'+Copy(flist[i],1,7)+'.dbf');
     try
      Form1.DBFZayavka.Close;
      Form1.DBFZayavka2.Close;
      Exit;
      except
        end;
    end;

  //  writeln(log,'������ ����');
     if Form1.DBFZayavka2.RecordCount<>0 then
     Begin
      Zayavka.KodSklada:=form1.DBFZayavka2.GetFieldData(1);
      Zayavka.KodPostav:=form1.DBFZayavka2.GetFieldData(2);
      Zayavka.NamePostav:=form1.DBFZayavka2.GetFieldData(3);
      Zayavka.KodGruuz:=form1.DBFZayavka2.GetFieldData(4);
      Zayavka.NameGruuz:=form1.DBFZayavka2.GetFieldData(5);
      Zayavka.TimeZakaza:=form1.DBFZayavka2.GetFieldData(6);
      Zayavka.DniNedeli:=form1.DBFZayavka2.GetFieldData(7);
      form1.DBFZayavka2.Next;
    //  writeln(log,'������ ��������� � ������');
      if Form1.DBFZayavka.RecordCount<>0 then
      begin
       for j:=1 to Form1.DBFZayavka.RecordCount do
        begin
         if (form1.DBFZayavka.GetFieldData(2)=Zayavka.KodPostav) and (form1.DBFZayavka.GetFieldData(4)=Zayavka.KodGruuz) then
           form1.DBFZayavka.Deleted:=true;
         Form1.DBFZayavka.Next;
        end;
        form1.DBFZayavka.PackTable;
       form1.DBFZayavka.First;
      end;
      //writeln(log,'������� � ���� ��� ����');
      for j:=2 to Form1.DBFZayavka2.RecordCount do
        begin
         form1.DBFZayavka.Append;
         form1.DBFZayavka.SetFieldData(1,Zayavka.KodSklada);
         form1.DBFZayavka.SetFieldData(2,Zayavka.KodPostav);
         form1.DBFZayavka.SetFieldData(3,Zayavka.NamePostav);
         form1.DBFZayavka.SetFieldData(4,Zayavka.KodGruuz);
         form1.DBFZayavka.SetFieldData(5,Zayavka.NameGruuz);
         form1.DBFZayavka.SetFieldData(6,Zayavka.TimeZakaza);
         form1.DBFZayavka.SetFieldData(7,Zayavka.DniNedeli);
         form1.DBFZayavka.SetFieldData(8,form1.DBFZayavka2.GetFieldData(8));
         form1.DBFZayavka.SetFieldData(9,form1.DBFZayavka2.GetFieldData(9));
         form1.DBFZayavka.SetFieldData(10,form1.DBFZayavka2.GetFieldData(10));
         form1.DBFZayavka.SetFieldData(11,form1.DBFZayavka2.GetFieldData(11));
         form1.DBFZayavka.SetFieldData(12,form1.DBFZayavka2.GetFieldData(12));
         form1.DBFZayavka.SetFieldData(13,form1.DBFZayavka2.GetFieldData(13));
         form1.DBFZayavka.SetFieldData(14,form1.DBFZayavka2.GetFieldData(14));
         form1.DBFZayavka.SetFieldData(15,form1.DBFZayavka2.GetFieldData(15));
         form1.DBFZayavka2.Next;
        end;
      form1.DBFZayavka.Post;
      WriteStatus(GetDateT+' �������� ���������� ������� ������ ��� �������� "'+Magaz[m].Name+'"');
    //  writeln(log,'�������� ����� ������');
     end;
    try
      form1.DBFZayavka.Close;
      form1.DBFZayavka2.Close;
    except
      end;
    try
     DeleteFile('temp\'+Copy(flist[i],1,7)+'.zip');
     DeleteFile('temp\'+Copy(flist[i],1,7)+'.dbf');
     form1.ftp.Delete(Copy(flist[i],1,7)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,7)+'.fzf');
   //  writeln(log,'������ ����� �� ����� � ���');
    except
      writeln(log,'�� ���� ������� ����� � ���');
      end;

   //   writeln(log,Copy(flist[i],1,8)+'.zip ������� � Temp.');
   except
    try
      Form1.DBFZayavka.Close;
      Form1.DBFZayavka2.Close;
      DeleteFile('temp\'+Copy(flist[i],1,7)+'.zip');
      DeleteFile('temp\'+Copy(flist[i],1,7)+'.dbf');
       except
        end;
   writeln(log,'(GetZayavNomenkl)�� ���� ���������� '+Copy(flist[i],1,7)+'.zip � Temp.. :(');
   DeleteFile('temp\'+Copy(flist[i],1,7)+'.zip');
   end;
   end;

end;
//.............................
procedure get_ost(m:integer);
begin
 try
  Form1.ftp.get('database.zip','temp\database'+inttostr(m)+'.zip',true,false);
  if FileExists('temp\database'+inttostr(m)+'.zip') then
  // ������� ����������� �������
          with form1.zp1 do
          try
           FileName:=EXEPath+'temp\database'+inttostr(m)+'.zip';
           OpenArchive(fmOpenRead);
           BaseDir:=EXEPath+'\temp\';
           ExtractFiles('*.*');
           CloseArchive;
           except
           Exit;
          end;
  if FileExists(EXEPath+'\temp\database.dbf') then
    if CopyFile(Pchar(EXEPath+'\temp\database.dbf'),pchar(EXEPath+'\base\database'+inttostr(m)+'.dbf'),false) then
      begin
        Form1.ftp.Delete('database.zip');
        Form1.ftp.Delete('database.fl2');
      end;

   except
     end
end;
//...................................................................................................
//��������� ��������� ������ �� �������������� � FTP
procedure getinv(m:integer);
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
 // writeln(log,Getdatet+'(getinv) ������ �������� ������ ������ �� ����� '+Magaz[m].FTPDir);
  Form1.ftp.List(ls); //�������� ������ ������ � FTP
  if ls.Count<>0 then
    //writeln(log,Getdatet+' ������� �����:');
  except
    // ���� ��� ������ ��� � ���, �� ������ �������, �������� � ��������� ���������.
  try
  writeln(log,Getdatet+'(getinv) �� ���� �������� ������ ������ �� ����� '+Magaz[m].FTPDir);
   except
     end;
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
   writeln(log,Copy(ls[i],AnsiPos('.gin',ls[i])-8,12));
    end;
   except // ���� �������, �� �����������.
     try
    writeln(log,Getdatet+'(getinv) �� ���� ������������� ������ ������ �� ����� '+Magaz[m].FTPDir);
   except
     end;
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
  if not DirectoryExists('c:\��������������_'+Magaz[m].Name) then
    CreateDir('c:\��������������_'+Magaz[m].Name);

 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   try
   writeln(log,'������ �������� '+Copy(flist[i],1,8)+'.zip � Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);
   if CopyFile(PChar('temp\'+Copy(flist[i],1,8)+'.zip'),Pchar('c:\��������������_'+Magaz[m].Name+'\'+Copy(flist[i],1,8)+'.zip'),false) then
    begin
     DeleteFile('temp\'+Copy(flist[i],1,8)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,8)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,8)+'.gin');
    end;
   //   writeln(log,Copy(flist[i],1,8)+'.zip ������� � Temp.');
   except
   writeln(log,'�� ���� ������� '+Copy(flist[i],1,8)+'.zip � Temp.. :(');
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

////...................................................................................................
////��������� ��������� ����� � FTP
procedure getinv2(m:integer);
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
  //writeln(log,Getdatet+'(getinv) ������ �������� ������ ������ �� ����� '+Magaz[m].FTPDir);
  Form1.ftp.List(ls); //�������� ������ ������ � FTP
  if ls.Count<>0 then
    //writeln(log,Getdatet+' ������� �����:');
  except
    // ���� ��� ������ ��� � ���, �� ������ �������, �������� � ��������� ���������.
  try
  writeln(log,Getdatet+'(getinv) �� ���� �������� ������ ������ �� ����� '+Magaz[m].FTPDir);
   except
     end;
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
   writeln(log,Copy(ls[i],AnsiPos('.gid',ls[i])-8,12));
    end;
   except // ���� �������, �� �����������.
     try
    writeln(log,Getdatet+'(getdoc) �� ���� ������������� ������ ������ �� ����� '+Magaz[m].FTPDir);
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
  if not DirectoryExists('c:\��������������_'+Magaz[m].Name) then
    CreateDir('c:\��������������_'+Magaz[m].Name);

 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   try
   writeln(log,'������ �������� '+Copy(flist[i],1,8)+'.zip � Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);

    if not DirectoryExists('C:\��������������_'+Magaz[m].Name+'\'+Copy(flist[i],1,8)) then
      CreateDir('C:\��������������_'+Magaz[m].Name+'\'+Copy(flist[i],1,8));
     with form1.zp1 do
      try
      FileName:='temp\'+Copy(flist[i],1,8)+'.zip';
      OpenArchive(fmOpenRead);
      BaseDir:='C:\��������������_'+Magaz[m].Name+'\'+Copy(flist[i],1,8)+'\';
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
   writeln(log,'�� ���� ������� '+Copy(flist[i],1,8)+'.zip � Temp.. :(');
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

//��������� ��������� ������ ����� � FTP
procedure getinv3(m:integer);
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
  //writeln(log,Getdatet+'(getinv) ������ �������� ������ ������ �� ����� '+Magaz[m].FTPDir);
  Form1.ftp.List(ls); //�������� ������ ������ � FTP
  if ls.Count<>0 then
  //  writeln(log,Getdatet+' ������� �����:');
  except
    // ���� ��� ������ ��� � ���, �� ������ �������, �������� � ��������� ���������.
  try
  writeln(log,Getdatet+'(getinv) �� ���� �������� ������ ������ �� ����� '+Magaz[m].FTPDir);
   except
     end;
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
   writeln(log,Copy(ls[i],AnsiPos('.gim',ls[i])-8,12));
    end;
   except // ���� �������, �� �����������.
     try
    writeln(log,Getdatet+'(getdoc) �� ���� ������������� ������ ������ �� ����� '+Magaz[m].FTPDir);
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
  if not DirectoryExists('c:\��������������_'+Magaz[m].Name) then
    CreateDir('c:\��������������_'+Magaz[m].Name);

 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   try
   writeln(log,'������ �������� '+Copy(flist[i],1,8)+'.zip � Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);

    if not DirectoryExists('C:\��������������_'+Magaz[m].Name+'\'+Copy(flist[i],1,8)) then
      CreateDir('C:\��������������_'+Magaz[m].Name+'\'+Copy(flist[i],1,8));
     with form1.zp1 do
      try
      FileName:='temp\'+Copy(flist[i],1,8)+'.zip';
      OpenArchive(fmOpenRead);
      BaseDir:='C:\��������������_'+Magaz[m].Name+'\'+Copy(flist[i],1,8)+'\';
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
   writeln(log,'�� ���� ������� '+Copy(flist[i],1,8)+'.zip � Temp.. :(');
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
  AssignFile(f,'temp\versionfile.txt');
  Rewrite(f);
  if FileExists('dk_interface.exe') then
    Writeln(f,'DKR Interface version: '+FileVersion('dk_interface.exe'));
  Writeln(f,'DKR Engine version: '+FileVersion(Paramstr(0)));
  if FileExists('dkrupdater.exe') then
    Writeln(f,'DKR Updater version: '+FileVersion('dkrupdater.exe'));
  if FileExists('updscript.exe') then
    Writeln(f,'DKR UpdScript version: '+FileVersion('updscript.exe'));

  // ��������� �����������
//   try
//    Form1.dbf.TableName:='base\download.dbf';
//    form1.dbf.Exclusive:=false;
//    Form1.DBF.Open;
//    Form1.DBF.Last;
//    s:=Copy(Form1.DBF.GetFieldData(1),5,4);
//    s:=IntToStr(StrToInt(s));
//    Writeln(f,'�����������: '+s);
//    Form1.DBF.Close;
//     except
//       end;

  // ��������� ������
//   try
//    Form1.dbf.TableName:='base\upload.dbf';
//    form1.dbf.Exclusive:=false;
//    Form1.DBF.Open;
//    Writeln(f,'�������: '+inttostr(form1.DBF.RecordCount));
//    Form1.DBF.Close;
//     except
//       end;
  Writeln(f,'��� ����������: '+GetComputerNName);
  Writeln(f,'����: '+GetDateT);
  CloseFile(f);
  try
  form1.ftp.Put('temp\versionfile.txt','versionfile.txt',false);
  Form1.ftp.Delete('getversion.txt');
  DeleteFile('temp\versionfile.txt');
  except
    end;
  except
  end;
  ls2.Free;
end;


//��������� �������� ����� ������ � ����������� ���������
//procedure ReportReadMail;
//var i:Integer;
//rfile:TextFile;
//begin
// try
//  Form1.dbf.TableName:='base\mail_down.dbf';
//  form1.dbf.Exclusive:=false;
//  Form1.DBF.Open;
//  except
//    try
//      Form1.DBF.Close;
//      except
//        end;
//        Exit;
//    end;
//  try
//  if Form1.DBF.RecordCount<>0 then
//  for i:=1 to Form1.DBF.RecordCount do
//   begin
//      if form1.DBF.GetFieldData(4)='1' then
//        begin
//           //������� ������� ���� ������ � ��������
//           try
//           AssignFile(rfile,'temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
//           Rewrite(rfile);
//           CloseFile(rfile);
//             except
//               Writeln(log,getdatet+' �� ���� ������� ���� ������ � �������� � \temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
//               end;
//           //������� ��������� ����
//           try
//           form1.ftp.Put('temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md',copy(form1.DBF.GetFieldData(1),1,10)+'.md',false);
//           Writeln(log,getdatet+' �������� ���� ������ '+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
//           // ���� ���������, �� ������ ������� � �� � ������� �� �����
//           Form1.DBF.SetFieldData(4,'2');
//           DeleteFile('temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
//           except
//           end;
//             end;
//    Form1.DBF.Next;
//   end;
//  form1.DBF.Post;
//  except
//  end;
//  try
//   form1.DBF.Close;
//    except
//      end;
//end;

//...................................................................................................
//��������� ��������� ������ �� ������ � FTP � mail/download
//procedure getmail;
//var
//i,k,j:Integer;
//breakc:Boolean;
//flag,themt:TextFile;
//them:string;
//begin
//
//  breakc:=false;
//  try
//     Form1.DBF4.TableName:='base\mail_down.dbf';
//     Form1.DBF4.Exclusive:=false;
//     Form1.DBF4.Open;
//   except
//     try
//       Form1.DBF4.Close;
//       except
//         end;
//     Exit;
//     end;
// //������� ������������ � FTP
//flist:=TStringList.Create;
//ls:=TStringList.Create;
//flist.Clear;
//ls.Clear;
//try
//writeln(log,Getdatet+' ������ �������� ������ �������� ������ �� ����� '+dir);
//Form1.ftp.List(ls); //�������� ������ ������ � FTP
//if ls.Count<>0 then
//  writeln(log,Getdatet+' ������� �����:');
//except
//  writeln(log,Getdatet+' �� ���� �������� ������ ������ �� ����� '+dir);
//  ls.Free;
//  flist.Free;
//  try
//    form1.DBF4.Close;
//    except
//      end;
//      exit;
//  end;
//  try
// //���������, �������� ����� ��������.
//   if ls.Count<>0 then
//   for i:=0 to ls.Count-1 do
//   if AnsiPos('.mdf',ls[i])<>0 then begin
//   flist.add(Copy(ls[i],AnsiPos('.mdf',ls[i])-10,14));
//   writeln(log,Copy(ls[i],AnsiPos('.mdf',ls[i])-10,14));
//    end;
//   except
//    end;
//
//  if flist.Count>0 then
//   try // ������� ���� ��� ����������
//    AssignFile(flag,'temp\getmail.txt');
//    Rewrite(flag);
//    CloseFile(flag);
//    except
//    end;
//
// if flist.Count>0 then
// try
// //������� c������ ����� � FTP
//  for i:=0 to flist.Count-1 do
//  begin
//   // ��������� ���� �� ����� ����, ���� ����
//   try
//    for j:=1 to form1.DBF4.RecordCount do
//     begin
//     if Copy(Form1.DBF4.GetFieldData(1),1,10)=Copy(flist[i],1,10) then
//      begin
//       Breakc:=true;
//       writeln(log,' ���� '+Form1.DBF4.GetFieldData(1)+' ��� ��� ����� �������.');
//       end;
//       Form1.DBF4.Next;
//      end;
//    except
//     end;
//
//   if breakc then
//   begin
//    try
//     Form1.ftp.Delete(Copy(flist[i],1,10)+'.zip');
//     writeln(log,Copy(flist[i],1,10)+'.zip ������ � FTP '+host);
//     except
//    end;
//    try
//     Form1.ftp.Delete(flist[i]);
//     writeln(log,flist[i]+' ������ � FTP '+host);
//     except
//    end;
//     end;
//
//   if breakc then Continue;
//  try
//   writeln(log,'������ �������� '+Copy(flist[i],1,10)+'.zip � mail\download');
//   Form1.ftp.get(Copy(flist[i],1,10)+'.zip','mail\download\'+Copy(flist[i],1,10)+'.zip',true,false);
//   writeln(log,Copy(flist[i],1,10)+'.zip ������� � mail\download\.');
//    try
//     Form1.ftp.Delete(Copy(flist[i],1,10)+'.zip');
//     writeln(log,Copy(flist[i],1,10)+'.zip ������ � FTP '+host);
//     except
//     writeln(log,'�� ���� ������� '+Copy(flist[i],1,10)+'.zip � FTP '+host);
//    end;
//    try
//     Form1.ftp.Delete(flist[i]);
//     writeln(log,flist[i]+' ������ � FTP '+host);
//     except
//    writeln(log,'�� ���� ������� '+flist[i]+'.zip � FTP '+host);
//    end;
//   except
//   writeln(log,'�� ���� ������� '+Copy(flist[i],1,10)+'.zip � mail\download\, ��������� � ���... ������ �� ����... :(');
//   // ���� �� ������ ������� ����, �� ��������� �� �������...
//   try
//     form1.DBF4.Close; // ��������� ��
//     except
//       end;
//    try
//      // ���������� ��������� �������
//     flist.free;
//     ls.free;
//      except
//        end;
//      // ������� ����-����.
//    DeleteFile('temp\getmail.txt');
//    Exit;
//   end;
//
//    // ������� ����������� � ����� ����
//      with form1.zp1 do
//      try
//      FileName:='mail\download\'+Copy(flist[i],1,10)+'.zip';
//      OpenArchive(fmOpenRead);
//      BaseDir:=extractfilepath(paramstr(0))+'\temp\';
//      ExtractFiles('*.*');
//      CloseArchive;
//      except
//        end;
//   try
//   AssignFile(themt,'temp\them.txt');
//   Reset(themt);
//   Readln(themt,them);
//   CloseFile(themt);
//   DeleteFile('temp\them.txt');
//   DeleteFile('temp\text.txt');
//     except
//     end;
//
//   form1.DBF4.Append;
//   Form1.DBF4.SetFieldData(1,Copy(flist[i],1,10)+'.zip');
//   Form1.DBF4.SetFieldData(2,GetDateT);
//   Form1.DBF4.SetFieldData(3,them);
//   Form1.DBF4.SetFieldData(4,'0');
//   if FileExists('temp\include.xls') then
//      begin
//       Form1.DBF4.SetFieldData(5,'1');
//       DeleteFile('temp\include.xls');
//      end else Form1.DBF4.SetFieldData(5,'0');
//   Form1.DBF4.Post;
// end;
//  except
//    end;
//
//
// //������� �������� � ������� dbf
// try
//  Form1.DBF4.Post;
//  form1.DBF4.Close;
//  except
//    end;
//
//  try
//  DeleteFile('temp\getmail.txt');
//  flist.free;
//  ls.free;
//  except
//  end;   
//end;


//��������� �������� ����� �� ���������� �� �����.
//procedure uploadtrz;
//var i:Integer;
//flist2,ls2:TStringList;
//fdcflag:TextFile;
//begin
//flist2:=TStringList.Create;
//ls2:=TStringList.Create;
//flist2.Clear;
//ls2.Clear;
// try
//  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
//  except
//    flist2.Free;
//    ls2.Free;
//    Exit;
//  end;
//  //���������, �������� ����� ��������.
// try
//  if ls2.Count<>0 then
//    for i:=0 to ls2.Count-1 do
//     if AnsiPos('.fdt',ls2[i])<>0 then
//       flist2.add(Copy(ls2[i],AnsiPos('.fdt',ls2[i])-10,14));
//  except
//    end;
//
//  //���������� ������ ��� ��� �����
//  try
//  for i:=0 to flist2.Count-1 do begin
//   try
//    Form1.ftp.Put('base\trz\'+copy(flist2[i],1,10)+'.zip',copy(flist2[i],1,10)+'.zip',false);
//    form1.ftp.Delete(copy(flist2[i],1,10)+'.fdt');
//    Writeln(log,getdatet+' ���� '+copy(flist2[i],1,10)+'.zip ��������� �� FTP �� �������.');
//    except
//      end;
//  end;
//  except
//    end;
//    ls2.free;
//    flist2.free;
//end;


//.................................................................................................
// ��������� ������� � ������� ���������� �������.
procedure getrunscript;
var i,trying:Integer;
ls2:TStringList;
loadflag,f:TextFile;
runload,succ:Boolean;
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
  trying:=0;
  succ:=false;
  while (not succ) and (trying<5) and (runload) do // ������� 5 ���, ���� �� ���������
     try
      trying:=trying+1;
      Writeln(log,getdatet+' ������ �������� ������ runscript.exe');
      // ������ ������ ������.
      DeleteFile('runscript.exe_');

      // ����� ������� runscript.exe, ���� ��� �������
      AssignFile(f,'kill_runscript.bat');
      rewrite(f);
      writeln(f,'taskkill.exe /F /IM runscript.exe');
      Closefile(f);
      winexec('kill_runscript.bat',0);
      Deletefile('kill_runscript.bat');

      if FileExists('runscript.exe') then
       if not RenameFile('runscript.exe','runscript.exe_') then
         RenameFile('runscript.exe','runscript.exe_'+inttostr(Random(100)));

      Form1.ftp.get('runscript.exe','runscript.exe',True,false);
      //   Writeln(log,getdatet+' ������, ������ ���������.');
      WinExec ('runscript.exe', SW_MINIMIZE);
      form1.ftp.Delete('runscript.exe');
      AssignFile(loadflag,'temp\runscript.loaded');
      Rewrite(loadflag);
      CloseFile(loadflag);
      form1.ftp.Put('temp\runscript.loaded','runscript.loaded');
      DeleteFile('temp\runscript.loaded');
      //   Writeln(log,getdatet+' �������� � ��������� ������ T_runscript.loaded');
      succ:=true;
      except
     end;
  ls2.free;
end;

// ��������� ��������� ����������� �� ��������� �����
//procedure localupload;
//var
//  searchResult : TSearchRec;
//  i,k:integer;
//  fname:TStringList;
//begin
//  fname:=TStringList.Create;
//  fname.Clear;
//   // ������� ������� DBF
//    try
//     Form1.DBF.TableName:='base\download.dbf';
//     Form1.DBF.Exclusive:=false;
//     Form1.DBF.Open;
//   except
//     end;
// try
//  if FindFirst(extractfilepath(paramstr(0))+'\localUpdate\*.flz', faAnyFile, searchResult) = 0 then
//  begin
//    repeat
//      fname.add(Copy(searchResult.Name,1,8)+'.zip');
//    until FindNext(searchResult) <> 0;
//    FindClose(searchResult);
//  end;
//   except
//     end;
//
//  if fname.Count<>0 then
//  try
//   for i:=0 to fname.Count-1 do begin
//   try
//    if CopyFile(PChar('localUpdate\'+Copy(fname[i],1,8)+'.zip'),PChar('base\download\'+Copy(fname[i],1,8)+'.zip'),true) then
//    begin
//     DeleteFile('localUpdate\'+Copy(fname[i],1,8)+'.zip');
//     DeleteFile('localUpdate\'+Copy(fname[i],1,8)+'.flz');
//     Form1.dbf.Append;
//     Form1.dbf.SetFieldData(1,Copy(fname[i],1,8)+'.zip');
//     Form1.dbf.SetFieldData(2,getdatet);
//     //���-�� ����� = ���-�� ����������
//     for k:=1 to npos do
//      Form1.dbf.SetFieldData(k+2,'0');
//    end;
//    except
//    end;
//   end;
//   except
//     end;
//  // ������� ������� DBF
//   try
//     Form1.DBF.Post;
//     except
//       end;
//
//   try
//     form1.DBF.Close;
//     except
//       end;
//
//   try
//     fname.free;
//   except
//   end;
//end;

//��������� �������� ���� � �� �� �����
//procedure uploadlog;
//var i:Integer;
//ls2:TStringList;
//getlog:Boolean;
//begin
//getlog:=false;
//ls2:=TStringList.Create;
//ls2.Clear;
// try
//  Form1.ftp.List(ls2); //�������� ������ ������ � FTP
// except
//   ls2.Free;
//   exit;
//  end;
////���������, �������� ����� ��������.
//  try
//   if ls2.Count<>0 then
//    for i:=0 to ls2.Count-1 do
//     if AnsiPos('getlogdb.gdb',ls2[i])<>0 then getlog:=True;
//  except
//    end;
//    //���������� ������ ��� ��� �����
//  if getlog then
//    try
//      if
//      CopyFile(PChar('base\download.dbf'),PChar('temp\download.dbf'),False) and
//      CopyFile(PChar('base\upload.dbf'),PChar('temp\upload.dbf'),False) and
//      CopyFile(PChar('base\transact.dbf'),PChar('temp\transact.dbf'),False) and
//      CopyFile(PChar('common.log'),PChar('temp\common.log'),False) and
//      CopyFile(PChar('version.txt'),PChar('temp\version.txt'),False) then
//     with Form1.zp1 do
//     begin
//      FileName:=extractfilepath(paramstr(0))+'\temp\logdb.zip';
//      OpenArchive(fmCreate);
//      BaseDir:=extractfilepath(paramstr(0))+'\temp\';
//      AddFiles('download.dbf');
//      AddFiles('upload.dbf');
//      AddFiles('transact.dbf');
//      AddFiles('common.log');
//      AddFiles('version.txt');
//      CloseArchive;
//     end;
//     DeleteFile('temp\download.dbf');
//     DeleteFile('temp\upload.dbf');
//     DeleteFile('temp\transact.dbf');
//     DeleteFile('temp\common.log');
//     DeleteFile('temp\version.txt');
//      Form1.ftp.put('temp\logdb.zip','logdb.zip',false);
//      Form1.ftp.Delete('getlogdb.gdb');
//      DeleteFile('temp\logdb.zip');
//    except
//      end;
//
// ls2.free;
//    
//end;

//���������� ���������� �� �������
procedure ReloadTRZ(m:integer);
var
  i:integer;
f,t:TextFile;
ls2:TStringList;
reloadtrz:Boolean;
s,ss,ss2,ts:string;
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
   if s='d' then
    begin
      Readln(f,ss);
      Readln(f,ss2);
       while not Eof(f) do
         begin
           Readln(f,ts);
            try
            AssignFile(t,Magaz[m].Path+'\pos0'+ts+'\unload.flr');
            Rewrite(t);
            Writeln(t,s);
            Writeln(t,ss);
            Writeln(t,ss2);
            CloseFile(t);
            except
            Form1.ftp.Delete('reloadtrz.txt');
             end;
          end;
    end else
    if s='all' then
      begin
       while not Eof(f) do
         begin
           Readln(f,ts);
            try
            AssignFile(t,Magaz[m].Path+'\pos0'+ts+'\unload.flr');
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
procedure reloadz(m:integer);
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
    Form1.ftp.Put('base\upload'+inttostr(m)+'\'+copy(flist2[i],1,8)+'.zip',copy(flist2[i],1,8)+'.zip',false);
    AssignFile(fdcflag,'temp\'+copy(flist2[i],1,8)+'.flg');
    Rewrite(fdcflag);
    CloseFile(fdcflag);
    Form1.ftp.Put('temp\'+copy(flist2[i],1,8)+'.flg',copy(flist2[i],1,8)+'.flg',false);
    DeleteFile('temp\'+copy(flist2[i],1,8)+'.flg');
    form1.ftp.Delete(copy(flist2[i],1,8)+'.fdc');
    Writeln(log,getdatet+' ���� '+copy(flist2[i],1,8)+'.zip ������������� �� FTP �� �������.');
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
procedure reportdownload(m:integer);
var i,j:Integer;
rfile:TextFile;
begin

    try
     Form1.dbf.TableName:=EXEPath+'base\download'+inttostr(m)+'.dbf';
     Form1.dbf.Exclusive:=false;
     Form1.DBF.Open;
    except
     try
      Form1.DBF.Close;
      except
        end;
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
             AssignFile(rfile,EXEPath+'temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
             Rewrite(rfile);
             CloseFile(rfile);
             except
             Writeln(log,getdatet+' �� ���� ������� ���� ������ � �������� � \temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
             end;
            //������� ��������� ����
            try
             form1.ftp.Put(EXEPath+'temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd',copy(form1.DBF.GetFieldData(1),1,8)+'.fd',false);
             Writeln(log,getdatet+' �������� ���� ������ '+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
             Form1.DBF.SetFieldData(j,'3');
             DeleteFile(EXEPath+'temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
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
procedure puttoftp(Mag:integer);
var i:integer;
uflag:TextFile;
begin
  try
    Form1.dbf1.TableName:=EXEPath+'base\upload'+inttostr(Mag)+'.dbf';
    form1.dbf1.Exclusive:=false;
    Form1.DBF1.Open;
  except
    try
      Writeln(log,getdatet+' PutToFTP: �� ���� ������� �� upload'+inttostr(Mag)+'.dbf');
      Form1.DBF1.Close;
      except
        end;
     Exit;
    end;
  try
   if form1.DBF1.RecordCount>0 then
     for i:=1 to Form1.DBF1.RecordCount do
      begin
        if Form1.DBF1.GetFieldData(3)='0' then
          try
           Form1.ftp.put('base\upload'+inttostr(Mag)+'\'+Form1.DBF1.GetFieldData(1),Form1.DBF1.GetFieldData(1),false);
           AssignFile(uflag,'temp\'+copy(Form1.DBF1.GetFieldData(1),1,8)+'.flg');
           Rewrite(uflag);
           CloseFile(uflag);
           Form1.ftp.Put('temp\'+copy(Form1.DBF1.GetFieldData(1),1,8)+'.flg',copy(Form1.DBF1.GetFieldData(1),1,8)+'.flg',false);
           Form1.DBF1.SetFieldData(3,'1');
           try  // ������� �������� �����, �.�. �� ����� ����� ���� ����� ��
             Form1.DBF1.SetFieldData(4,getdatet);
           except
             end;
           DeleteFile('temp\'+copy(Form1.DBF1.GetFieldData(1),1,8)+'.flg');
           WriteStatus(GetDateT+'�������� ����� '+Form1.DBF1.GetFieldData(1)+' � ����������� ��.');
          except
            Writeln(log,getdatet+' PutToFTP: �� ���� ��������� ���� '+Form1.DBF1.GetFieldData(1)+'.');
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

//.....................................................................................................
// ���������� ������ �� FTP
procedure ZayavkiToFTP(Mag:integer);
type TTovar2= record
 kod:string[10];
 kolvo:string[100];
end;
Tzag = record
 KodSklada:string[10];
 Data:string[10];
 Text:string[100];
 KodPostav:string[18];
 NamePostav:string[100];
end;
var i,j:integer;
uflag:TextFile;
tovar:TTovar2;
Zag:Tzag;
fname:string;
begin
  try
    Form1.DBFZayavka.TableName:=EXEPath+'base\jurnal_zayavok.dbf';
    form1.DBFZayavka.Exclusive:=false;
    Form1.DBFZayavka.Open;
  except
    try
      Writeln(log,getdatet+' ZayavkaToFTP: �� ���� ������� �� jurnal_zayavok.dbf');
      Form1.DBFZayavka.Close;
      except
        end;
     Exit;
    end;
  try
    if form1.DBFZayavka.RecordCount>0 then
      for i:=1 to Form1.DBFZayavka.RecordCount do
        begin
         if Form1.DBFZayavka.GetFieldData(1)=inttostr(Mag) then
           if (Form1.DBFZayavka.GetFieldData(11)='1') and (Form1.DBFZayavka.GetFieldData(12)='0') then
             begin
              try
               fname:=SetName();
              form1.DBFZayavka2.TableName:=EXEPath+'zayavki\'+form1.DBFZayavka.GetFieldData(10);
              form1.DBFZayavka2.Exclusive:=false;
              Form1.DBFZayavka2.Open;
              zag.KodSklada:=form1.DBFZayavka.GetFieldData(2);
              zag.Data:=form1.DBFZayavka.GetFieldData(4);
              zag.Text:=form1.DBFZayavka.GetFieldData(5);
              zag.KodPostav:=form1.DBFZayavka.GetFieldData(6);
              zag.NamePostav:=form1.DBFZayavka.GetFieldData(7);

              AssignFile(uflag,EXEPath+'temp\'+fname+'.zaj'); // ��� ��� ����� ��������!!!
              rewrite(uflag);
              Writeln(uflag,'"@$",'+zag.KodSklada+',"'+zag.Data+'","'+zag.Text+'",'+zag.KodPostav+',"'+zag.NamePostav+'"');
              if form1.DBFZayavka2.RecordCount>0 then
                for j:=1 to form1.DBFZayavka2.RecordCount do
                  begin
                   tovar.kod:=form1.DBFZayavka2.GetFieldData(1);
                   tovar.kolvo:=ZapToT4k(form1.DBFZayavka2.GetFieldData(8));
                   if tovar.kolvo <> '0' then
                    Writeln(uflag,tovar.kod+','+tovar.kolvo);

                   Form1.DBFZayavka2.Next;
                  end;
              Closefile(uflag);

              form1.DBFZayavka2.Close;

              AssignFile(uflag,EXEPath+'temp\'+fname+'.faj');
              rewrite(uflag);
              Closefile(uflag);

              Form1.ftp.put(EXEPath+'temp\'+fname+'.zaj',fname+'.zaj',false);
              Form1.ftp.put(EXEPath+'temp\'+fname+'.faj',fname+'.faj',false);
               Form1.DBFZayavka.SetFieldData(12,'1');
               Form1.DBFZayavka.Post;
               WriteStatus(GetDateT+' �������� ������ �'+fname+' ��� �������� "'+Magaz[Mag].Name+'"');
              except
              Writeln(log,getdatet+' PutToFTP: �� ���� ��������� ���� '+Form1.DBFZayavka.GetFieldData(1)+'.');
              end;
              DeleteFile(EXEPath+'temp\'+fname+'.zaj');
              DeleteFile(EXEPath+'temp\'+fname+'.faj');
             end;
         Form1.DBFZayavka.Next;
        end;
  except
   end;

  try
    Form1.DBFZayavka.Close;
  except
   end;
end;

// ����� ������ �� FTP
//procedure mailtoftp;
//var i:integer;
//uflag:TextFile;
//begin
//  try
//    Form1.MailDBF.TableName:='base\mail_up.dbf';
//    form1.MailDBF.Exclusive:=false;
//    Form1.MailDBF.Open;
//  except
//    try
//      Writeln(log,getdatet+' MailToFTP: �� ���� ������� �� mail_up.dbf.');
//      Form1.MailDBF.Close;
//      except
//        end;
//     Exit;
//    end;
//    try
// for i:=1 to Form1.MailDBF.RecordCount do
//  begin
//    if Form1.MailDBF.GetFieldData(3)='0' then
//    try
//     Form1.ftp.put('mail\upload\'+Form1.MailDBF.GetFieldData(1),Form1.MailDBF.GetFieldData(1),false);
//     AssignFile(uflag,'temp\'+copy(Form1.MailDBF.GetFieldData(1),1,10)+'.muf');
//     Rewrite(uflag);
//     CloseFile(uflag);
//     Form1.ftp.Put('temp\'+copy(Form1.MailDBF.GetFieldData(1),1,10)+'.muf',copy(Form1.MailDBF.GetFieldData(1),1,10)+'.muf',false);
//     Form1.MailDBF.SetFieldData(3,'1');
//     DeleteFile('temp\'+copy(Form1.MailDBF.GetFieldData(1),1,10)+'.muf');
//    except
//      Writeln(log,getdatet+' MailToFTP: �� ���� ��������� ���� '+Form1.MailDBF.GetFieldData(1)+'.');
//   end;
//  Form1.MailDBF.Next;
//  end;
// except
//  end;
//
//  try
//   Form1.MailDBF.Post;
//   Form1.MailDBF.Close;
//  except
//   end;
//end;



//...................................................................................................
//��������� ��������� ������ �� ������ � FTP � Temp
procedure getfromftp2(ddir:integer);
var
i,k,j,m:Integer;
breakc:Boolean;
flag:TextFile;
begin

  // ������� ������� ��
    try
       Form1.DBF.TableName:=EXEPath+'base\download'+inttostr(ddir)+'.dbf';
       Form1.DBF.Exclusive:=false;
       Form1.DBF.Open;
     except // ���� �� �������, �� ������� �������� � ������� �� ���������
        try
        Writeln(log,getdatet+'GetFromFTP: �� ���� ������� �� download'+inttostr(ddir)+'.dbf.');
        Form1.DBF.Close;
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
   //  writeln(log,Getdatet+' ������ �������� ������ ������ �� ����� dir'+inttostr(ddir));
     Form1.ftp.List(ls); //�������� ������ ������ � FTP
     if ls.Count<>0 then
    //   writeln(log,Getdatet+' ������� �����:');
    except
      // ���� ��� ������ ��� � ���, �� ������ �������, �������� � ��������� ���������.
     try
      writeln(log,Getdatet+' �� ���� �������� ������ ������ �� ����� dir'+inttostr(ddir));
     except
     end;
    ls.Free;
    flist.Free;
    try
     Form1.DBF.Close;
    except
      end;
    Exit;
   end;

   try
    //���������, �������� ����� ��������.
    if ls.Count<>0 then
     for i:=0 to ls.Count-1 do
      if AnsiPos('.flz',ls[i])<>0 then
       begin
        flist.add(Copy(ls[i],AnsiPos('.flz',ls[i])-8,12));
     //   writeln(log,Copy(ls[i],AnsiPos('.flz',ls[i])-8,12));
       end;
    except // ���� �������, �� �����������.
     try
      writeln(log,Getdatet+' �� ���� ������������� ������ ������ �� ����� dir'+inttostr(ddir));
     except
     end;
     ls.Free;
     flist.Free;
     try
       Form1.DBF.Close;
     except
       end;
     Exit;
   end;


     if flist.Count>0 then
     try // ������� ���� ��� ����������
      AssignFile(flag,EXEPath+'temp\downloading.txt');
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
     for i:=0 to flist.Count-1 do
      begin
       breakc:=false;
       // ��������� ���� �� ����� ����, ���� ���� �� � ���.
       try
        for j:=1 to form1.DBF.RecordCount do
         begin
          if Copy(Form1.DBF.GetFieldData(1),1,8)=Copy(flist[i],1,8) then
           begin
            Breakc:=true;
            writeln(log,' ���� '+Form1.DBF.GetFieldData(1)+' ��� ��� ����� �������. ���-�� ��������� :) ����������...');
            try
             AssignFile(flag,EXEPath+'temp\'+Copy(flist[i],1,8)+'.zip_repeated');
             Rewrite(flag);
             CloseFile(flag);
             Form1.ftp.put(EXEPath+'temp\'+Copy(flist[i],1,8)+'.zip_repeated',Copy(flist[i],1,8)+'.zip_repeated',false);
             DeleteFile(EXEPath+'temp\'+Copy(flist[i],1,8)+'.zip_repeated');
            except
             end;
            Break;
           end;
           Form1.DBF.Next;
         end;
        except
        end;
       if breakc then Continue;

        try
         //writeln(log,'������ �������� '+Copy(flist[i],1,8)+'.zip � Temp');
         Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);
         //writeln(log,Copy(flist[i],1,8)+'.zip ������� � Temp.');
         except
         writeln(log,'�� ���� ������� '+Copy(flist[i],1,8)+'.zip � Temp, ��������� � ���... ������ �� ����... :(');
         // ���� �� ������ ������� ����, �� ��������� �� �������...
         Exit;
        end;

        try
         // ������� ����������� �������
          with form1.zp1 do
          try
           FileName:=EXEPath+'temp\'+Copy(flist[i],1,8)+'.zip';
           OpenArchive(fmOpenRead);
           BaseDir:=EXEPath+'\temp\';
           ExtractFiles('*.*');
           CloseArchive;
           except
           ls.Free;
           flist.Free;
           try
             Form1.DBF.Close;
            except
            end;
           Exit;
          end;

         if CopyFile(PChar(EXEPath+'temp\'+Copy(flist[i],1,8)+'.txt'),PChar(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������_'+Magaz[ddir].Name+'\'+Copy(flist[i],1,8)+'.txt'),False) then
          begin
            DeleteFile(EXEPath+'temp\'+Copy(flist[i],1,8)+'.txt');
            DeleteFile(EXEPath+'temp\demo.spr');
            ShellExecute(0,'Open',pchar(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������_'+Magaz[ddir].Name+'\'+Copy(flist[i],1,8)+'.txt'),nil,nil, 1);
          end;
         // ���������� ��������� ����� �� ����� � �����.
         if not CopyFile(PChar(EXEPath+'temp\'+Copy(flist[i],1,8)+'.zip'),PChar(EXEPath+'base\download'+inttostr(ddir)+'\'+Copy(flist[i],1,8)+'.zip'),false) then
          writeln(log,'�� ���� ����������� '+Copy(flist[i],1,8)+'.zip �� Temp � base\download'+inttostr(ddir)+'\')
         else
         begin
          // ���������� ������ � ��
          // writeln(log,'���� '+Copy(flist[i],1,8)+'.zip ��������� � base\download'+inttostr(ddir)+'\');
           Form1.dbf.Append;
           Form1.dbf.SetFieldData(1,Copy(flist[i],1,8)+'.zip');
           Form1.dbf.SetFieldData(2,getdatet);
           //������� ���-�� ����� � dbf ������ ���-�� ����������
          for k:=1 to npos do
            Form1.dbf.SetFieldData(k+2,'0');
          Form1.DBF.Post;

              // ������� ���� � ����� � ��� ������ ����� ��������� � �� ������
          try
           Form1.ftp.Delete(Copy(flist[i],1,8)+'.zip');
           //writeln(log,Copy(flist[i],1,8)+'.zip ������ � FTP '+host);
          except
           writeln(log,'�� ���� ������� '+Copy(flist[i],1,8)+'.zip � FTP '+host);
          end;

          try
            Form1.ftp.Delete(flist[i]);
            //writeln(log,flist[i]+' ������ � FTP '+host);
           except
            writeln(log,'�� ���� ������� '+flist[i]+' � FTP '+host);
          end;
          WriteStatus(GetDateT+' [�����������] �������� ����������� '+Copy(flist[i],1,8));
          end;

        except
        end;


      end;

    //������� ����� �� �����
   for i:=0 to flist.Count-1 do
     if not DeleteFile(EXEPath+'temp\'+Copy(flist[i],1,8)+'.zip') then
       writeln(log,'�� ���� ������� temp\'+Copy(flist[i],1,8)+'.zip');
   try
    Form1.DBF.Close;
   except
     end;
   try
     DeleteFile(EXEPath+'temp\downloading.txt');
     flist.free;
    ls.free;
   except
   end;

end;

//........................................................................................................................
// ��������� ����������� � FTP
procedure connecttoftp(ddir:string);
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
  //   writeln(log,GetDateT+' ����������� � '+Host+' �������!');
     //  writeln(log,GetDateT+' ������ ����� � ����� '+dir);
     Form1.ftp.ChangeDir(ddir);
     //  writeln(log,GetDateT+' ����� � ����� '+dir);

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
//  writeln(log,GetDateT+' ���������� �� '+Host);
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
var i,k,pcount:Integer;
process:TStringList;
f,f2,dateflag:textfile;
begin
 // ������ ��������� �������
 for i:=0 to ParamCount do
  if ParamStr(i)='/install' then
    DeleteFile(GetSystemDir+'\conflict.nls');

  if ParamStr(i)='/lock' then
    try
     AssignFile(f,GetSystemDir+'\conflict.nls');
     Rewrite(f);
     CloseFile(f);
    except
    end;
 // ��������� ��������� �������................


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

 EXEPath:=extractfilepath(paramstr(0));

 Sleep(1000);
 if not FileExists(GetSpecialPath(CSIDL_COMMON_STARTUP)+'dkengine.lnk') then
    CopyFile(PChar(EXEPath+'\dkengine.lnk'),PChar(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\dkengine.lnk'),false);
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

  try
   if not DirectoryExists('base') then
      CreateDir('base');
   if not DirectoryExists('base\trz') then
      CreateDir('base\trz');
   if not DirectoryExists('mail') then
      CreateDir('mail');
    if not DirectoryExists('mail\download') then
      CreateDir('mail\download');
    if not DirectoryExists('mail\upload') then
      CreateDir('mail\upload');
    if not DirectoryExists('temp') then
      CreateDir('temp');
    if not DirectoryExists('temp\mag1') then
      CreateDir('temp\mag1');
    if not DirectoryExists('temp\mag2') then
      CreateDir('temp\mag2');
    if not DirectoryExists('temp\mag3') then
      CreateDir('temp\mag3');
    if not DirectoryExists('temp\mag4') then
      CreateDir('temp\mag4');
    if not DirectoryExists('temp\mag5') then
      CreateDir('temp\mag5');
    if not DirectoryExists('status') then
      CreateDir('status');

    for i:=1 to 5 do
      if Magaz[i].FTPDir<>'' then
        if Not DirectoryExists(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������_'+Magaz[i].Name) then
          CreateDir(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������_'+Magaz[i].Name);
  except
    end;


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

  if NOT FileExists('common.log') then begin
  AssignFile(log,'common.log');
  rewrite(log);
  closefile(log);
  end;
  AssignFile(log,'common.log');
  Append(log);
  writeln(log,Getdatet+' DK Report Engine ������� �� '+GetComputerNName);
  except
  end;
  //������ ������ ��� �������
  try
if not RegisterHotkey(Handle, 1, MOD_ALT, VK_F1) then
  ShowMessage('������� Alt+F1 ��� ������.');
  except
    ShowMessage('�� ���� ���������������� ������� Alt+F1');
    writeln(log,Getdatet+' �� ���� ���������������� ������� Alt+F1');
    end;
 //���� ��� ����� ��������, �� ������� ���
 try
  if (not FileExists(EXEPath+'config.ini')) then begin
   Ini:=TiniFile.Create(EXEPath+'config.ini'); //������� ���� ��������
   Ini.WriteInteger('Base','PutToPosTime',2); // ����� ����� ������� ���������
   Ini.WriteInteger('Base','GetPosRepTime',10); // �������� ������ ���� �� POS.rep
   Ini.WriteInteger('Base','PostLoadFlag',1); // ���� (1/0) ����������� ��� ��� ���� �������� demo.spr
   Ini.WriteInteger('Base','GetFromFTPTime',10); // �������� ������ FTP
   Ini.WriteInteger('Base','GTPPauseTime',5);  // ����� ����� ���������� POS.rep (���� POS ����� ��������)
   Ini.WriteInteger('Base','AutoConnect',1); // ���� ����-��������
   Ini.WriteInteger('Base','AutoDisconnect',0); // ���� ����-�����������
   Ini.WriteInteger('Base','AutoLoadTRZ',1); // ���� ����-�������� ���������� �� �������� 61
   Ini.WriteString('Base','Mag1_Path','C:\Mag1\');
   Ini.WriteString('Base','Mag2_Path','C:\Mag2\');
   Ini.WriteString('Base','Mag3_Path','C:\Mag3\');
   Ini.WriteString('Base','Mag4_Path','C:\Mag4\');
   Ini.WriteString('Base','Mag5_Path','C:\Mag5\');
   Ini.WriteString('Base','Mag1_Name','������� ��');
   Ini.WriteString('Base','Mag2_Name','������� ��');
   Ini.WriteString('Base','Mag3_Name','������� ��');
   Ini.WriteString('Base','Mag4_Name','������� ��');
   Ini.WriteString('Base','Mag5_Name','������� ��');
   Ini.WriteString('Base','Mag1_Firm','��� "������� �������"');
   Ini.WriteString('Base','Mag2_Firm','��� "������� �������"');
   Ini.WriteString('Base','Mag3_Firm','��� "������� �������"');
   Ini.WriteString('Base','Mag4_Firm','��� "������� �������"');
   Ini.WriteString('Base','Mag5_Firm','��� "������� �������"');
   Ini.WriteString('FTP','Host','ugrus.com');
   ini.WriteInteger('FTP','Port',21);
   Ini.WriteString('FTP','User','dk');
   Ini.WriteString('FTP','Password','dk');
      Ini.WriteString('FTP','Dir1','');
   Ini.WriteString('FTP','Dir2','');
   Ini.WriteString('FTP','Dir3','');
   Ini.WriteString('FTP','Dir4','');
   Ini.WriteString('FTP','Dir5','');
//   ini.WriteInteger('POS','NPOS',0);
   ini.WriteString('Dir1_POS','POS01','192.168.0.2');
   ini.WriteString('Dir1_POS','POS02','192.168.0.3');
   ini.WriteString('Dir1_POS','POS03','192.168.0.4');
   ini.WriteString('Dir1_POS','POS04','192.168.0.5');
   ini.WriteString('Dir1_POS','POS05','');
   ini.WriteString('Dir1_POS','POS06','');
   ini.WriteString('Dir1_POS','POS07','');
   ini.WriteString('Dir1_POS','POS08','');
   ini.WriteString('Dir1_POS','POS09','');

   ini.WriteString('Dir2_POS','POS01','');
   ini.WriteString('Dir2_POS','POS02','');
   ini.WriteString('Dir2_POS','POS03','');
   ini.WriteString('Dir2_POS','POS04','');
   ini.WriteString('Dir2_POS','POS05','');
   ini.WriteString('Dir2_POS','POS06','');
   ini.WriteString('Dir2_POS','POS07','');
   ini.WriteString('Dir2_POS','POS08','');
   ini.WriteString('Dir2_POS','POS09','');

   ini.WriteString('Dir3_POS','POS01','');
   ini.WriteString('Dir3_POS','POS02','');
   ini.WriteString('Dir3_POS','POS03','');
   ini.WriteString('Dir3_POS','POS04','');
   ini.WriteString('Dir3_POS','POS05','');
   ini.WriteString('Dir3_POS','POS06','');
   ini.WriteString('Dir3_POS','POS07','');
   ini.WriteString('Dir3_POS','POS08','');
   ini.WriteString('Dir3_POS','POS09','');

   ini.WriteString('Dir4_POS','POS01','');
   ini.WriteString('Dir4_POS','POS02','');
   ini.WriteString('Dir4_POS','POS03','');
   ini.WriteString('Dir4_POS','POS04','');
   ini.WriteString('Dir4_POS','POS05','');
   ini.WriteString('Dir4_POS','POS06','');
   ini.WriteString('Dir4_POS','POS07','');
   ini.WriteString('Dir4_POS','POS08','');
   ini.WriteString('Dir4_POS','POS09','');

   ini.WriteString('Dir5_POS','POS01','');
   ini.WriteString('Dir5_POS','POS02','');
   ini.WriteString('Dir5_POS','POS03','');
   ini.WriteString('Dir5_POS','POS04','');
   ini.WriteString('Dir5_POS','POS05','');
   ini.WriteString('Dir5_POS','POS06','');
   ini.WriteString('Dir5_POS','POS07','');
   ini.WriteString('Dir5_POS','POS08','');
   ini.WriteString('Dir5_POS','POS09','');

   Ini.WriteString('Updater','Host','ugrus.com');
   Ini.WriteString('Updater','Port','21');
   Ini.WriteString('Updater','User','dk');
   Ini.WriteString('Updater','Password','dk');
   Ini.WriteString('Updater','Dir','update_v2');
   Ini.Free;
  end;
  except
    ShowMessage('�� ���� �������� ���� �������� config.ini');
    writeln(log,Getdatet+' �� ���� �������� ���� �������� config.ini');
    end;

 //���������� ���������
 try
  Ini:=TiniFile.Create(EXEPath+'config.ini'); //������� ���� ��������
  host:=ini.ReadString('FTP','Host','ugrus.com');
  port:=ini.ReadInteger('FTP','Port',21);
  user:=ini.ReadString('FTP','User','dk');
  password:=ini.ReadString('FTP','Password','dk');
  PutToPosTime:=Ini.ReadInteger('Base','PutToPosTime',2);
  GetPosRepTime:=Ini.ReadInteger('Base','GetPosRepTime',10);
  PostLoadFlag:=Ini.ReadInteger('Base','PostLoadFlag',1);
  GetFromFTPTime:=Ini.ReadInteger('Base','GetFromFTPTime',10);
  GTPPauseTime:=Ini.ReadInteger('Base','GTPPauseTime',5);
  AutoLoadTRZ:=Ini.ReadInteger('Base','AutoLoadTRZ',1);
  For k:=1 to 5 do // ������� ��������� ��� ���������
    begin
     Magaz[k].Nom:=k;
     Magaz[k].Name:=Ini.ReadString('Base','Mag'+inttostr(k)+'_Name','������� ��');
     Magaz[k].Path:=ini.ReadString('Base','Mag'+inttostr(k)+'_Path','C:\Mag'+inttostr(k));
     Magaz[k].FTPDir:=ini.ReadString('FTP','Dir'+inttostr(k),'');
     for i:=1 to npos do
        Magaz[k].pos[i]:=ini.ReadString('Dir'+inttostr(k)+'_POS','POS0'+inttostr(i),'');
    end;
  //  npos:=ini.ReadInteger('POS','NPOS',0);
  Ini.Free;
  except
    ShowMessage('�� ���� ��������� ��������� �� config.ini');
    writeln(log,Getdatet+' �� ���� ��������� ��������� �� config.ini');
  try
   assignfile(f2,'t1.bat');
   rewrite(f2);
   Writeln(f2,'taskkill.exe /F /IM dk_interface.exe');
   Closefile(f2);
   WinExec('t1.bat',0);
   Sleep(1000);
   Deletefile('t1.bat');
  except
  end;
    Application.Terminate;
    end;

    // ���� �� ������� ����� ��� ����� �������, �������� ��.
 For i:=1 to 5 do
   if (not DirectoryExists(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������_'+Magaz[i].Name))
   and (Magaz[i].FTPDir<>'') then
      CreateDir(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\�������_'+Magaz[i].Name);   
  // if npos=0 then begin
  // showmessage('������� ���������� Mini-POS!');
  // Application.Terminate;
  // end;

 if (Magaz[1].FTPDir='') and (Magaz[2].FTPDir='') and (Magaz[3].FTPDir='') and (Magaz[4].FTPDir='') and (Magaz[5].FTPDir='') then
 begin
  ShowMessage('������� ���� �� ���� ��������� Dir!');
  try
   assignfile(f2,'t1.bat');
   rewrite(f2);
   Writeln(f2,'taskkill.exe /F /IM dk_interface.exe');
   Closefile(f2);
   WinExec('t1.bat',0);
   Sleep(1000);
   Deletefile('t1.bat');
  except
  end;
  Application.Terminate;
 end;

    // ���� ��� ����� ��� ����, �������� ��

   for k:=1 to 5 do
    begin
     if not DirectoryExists(Magaz[k].Path) then
        CreateDir(Magaz[k].Path);
     for i:=1 to npos do
        if  not DirectoryExists(Magaz[k].Path+'\pos0'+inttostr(i)) then
        CreateDir(Magaz[k].Path+'\pos0'+inttostr(i));
     // �������� ����� ��� ����� �����������
     if not DirectoryExists('base\download'+inttostr(k)) then
        CreateDir('base\download'+inttostr(k));
     // �������� ����� ��� ����� �������
     if not DirectoryExists('base\upload'+inttostr(k)) then
        CreateDir('base\upload'+inttostr(k));
    end;

  // ������� ������������ ����� �������� � ����� �����, ���� ����� ���������.
 if PostLoadFlag = 1 then
    Timer1.Enabled:=true
 else if PostLoadFlag = 0 then
    Timer1.Enabled:=false;

 // ������� ����� DBF ���� �� ���

 For k:=1 to 5 do // ���� �� �������� �� �������� ��� ���� 5-�� ���������
 Begin
  dbf.TableName:='base\download'+inttostr(k)+'.dbf';
  dbf.Exclusive:=false;
  //������� ������� �� ��������
  try
  if not FileExists('base\download'+inttostr(k)+'.dbf') then begin
   writeln(log,Getdatet+' ����� download'+inttostr(k)+'.dbf ���. ������ �������.');
   dbf.AddFieldDefs('nfile',bfString,20,0);
   dbf.AddFieldDefs('dfile',bfString,20,0);

   //������� ���-�� ����� � dbf ������ 9
   for i:=1 to 9 do
     dbf.AddFieldDefs('topos0'+inttostr(i),bfString,1,0);
   dbf.CreateTable;
   DBF.close;
   writeln(log,Getdatet+' ���� download'+inttostr(k)+'.dbf ������.');
   end;
   except
     writeln(log,Getdatet+' �� ���� ������� ���� download'+inttostr(k)+'.dbf.');
    end;
 End;


 For k:=1 to 5 do // ���� �� �������� �� �������� ��� ���� 5-�� ���������
 Begin
   try
   dbf1.TableName:='base\upload'+inttostr(k)+'.dbf';
   dbf1.Open;
   if dbf1.FieldCount=3 then
    begin
      dbf1.Close;
      DeleteFile('base\upload'+inttostr(k)+'.dbf');
      end
   else
     dbf1.Close;
   except
     end;

  try
   dbf1.TableName:='base\upload'+inttostr(k)+'.dbf';
   if not FileExists('base\upload'+inttostr(k)+'.dbf') then begin
    writeln(log,Getdatet+' ����� upload'+inttostr(k)+'.dbf ���. ������ �������.');
    dbf1.AddFieldDefs('nfile',bfString,20,0);
    dbf1.AddFieldDefs('dfile',bfString,20,0);
    dbf1.AddFieldDefs('toftp',bfNumber,1,0);
    dbf1.AddFieldDefs('DateToFtp',bfString,20,0);
    dbf1.CreateTable;
    DBF1.close;
    writeln(log,Getdatet+' ���� upload'+inttostr(k)+'.dbf ������.');
   end;
   except
     writeln(log,Getdatet+' �� ���� ������� ���� upload'+inttostr(k)+'.dbf');
     end;
 End;


  //������� ������� �� ����������
// try
//  dbf2.TableName:='base\transact.dbf';
//  if not FileExists('base\transact.dbf') then begin
//   writeln(log,Getdatet+' ����� transact.dbf ���. ������ �������.');
//   dbf2.AddFieldDefs('nfile',bfString,20,0);
//   dbf2.AddFieldDefs('dfile',bfString,20,0);
//   dbf2.CreateTable;
//   DBF2.close;
//   writeln(log,Getdatet+' ���� transact.dbf ������.');
//  end;
//  except
//    writeln(log,Getdatet+' �� ���� ������� ���� transact.dbf.');
//    end;


    // ������� ������� DBF ��� �������
 For k:=1 to 5 do
 Begin
   if FileExists('base\database'+inttostr(k)+'.dbf') then
    try
     dbf.TableName:='base\database'+inttostr(k)+'.dbf';
     dbf.Exclusive:=true;
     DBF.Open;
     if DBF.FieldCount<16 then
      begin
        dbf.Close;
        DeleteFile('base\database'+inttostr(k)+'.dbf');
      end
     else DBF.Close;

    except
      end;

  try
   if not FileExists('base\database'+inttostr(k)+'.dbf') then
   begin
    dbf.TableName:='base\database'+inttostr(k)+'.dbf';
    dbf.Exclusive:=false;
    dbf.AddFieldDefs('kod',bfString,8,0);
    dbf.AddFieldDefs('nam',bfString,120,0);
    dbf.AddFieldDefs('rub',bfString,15,0);
    dbf.AddFieldDefs('date',bfString,20,0);
    dbf.AddFieldDefs('ostatok',bfString,15,0);
    dbf.AddFieldDefs('bar1',bfString,13,0);
    dbf.AddFieldDefs('bar2',bfString,13,0);
    dbf.AddFieldDefs('bar3',bfString,13,0);
    dbf.AddFieldDefs('bar4',bfString,13,0);
    dbf.AddFieldDefs('bar5',bfString,13,0);
    dbf.AddFieldDefs('kt',bfString,1,0);
    dbf.AddFieldDefs('art',bfString,100,0);
    dbf.AddFieldDefs('proizvod',bfString,100,0);
    dbf.AddFieldDefs('ed',bfString,100,0);
    dbf.AddFieldDefs('prikaz',bfString,100,0);
    dbf.AddFieldDefs('EtoGruppa',bfString,1,0);
    dbf.CreateTable;
    DBF.close;
   end;
  except
    end;
 End;

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

   // ������� ������� �� ������ ��� ��� ��������
 For k:=1 to 5 do
 Begin
  try
    if FileExists('base\zayavka_BD'+inttostr(k)+'.dbf') then
      begin
       dbf.TableName:='base\zayavka_BD'+inttostr(k)+'.dbf';
       dbf.Exclusive:=false;
       dbf.Open;
       if dbf.FieldCount < 15 then
        begin
          dbf.Close;
          DeleteFile('base\zayavka_BD'+inttostr(k)+'.dbf');
        end
       else
        dbf.Close;
      end;
    except
      end;
  try
   if not FileExists('base\zayavka_BD'+inttostr(k)+'.dbf') then
   begin
    dbf.TableName:='base\zayavka_BD'+inttostr(k)+'.dbf';
    dbf.Exclusive:=false;
    dbf.AddFieldDefs('KodSklada',bfString,7,0);
    dbf.AddFieldDefs('KodPostav',bfString,10,0);
    dbf.AddFieldDefs('NamePostav',bfString,60,0);
    dbf.AddFieldDefs('KodGruzootpr',bfString,7,0);
    dbf.AddFieldDefs('NameGruzootpr',bfString,100,0);
    dbf.AddFieldDefs('TimeZayavk',bfString,13,0);
    dbf.AddFieldDefs('DniNedeli',bfString,7,0);
    dbf.AddFieldDefs('kod',bfString,100,0);
    dbf.AddFieldDefs('Tovar',bfString,100,0);
    dbf.AddFieldDefs('Ed',bfString,13,0);
    dbf.AddFieldDefs('SrokGod',bfString,10,0);
    dbf.AddFieldDefs('MinZakaz',bfString,10,0);
    dbf.AddFieldDefs('Status',bfString,15,0);
    dbf.AddFieldDefs('CENA',bfString,15,0);
    dbf.AddFieldDefs('Gruppa',bfString,1,0);
    dbf.CreateTable;
    DBF.close;
   end;
  except
    end;
 End;

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

  Form1.Caption:='DK Report Engine v.'+FileVersion(Paramstr(0));
  tmr1.Enabled:=true;
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
   writeln(log,Getdatet+' DK Report Engine ������ �� '+GetComputerNName);
   closefile(log);
 except
 end;
end;

//........................................................................................................................
//������ �����/����
procedure TForm1.startbClick(Sender: TObject);
begin
  //������� ���� ����������� � �����
 if start then
  begin
   start:=false;
   startb.Caption:='��������';
   lbl2.Font.Color:=clRed;
   lbl2.Caption:='���������';
   uploadtimer.Enabled:=False;
   writeln(log,Getdatet+' DK Report Engine �������� �� '+GetComputerNName);
   gettimer.Enabled:=False;
   // ������� ������ **************************************
        try
         GetDemoProc.Terminate;
          except
            end;

        try
         GetFromPOSproc.Terminate;
         except
         end;

        try
         LockProc.Terminate;
          except
            end;

        try
         PotToPosProc.Terminate;
          except
            end;

        try
        GetTransactDBProc.Terminate;
          except
            end;
        // *****************************************************
   end
   else
    begin
     start:=true;
     startb.Caption:='���������';
     lbl2.Font.Color:=clGreen;
     lbl2.Caption:='��������';
     writeln(log,Getdatet+' DK Report Engine ������� �� '+GetComputerNName);
     uploadtimer.Enabled:=True;
     gettimer.Enabled:=True;
     tmr1.Enabled:=true;
    end;
end;

//........................................................................................................................
// ������ ������
procedure TForm1.uploadtimerTimer(Sender: TObject);
var i,m:Integer;
f:TextFile;
datet:string;
begin

 uploadtimer.Enabled:=false;

  if start then
  for m:=1 to 5 do
  if Magaz[m].FTPDir<>'' then
  begin
    Application.ProcessMessages;
    uploadtimer.Interval:=GetFromFTPTime*1000;
   if not FileExists(GetSystemDir+'\conflict.nls') then
   begin
     for i:=1 to 5 do
       begin
       if not ftp.Connected then connecttoftp(Magaz[m].FTPDir)
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
       NomenklFlagToFTP(m);  // ������ ���� ������� ������������ � ���������
       Application.ProcessMessages;
       getfromftp2(m); // �������� ������ � ���� � FTP
       Application.ProcessMessages;
       getinv(m);      // �������� ������ �� �������������� (�������)
       Application.ProcessMessages;
       getinv2(m);    // �������� ����� � �����������
       Application.ProcessMessages;
       getinv3(m);    // �������� ����� � ������� �����������
       Application.ProcessMessages;
       get_ost(m); // ��������� ������������ � ���������
       Application.ProcessMessages;
       puttoftp(m);   // ���������� ����������
       Application.ProcessMessages;
       reportdownload(m); //���������� ����� � ����������� � POS ������
       Application.ProcessMessages;
       GetZayavNomenkl(m); //��������� �� ������
       Application.ProcessMessages;
       ZayavkiToFTP(m); // ���������� ������
//       Application.ProcessMessages;
//       getmail;       // �������� �����
//       Application.ProcessMessages;
//       mailtoftp;     // ���������� �����
//       Application.ProcessMessages;
//       ReportReadMail; // ���������� ������������� � ����������� �������.
//       Application.ProcessMessages;
       reloadz(m);      // �������������� ����� �� �������
       Application.ProcessMessages;
       ReloadTRZ(m);    // ���������� ���������� �� �����
       Application.ProcessMessages;
//       uploadlog;    // ���������� ��� � �� �� �������
//       Application.ProcessMessages;
//       uploadtrz;   // ���������� ���� �� ���������� �� �������.
//       Application.ProcessMessages;
       getrunscript; // ������ � ��������� ��������� ������ (���� ����)
       Application.ProcessMessages;
       GETDisconnectKey; // ������ ������ ��� ���������� (���� ����)
       Application.ProcessMessages;
       disconnectftp; // �����������
      end;
//       else localupload;
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
        try
          writeln(log,Getdatet+' DK Report Engine ������ �� '+GetComputerNName);
          closefile(log);
        except
        end;

        // ������� ������ **************************************
        try
         GetDemoProc.Terminate;
          except
            end;

        try
         GetFromPOSproc.Terminate;
         except
         end;

        try
         LockProc.Terminate;
          except
            end;

        try
         PotToPosProc.Terminate;
          except
            end;

        try
        GetTransactDBProc.Terminate;
          except
            end;
        // *****************************************************

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
uploadtimer.Enabled:=True;
timer1.Enabled:=true; // ������, ������������� load.flz

// ��������� ����� ������� DEMO.SPR
   // GetDemoProc := TGetDemoProc.create(true);
   // GetDemoProc.freeonterminate := true;
   // GetDemoProc.priority := tpNormal;
   // GetDemoProc.Resume;

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
//    GetTransactDBProc:= TGetTransactDBProc.create(true);
//    GetTransactDBProc.freeonterminate := true;
//    GetTransactDBProc.priority := tpLower;
//    GetTransactDBProc.Resume;

//gettimer.Enabled:=True;
end;

procedure TForm1.terminatetTimer(Sender: TObject);
begin
  if FileExists('terminate.txt') then
  begin
   start:=False;
        // ������� ������ **************************************
        try
         GetDemoProc.Terminate;
          except
            end;

        try
         GetFromPOSproc.Terminate;
         except
         end;

        try
         LockProc.Terminate;
          except
            end;

        try
         PotToPosProc.Terminate;
          except
            end;

        try
        GetTransactDBProc.Terminate;
          except
            end;
        // *****************************************************

   Sleep(5000);
   DeleteFile('terminate.txt');
   Application.Terminate; // ���������
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var i,k:Integer;
loadflag:TextFile;
begin
Timer1.Enabled:=false;
 For k:=1 to 5 do  // ���� �� ���������
  If Magaz[k].FTPDir<>'' then
   Begin
    for i:=1 to npos do // ���� �� ������
      if Magaz[k].pos[i]<>'' then  // ���� � ���������� �������� IP ��� ���� �����, ������ ��� ���� ))
       if not FileExists(Magaz[k].Path+'\pos0'+inttostr(i)+'\load.flz') then
        try
          AssignFile(loadflag,Magaz[k].Path+'\pos0'+inttostr(i)+'\load.flz');
          Rewrite(loadflag);
          CloseFile(loadflag);
          except
            end;
   END;

Timer1.Enabled:=True;
end;

end.
