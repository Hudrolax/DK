unit dkinterface;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, inifiles, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent,
  IdRawBase, IdRawClient, IdIcmpClient, DBF, Gvar, Registry, ComCtrls, ShlObj, shellapi,
  IdTCPConnection, IdTCPClient, Menus, unit2, unit3, Unit4, unit5, Unit6, unit7,
  passdial,nomencl,dialog1,dialog2,DateUtils,prikazi,mail,sendmail,kass_book,unit19,
  IdFTP, jurnal_zayavok;

type
  TForm1 = class(TForm)
    btn1: TButton;
    Timer1: TTimer;
    tmrtermtimer: TTimer;
    DBF1: TDBF;
    icmp1: TIdIcmpClient;
    Timer3: TTimer;
    DBF2: TDBF;
    Button1: TButton;
    Label5: TLabel;
    Timer4: TTimer;
    MainMenu1: TMainMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    GroupBox5: TGroupBox;
    p1: TLabel;
    ptimer: TTimer;
    BConnect: TButton;
    BDisconnect: TButton;
    lbLog: TListBox;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    connecttimer: TTimer;
    DisconnectT: TTimer;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    DBF3: TDBF;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    ListBox1: TListBox;
    Label1: TLabel;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    ListBox4: TListBox;
    ListBox5: TListBox;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ftp: TIdFTP;
    N33: TMenuItem;
    lbs: TListBox;
    TermDKengine: TTimer;
    procedure wmGetMinMaxInfo(var Msg : TMessage); message wm_GetMinMaxInfo;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure tmrtermtimerTimer(Sender: TObject);
    procedure icmp1Reply(ASender: TComponent;
      const AReplyStatus: TReplyStatus);
    procedure Timer3Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure ptimerTimer(Sender: TObject);
    procedure BConnectClick(Sender: TObject);
    procedure BDisconnectClick(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure connecttimerTimer(Sender: TObject);
    procedure DisconnectTTimer(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure p1Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBox3DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure N33Click(Sender: TObject);
    procedure TermDKengineTimer(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
  end;


// Описываем класс для потока
Tping = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;

function GetSpecialPath(CSIDL: word): string;

var
  Form1: TForm1;
  ini:TIniFile;
  tping1:Tping;
  reg: tregistry;
  repdelta,port,rascount,k:Integer;
  GetReply:boolean;
  OrdToRefresh:boolean;
implementation

{Tping}
procedure tping.execute;
var ip,k,i,j:integer;
conn:boolean;
begin
  while True do
  begin
    // Посылаем запрос на 21 порт в интерент (На ФТП обмена) и на каждую кассу.
   if k=0 then // выполняем коннект только каждый 11-й раз прохождения цикла
   begin
    try
     conn:=false;
     Form1.ftp.Host:=host;
     Form1.ftp.Port:=port;
     Form1.ftp.Username:=user;
     Form1.ftp.Password:=password;
     Form1.ftp.Connect;
     If form1.ftp.Connected then conn:=true else conn:=false;
     Form1.ftp.Disconnect;
    except
      end;
      // Если ответ от FTP есть
     if conn then
      begin
       InetStatus:='Интернет ПОДКЛЮЧЕН';
       end
    else
    begin
     InetStatus:='Интернет НЕ ПОДКЛЮЧЕН';
    end;
   end;
   k:=k+1; // Это чтобы он не задрачивал FTP коннектами каждые 3 секунды
   If k>5 then k:=0;

   OrdToRefresh:=false;
   for i:=1 to 5 do
    for j:=1 to 9 do
     KassStatus[i,j]:=Magaz[i].Name+' касса POS'+inttostr(j)+' ('+Magaz[i].pos[j]+') НЕ ДОСТУПНА';

   // Пинг на кассы
   For i:=1 to 5 do
    for j:=1 to 9 do
     if (Magaz[i].FTPDir<>'') and (Magaz[i].pos[j]<>'') then
      try
       Form1.icmp1.Host:=Magaz[i].pos[j];
       Form1.icmp1.TTL:=114;
       Form1.icmp1.Ping;
       GetReply:=false;
       Sleep(120);
       except
      end;
   OrdToRefresh:=true;   
     sleep(3000); 
  end;
end;

{$R *.dfm}
procedure ReadStatus;
var
  f:textfile;
  var sr:TSearchRec;
  Result:word;
  fname:string;
  s:string;
begin
 Result := FindFirst (EXEPath+'status\*.txt',faAnyFile,sr);
 While result=0 do
  Begin
   Result:=FindNext (sr);
   fname:=EXEPath+'status\'+sr.name;
   IF FileExists(fname) then
    try
     AssignFile(f,fname);
     reset(f);
     while not eof(f) do
       readln(f,s);
     Form1.ListBox2.Items.Append(s);
     Form1.ListBox2.ItemIndex := Form1.ListBox2.Items.Count - 1;
     if Pos('[Отчеты]',s)>0 then
      begin
       Form1.ListBox5.Items.Append(s);
       Form1.ListBox5.ItemIndex := Form1.ListBox5.Items.Count - 1;
      end;
     if Pos('[Поступления]',s)>0 then
      begin
       Form1.ListBox4.Items.Append(s);
       Form1.ListBox4.ItemIndex := Form1.ListBox4.Items.Count - 1;
      end;
     CloseFile(f);
     DeleteFile(fname);
    except
    end;
  End;
end;

function SecondsBetweenRound(const ANow, AThen: TDateTime): Int64;
begin
  Result := Round(SecondSpan(ANow, AThen));
end;

function GetSpecialPath(CSIDL: word): string;
var s:  string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
  then s := '';
  result := PChar(s);
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

// Процедура автозапроса отчетов с касс
procedure AutoZapros;
var
unloadfile,dateflag:textfile;
i:integer;
datet:string;
begin
  OrdToExport:=false;
if not FileExists('temp\dateflag.dt') then
  try
     AssignFile(dateflag,'temp\dateflag.dt');
     Rewrite(dateflag);
     Writeln(dateflag,GetdateT);
     CloseFile(dateflag);
    except
     end;

 try
   AssignFile(dateflag,'temp\dateflag.dt');
   Reset(dateflag);
   Readln(dateflag,datet);
   CloseFile(dateflag);
 if SecondsBetweenRound(StrToDateTime(GetDateT),StrToDateTime(datet))>43200 then
    OrdToExport:=True;
   except
     end;

 if OrdToExport then
 try
   AssignFile(unloadfile,'loadtrz.pos');
   Rewrite(unloadfile);
   CloseFile(unloadfile);

   try
    AssignFile(dateflag,'temp\dateflag.dt');
    Rewrite(dateflag);
    Writeln(dateflag,GetdateT);
    CloseFile(dateflag);
    except
     end;

  Form1.label5.Font.Size:=10;
  Form1.label5.Caption:='Запрос на кассы отправлен автоматически '+GetDateT;
  Form1.Label5.Visible:=true;
 except
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
try
tping1.Terminate;
except
  end;
close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i,k,pcount:Integer;
  process:TStringList;
  f:TextFile;
begin
 // Завершам работу, если копия уже запущена
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 pcount:=0;
 for i:=0 to process.Count-1 do
  if process[i]='dk_interface.exe' then pcount:=pcount+1;
  if pcount>1 then Application.Terminate;

 if FileExists(GetSystemDir+'\conflict.nls') then Application.Terminate;
 EXEPath:=extractfilepath(paramstr(0));

 Form1.Caption:='DK Report Interface v.'+FileVersion(Paramstr(0));

if not FileExists(GetSpecialPath(CSIDL_COMMON_STARTUP)+'dk_interface.lnk') then
    CopyFile(PChar(EXEPath+'\dk_interface.lnk'),PChar(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\dk_interface.lnk'),false);

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
    if not DirectoryExists('zayavki') then
      CreateDir('zayavki');

  except
    end;
        
// Регистрируем компоненты в системе.
RegisterOfficeComponents;

  //Подгружаем настройки
 try
  Ini:=TiniFile.Create(EXEPath+'config.ini'); //создаем файл настроек
  host:=ini.ReadString('FTP','Host','ugrus.com');
  port:=ini.ReadInteger('FTP','Port',21);
  user:=ini.ReadString('FTP','User','dk');
  password:=ini.ReadString('FTP','Password','dk');
  For k:=1 to 5 do // Считаем настройки для магазинов
    begin
     Magaz[k].Nom:=k;
     Magaz[k].Name:=Ini.ReadString('Base','Mag'+inttostr(k)+'_Name','Магазин ДК');
     Magaz[k].Firm:=Ini.ReadString('Base','Mag'+inttostr(k)+'_Firm','ООО "Динские колбасы - Краснодар"');
     Magaz[k].Path:=ini.ReadString('Base','Mag'+inttostr(k)+'_Path','C:\Mag'+inttostr(k));
     Magaz[k].FTPDir:=ini.ReadString('FTP','Dir'+inttostr(k),'');
     for i:=1 to 9 do
        Magaz[k].pos[i]:=ini.ReadString('Dir'+inttostr(k)+'_POS','POS0'+inttostr(i),'');
    end;
 
  If ini.ReadInteger('Base','AutoConnect',1)=1 then
    AutoConnectFlag:=True
  Else AutoConnectFlag:=False;
  If ini.ReadInteger('Base','AutoDisconnect',1)=1 then
  AutoDisconnectFlag:=True
  Else AutoDisconnectFlag:=False;
  
  //  npos:=ini.ReadInteger('POS','NPOS',0);
  Ini.Free;
  except
    ShowMessage('Не могу загрузить настройки из config.ini');
    end;

 InetStatus:='Интернет НЕ ПОДКЛЮЧЕН';
 
  //Пробуем создать БД кассовой книги
// if not FileExists('base\kassbook.dbf') then
// try
//  dbf2.TableName:='base\kassbook.dbf';
//  dbf2.AddFieldDefs('kkm',bfString,100,0);
//  dbf2.AddFieldDefs('date',bfString,100,0);
//  dbf2.AddFieldDefs('time',bfString,100,0);
//  dbf2.AddFieldDefs('NO',bfString,100,0);
//  dbf2.AddFieldDefs('neobn',bfString,100,0);
//  dbf2.AddFieldDefs('vozvrat',bfString,100,0);
//  dbf2.AddFieldDefs('inkass',bfString,100,0);
//  dbf2.AddFieldDefs('viruchka',bfString,100,0);
//  dbf2.AddFieldDefs('tobase',bfString,100,0);
//  dbf2.CreateTable;
//  DBF2.close;
//  except
//    ShowMessage('Не могу создать файл base\kassbook.dbf!!!');
//    Close;
//    end;

   //Пробуем создать БД журнала заявок
 if not FileExists('base\jurnal_zayavok.dbf') then
 try
  dbf2.TableName:='base\jurnal_zayavok.dbf';
  dbf2.AddFieldDefs('magaz',bfString,100,0);
  dbf2.AddFieldDefs('KodSklada',bfString,100,0);
  dbf2.AddFieldDefs('date',bfString,100,0);
  dbf2.AddFieldDefs('OnDate',bfString,100,0);
  dbf2.AddFieldDefs('Sostavlena',bfString,100,0);
  dbf2.AddFieldDefs('post',bfString,100,0);
  dbf2.AddFieldDefs('postName',bfString,100,0);
  dbf2.AddFieldDefs('gruuz',bfString,100,0);
  dbf2.AddFieldDefs('gruuzName',bfString,100,0);
  dbf2.AddFieldDefs('Link',bfString,100,0);
  dbf2.AddFieldDefs('flag',bfString,1,0);
  dbf2.AddFieldDefs('otpravlen',bfString,1,0);
  dbf2.CreateTable;
  DBF2.close;
  except
    ShowMessage('Не могу создать файл base\jurnal_zayavok.dbf!!!');
    Close;
    end;

  // Перезапуск движка
  try
    AssignFile(f,'restart.bat');
    Rewrite(f);
    Writeln(f,'start /wait taskkill.exe /F /IM dkengine.exe');
    Writeln(f,'start dkengine.exe');
    CloseFile(f);

    WinExec('restart.bat',0);
    except
     end;

end;

// Процедура запуска потока опроса касс и интернета и остальные таймеры
procedure TForm1.Timer1Timer(Sender: TObject);
var i,j:integer;
begin
  Timer1.Enabled:=False;

//   For i:=1 to 5 do
//    For j:=1 to 9 do
//      Showmessage(Magaz[i].pos[j]);

  try
    tping1 := tping.create(true);
    tping1.freeonterminate := true;
    tping1.priority := tplowest;
    tping1.Resume;
    except
      Showmessage('Не удалось запустить процесс опроса!');
    end;
   ptimer.Enabled:=true; // Запуск таймера обновления строки подсказок
   Timer3.Enabled:=true; // Запуск таймера обновления состояния модулей
end;
//.................................................

procedure TForm1.tmrtermtimerTimer(Sender: TObject);
begin
if FileExists('terminate.txt') then
begin
  Application.Terminate;
  close;
  end;
  ReadStatus; // Читаем файлы статусов из папки \status
end;

procedure TForm1.icmp1Reply(ASender: TComponent;
  const AReplyStatus: TReplyStatus);
var i,j:integer;
begin

  for i:=1 to 5 do
    for j:=1 to 9 do
     If Magaz[i].pos[j]<>'' then
      if Form1.icmp1.ReplyStatus.FromIpAddress=Magaz[i].pos[j] then
       begin
        KassStatus[i,j]:=Magaz[i].Name+' касса POS'+inttostr(j)+' ('+Magaz[i].pos[j]+') включена';
       end;

  GetReply:=true;


end;


// Таймер отображения состояния
procedure TForm1.Timer3Timer(Sender: TObject);
var process:TStringList;
i,j:Integer;
dke,dku:Boolean;
begin
 Timer3.Enabled:=False;
 dku:=false;
 dke:=false;
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 ListBox3.Clear;
 If OrdToRefresh then
    ListBox1.Clear;
 // Смотрим в процессах и отображаем состояние модулей
 try
  for i:=0 to process.Count-1 do
   if process[i]='dkengine.exe' then dke:=True;
 except
   end;

    if dke then
      begin
       ListBox3.items.Append('Модуль обмена ВКЛЮЧЕН');
      end else
      begin
       ListBox3.items.Append('Модуль обмена ВЫКЛЮЧЕН!');
       // Если выключен, то пробуем запустить.
       try
        winexec('dkengine.exe',0);
         except
           end;

        end;

 for i:=0 to process.Count-1 do
  if process[i]='dkrupdater.exe' then dku:=True;

    if dku then
      begin
       ListBox3.items.Append('Модуль обновлений ВКЛЮЧЕН');
      end else
      begin
       ListBox3.items.Append('Модуль обновлений ВЫКЛЮЧЕН');

       try
        winexec('dkrupdater.exe',0);
         except
           end;
        end;
 If NePustaya(InetStatus) then
    Listbox3.Items.Append(InetStatus); // Добавим статус Интернета

 // Добавим статусы касс
If OrdToRefresh then
 For i:=1 to 5 do
  For j:=1 to 9 do
   if NePustaya(Magaz[i].pos[j]) then
    if NePustaya(KassStatus[i,j]) then
      Listbox1.Items.Append(KassStatus[i,j]);

  process.free;
  Timer3.Enabled:=true;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
unloadfile,dateflag:textfile;
i:integer;
datet:string;
begin
if not FileExists('temp\dateflag.dt') then
  try
     AssignFile(dateflag,'temp\dateflag.dt');
     Rewrite(dateflag);
     Writeln(dateflag,GetdateT);
     CloseFile(dateflag);
    except
     end;

 try
   AssignFile(dateflag,'temp\dateflag.dt');
   Reset(dateflag);
   Readln(dateflag,datet);
   CloseFile(dateflag);
 if SecondsBetweenRound(StrToDateTime(GetDateT),StrToDateTime(datet))<43200 then
   begin
    Button1.Enabled:=False;
    OKBottomDlg.Visible:=True;
    dlg1:=False;
    while not dlg1 do
      begin
       Application.ProcessMessages;
      Sleep(50);
      end;
    Button1.Enabled:=True;
    end else OrdToExport:=True;
   except
     end;

 if OrdToExport then
 try

   AssignFile(unloadfile,'loadtrz.pos');
   Rewrite(unloadfile);
   CloseFile(unloadfile);


   try
    AssignFile(dateflag,'temp\dateflag.dt');
    Rewrite(dateflag);
    Writeln(dateflag,GetdateT);
    CloseFile(dateflag);
    except
     end;

  Button1.Enabled:=false;
  label5.Font.Size:=12;
  label5.Caption:='Отправлен запрос на кассы. Ждите 5 минут...';
  Label5.Visible:=true;
  Timer4.Enabled:=True;
 except
  end;
end;


procedure TForm1.Timer4Timer(Sender: TObject);
begin
Timer4.Enabled:=False;
label5.Font.Size:=8;
label5.Caption:='Чтобы запросить следующий отчет, перезапустите программу.';
end;

procedure TForm1.N1Click(Sender: TObject);
begin
 Close;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
 Form2.Visible:=True;
end;

procedure TForm1.N6Click(Sender: TObject);
var f:TextFile;
m:string;
begin
  m:='Не установлена';
 try
 AssignFile(f,'version.txt');
 Reset(f);
 Readln(f,m);
 CloseFile(f);
 except
   end;
   ShowMessage('Версия сборки: '+m);
end;

procedure TForm1.N7Click(Sender: TObject);
var i,j:integer;
begin
 Form3.Timer1.Enabled:=True;
 Form3.Visible:=True;
 Form3.Show;
end;

procedure TForm1.N8Click(Sender: TObject);
var i,j:Integer;
begin
Form4.Timer1.Enabled:=True;
Form4.Visible:=True;
Form4.Show;
end;

procedure TForm1.N10Click(Sender: TObject);
var
unloadfile,dateflag:textfile;
i:integer;
datet:string;
begin
if not FileExists('temp\dateflag.dt') then
  try
     AssignFile(dateflag,'temp\dateflag.dt');
     Rewrite(dateflag);
     Writeln(dateflag,GetdateT);
     CloseFile(dateflag);
    except
     end;

 try
   AssignFile(dateflag,'temp\dateflag.dt');
   Reset(dateflag);
   Readln(dateflag,datet);
   CloseFile(dateflag);
 if SecondsBetweenRound(StrToDateTime(GetDateT),StrToDateTime(datet))<43200 then
   begin
    Button1.Enabled:=False;
    OKBottomDlg.Visible:=True;
    dlg1:=False;
    while not dlg1 do
      begin
       Application.ProcessMessages;
      Sleep(50);
      end;
    Button1.Enabled:=True;
    end else OrdToExport:=True;
   except
     end;

 if OrdToExport then
 try
  AssignFile(unloadfile,'loadtrz.pos');
   Rewrite(unloadfile);
   CloseFile(unloadfile);

   try
    AssignFile(dateflag,'temp\dateflag.dt');
    Rewrite(dateflag);
    Writeln(dateflag,GetdateT);
    CloseFile(dateflag);
    except
     end;

  Button1.Enabled:=false;
  label5.Font.Size:=12;
  label5.Caption:='Отправлен запрос на кассы. Ждите 5 минут...';
  Label5.Visible:=true;
  Timer4.Enabled:=True;
 except
  end;
end;

procedure TForm1.N11Click(Sender: TObject);
begin
Form5.Visible:=True;
Form5.Button1.Enabled:=True;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
 Form6.Visible:=True;
Form6.Button1.Enabled:=True;
end;

procedure TForm1.N13Click(Sender: TObject);
begin
 Form7.Visible:=True;
end;

procedure TForm1.ptimerTimer(Sender: TObject);
var i,k:integer;
begin
 ptimer.Enabled:=False;
 // Сообщаем о наличии обновлений
 if (FileExists('update\go.txt')) and (Pos(InetStatus,'ПОДКЛЮЧЕН')>0) then
    begin
     p1.Caption:='Не отключайтесь от интернета 20 минут! Скачивается обновление!';
     p1.Font.Color:=clRed;
     p1.Cursor:=crDefault;
     ptimer.Enabled:=true;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     Exit;
    end;

 // Сообщаем о наличии обновлений
   if (FileExists('update\go.txt')) and (Pos(InetStatus,'ПОДКЛЮЧЕН')>0) then
    begin
     p1.Caption:='Подключитесь к Интернету на 20 минут! Имеются обновления!';
     p1.Font.Color:=clRed;
     p1.Cursor:=crDefault;
     if connecttimer.Interval<>600000 then
     begin
     connecttimer.Interval:=1000;
     connecttimer.Enabled:=True;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     end;
     ptimer.Enabled:=true;
     Exit;
    end;

 // Сообщаем о закачке поступлений
 if (FileExists('temp\downloading.txt')) and (Pos(InetStatus,'ПОДКЛЮЧЕН')>0) then
    begin
     p1.Caption:='Не отключайтесь от интернета! Скачиваются поступления!';
     p1.Font.Color:=clRed;
     p1.Cursor:=crDefault;
     ptimer.Enabled:=true;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     Exit;
    end;

  // Сообщаем о оборванной закачке
 if (FileExists('temp\downloading.txt')) and (Pos(InetStatus,'ПОДКЛЮЧЕН')>0) then
    begin
     p1.Caption:='Закачка поступлений не завершена. Подключитесь к интернету на 20 минут!';
     p1.Font.Color:=clRed;
     p1.Cursor:=crDefault;
     ptimer.Enabled:=true;
     if connecttimer.Interval<>600000 then
     begin
     connecttimer.Interval:=1000;
     connecttimer.Enabled:=True;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     end;
     Exit;
    end;

// Сообщаем о закачке остатков
 if (FileExists('temp\downloading_inv.txt')) and (Pos(InetStatus,'ПОДКЛЮЧЕН')>0) then
    begin
     p1.Caption:='Не отключайтесь от интернета! Скачиваются остатки для ревизии!';
     p1.Font.Color:=clRed;
     p1.Cursor:=crDefault;
     ptimer.Enabled:=true;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     Exit;
    end;

  // Сообщаем о оборванной закачке
 if (FileExists('temp\downloading_inv.txt')) and (Pos(InetStatus,'ПОДКЛЮЧЕН')>0) then
    begin
     p1.Caption:='Закачка остатков не завершена. Подключитесь к интернету на 20 минут!';
     p1.Font.Color:=clRed;
     p1.Cursor:=crDefault;
     ptimer.Enabled:=true;
     if connecttimer.Interval<>600000 then
     begin
     connecttimer.Interval:=1000;
     connecttimer.Enabled:=True;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     end;
     Exit;
    end;

 // Сообщаем о закачке остатков
 if (FileExists('temp\downloading_doc.txt')) and (Pos(InetStatus,'ПОДКЛЮЧЕН')>0) then
    begin
     p1.Caption:='Не отключайтесь от интернета! Скачиваются документы для ревизии!';
     p1.Font.Color:=clRed;
     p1.Cursor:=crDefault;
     ptimer.Enabled:=true;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     Exit;
    end;

  // Сообщаем о оборванной закачке
 if (FileExists('temp\downloading_doc.txt')) and (Pos(InetStatus,'ПОДКЛЮЧЕН')>0) then
    begin
     p1.Caption:='Закачка документов не завершена. Подключитесь к интернету на 20 минут!';
     p1.Font.Color:=clRed;
     p1.Cursor:=crDefault;
     ptimer.Enabled:=true;
     if connecttimer.Interval<>600000 then
     begin
     connecttimer.Interval:=1000;
     connecttimer.Enabled:=True;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     end;
     Exit;
    end;    


 // Сообщаем о неотправленных отчетах
// if IsDigit(lz3.caption) and IsDigit(lz1.caption) then
// if StrToInt(lz3.Caption)<StrToInt(lz1.Caption) then
//    if linet.Caption='Включен' then
//    begin
//     p1.Caption:='В данный момент отправляются отчеты. Не отключайтесь 10 минут.';
//     p1.Font.Color:=clRed;
//     p1.Cursor:=crDefault;
//     ptimer.Enabled:=true;
//      DisconnectT.Enabled:=False;
//      DisconnectT.Interval:=300000;
//     Exit;
//    end else
//    begin
//     p1.Caption:='Имеются неотправленные отчеты! Подключитесь к Интернету на 10 минут.';
//     p1.Font.Color:=clRed;
//     p1.Cursor:=crDefault;
//     if connecttimer.Interval<>600000 then
//     begin
//     connecttimer.Interval:=1000;
//     connecttimer.Enabled:=True;
//      DisconnectT.Enabled:=False;
//      DisconnectT.Interval:=300000;
//     end;
//     ptimer.Enabled:=true;
//     Exit;
//    end;

  // Сообщаем о закачке почты
//**************************************************************
 if FileExists('temp\getmail.txt') then
    begin
     p1.Caption:='Не отключайтесь от интернета! Закачиваются почтовые сообщения!';
     p1.Cursor:=crDefault;
     p1.Font.Color:=clRed;
     ptimer.Enabled:=true;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     Exit;
    end;

//***************************************************************
//Сообщаем кол-во непрочитанных сообщений
      // Открываем БД
    try
     Form1.DBF3.TableName:='base\mail_down.dbf';
     Form1.DBF3.Exclusive:=false;
     Form1.DBF3.Open;
   except
     end;

   k:=0;
   for i:=1 to DBF3.RecordCount do
    begin
    if DBF3.GetFieldData(4)='0' then
      k:=k+1;
    DBF3.Next;
     end;

   if k>0 then
    begin
     if (k=1) or (k=21) then
      p1.Caption:='У Вас имеется '+inttostr(k)+' непрочитанное сообщениe.' else
     if (k=2) or (k=3) or (k=3) then
     p1.Caption:='У Вас имеется '+inttostr(k)+' непрочитанных сообщения.' else
     p1.Caption:='У Вас имеется '+inttostr(k)+' непрочитанных сообщений.';
     p1.Cursor:=crHandPoint;
     p1.Font.Color:=clRed;

     try
     ptimer.Enabled:=true;
     Form1.DBF3.Close;
     Exit;
     except
       end;


      end;

     try
     Form1.DBF3.Close;
     except
       end;
//**************************************************************

//***************************************************************
//Сообщаем кол-во неотправленных сообщений
      // Открываем БД
    try
     Form1.DBF3.TableName:='base\mail_up.dbf';
     Form1.DBF3.Exclusive:=false;
     Form1.DBF3.Open;
   except
     end;

   k:=0;
   for i:=1 to DBF3.RecordCount do
    begin
    if DBF3.GetFieldData(3)='0' then
      k:=k+1;
    DBF3.Next;
     end;

   if k>0 then
    begin
     if (k=1) or (k=21) then
      p1.Caption:='У Вас имеется '+inttostr(k)+' неотправленное сообщениe.' else
     if (k=2) or (k=3) or (k=3) then
     p1.Caption:='У Вас имеется '+inttostr(k)+' неотправленных сообщения.' else
     p1.Caption:='У Вас имеется '+inttostr(k)+' неотправленных сообщений.';
     p1.Cursor:=crDefault;
     p1.Font.Color:=clRed;
     if connecttimer.Interval<>600000 then
     begin
     connecttimer.Interval:=1000;
     connecttimer.Enabled:=True;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     end;
     try
     ptimer.Enabled:=true;
     Form1.DBF3.Close;
     Exit;
     except
       end;
    end;

     try
     Form1.DBF3.Close;
     except
       end;
//**************************************************************

 p1.Caption:='В данный момент подсказок нет.';
 p1.Cursor:=crDefault;
 p1.Font.Color:=clGreen;
 connecttimer.Interval:=5000;
 if (Pos(InetStatus,'ПОДКЛЮЧЕН')>0) and (not DisconnectT.Enabled) then
 begin
 DisconnectT.Enabled:=False;
 DisconnectT.Interval:=2400000;
 DisconnectT.Enabled:=True;
 end;
 ptimer.Enabled:=true;
end;


procedure TForm1.BConnectClick(Sender: TObject);
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
 lbLog.Items.Append('Пробую подключиться...');
  try
  WinExec('rasc.exe',SW_NORMAL);
  except
    lbLog.Items.Append('Ошибка: 666 :** Не могу найти rasc.exe! ***');
    lbLog.Items.Append('Попробуйте подключиться через значек MTS на рабочем столе.');
    lbLog.Items.Append('Сообщите об этой проблеме Системному Администратору.');
    end;
 end else
 begin
 lbLog.Items.Append('Работа с подключениями еще не закончена.');
 lbLog.Items.Append('Попробуйте позднее..');
 end;
 end;

procedure TForm1.BDisconnectClick(Sender: TObject);
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
 lbLog.Items.Append('Пробую отключиться...');
  try
  WinExec('rasd.exe',SW_NORMAL);
  except
    lbLog.Items.Append('Ошибка: 777 :** Не могу найти rasd.exe! ***');
    lbLog.Items.Append('Попробуйте просто отключить телефон (модем) от компьютера.');
    lbLog.Items.Append('В появившемся окне об ошибке нажмите "Отмена"');
    lbLog.Items.Append('Сообщите об этой проблеме Системному Администратору.');
    end;
 end else
 begin
 lbLog.Items.Append('Работа с подключениями еще не закончена.');
 lbLog.Items.Append('Попробуйте позднее..');
 end;
 end;

 
procedure TForm1.N15Click(Sender: TObject);
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
 lbLog.Items.Append('Пробую подключиться...');
  try
  WinExec('rasc.exe',SW_NORMAL);
  except
    lbLog.Items.Append('Ошибка: 666 :** Не могу найти rasc.exe! ***');
    lbLog.Items.Append('Попробуйте подключиться через значек MTS на рабочем столе.');
    lbLog.Items.Append('Сообщите об этой проблеме Системному Администратору.');
    end;
 end else
 begin
 lbLog.Items.Append('Работа с подключениями еще не закончена.');
 lbLog.Items.Append('Попробуйте позднее..');
 end;
 end;

procedure TForm1.N16Click(Sender: TObject);
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
 lbLog.Items.Append('Пробую отключиться...');
  try
  WinExec('rasd.exe',SW_NORMAL);
  except
    lbLog.Items.Append('Ошибка: 777 :** Не могу найти rasd.exe! ***');
    lbLog.Items.Append('Попробуйте просто отключить телефон (модем) от компьютера.');
    lbLog.Items.Append('В появившемся окне об ошибке нажмите "Отмена"');
    lbLog.Items.Append('Сообщите об этой проблеме Системному Администратору.');
    end;
 end else
 begin
 lbLog.Items.Append('Работа с подключениями еще не закончена.');
 lbLog.Items.Append('Попробуйте позднее..');
 end;
 end;


procedure TForm1.N18Click(Sender: TObject);
begin
 PasswordDlg.Visible:=True;
end;

procedure TForm1.N17Click(Sender: TObject);
begin
 if ADMMod then
  begin
    N18.Enabled:=False;
    N19.Enabled:=True;
    N23.Enabled:=True;
  end else
  begin
    N18.Enabled:=True;
    N19.Enabled:=False;
    N23.Enabled:=False;
    end;
end;

procedure TForm1.N19Click(Sender: TObject);
begin
 ADMMod:=False;
end;

procedure TForm1.N22Click(Sender: TObject);
begin
  // Если форму открывали - просто показываем ее впереди.
 Form8.Visible:=True;
 Form8.Show;

 Form8.Timer1.Enabled:=True;
 Form8.VibranMag.Text:='0';
 Form8.Edit1.SetFocus;
 Form8.Button3.Default:=True;
 Form8.Button4.Default:=False;
end;

// Установим минимальный размер формы
procedure TForm1.wmGetMinMaxInfo(var Msg : TMessage);

begin
  PMinMaxInfo(Msg.lParam)^.ptMinTrackSize.X := 855; //W
  PMinMaxInfo(Msg.lParam)^.ptMinTrackSize.Y := 623; //H
end;


procedure TForm1.connecttimerTimer(Sender: TObject);
var i,pcount:integer;
process:TStringList;
begin
 connecttimer.Enabled:=False;
 connecttimer.Interval:=600000;

 pcount:=0;
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 for i:=0 to process.Count-1 do
  if (process[i]='rasc.exe') or (process[i]='rasd.exe') then pcount:=pcount+1;
  if pcount=0 then
 begin
 lbLog.Items.Append('*********************');
 lbLog.Items.Append('Программе необходимо подключиться к интернету.');
 lbLog.Items.Append('Пробую подключиться автоматически..');
  try
  WinExec('rasc.exe',SW_NORMAL);
  except
    lbLog.Items.Append('Ошибка: 666 :** Не могу найти rasc.exe! ***');
    lbLog.Items.Append('Попробуйте подключиться через значек MTS на рабочем столе.');
    lbLog.Items.Append('Сообщите об этой проблеме Системному Администратору.');
    end;
 end;
Sleep(1000);
 end;


procedure TForm1.DisconnectTTimer(Sender: TObject);
var i,pcount:integer;
process:TStringList;
begin
 DisconnectT.Enabled:=False;

 pcount:=0;
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 for i:=0 to process.Count-1 do
  if (process[i]='rasc.exe') or (process[i]='rasd.exe') then pcount:=pcount+1;
  if pcount=0 then
 begin
 lbLog.Items.Append('*********************');
 lbLog.Items.Append('Подключение к Интернету пока не требуется.');
 lbLog.Items.Append('Пробую отключиться автоматически...');
  try
  WinExec('rasd.exe',SW_NORMAL);
  except
    lbLog.Items.Append('Ошибка: 777 :** Не могу найти rasd.exe! ***');
    lbLog.Items.Append('Попробуйте просто отключить телефон (модем) от компьютера.');
    lbLog.Items.Append('В появившемся окне об ошибке нажмите "Отмена"');
    lbLog.Items.Append('Сообщите об этой проблеме Системному Администратору.');
    end;
 end;
 end;

procedure TForm1.N23Click(Sender: TObject);
begin
 ExportDialog.Visible:=True;
 ExportDialog.Show;
end;

procedure TForm1.N24Click(Sender: TObject);
begin
Form10.Timer1.Enabled:=True;
Form10.Visible:=True;
end;

procedure TForm1.N26Click(Sender: TObject);
begin
mailtamrowselect:=1;
Form12.Visible:=True;
Form12.sg1.Row:=1;
Form12.Timer1.Enabled:=True;
end;

procedure TForm1.N27Click(Sender: TObject);
begin
Form14.Visible:=True;
end;

procedure TForm1.p1Click(Sender: TObject);
begin
 if AnsiPos('У Вас имеется',p1.Caption)=1 then
  begin
    mailtamrowselect:=1;
    Form12.Visible:=True;
    Form12.sg1.Row:=1;
    Form12.Timer1.Enabled:=True;
    end;
end;

procedure TForm1.N29Click(Sender: TObject);
begin
Form15.DateTimePicker1.Date:=Date;
Form15.DateTimePicker2.Time:=Time;
Form15.Visible:=True;
Form15.Show;
form15.Timer1.Enabled:=True;
end;

procedure TForm1.N30Click(Sender: TObject);
var f:TextFile;
begin
 try
  AssignFile(f,'getinvent.f');
  Rewrite(f);
  CloseFile(f);
  ShowMessage('Запрос отправлен! Подключитесь к интернету для получения остатков.');
  ShowMessage('Архив с остатками будет помещен в C:\Инвентаризация_<ИмяМагазина>\');
  N30.Enabled:=False;
  except
    ShowMessage('Нет доступа к диску!');
    end;
  end;

procedure TForm1.N31Click(Sender: TObject);
var f:TextFile;
begin
 try
  AssignFile(f,'getdoc.f');
  Rewrite(f);
  CloseFile(f);
  ShowMessage('Запрос отправлен! Подключитесь к интернету для получения документов.');
  ShowMessage('Документы будут помещены в C:\Инвентаризация_<ИмяМагазина>\');
  N31.Enabled:=False;
  except
    ShowMessage('Нет доступа к диску!');
    end;
end;

procedure TForm1.N32Click(Sender: TObject);
begin
 Form19.Visible:=True;
 Form19.Show;
 form19.ComboBox1.Text:='Выбирите тип документа';
 Form19.ComboBox1.Items.Append('ПеремещениеТоваров');
 Form19.ComboBox1.Items.Append('ВводИзлишковТоваров');
 Form19.DateTimePicker1.DateTime:=Date;
 Form19.ListBox1.Clear;
 Form19.LabeledEdit1.Clear;
end;

procedure TForm1.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
with Listbox1 do
  begin

    if Pos('включена',ListBox1.Items.Strings[index])>0 then
        begin
          Canvas.Font.Color := clGreen;
          Canvas.Font.Style:=[fsBold];
          Canvas.Brush.Color := clSkyBlue;
        end;

    if Pos('НЕ ДОСТУПНА',ListBox1.Items.Strings[index])>0 then
        begin
          Canvas.Font.Color := clRed;
          Canvas.Font.Style:=[fsBold];
          Canvas.Brush.Color := clSkyBlue;
        end;

    Canvas.FillRect(Rect);
    Canvas.TextOut(Rect.Left+2, Rect.Top,Items[Index]);
  end;

end;

procedure TForm1.ListBox3DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
with Listbox3 do
  begin

    if (Pos('НЕ ПОДКЛЮЧЕН',ListBox3.Items.Strings[index])=0) or (Pos('ВКЛЮЧЕН',ListBox3.Items.Strings[index])>0) then
        begin
          Canvas.Font.Color := clGreen;
          Canvas.Font.Style:=[fsBold];
          Canvas.Font.Size:=12;
          Canvas.Brush.Color := clSkyBlue;
        end;

    if (Pos('НЕ ПОДКЛЮЧЕН',ListBox3.Items.Strings[index])>0) or (Pos('ВЫКЛЮЧЕН',ListBox3.Items.Strings[index])>0) then
        begin
          Canvas.Font.Color := clRed;
          Canvas.Font.Style:=[fsBold];
          Canvas.Font.Size:=12;
          Canvas.Brush.Color := clSkyBlue;
        end;

    Canvas.FillRect(Rect);
    Canvas.TextOut(Rect.Left+2, Rect.Top,Items[Index]);
  end;
end;

procedure TForm1.N33Click(Sender: TObject);
begin
Form17.Visible:=True;
Form17.Show;
form17.Timer1.Interval:=10;
form17.Timer1.Enabled:=true;
end;

procedure TForm1.TermDKengineTimer(Sender: TObject);
var f:TextFile;
begin
// Перезапуск движка
  try
    AssignFile(f,'restart.bat');
    Rewrite(f);
    Writeln(f,'start /wait taskkill.exe /F /IM dkengine.exe');
    Writeln(f,'start dkengine.exe');
    CloseFile(f);

    WinExec('restart.bat',0);
    except
     end;
end;

end.
