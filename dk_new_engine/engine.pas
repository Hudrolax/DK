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

 // Описываем класс для потока GETDEMO
TGetDemoProc = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;


 // Описываем класс для потока GetFromPOS
TGetFromPosProc = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;

 // Описываем класс для потока локера
TLockProc = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;

 // Описываем класс для PutToPos
TPotToPosProc = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;

 // Описываем класс для PutToPos
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
  GetPosRepTime:Integer; // Задержка запроса  pos.rep
  PutToPosTime:Integer; // Задержка кормления Поса файлами
implementation
//******************************************************************************
//*********** Базовые функции **************************************************
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

// Определение системной папки
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
// Процедура подбирания и упаковки файла базы данных транзакций
procedure gettransactdb;
var i,ntemp:Integer;
name,gname:string;
v1,v2,h:LongInt;
begin
//Ищем pos.rep в папках терминалов
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
     // Если нашли файл, делаем пометку в логе
     AddLog('Файл transact.sdf был найден в папке c:\pos0'+inttostr(i)+'\');
     AddLog('Жду 5 секунд, вдруг файл не записался до конца.');
     Sleep(5000);
     h:=FileOpen('c:\pos\pos0'+inttostr(i)+'\transact.sdf',fmShareExclusive);
     FileClose(h);
     if h<=0 then
           begin
             AddLog('Файл '+'c:\pos\pos0'+inttostr(i)+'\transact.sdf'+' заблокирован. Не могу получить доступ.');
             Continue;
             end;
     // Назначаем уникальное имя
     if Form1.DBF2.RecordCount=0 then
     name:='trz'+inttostr(i)+'000001.zip' else
      begin
       form1.DBF2.Last;
       ntemp:=StrToInt(Copy(form1.DBF2.GetFieldData(1),5,6))+1;
       name:='000000'+inttostr(ntemp);
       name:='trz'+inttostr(i)+copy(name,Length(name)-5,6)+'.zip';
      end;

     //  пробуем запаковать
      gname:=extractfilepath(paramstr(0))+'base\trz\'+name;
      try
       with Form1.ZPGTDB do
       begin
       FileName:=gname;
       OpenArchive(fmCreate);
       BaseDir:='c:\pos\pos0'+inttostr(i)+'\';
       AddFiles('transact.sdf');
       CloseArchive;
       AddLog('Файл '+gname+' был создан.');
      end;
      except
        end;
       // Проверяем файл в архиве на битость
      try
       // Распаковываем в темп
       AddLog('Пробую проверить файл '+gname+' на битость.');
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
        AddLog('Распаковал файл '+gname+' в \temp.');
        AddLog('Сравниваю распакованный файл с исходным.');
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

           AddLog('Файлы одинаковые, значит архив целый. Удалил оба.');
           end;
          end
         else
           begin
            AddLog('Файлы разные, значит архив битый. Удаляю файл из темпа.');
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
//Процедура кормления POS'а файлами из base\download
procedure puttopos;
var
i,j:Integer;
s:string;
begin
  //Открываем DBF
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
   //Просматриваем что выкладывали, а что нет и выкладываем по одному
  for j:=3 to npos+2 do
  begin
    Form1.DBFPTP.First; //чтоб наверняка

  s:=IntToStr(j-2);
  for i:=1 to Form1.DBFPTP.RecordCount do
    if Form1.DBFPTP.GetFieldData(j)='1' then
      if not FileExists('c:\pos\pos0'+s+'\demo.spr') then
      begin
      form1.DBFPTP.SetFieldData(j,'2');
      Break;
      end else Break else if Form1.DBFPTP.GetFieldData(j)='0' then
     try
           //Пробуем распаковать архив
       with form1.ZPPTP do
       begin
        FileName:='base\download\'+Form1.DBFPTP.GetFieldData(1);
        OpenArchive(fmOpenRead);
        BaseDir:='C:\pos\pos0'+s+'\';
        ExtractFiles('*.*');
        DeleteFile('C:\pos\pos0'+s+'\'+copy(Form1.DBFPTP.GetFieldData(1),1,8)+'.txt');
        CloseArchive;
       end;

       // Если хоть одна касса зОхавала файло, то выкладываем demo.spr для товароучетки.
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




      // Создаем флаг загрузки для POS
        begin
         AssignFile(loadflz,'c:\pos\pos0'+s+'\load.flz');
         rewrite(loadflz);
         closefile(loadflz);
         form1.DBFPTP.SetFieldData(j,'1');
         AddLog('Файл '+Form1.DBFPTP.GetFieldData(1)+' распакован в C:\pos\pos0'+s);
         Break;
        end;
     except
     AddLog('Файл '+Form1.DBFPTP.GetFieldData(1)+' не распакован в C:\pos\pos0'+s);
       end else Form1.DBFPTP.Next;
  end;
 except
  end;
  // Закрываем БД
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

   //подключаемся к FTP
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
   Form1.ftp_lock.List(ls2); //Забираем список файлов с FTP
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
     //подключаемся к FTP
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
   Form1.ftp_lock.List(ls2); //Забираем список файлов с FTP
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

   //подключаемся к FTP
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
   Form1.ftp_lock.List(ls2); //Забираем список файлов с FTP
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
     //подключаемся к FTP
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
   Form1.ftp_lock.List(ls2); //Забираем список файлов с FTP
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
// Процедура запаковки файла pos.rep с параметром. Параметр - номер POS'а.
procedure getfrompos(posn:integer);
var i,ntemp:Integer;
name,gname:string;
v1,v2,h:LongInt;
begin
//Ищем pos.rep в папках терминалов
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
  //  Writeln(log,getfatet+' Не могу открыть upload.dbf');

  for i:=posn to posn do
   if FileExists('c:\pos\pos0'+inttostr(i)+'\pos.rep') then
    begin
       h:=332; //сбрасываем дискриптор
      //Если нашли файл, делаем пометку в логе
     AddLog('Файл pos.rep был найден в папке c:\pos0'+inttostr(i)+'\');
     AddLog('Жду 5 секунд, вдруг файл не записался до конца.');
     Sleep(5000);
     h:=FileOpen('c:\pos\pos0'+inttostr(i)+'\pos.rep',fmShareExclusive);   //считываем дискриптор
       FileClose(h);  // закрываем файл
     if h<=0 then    // если больше нуля - знач все ОК
          begin
           AddLog('Файл '+'c:\pos\pos0'+inttostr(i)+'\pos.rep'+' занят какой-то херней, пропускаем.');
           Continue;
          end;
     AddLog('Мне повезло! Файл абсолютно свободен! Ура! Трижды! Пробую запаковать!.');



     //**********************************************************************
     //**********************************************************************
     // Назначаем уникальное имя
     if Form1.GetFromPosDBF.RecordCount=0 then
     name:='z'+inttostr(i)+'000001.zip' else begin
     form1.GetFromPosDBF.Last;
     ntemp:=StrToInt(Copy(form1.GetFromPosDBF.GetFieldData(1),3,6))+1;
     name:='000000'+inttostr(ntemp);
     name:='z'+inttostr(i)+copy(name,Length(name)-5,6)+'.zip';
      end;

     //  пробуем запаковать
      gname:=extractfilepath(paramstr(0))+'base\upload\'+name;
      try
       with Form1.ZPGFP do
       begin
       FileName:=gname;
       OpenArchive(fmCreate);
       BaseDir:='c:\pos\pos0'+inttostr(i)+'\';
       AddFiles('pos.rep');
       CloseArchive;
       AddLog('Уря! Файл '+gname+' был создан.');
      end;
      except
        end;
       // Проверяем файл в архиве на битость
      try
       // Распаковываем в темп
       AddLog('Пробую проверить файл '+gname+' на хреновастость.');
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
        AddLog('Распаковал файл '+gname+' в \temp.');
        AddLog('Сравниваю распакованный файл с исходным.');
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

           AddLog('Файлы одинаковые, значит все пучком. Удалил оба.');
           end;
          end
         else
           begin
            AddLog('Файлы разные, значит архив битый. Удаляю файл только из ..\temp.');
            DeleteFile(extractfilepath(paramstr(0))+'temp\pos.rep');
           end;


       end;

        end;
   except
     end;
 // Пробуем закрыть БД
   try
    form1.GetFromPosDBF.Close;
    except
     end;
end;

// Функция проверки pos.rep на наличие транзакции закрытия смены.
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
    // Пробуем открыть БД
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
          begin  // Тут считываем содержимое блоков транзакции
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

         if SS='61' then  // Если тип транзакции 61, то пишем запись в журнал реализаций и возвращаем добро
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

// Процедура запроса транзакций от POS (пос тупо складывает из в pos.rep накопительно)
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
      // Запакуем уже имеющийся файл, если в нем есть закрытая смена
      if FileExists('c:\pos\pos0'+inttostr(i)+'\pos.rep') then
        if ZakritaSmena(i) then
          getfrompos(i);

            // Выложим новый флаг.
      AssignFile(f,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
      Rewrite(f);
      CloseFile(f);
      end;
   except
     ShowMessage('Не могу создать unload.flr !');
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
{Процедура создает справочник товаров из demo.spr}
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
 // Проверяем на ключ очистки
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
  ShowMessage('Ошибка доступа к demo.spr');
  Exit;
   end;
 //****************************


   // Если стоит ключ очистки: чистим БД.
 //****************************
  if clear then
  try
   // Ждем, если файл занят какой-то херней
   while h<=0 do
   begin
   h:=FileOpen('base\database.dbf',fmShareExclusive);   //считываем дискриптор
   FileClose(h);  // закрываем файл
   Sleep(500);
   end;

   if DeleteFile('base\database.dbf') then
   begin
    // Пробуем создать DBF для товаров
    try
      if not FileExists('base\database.dbf') then begin
      Form1.dbf3.TableName:='base\database.dbf';
      Form1.dbf3.Exclusive:=false;
//   writeln(log,Getdatet+' Файла download.dbf нет. Пробую создать.');
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
//  writeln(log,Getdatet+' Файл download.dbf создан.');
     end;
    except
//    writeln(log,Getdatet+' Не могу создать файл download.dbf.');
    end;

   end;
   except
   ShowMessage('Не могу очистить БД товаров! Обратитесь к Системному Администратору!');
   end;


 AssignFile(demo,'demo.spr');
 Reset(demo);
  try
      //Открываем БД
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
 // Заполняем БД данными из файла (Новые позиции)
 while not Eof(demo) do
 begin
 // Читаем строку в переменную
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
    // Пишем в БД
   if not form1.DBF3.IsEmpty then
     form1.DBF3.First;
   indb:=false;
   if not form1.DBF3.IsEmpty then
     for i:=1 to Form1.DBF3.RecordCount do
     begin
       {Ищем дубли в БД перед вставкой}
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
      if indb then Break; // Если нашли дубль, то дальше можно не искать.
      form1.DBF3.Next;
     end;

   // Если нету в БД, добавляем новой строкой
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
    // Пишем в БД
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
 // Закрываем файл и БД
 try
 CloseFile(demo);
 // Закрываем БД
    Form1.DBF3.Close;
 except
   end;
   DeleteFile('demo.spr');
end;

// Процедура потока
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
     ShowMessage('Не удалось зарегистрировать компонент.');
     Application.Terminate;
     end;
end;

//.....................................................................................................
// Процедура отключения от интернета
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
// Забираем с ФТП ключ для отключения
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
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
 except
   ls2.Free;
   exit;
  end;
//Фильтруем, оставляя флаг отключения
  try
   if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('disconnect.txt',ls2[i])<>0 then godisconnect:=True;
  except
    end;
 //Удаляем флаг и отключаемся

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
// Информацию по чекам кладем на FTP
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
      AddLog('ZToFTP: Не могу открыть БД kassbook.dbf.');
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
     if AnsiPos('ККМ1',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'1' else
      if AnsiPos('ККМ2',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'2' else
       if AnsiPos('ККМ3',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'3'else
        if AnsiPos('ККМ4',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'4' else
         if AnsiPos('ККМ5',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'5' else
          if AnsiPos('ККМ6',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'6' else
           if AnsiPos('ККМ7',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'7' else
            if AnsiPos('ККМ8',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'8' else
             if AnsiPos('ККМ9',form1.DBF1.GetFieldData(1))>0 then fname:=fname+'9';
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
      AddLog('ZToFTP: Не могу отправить файл '+fname+'.zz');
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


//Процедура отправки файла версии на фтп.
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
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
 except
   ls2.Free;
   exit;
  end;
//Фильтруем, оставляя флаги загрузки.
  try
   if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('getversion.txt',ls2[i])<>0 then getversion:=True;
  except
    end;
    //Отправляем заново все что нужно
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

  // Вписываем поступления
   try
    Form1.dbf.TableName:=ExePatch+'base\download.dbf';
    form1.dbf.Exclusive:=false;
    Form1.DBF.Open;
    Form1.DBF.Last;
    s:=Copy(Form1.DBF.GetFieldData(1),5,4);
    s:=IntToStr(StrToInt(s));
    Writeln(f,'Поступлений: '+s);
    Form1.DBF.Close;
     except
       end;

  // Вписываем отчеты
   try
    Form1.dbf.TableName:=ExePatch+'base\upload.dbf';
    form1.dbf.Exclusive:=false;
    Form1.DBF.Open;
    Writeln(f,'Отчетов: '+inttostr(form1.DBF.RecordCount));
    Form1.DBF.Close;
     except
       end;
  Writeln(f,'Имя компьютера: '+GetComputerNName);
  Writeln(f,'Дата: '+GetDateT);
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

//Процедура отправки флага для Инвентаризации
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


//Процедура отправки файла отчета о прочитанном сообщении
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
           //Пробуем создать файл отчета о доставке
           try
           AssignFile(rfile,ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
           Rewrite(rfile);
           CloseFile(rfile);
             except
               AddLog('Не могу создать файл отчета о доставке в \temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
               end;
           //Пробуем отправить файл
           try
           form1.ftp.Put(ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,10)+'.md',copy(form1.DBF.GetFieldData(1),1,10)+'.md',false);
           AddLog('Отправил файл отчета '+copy(form1.DBF.GetFieldData(1),1,10)+'.md');
           // Если отправили, то ставим пометку в БД и удаляем из темпа
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
//Процедура получения файлов по флагам с FTP в mail/download
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
 //Пробуем подключиться к FTP
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try
 // AddLog('Пробую получить список почтовых флагов из папки '+dir);
  Form1.ftp.List(ls); //Забираем список файлов с FTP
  if ls.Count<>0 then
 //   AddLog('Получил флаги:');
  except
 // AddLog('Не могу получить список файлов из папки '+dir);
  ls.Free;
  flist.Free;
  try
    form1.DBF4.Close;
    except
      end;
      exit;
  end;
  try
 //Фильтруем, оставляя флаги загрузки.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.mdf',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.mdf',ls[i])-10,14));
   AddLog(Copy(ls[i],AnsiPos('.mdf',ls[i])-10,14));
    end;
   except
    end;

  if flist.Count>0 then
   try // Создаем флаг для интерфейса
    AssignFile(flag,ExePatch+'temp\getmail.txt');
    Rewrite(flag);
    CloseFile(flag);
    except
    end;

 if flist.Count>0 then
 try
 //Пробуем cкачать файлы с FTP
  for i:=0 to flist.Count-1 do
  begin
   // проверяем есть ли такой файл, если есть
   try
    for j:=1 to form1.DBF4.RecordCount do
     begin
     if Copy(Form1.DBF4.GetFieldData(1),1,10)=Copy(flist[i],1,10) then
      begin
       Breakc:=true;
       AddLog('Файл '+Form1.DBF4.GetFieldData(1)+' уже был ранее закачан.');
       end;
       Form1.DBF4.Next;
      end;
    except
     end;

   if breakc then
   begin
    try
     Form1.ftp.Delete(Copy(flist[i],1,10)+'.zip');
     AddLog(Copy(flist[i],1,10)+'.zip удален с FTP '+host);
     except
    end;
    try
     Form1.ftp.Delete(flist[i]);
     AddLog(flist[i]+' удален с FTP '+host);
     except
    end;
     end;

  if breakc then Continue;
  try
   AddLog('Пробую закачать '+Copy(flist[i],1,10)+'.zip в mail\download');
   Form1.ftp.get(Copy(flist[i],1,10)+'.zip',ExePatch+'mail\download\'+Copy(flist[i],1,10)+'.zip',true,false);
   AddLog(Copy(flist[i],1,10)+'.zip закачан в mail\download\.');
    try
     Form1.ftp.Delete(Copy(flist[i],1,10)+'.zip');
     AddLog(Copy(flist[i],1,10)+'.zip удален с FTP '+host);
     except
     AddLog('Не могу удалить '+Copy(flist[i],1,10)+'.zip с FTP '+host);
    end;
    try
     Form1.ftp.Delete(flist[i]);
     AddLog(flist[i]+' удален с FTP '+host);
     except
    AddLog('Не могу удалить '+flist[i]+'.zip с FTP '+host);
    end;
   except
   AddLog('Не могу скачать '+Copy(flist[i],1,10)+'.zip в mail\download\, остальные в сад... качать не буду... :(');
   // Если не смогли скачать файл, то следующие не пробуем...
   try
     form1.DBF4.Close; // Закрываем БД
     except
       end;
    try
      // Уничтожаем созданные объекты
     flist.free;
     ls.free;
      except
        end;
      // Удаляем файл-флаг.
    DeleteFile(ExePatch+'temp\getmail.txt');
    Exit;
   end;

    // Пробуем распаковать и взять тему
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


 //пробуем записать и закрыть dbf
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


//Процедура отправки файла БД транзакций по флагу.
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
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
  except
    flist2.Free;
    ls2.Free;
    Exit;
  end;
  //Фильтруем, оставляя флаги загрузки.
 try
  if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('.fdt',ls2[i])<>0 then
       flist2.add(Copy(ls2[i],AnsiPos('.fdt',ls2[i])-10,14));
  except
    end;

  //Отправляем заново все что нужно
  try
  for i:=0 to flist2.Count-1 do begin
   try
    Form1.ftp.Put('base\trz\'+copy(flist2[i],1,10)+'.zip',copy(flist2[i],1,10)+'.zip',false);
    form1.ftp.Delete(copy(flist2[i],1,10)+'.fdt');
    AddLog('Файл '+copy(flist2[i],1,10)+'.zip отправлен на FTP по запросу.');
    except
      end;
  end;
  except
    end;
    ls2.free;
    flist2.free;
end;


//.................................................................................................
// Процедура закачки и запуска стороннего скрипта.
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
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
  except
    ls2.Free;
    exit;
  end;
  //Глядим, есть ли скрипт для запуска
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

  //Если есть - качаем, запускаем, удаляем с фтп, кладем флаг что запустили.

  if runload then
   try
   AddLog('Пробую закачать скрипт runscript.exe');
   try // Удалим старую версию.
     DeleteFile('runscript.exe_');
     except
       end;
   if FileExists('runscript.exe') then
     if not RenameFile('runscript.exe','runscript.exe_') then
        RenameFile('runscript.exe','runscript.exe_'+inttostr(Random(100)));

   Form1.ftp.get('runscript.exe','runscript.exe',True,false);
   AddLog('Скачал, пробую запустить.');
   WinExec ('runscript.exe', SW_MINIMIZE);
   form1.ftp.Delete('runscript.exe');
   AssignFile(loadflag,'temp\runscript.loaded');
   Rewrite(loadflag);
   CloseFile(loadflag);
   form1.ftp.Put('temp\runscript.loaded','runscript.loaded');
   DeleteFile('temp\runscript.loaded');
   AddLog('Запустил и отчитался флагом runscript.loaded');
   except
  end;
  ls2.free;
end;

// Процедура подгрузки справочника из локальной папки
procedure localupload;
var
  searchResult : TSearchRec;
  i,k:integer;
  fname:TStringList;
begin
  fname:=TStringList.Create;
  fname.Clear;
   // Пробуем открыть DBF
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
     //кол-во полей = кол-ву терминалов
     for k:=1 to npos do
      Form1.dbf.SetFieldData(k+2,'0');
    end;
    except
    end;
   end;
   except
     end;
  // Пробуем закрыть DBF
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

//Процедура отправки лога и БД по флагу
procedure uploadlog;
var i:Integer;
ls2:TStringList;
getlog:Boolean;
begin
getlog:=false;
ls2:=TStringList.Create;
ls2.Clear;
 try
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
 except
   ls2.Free;
   exit;
  end;
//Фильтруем, оставляя флаги загрузки.
  try
   if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('getlogdb.gdb',ls2[i])<>0 then getlog:=True;
  except
    end;
    //Отправляем заново все что нужно
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
        addlog('Не могу отправить logdb.zip');
        end;
      try
       Form1.ftp.Delete('getlogdb.gdb');
      except
        end;
      DeleteFile(ExePatch+'temp\logdb.zip');
    except
      addlog('Ошибка в модуле отправки лога и БД!');
      end;

 ls2.free;
    
end;

//Отправка скрина по запросу
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
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
 except
   ls2.Free;
   exit;
  end;
//Фильтруем, оставляя флаги загрузки.
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
//      ShowMessage('Ошибка 1772');
    end;

 ls2.free;
    
end;

//Закачка и запуск пакетного файла
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
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
 except
   ls2.Free;
   exit;
  end;
//Фильтруем, оставляя флаги загрузки.
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
     writeln(cmdlog,GetdateT+' Файл c:\batfile.bat успешно загружен и запущен.');
     writeln(cmdlog,'Текст файла:');
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
//      ShowMessage('Ошибка 1772');
    end;

 ls2.free;
    
end;

//Закачка и исполнение команды
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
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
 except
   ls2.Free;
   exit;
  end;
//Фильтруем, оставляя флаги загрузки.
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
     {Исполнение...}
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
     writeln(cmdlog,GetdateT+' Файл temp\cmdfile.f успешно загружен и запущен.');
     writeln(cmdlog,'Текст файла:');
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
//      ShowMessage('Ошибка 1772');
    end;

 ls2.free;
    
end;

//Перезапрос транзакций по запросу
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
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
 except
   ls2.Free;
   exit;
  end;
//Фильтруем, оставляя флаги загрузки.
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


//Процедура переотправки файлов по флагу
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
  Form1.ftp.List(ls2); //Забираем список файлов с FTP
  except
    flist2.Free;
    ls2.Free;
    Exit;
  end;
  //Фильтруем, оставляя флаги загрузки.
 try
  if ls2.Count<>0 then
    for i:=0 to ls2.Count-1 do
     if AnsiPos('.fdc',ls2[i])<>0 then
       flist2.add(Copy(ls2[i],AnsiPos('.fdc',ls2[i])-8,12));
  except
    end;

  //Отправляем заново все что нужно
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
    AddLog('Файл '+copy(flist2[i],1,8)+'.zip переотправлен на FTP по запросу.');
    except
      end;
  end;
  except
    end;
    flist2.free;
    ls2.free;
end;

//......................................................................................................
//Процедура отправки файла отчета о загрузки в POS
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
           //Пробуем создать файл отчета о доставке
           try
           AssignFile(rfile,ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
           Rewrite(rfile);
           CloseFile(rfile);
             except
               AddLog('Не могу создать файл отчета о доставке в \temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
               end;
           //Пробуем отправить файл
           try
           form1.ftp.Put(ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd',copy(form1.DBF.GetFieldData(1),1,8)+'.fd',false);
           AddLog('Отправил файл отчета '+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
           Form1.DBF.SetFieldData(j,'3');
           DeleteFile(ExePatch+'temp\'+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
           Break;
             except
//             Writeln(log,getdatet+' Не могу отправить файл отчета '+copy(form1.DBF.GetFieldData(1),1,8)+'.fd');
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
// Отчет кладем на FTP
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
  // AddLog('PutToFTP: Успешно открыл БД upload.dbf.');
  except
   AddLog('PutToFTP: Не могу открыть БД upload.dbf.');
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
     AddLog('PutToFTP: Ошибка код 1.');
     Continue;
    end;
    if Form1.DBF1.GetFieldData(3)='0' then
      begin
        try
     //   AddLog('PutToFTP: Нашел неотправленный файл '+fname+'. Попытаюсь отправить.');
        k:=0;
        succ2:=false;
        Error:='';
     //   AddLog('PutToFTP: Начинаю непосредственную отправку файла '+fname);
        Form1.ftp.put(ExePatch+'base\upload\'+fname,fname,false);
       // AddLog('PutToFTP: Отправка файла '+fname+' прошла без ошибок. Пробую выложить флаг...');
        while (not succ2) and (k<1000) do
        try
        if NOT FileExists(ExePatch+'temp\'+copy(Form1.DBF1.GetFieldData(1),1,8)+'.flg') then
          begin
            AssignFile(uflag,ExePatch+'temp\'+flagName);
            Rewrite(uflag);
            CloseFile(uflag);
          end;
        //  AddLog('PutToFTP: Создал флаг. Пытаюсь положить на ФТП');
          Form1.ftp.Put(ExePatch+'temp\'+flagName,flagName,false);
         // AddLog('PutToFTP: Положил флаг на FTP');
          DeleteFile(ExePatch+'temp\'+flagName);
         succ2:=true;
         except
          AddLog('Не могу отправить '+flagName);
          k:=k+1;
         end;
        except
        Error:=getdatet+' PutToFTP: Не могу отправить файл '+fname+'.';
        AddLog(Error);
        end
      end
    else
     begin
       Form1.DBF1.Next;
       Continue; // Если отчет отправлен, то в жопу
     end;
    if not succ2 then
    begin
     Form1.DBF1.Next;
     Continue; // Если не отправили флаг, то в жопу
    end;
    succ:=false;
    k:=0;
    if Error = '' then
      while (not succ) and (k<1000) do
        try
       //  AddLog('PutToFTP: Пытаюсь записать в БД данные о загруженных отчетах.');
         Form1.DBF1.SetFieldData(3,'1');
         Form1.DBF1.Post;
        // AddLog('PutToFTP: Записал в БД данные.');
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

// Почту кладем на FTP
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
      AddLog('MailToFTP: Не могу открыть БД mail_up.dbf.');
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
      AddLog('MailToFTP: Не могу отправить файл '+Form1.MailDBF.GetFieldData(1)+'.');
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
//Процедура получения файлов по флагам с FTP в Temp
procedure getfromftp2;
var
i,k,j,m:Integer;
breakc,succ:Boolean;
flag:TextFile;
begin

  // Пробуем открыть БД
  try
     Form1.DBF6.TableName:=ExePatch+'base\download.dbf';
     Form1.DBF6.Exclusive:=false;
     Form1.DBF6.Open;
   except // Если не удалось, то пробуем закрывть и выходим из процедуры
      try
      AddLog('GetFromFTP1: Не могу открыть БД '+ExePatch+'base\download.dbf'+'.');
      Form1.DBF6.Close;
      except
        end;
     Exit;
     end;
 //Создаем списки для хранения листинга ФТП
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try // Получаем листинг с ФТП
  //dLog('Пробую получить список флагов из папки '+dir);
  Form1.ftp.List(ls); //Забираем список файлов с FTP
  if ls.Count<>0 then
   //ddLog('Получил флаги:');
  except
    // Если ФТП послал нас в сад, то чистим объекты, ругаемся и завершаем процедуру.

  ls.Free;
  flist.Free;
  try
    Form1.DBF6.Close;
    except
      end;
  Exit;
  end;

   try
 //Фильтруем, оставляя флаги загрузки.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.flz',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.flz',ls[i])-8,12));
   AddLog(Copy(ls[i],AnsiPos('.flz',ls[i])-8,12));
    end;
   except // Если запарка, то закрываемся.
     try
    AddLog('Не могу отфильтровать список файлов из папки '+dir);
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
     try // Создаем флаг для интерфейса
      AssignFile(flag,ExePatch+'temp\downloading.txt');
      Rewrite(flag);
      CloseFile(flag);
      except
     end
    else
    begin // Если качать нечего, завершаем процедуру.
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
      // проверяем есть ли такой файл, если есть то в сад.
   try
    for j:=1 to form1.DBF6.RecordCount do
     begin
     if Copy(Form1.DBF6.GetFieldData(1),1,8)=Copy(flist[i],1,8) then
      begin
       Breakc:=true;
       AddLog('Файл '+Form1.DBF6.GetFieldData(1)+' уже был ранее закачан. Кто-то лохонулся :) Пропускаем...');
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
   AddLog('Пробую закачать '+Copy(flist[i],1,8)+'.zip в Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip',ExePatch+'temp\'+Copy(flist[i],1,8)+'.zip',true,false);
   AddLog(Copy(flist[i],1,8)+'.zip закачан в Temp.');
   except
   AddLog('Не могу скачать '+Copy(flist[i],1,8)+'.zip в Temp, остальные в сад... качать не буду... :(');
   // Если не смогли скачать файл, то следующие не пробуем...
    try
      Form1.DBF6.Close;
       except
         end;
   Exit;
   end;

    try
  // Пробуем распаковать приказы
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

      if CopyFile(PChar(ExePatch+'temp\'+Copy(flist[i],1,8)+'.txt'),PChar(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы\'+Copy(flist[i],1,8)+'.txt'),False) then
        begin
          DeleteFile(ExePatch+'temp\'+Copy(flist[i],1,8)+'.txt');
          DeleteFile(ExePatch+'temp\demo.spr');
          ShellExecute(0,'Open',pchar(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы\'+Copy(flist[i],1,8)+'.txt'),nil,nil, 1);
          end;
     // Перемещаем скачанный файлы из темпа в архив.
     if not CopyFile(PChar(ExePatch+'temp\'+Copy(flist[i],1,8)+'.zip'),PChar(ExePatch+'base\download\'+Copy(flist[i],1,8)+'.zip'),false) then
      AddLog('Не могу переместить '+Copy(flist[i],1,8)+'.zip из Temp в base\download\') else
     begin
      // Записываем данные в БД
       AddLog('Файл '+Copy(flist[i],1,8)+'.zip перемещен в base\download\');
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
             // Удаляем файл и флаги с ФТП только после занесения в БД данных
      try
       Form1.ftp.Delete(Copy(flist[i],1,8)+'.zip');
       AddLog(Copy(flist[i],1,8)+'.zip удален с FTP '+host);
       except
       AddLog('Не могу удалить '+Copy(flist[i],1,8)+'.zip с FTP '+host);
      end;

      try
       Form1.ftp.Delete(flist[i]);
       AddLog(flist[i]+' удален с FTP '+host);
       except
      AddLog('Не могу удалить '+flist[i]+'.zip с FTP '+host);
      end;

     end;

    except
     end;


  end;

  //Удаляем файлы из темпа
for i:=0 to flist.Count-1 do
  if not DeleteFile(ExePatch+'temp\'+Copy(flist[i],1,8)+'.zip') then
     AddLog('Не могу удалить temp\'+Copy(flist[i],1,8)+'.zip');
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
//Процедура получения данных по инвентаризации с FTP
procedure getinv;
var
i,k,j:Integer;
breakc:Boolean;
flag:TextFile;
begin

 //Создаем списки для хранения листинга ФТП
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try // Получаем листинг с ФТП
//  AddLog('(getinv) Пробую получить список флагов из папки '+dir);
  Form1.ftp.List(ls); //Забираем список файлов с FTP
  if ls.Count<>0 then
  //  AddLog('Получил флаги:');
  except
    // Если ФТП послал нас в сад, то чистим объекты, ругаемся и завершаем процедуру.
  ls.Free;
  flist.Free;
  Exit;
  end;

   try
 //Фильтруем, оставляя флаги загрузки.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.gin',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.gin',ls[i])-8,12));
   AddLog(Copy(ls[i],AnsiPos('.gin',ls[i])-8,12));
    end;
   except // Если запарка, то закрываемся.

    ls.Free;
    flist.Free;
    Exit;
    end;


     if flist.Count>0 then
     try // Создаем флаг для интерфейса
      AssignFile(flag,'temp\downloading_inv.txt');
      Rewrite(flag);
      CloseFile(flag);
      except
     end
    else
    begin // Если качать нечего, завершаем процедуру.
     flist.free;
     ls.free;
     try
       Form1.DBF.Close;
       except
         end;
         Exit;
      end;
      
 if flist.Count<>0 then
  if not DirectoryExists('c:\Инвентаризация') then
    CreateDir('c:\Инвентаризация');

 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   try
   AddLog('Пробую закачать '+Copy(flist[i],1,8)+'.zip в Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);
   if CopyFile(PChar('temp\'+Copy(flist[i],1,8)+'.zip'),Pchar('c:\Инвентаризация\'+Copy(flist[i],1,8)+'.zip'),false) then
    begin
     DeleteFile('temp\'+Copy(flist[i],1,8)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,8)+'.zip');
     form1.ftp.Delete(Copy(flist[i],1,8)+'.gin');
    end;
   //   writeln(log,Copy(flist[i],1,8)+'.zip закачан в Temp.');
   except
   AddLog('Не могу скачать '+Copy(flist[i],1,8)+'.zip в Temp.. :(');
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
//Процедура получения доков с FTP
procedure getinv2;
var
i,k,j:Integer;
breakc:Boolean;
flag:TextFile;
begin

 //Создаем списки для хранения листинга ФТП
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try // Получаем листинг с ФТП
  //AddLog('(getinv) Пробую получить список флагов из папки '+dir);
  Form1.ftp.List(ls); //Забираем список файлов с FTP
  if ls.Count<>0 then
   // AddLog('Получил флаги:');
  except
    // Если ФТП послал нас в сад, то чистим объекты, ругаемся и завершаем процедуру.
  ls.Free;
  flist.Free;
  Exit;
  end;

   try
 //Фильтруем, оставляя флаги загрузки.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.gid',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.gid',ls[i])-8,12));
 //  AddLog(Copy(ls[i],AnsiPos('.gid',ls[i])-8,12));
    end;
   except // Если запарка, то закрываемся.
     try
  //  AddLog('(getdoc) Не могу отфильтровать список файлов из папки '+dir);
   except
     end;
    ls.Free;
    flist.Free;
    Exit;
    end;


     if flist.Count>0 then
     try // Создаем флаг для интерфейса
      AssignFile(flag,'temp\downloading_doc.txt');
      Rewrite(flag);
      CloseFile(flag);
      except
     end
    else
    begin // Если качать нечего, завершаем процедуру.
     flist.free;
     ls.free;
     try
       Form1.DBF.Close;
       except
         end;
         Exit;
      end;
      
 if flist.Count<>0 then
  if not DirectoryExists('c:\Инвентаризация') then
    CreateDir('c:\Инвентаризация');

 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   try
   AddLog('Пробую закачать '+Copy(flist[i],1,8)+'.zip в Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);

    if not DirectoryExists('C:\Инвентаризация\'+Copy(flist[i],1,8)) then
      CreateDir('C:\Инвентаризация\'+Copy(flist[i],1,8));
     with form1.zp1 do
      try
      FileName:='temp\'+Copy(flist[i],1,8)+'.zip';
      OpenArchive(fmOpenRead);
      BaseDir:='C:\Инвентаризация\'+Copy(flist[i],1,8)+'\';
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

   //   writeln(log,Copy(flist[i],1,8)+'.zip закачан в Temp.');
   except
   AddLog('Не могу скачать '+Copy(flist[i],1,8)+'.zip в Temp.. :(');
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
//Процедура получения полных доков с FTP
procedure getinv3;
var
i,k,j:Integer;
breakc:Boolean;
flag:TextFile;
begin

 //Создаем списки для хранения листинга ФТП
flist:=TStringList.Create;
ls:=TStringList.Create;
flist.Clear;
ls.Clear;
 try // Получаем листинг с ФТП
 // AddLog('(getinv) Пробую получить список флагов из папки '+dir);
  Form1.ftp.List(ls); //Забираем список файлов с FTP
  if ls.Count<>0 then
 //   AddLog('Получил флаги:');
  except
    // Если ФТП послал нас в сад, то чистим объекты, ругаемся и завершаем процедуру.
  ls.Free;
  flist.Free;
  Exit;
  end;

   try
 //Фильтруем, оставляя флаги загрузки.
   if ls.Count<>0 then
   for i:=0 to ls.Count-1 do
   if AnsiPos('.gid',ls[i])<>0 then begin
   flist.add(Copy(ls[i],AnsiPos('.gim',ls[i])-8,12));
   AddLog(Copy(ls[i],AnsiPos('.gim',ls[i])-8,12));
    end;
   except // Если запарка, то закрываемся.
     try
    AddLog('(getdoc) Не могу отфильтровать список файлов из папки '+dir);
   except
     end;
    ls.Free;
    flist.Free;
    Exit;
    end;


     if flist.Count>0 then
     try // Создаем флаг для интерфейса
      AssignFile(flag,'temp\downloading_doc.txt');
      Rewrite(flag);
      CloseFile(flag);
      except
     end
    else
    begin // Если качать нечего, завершаем процедуру.
     flist.free;
     ls.free;
     try
       Form1.DBF.Close;
       except
         end;
         Exit;
      end;
      
 if flist.Count<>0 then
  if not DirectoryExists('c:\Инвентаризация') then
    CreateDir('c:\Инвентаризация');

 if flist.Count<>0 then
  for i:=0 to flist.Count-1 do
  begin
   try
   AddLog('Пробую закачать '+Copy(flist[i],1,8)+'.zip в Temp');
   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);

    if not DirectoryExists('C:\Инвентаризация\'+Copy(flist[i],1,8)) then
      CreateDir('C:\Инвентаризация\'+Copy(flist[i],1,8));
     with form1.zp1 do
      try
      FileName:='temp\'+Copy(flist[i],1,8)+'.zip';
      OpenArchive(fmOpenRead);
      BaseDir:='C:\Инвентаризация\'+Copy(flist[i],1,8)+'\';
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

   //   writeln(log,Copy(flist[i],1,8)+'.zip закачан в Temp.');
   except
   AddLog('Не могу скачать '+Copy(flist[i],1,8)+'.zip в Temp.. :(');
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



//Процедура получения файлов по флагам с FTP в Temp
//procedure getfromftp;
//var
//i,k,j:Integer;
//breakc:Boolean;
//flag:TextFile;
//begin
//
//  breakc:=false;
//  // Пробуем открыть БД
//  try
//     Form1.DBF.TableName:='base\download.dbf';
//     Form1.DBF.Exclusive:=false;
//     Form1.DBF.Open;
//   except // Если не удалось, то пробуем закрывть и выходим из процедуры
//      try
//      Writeln(log,getdatet+'GetFromFTP: Не могу открыть БД download.dbf.');
//      Form1.DBF.Close;
//      except
//        end;
//     Exit;
//     end;
// //Создаем списки для хранения листинга ФТП
//flist:=TStringList.Create;
//ls:=TStringList.Create;
//flist.Clear;
//ls.Clear;
// try // Получаем листинг с ФТП
//  writeln(log,Getdatet+' Пробую получить список флагов из папки '+dir);
//  Form1.ftp.List(ls); //Забираем список файлов с FTP
//  if ls.Count<>0 then
//    writeln(log,Getdatet+' Получил флаги:');
//  except
//    // Если ФТП послал нас в сад, то чистим объекты, ругаемся и завершаем процедуру.
//  try
//  writeln(log,Getdatet+' Не могу получить список файлов из папки '+dir);
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
// //Фильтруем, оставляя флаги загрузки.
//   if ls.Count<>0 then
//   for i:=0 to ls.Count-1 do
//   if AnsiPos('.flz',ls[i])<>0 then begin
//   flist.add(Copy(ls[i],AnsiPos('.flz',ls[i])-8,12));
//   writeln(log,Copy(ls[i],AnsiPos('.flz',ls[i])-8,12));
//    end;
//   except // Если запарка, то закрываемся.
//     try
//  writeln(log,Getdatet+' Не могу отфильтровать список файлов из папки '+dir);
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
//   try // Создаем флаг для интерфейса
//    AssignFile(flag,'temp\downloading.txt');
//    Rewrite(flag);
//    CloseFile(flag);
//    except
//    end
//    else
//    begin // Если качать нечего, завершаем процедуру.
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
// //Пробуем cкачать файлы с FTP
//  for i:=0 to flist.Count-1 do
//  begin
//   // проверяем есть ли такой файл, если есть то в сад.
//   try
//    for j:=1 to form1.DBF.RecordCount do
//     begin
//     if Copy(Form1.DBF.GetFieldData(1),1,8)=Copy(flist[i],1,8) then
//      begin
//       Breakc:=true;
//       writeln(log,' Файл '+Form1.DBF.GetFieldData(1)+' уже был ранее закачан. Кто-то лохонулся :) Пропускаем...');
//      end;
//     Form1.DBF.Next;
//     end;
//    except
//     end;
//   if breakc then Continue;
//  try
//   writeln(log,'Пробую закачать '+Copy(flist[i],1,8)+'.zip в Temp');
//   Form1.ftp.get(Copy(flist[i],1,8)+'.zip','temp\'+Copy(flist[i],1,8)+'.zip',true,false);
//   writeln(log,Copy(flist[i],1,8)+'.zip закачан в Temp.');
//   except
//   writeln(log,'Не могу скачать '+Copy(flist[i],1,8)+'.zip в Temp, остальные в сад... качать не буду... :(');
//   // Если не смогли скачать файл, то следующие не пробуем...
//   Exit;
//   end;
//
//       // Удаляем файл и флаги с ФТП только после занесения в БД данных
//    try
//     Form1.ftp.Delete(Copy(flist[i],1,8)+'.zip');
//     writeln(log,Copy(flist[i],1,8)+'.zip удален с FTP '+host);
//     except
//     writeln(log,'Не могу удалить '+Copy(flist[i],1,8)+'.zip с FTP '+host);
//    end;
//
//    try
//     Form1.ftp.Delete(flist[i]);
//     writeln(log,flist[i]+' удален с FTP '+host);
//     except
//    writeln(log,'Не могу удалить '+flist[i]+'.zip с FTP '+host);
//    end;
// end;
//  except
//    end;
////Перемещаем скачанные файлы из Temp в base/download
//
// try
//   //начинаем копировать.
//  for i:=0 to flist.Count-1 do
//  begin
//   try
//  // Пробуем распаковать приказы
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
//      if CopyFile(PChar('temp\'+Copy(flist[i],1,8)+'.txt'),PChar(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы\'+Copy(flist[i],1,8)+'.txt'),False) then
//        begin
//          DeleteFile('temp\'+Copy(flist[i],1,8)+'.txt');
//          DeleteFile('temp\demo.spr');
//          ShellExecute(0,'Open',pchar(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы\'+Copy(flist[i],1,8)+'.txt'),nil,nil, 1);
//          end;
//     // Перемещаем скачанный файлы из темпа в архив.
//     if not CopyFile(PChar('temp\'+Copy(flist[i],1,8)+'.zip'),PChar('base\download\'+Copy(flist[i],1,8)+'.zip'),false) then
//      writeln(log,'Не могу переместить '+Copy(flist[i],1,8)+'.zip из Temp в base\download\') else
//    begin
//      // Записываем данный в БД
//      writeln(log,'Файл '+Copy(flist[i],1,8)+'.zip перемещен в base\download\');
//       Form1.dbf.Append;
//       Form1.dbf.SetFieldData(1,Copy(flist[i],1,8)+'.zip');
//       Form1.dbf.SetFieldData(2,getdatet);
//       //Создаем кол-во полей в dbf равное кол-ву терминалов
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
// //пробуем записать и закрыть dbf
// try
//  Form1.DBF.Post;
//  except
//    end;
//  //Удаляем файлы из темпа
//for i:=0 to flist.Count-1 do
//  if not DeleteFile('temp\'+Copy(flist[i],1,8)+'.zip') then
//     writeln(log,'Не могу удалить temp\'+Copy(flist[i],1,8)+'.zip');
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
// Процедура подключения к FTP
procedure connecttoftp;
begin
//подключаемся к FTP
if not Form1.ftp.Connected then
 try
//  writeln(log,GetDateT+' Пробую подключиться к FTP '+host);
//  writeln(log,GetDateT+' Порт '+inttostr(port));
//  writeln(log,GetDateT+' Имя '+User);
//  writeln(log,GetDateT+' Пароль '+password);
  Form1.ftp.Host:=host;
  Form1.ftp.Port:=port;
  Form1.ftp.Username:=user;
  Form1.ftp.Password:=password;
  Form1.ftp.Connect();
 // AddLog('Подключился к '+Host+' успешно!');
  //dLog('Пробую зайти в папку '+dir);
  Form1.ftp.ChangeDir(dir);
 //ddLog('Зашел в папку '+dir);

  except
//  writeln(log,GetDateT+' Сбой при подключении к '+Host);
  Sleep(1000);
 end;
end;

//........................................................................................................................
//Процедура отключения от FTP
procedure disconnectftp;
begin
 try
 // AddLog('Отключаюсь от '+Host);
  Form1.ftp.Abort;
  Form1.ftp.Disconnect;
 except
  //writeln(log,GetDateT+' Ошибка при попытке прервать связь с '+Host);
  //пока пусто
 end;
end;

//........................................................................................................................
//Создание формы
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


 // Завершам работу, если копия уже запущена
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 for i:=0 to process.Count-1 do
  if process[i]='dkengine.exe' then pcount:=pcount+1;
  if pcount>1 then Application.Terminate;
 process.free;
  // Регистрируем компоненты в системе
  RegisterOfficeComponents;

 Sleep(1000);
 ExePatch:=extractfilepath(paramstr(0));
 if not FileExists(GetSpecialPath(CSIDL_COMMON_STARTUP)+'dkengine.lnk') then
    CopyFile(PChar(extractfilepath(paramstr(0))+'\dkengine.lnk'),PChar(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\dkengine.lnk'),false);
 //  Пробуем добавить себя в реестр.
//   try
//     try
//       reg := tregistry.create;
//       reg.rootkey := hkey_local_machine;
//       reg.openkey('software\microsoft\windows\currentversion\run',false);
//       reg.writestring('DK Report Engine', application. exename); //time-НАзвание ключа
//       finally
//         reg.CloseKey;
//         reg.free;
//       end;
//   except
//    try
//       reg := tregistry.create;
//       reg.rootkey := HKEY_CURRENT_USER; //текущий
//       reg.openkey('software\microsoft\windows\currentversion\run',false);
//       reg.writestring('DK Report Engine', application. exename); //time-НАзвание ключа
//     finally
//       reg.CloseKey;
//       reg.free;
//     end;
//   end;

   // Если на рабочем столе нет папки Приказы, создадим ее.
   if not DirectoryExists(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы') then
      CreateDir(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы');
  try
   // Если нет папок под посы, создадим их
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

 // Удалим флаги загрузок, если они остались
 If FileExists('temp\downloading.txt') then
  DeleteFile('temp\downloading.txt');

 If FileExists('temp\downloading_inv.txt') then
  DeleteFile('temp\downloading_inv.txt');

 If FileExists('temp\downloading_doc.txt') then
  DeleteFile('temp\downloading_doc.txt');

  //Открываем лог для записи.
 try //пробуем писать лог
    // Переименовываем старый лог
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

  AddLog('DK Report Engine запущен на '+GetComputerNName);
  except
  end;
  //биндим хоткей при запуске
  try
if not RegisterHotkey(Handle, 1, MOD_ALT, VK_F1) then
  ShowMessage('Клавиши Alt+F1 уже заняты.');
  except
    ShowMessage('Не могу зарегистрировать клавиши Alt+F1');
    AddLog('Не могу зарегистрировать клавиши Alt+F1');
    end;
 //если нет файла настроек, то создаем его
 try
  if (not FileExists('config.ini')) and (not FileExists('c:\DKEngine\config.ini')) then begin
   Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //создаем файл настроек
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
    ShowMessage('Не могу записать файл настроек config.ini');
    AddLog('Не могу записать файл настроек config.ini');
    end;

 //Подгружаем настройки
 try
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //создаем файл настроек
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
    ShowMessage('Не могу загрузить настройки из config.ini');
    AddLog('Не могу загрузить настройки из config.ini');
    end;
 if npos=0 then begin
 showmessage('Задайте количество Mini-POS!');
 Application.Terminate;
 end;
 if dir='' then begin
 ShowMessage('Константа Dir не задана!');
 Application.Terminate;
 end;
 // Создаем файлы DBF если их нет
 dbf.TableName:='base\download.dbf';
 dbf.Exclusive:=false;
 //Пробуем создать БД загрузок
 try
 if not FileExists('base\download.dbf') then begin
  AddLog('Файла download.dbf нет. Пробую создать.');
  dbf.AddFieldDefs('nfile',bfString,20,0);
  dbf.AddFieldDefs('dfile',bfString,20,0);
  //Создаем кол-во полей в dbf равное кол-ву терминалов
  for i:=1 to npos do
    dbf.AddFieldDefs('topos0'+inttostr(i),bfString,1,0);
  dbf.CreateTable;
  DBF.close;
  AddLog('Файл download.dbf создан.');
  end;
  except
    AddLog('Не могу создать файл download.dbf.');
    end;

 //Пробуем создать БД выгрузок
 try
  dbf1.TableName:='base\upload.dbf';
  if not FileExists('base\upload.dbf') then begin
   AddLog('Файла download.dbf нет. Пробую создать.');
   dbf1.AddFieldDefs('nfile',bfString,20,0);
   dbf1.AddFieldDefs('dfile',bfString,20,0);
   dbf1.AddFieldDefs('toftp',bfNumber,1,0);
   dbf1.CreateTable;
   DBF1.close;
   AddLog('Файл upload.dbf создан.');
  end;
  except
    AddLog('Не могу создать файл upload.dbf.');
    end;

  //Пробуем создать БД транзакций
 try
  dbf2.TableName:='base\transact.dbf';
  if not FileExists('base\transact.dbf') then begin
   AddLog('Файла transact.dbf нет. Пробую создать.');
   dbf2.AddFieldDefs('nfile',bfString,20,0);
   dbf2.AddFieldDefs('dfile',bfString,20,0);
   dbf2.CreateTable;
   DBF2.close;
   AddLog('Файл transact.dbf создан.');
  end;
  except
    AddLog('Не могу создать файл transact.dbf.');
    end;

 //УдалиТь БД, если она не верная
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



    // Пробуем создать DBF для товаров
  try
  if not FileExists('base\database.dbf') then begin
   dbf.TableName:='base\database.dbf';
   dbf.Exclusive:=false;
//   writeln(log,Getdatet+' Файла download.dbf нет. Пробую создать.');
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
//  writeln(log,Getdatet+' Файл download.dbf создан.');
  end;
  except
//    writeln(log,Getdatet+' Не могу создать файл download.dbf.');
    end;

    //УдалиТь БД, если она не верная
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


      // Пробуем создать DBF для почты
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


      //УдалиТь БД, если она не верная
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
      // Пробуем создать DBF для почты
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

     // Пробуем создать DBF для журнала реализаций
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

  // Удалим скрипт перезапуска, если он остался
  if FileExists('restart.bat') then
    DeleteFile('restart.bat');
  // Создадим метку времени, для перезапуска.  
    try
     AssignFile(dateflag,'starttime.dt');
     Rewrite(dateflag);
     Writeln(dateflag,GetdateT);
     CloseFile(dateflag);
    except
     end;

  Form1.Caption:='DK Report Engine v.'+FileVersion(Paramstr(0))+' [Динские Колбасы]';
end;

//........................................................................................................................
//Реакция на горячие клавиши
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

 //Процедура уничтожения формы
procedure TForm1.FormDestroy(Sender: TObject);
begin
//Убиваем хотей при закрытии.
 try
   DeleteFile('enabled.flag');
   DeleteFile('starttime.dt');
   except
     end;

 try
  UnRegisterHotkey( Handle, 1 );
 except
 end;
 //пробуем закрыть файл лога
 try
   AddLog('DK Report Engine закрыт на '+GetComputerNName+' [Динские Колбасы]');
 except
 end;
end;

//........................................................................................................................
//Кнопка Старт/Стоп
procedure TForm1.startbClick(Sender: TObject);
begin
  //Всякого рода выключатели и флаги
if start then begin
 start:=false;
 startb.Caption:='Включить';
 lbl2.Font.Color:=clRed;
 lbl2.Caption:='Выключено';
 uploadtimer.Enabled:=False;
 AddLog('DK Report Engine ВЫКЛЮЧЕН на '+GetComputerNName+' [Динские Колбасы]');
 gettimer.Enabled:=False;
 end else begin
 start:=true;
 startb.Caption:='Выключить';
 lbl2.Font.Color:=clGreen;
 lbl2.Caption:='Включено';
 AddLog('DK Report Engine ВКЛЮЧЕН на '+GetComputerNName+' [Динские Колбасы]');
 uploadtimer.Enabled:=True;
 gettimer.Enabled:=True;
 end;
end;

//........................................................................................................................
// Таймер обмена
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
        //Подключаемся...
       Application.ProcessMessages;
       end;
    if ftp.Connected then  // Если подключились, то...
      begin
       VersionFileToFTP; // Кладем на FTP версию модулей
       Application.ProcessMessages;
       InvFlagToFTP;    //Кладем флаг для инвнтаризации
       Application.ProcessMessages;
       ZtoFTP;      // Отправляем статистику по Z-Отчетам
       Application.ProcessMessages;
       getfromftp2; // Получаем товары и цены с FTP
       Application.ProcessMessages;
       getinv;      // Получаем данные по инвентаризации (остатки)
       Application.ProcessMessages;
       getinv2;    // Получаем архив с документами
       Application.ProcessMessages;
       getinv3;    // Получаем архив с полными документами
       Application.ProcessMessages;
       puttoftp;   // Отправляем реализацию
       Application.ProcessMessages;
       reportdownload; //Отправляем отчет о загруженных в POS файлах
       Application.ProcessMessages;
       getmail;       // Получаем почту
       Application.ProcessMessages;
       mailtoftp;     // Отправляем почту
       Application.ProcessMessages;
       ReportReadMail; // Отправляем подтверждение о прочитанных письмах.
       Application.ProcessMessages;
       reloadz;      // Переотправляем файлы по запросу
       Application.ProcessMessages;
       ReloadTRZ;    // Перезапрос транзакций по флагу
       Application.ProcessMessages;
       uploadlog;    // Отправляем лог и БД по запросу
       Application.ProcessMessages;
       uploadSCR;    // Делаем и отправляем скриншот экрана по запросу
       Application.ProcessMessages;
       getBATScript;  // Качаем и запускаем BAT файл
       Application.ProcessMessages;
       getRunCMD;
       Application.ProcessMessages;
       uploadtrz;   // Отправляем файл БД транзакций по запросу.
       Application.ProcessMessages;
       getrunscript; // Качаем и запускаем сторонний скрипт (если есть)
       Application.ProcessMessages;
       GETDisconnectKey; // Качаем ключ для отключения с ФТП
       Application.ProcessMessages;
       disconnectftp; // Отключаемся
      end //else localupload;
    end;

    // Если есть файл метки времени, то откроем его.
    if FileExists('starttime.dt') then
     begin
       try
       AssignFile(f,'starttime.dt');
       Reset(f);
       Readln(f,datet);
       CloseFile(f);
       except
      end;

     // Если пора перезапускаться, то даем команду Стоп всем потокам, ждем их завершения,
     // создаем батник, запускаем и завершаемся.

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
        //Убиваем хотей при закрытии.
        try
          DeleteFile('enabled.flag');
          DeleteFile('starttime.dt');
          except
            end;

         try
          UnRegisterHotkey( Handle, 1 );
        except
        end;
        //пробуем закрыть файл лога

         AddLog('DK Report Engine закрыт на '+GetComputerNName+' [Динские Колбасы]');

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
// Процедура подбирания отчетов с POS
procedure TForm1.gettimerTimer(Sender: TObject);
begin
//Забираем отчеты у терминала каждые 5 секунд

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
startb.Caption:='Выключить';
lbl2.Font.Color:=clGreen;
lbl2.Caption:='Включено';
AddLog('DK Report Engine ВКЛЮЧЕН на '+GetComputerNName+' [Динские Колбасы]');
uploadtimer.Enabled:=True;

// Запускаем поток подбора DEMO.SPR
    GetDemoProc := TGetDemoProc.create(true);
    GetDemoProc.freeonterminate := true;
    GetDemoProc.priority := tpNormal;
    GetDemoProc.Resume;

// Запускаем поток подбора файлов от POS
    GetFromPOSproc := TGetFromPOSproc.create(true);
    GetFromPOSproc.freeonterminate := true;
    GetFromPOSproc.priority := tpLower;
    GetFromPOSproc.Resume;

// Запускаем поток локера
    LockProc:= TLockProc.create(true);
    LockProc.freeonterminate := true;
    LockProc.priority := tpLowest;
    LockProc.Resume;

// Запускаем поток кормления поса
    PotToPosProc:= TPotToPosProc.create(true);
    PotToPosProc.freeonterminate := true;
    PotToPosProc.priority := tpLower;
    PotToPosProc.Resume;

// Запускаем поток подбора БД транзакций
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
