unit dkinterface;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, inifiles, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent,
  IdRawBase, IdRawClient, IdIcmpClient, DBF, Gvar, Registry, ComCtrls, ShlObj, shellapi,
  IdTCPConnection, IdTCPClient, Menus, unit2, unit3, Unit4, unit5, Unit6, unit7,
  passdial,nomencl,dialog1,dialog2,DateUtils,prikazi,mail,sendmail,kass_book,unit16;

type
  TForm1 = class(TForm)
    btn1: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lpos1: TLabel;
    lpos2: TLabel;
    lpos3: TLabel;
    lpos4: TLabel;
    GroupBox2: TGroupBox;
    linet: TLabel;
    tmrtermtimer: TTimer;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lp1: TLabel;
    lp2: TLabel;
    lp3: TLabel;
    lp4: TLabel;
    Timer2: TTimer;
    DBF1: TDBF;
    icmp1: TIdIcmpClient;
    icmp2: TIdIcmpClient;
    icmp3: TIdIcmpClient;
    icmp4: TIdIcmpClient;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lz1: TLabel;
    lz2: TLabel;
    lz3: TLabel;
    lz4: TLabel;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    lme: TLabel;
    lmu: TLabel;
    Timer3: TTimer;
    tcp: TIdTCPClient;
    DBF2: TDBF;
    Button1: TButton;
    Label5: TLabel;
    Timer4: TTimer;
    MainMenu1: TMainMenu;
    A1: TMenuItem;
    N1: TMenuItem;
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
    procedure wmGetMinMaxInfo(var Msg : TMessage); message wm_GetMinMaxInfo;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure tmrtermtimerTimer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure icmp1Reply(ASender: TComponent;
      const AReplyStatus: TReplyStatus);
    procedure icmp2Reply(ASender: TComponent;
      const AReplyStatus: TReplyStatus);
    procedure icmp3Reply(ASender: TComponent;
      const AReplyStatus: TReplyStatus);
    procedure icmp4Reply(ASender: TComponent;
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
  npos:Integer;
  tping1:Tping;
  pos01,pos02,pos03,pos04,host:string;
  reg: tregistry;
  repdelta,port,rascount,k:Integer;
implementation

{Tping}
procedure tping.execute;
var ip:integer;
s:string;
begin
  while True do begin
    // Посылаем запрос на 21 порт в интерент (На ФТП обмена) и на каждую кассу.
   try
     try
     s:='';
     Form1.tcp.Host:=host;
     Form1.tcp.Port:=port;
     Form1.tcp.Connect;
     s:=form1.tcp.ReadLn();
     Form1.tcp.Disconnect;
    except
      end;
      // Если ответ от FTP есть
if ansipos('Welcome',s)>0 then
    begin
     Form1.lbl1.Font.Color:=clGreen;
     Form1.linet.Font.Color:=clGreen;
     form1.linet.Caption:='Включен';
     Sleep(10000);
     end else
    begin
     Form1.lbl1.Font.Color:=clRed;
     Form1.linet.Font.Color:=clRed;
     form1.linet.Caption:='НЕ Включен';
    end;
    except
      end;

   // Пинг на кассу 1 по умолчанию
   try
    Form1.icmp1.Host:=pos01;
    Form1.icmp1.TTL:=192;
    Form1.icmp1.Ping;
    sleep(500);
   except
     end;

   // Пинг на кассу 2 если в настройках больше 1 касс
   if npos>1 then
   try
    Form1.icmp2.Host:=pos02;
    Form1.icmp2.TTL:=192;
    Form1.icmp2.Ping;
    sleep(500);
   except
     end;

   // Пинг на кассу 3 если в настройках больше 2 касс
   if npos>2 then
   try
    Form1.icmp3.Host:=pos03;
    Form1.icmp3.TTL:=192;
    Form1.icmp3.Ping;
    sleep(500);
   except
     end;

   // Пинг на кассу 4 если в настройках больше 3 касс
   if npos>3 then
   try
    Form1.icmp4.Host:=pos04;
    Form1.icmp4.TTL:=192;
    Form1.icmp4.Ping;
    sleep(500);
   except
     end;
   Sleep(3000);
 end;
end;

{$R *.dfm}
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
  i,pcount:Integer;
  process:TStringList;
begin
 // Завершам работу, если копия уже запущена
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 for i:=0 to process.Count-1 do
  if process[i]='T_dk_interface.exe' then pcount:=pcount+1;
  if pcount>1 then Application.Terminate;

 if FileExists(GetSystemDir+'\conflict.nls') then Application.Terminate;

 Form1.Caption:='DK Report Interface v.'+FileVersion(Paramstr(0))+' [Шмоточка]';

if not FileExists(GetSpecialPath(CSIDL_COMMON_STARTUP)+'T_dk_interface.lnk') then
    CopyFile(PChar(extractfilepath(paramstr(0))+'\T_dk_interface.lnk'),PChar(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\T_dk_interface.lnk'),false);

// Регистрируем компоненты в системе.
RegisterOfficeComponents;


 try
 Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //создаем файл настроек
  npos:=ini.ReadInteger('POS','NPOS',0);
  pos01:=ini.ReadString('POS','POS01','192.168.0.2');
  pos02:=ini.ReadString('POS','POS02','192.168.0.3');
  pos03:=ini.ReadString('POS','POS03','192.168.0.4');
  pos04:=ini.ReadString('POS','POS04','192.168.0.5');
  host:=ini.ReadString('FTP','Host','ugrus.com');
  port:=ini.ReadInteger('FTP','Port',21);

   Gkass.kass1:=ini.ReadString('Kass','Kass1','ККМ1');
  Gkass.kass2:=ini.ReadString('Kass','Kass2','ККМ2');
  Gkass.kass3:=ini.ReadString('Kass','Kass3','ККМ3');
  Gkass.kass4:=ini.ReadString('Kass','Kass4','ККМ4');

  Ini.Free;
 except
   end;
 if npos>1 then
 begin
   label2.Visible:=True;
   lpos2.Visible:=True;
 end;
  if npos>2 then
 begin
   label3.Visible:=True;
   lpos3.Visible:=True;
 end;
  if npos>3 then
 begin
   label4.Visible:=True;
   lpos4.Visible:=True;
 end;


 // Показываем в мемки содержание файла memo.txt
 try
   Memo1.Lines.LoadFromFile('memo.txt');
   except
     end;

  //Пробуем создать БД кассовой книги
 if not FileExists(Gpath+'base\kassbook.dbf') then
 try
  dbf2.TableName:=Gpath+'base\kassbook.dbf';
  dbf2.AddFieldDefs('kkm',bfString,100,0);
  dbf2.AddFieldDefs('date',bfString,100,0);
  dbf2.AddFieldDefs('time',bfString,100,0);
  dbf2.AddFieldDefs('NO',bfString,100,0);
  dbf2.AddFieldDefs('neobn',bfString,100,0);
  dbf2.AddFieldDefs('vozvrat',bfString,100,0);
  dbf2.AddFieldDefs('inkass',bfString,100,0);
  dbf2.AddFieldDefs('viruchka',bfString,100,0);
  dbf2.AddFieldDefs('tobase',bfString,100,0);
  dbf2.CreateTable;
  DBF2.close;
  except
    ShowMessage('Не могу создать файл base\kassbook.dbf!!!');
    Close;
    end;    

end;

// Процедура запуска потока опроса касс и интернета
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  try
    Timer1.Enabled:=False;
    tping1 := tping.create(true);
    tping1.freeonterminate := true;
    tping1.priority := tplowest;
    tping1.Resume;
    except
    end;
end;


procedure TForm1.tmrtermtimerTimer(Sender: TObject);
begin
if FileExists('terminate.txt') then
begin
  Application.Terminate;
  close;
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var i,j,kolinpos,koltoftp:Integer;

begin
 Timer2.Enabled:=false;
  kolinpos:=0;
  koltoftp:=0;
 // Открываем БД download.dbf
 try
  DBF1.TableName:='base\download.dbf';
  DBF1.Exclusive:=false;
  DBF1.Open;
  except
   end;
  try
  // Вписывам кол-во поступлений
  try
  if DBF1.RecordCount<> 0 then
  lp1.Caption:=IntToStr(DBF1.RecordCount) else lp1.Caption:='0';
  except
    end;
  // Ищем номер последнего поступления
  try
  DBF1.Last;
   if IsDigit(Copy(dbf1.GetFieldData(1),5,4)) then
  lp2.Caption:=inttostr(strtoint(Copy(dbf1.GetFieldData(1),5,4)));
   except
    end;

  // Ищем кол-во загруженных
  try
  if DBF1.RecordCount<>0 then
   DBF1.First;
  for i:=1 to DBF1.RecordCount do
  begin
     for j:=3 to npos+2 do
       if (DBF1.GetFieldData(j)='2') or (DBF1.GetFieldData(j)='3') then
       begin
        kolinpos:=kolinpos+1;
        Break;
       end;
   DBF1.Next;
   end;
  lp3.Caption:=IntToStr(kolinpos);
  except
    end;
  // Ищем количество пропущенных
  try
  lp4.Caption:=inttostr(Abs(StrToInt(lp2.Caption)-StrToInt(lp1.Caption)));
  except
    end;
 except
   end;
 try
  DBF1.Close;
 except
   end;

  // Открываем БД upload.dbf
 try
  DBF2.TableName:='base\upload.dbf';
  DBF2.Exclusive:=false;
  DBF2.Open;
  except
   end;
  // Вписываем количество отчетов
  try
  if DBF2.RecordCount<> 0 then
  lz1.Caption:=IntToStr(DBF2.RecordCount) else lz1.Caption:='0';
  except
    end;
  // Ищем номер последнего поступления
  try
  DBF2.Last;
  if IsDigit(Copy(dbf2.GetFieldData(1),5,4)) then
  lz2.Caption:=inttostr(strtoint(Copy(dbf2.GetFieldData(1),5,4)));
  except
    end;

  // Счетаем кол-во отправленных
  try
    DBF2.First;
      for i:=1 to DBF2.RecordCount do
   begin
       if (DBF2.GetFieldData(3)='1') then
        koltoftp:=koltoftp+1;

    DBF2.Next;
   end;
   lz3.Caption:=IntToStr(koltoftp);
    except
      end;
    // Ищем количество пропущенных
  try
  lz4.Caption:=inttostr(Abs(StrToInt(lz2.Caption)-StrToInt(lz1.Caption)));
  except
    end;
  // Пробуем закрыть DBF
  try
    DBF2.Close;
    except
      end;
  Timer2.Enabled:=True;

    // Отправим автозапрос на кассы
  if Pos('22:20:',Timetostr(time))>0 then AutoZapros;
  Timer2.Enabled:=True;
 end;


procedure TForm1.icmp1Reply(ASender: TComponent;
  const AReplyStatus: TReplyStatus);
begin
 //   Если ответ с кассы 1
   if Form1.icmp1.ReplyStatus.FromIpAddress=pos01 then
    begin
     Form1.lpos1.caption:='Включена!';
     Form1.lpos1.Font.Color:=clGreen;
     end else
    begin
     Form1.lpos1.Caption:='Выключена';
     Form1.lpos1.Font.Color:=clRed;
    end;
end;

procedure TForm1.icmp2Reply(ASender: TComponent;
  const AReplyStatus: TReplyStatus);
begin
  //  Если ответ с кассы 2
     if Form1.icmp2.ReplyStatus.FromIpAddress=pos02 then
    begin
     Form1.lpos2.caption:='Включена!';
     Form1.lpos2.Font.Color:=clGreen;
     end else
    begin
     Form1.lpos2.Caption:='Выключена';
     Form1.lpos2.Font.Color:=clRed;
    end;
end;

procedure TForm1.icmp3Reply(ASender: TComponent;
  const AReplyStatus: TReplyStatus);
begin
    // Если ответ с кассы 3
    if Form1.icmp3.ReplyStatus.FromIpAddress=pos03 then
    begin
     Form1.lpos3.caption:='Включена!';
     Form1.lpos3.Font.Color:=clGreen;
     end else
    begin
     Form1.lpos3.Caption:='Выключена';
     Form1.lpos3.Font.Color:=clRed;
    end;
end;

procedure TForm1.icmp4Reply(ASender: TComponent;
  const AReplyStatus: TReplyStatus);
begin
  //   Если ответ с кассы 4
    if Form1.icmp4.ReplyStatus.FromIpAddress=pos04 then
    begin
     Form1.lpos4.caption:='Включена!';
     Form1.lpos4.Font.Color:=clGreen;
     end else
    begin
     Form1.lpos4.Caption:='Выключена';
     Form1.lpos4.Font.Color:=clRed;
    end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var process:TStringList;
i:Integer;
dke,dku:Boolean;
begin
 Timer3.Enabled:=False;
 dku:=false;
 dke:=false;
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 // Смотрим в процессах и отображаем состояние модулей
 try
  for i:=0 to process.Count-1 do
   if process[i]='T_dkengine.exe' then dke:=True;
 except
   end;

    if dke then
      begin
       lme.Caption:='Включен';
       lme.Font.Color:=clGreen;
      end else
      begin
       lme.Caption:='Выключен';
       lme.Font.Color:=clRed;
       // Если выключен, то пробуем запустить.
       try
        winexec('T_dkengine.exe',0);
         except
           end;

        end;

 for i:=0 to process.Count-1 do
  if process[i]='T_dkrupdater.exe' then dku:=True;

    if dku then
      begin
       lmu.Caption:='Включен';
       lmu.Font.Color:=clGreen;
      end else
      begin
       lmu.Caption:='Выключен';
       lmu.Font.Color:=clRed;

       try
        winexec('T_dkrupdater.exe',0);
         except
           end;
        end;

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
 // Очистка таблиц
 for i:=1 to form3.StringGrid1.RowCount-1 do
  for j:=1 to Form3.StringGrid1.ColCount-1 do
    Form3.StringGrid1.Cells[i,j]:='';

 for i:=1 to form3.StringGrid2.RowCount-1 do
  for j:=1 to Form3.StringGrid2.ColCount-1 do
    Form3.StringGrid2.Cells[i,j]:='';

 for i:=1 to form3.StringGrid3.RowCount-1 do
  for j:=1 to Form3.StringGrid3.ColCount-1 do
    Form3.StringGrid3.Cells[i,j]:='';

 for i:=1 to form3.StringGrid4.RowCount-1 do
  for j:=1 to Form3.StringGrid4.ColCount-1 do
    Form3.StringGrid4.Cells[i,j]:='';

  // Заполнение заголовков
 Form3.StringGrid1.Cells[0,0]:='№';
 Form3.StringGrid1.Cells[1,0]:='П. №';
 Form3.StringGrid1.Cells[2,0]:='Дата';
 Form3.StringGrid1.Cells[3,0]:='Статус';

 Form3.StringGrid2.Cells[0,0]:='№';
 Form3.StringGrid2.Cells[1,0]:='П. №';
 Form3.StringGrid2.Cells[2,0]:='Дата';
 Form3.StringGrid2.Cells[3,0]:='Статус';

 Form3.StringGrid3.Cells[0,0]:='№';
 Form3.StringGrid3.Cells[1,0]:='П. №';
 Form3.StringGrid3.Cells[2,0]:='Дата';
 Form3.StringGrid3.Cells[3,0]:='Статус';

 Form3.StringGrid4.Cells[0,0]:='№';
 Form3.StringGrid4.Cells[1,0]:='П. №';
 Form3.StringGrid4.Cells[2,0]:='Дата';
 Form3.StringGrid4.Cells[3,0]:='Статус';

 Form3.Timer2.Enabled:=True;
 Form3.Visible:=True;
end;

procedure TForm1.N8Click(Sender: TObject);
var i,j:Integer;
begin
 // Очистка таблиц
 for i:=1 to form4.StringGrid1.RowCount-1 do
  for j:=1 to Form4.StringGrid1.ColCount-1 do
    Form4.StringGrid1.Cells[i,j]:='';

 for i:=1 to form4.StringGrid2.RowCount-1 do
  for j:=1 to Form4.StringGrid2.ColCount-1 do
    Form4.StringGrid2.Cells[i,j]:='';

 for i:=1 to form4.StringGrid3.RowCount-1 do
  for j:=1 to Form4.StringGrid3.ColCount-1 do
    Form4.StringGrid3.Cells[i,j]:='';

 for i:=1 to form4.StringGrid4.RowCount-1 do
  for j:=1 to Form4.StringGrid4.ColCount-1 do
    Form4.StringGrid4.Cells[i,j]:='';

  // Заполнение заголовков
 Form4.StringGrid1.Cells[0,0]:='№';
 Form4.StringGrid1.Cells[1,0]:='Дата';
 Form4.StringGrid1.Cells[2,0]:='Статус';

 Form4.StringGrid2.Cells[0,0]:='№';
 Form4.StringGrid2.Cells[1,0]:='Дата';
 Form4.StringGrid2.Cells[2,0]:='Статус';

 Form4.StringGrid3.Cells[0,0]:='№';
 Form4.StringGrid3.Cells[1,0]:='Дата';
 Form4.StringGrid3.Cells[2,0]:='Статус';

 Form4.StringGrid4.Cells[0,0]:='№';
 Form4.StringGrid4.Cells[1,0]:='Дата';
 Form4.StringGrid4.Cells[2,0]:='Статус';
Form4.Timer1.Enabled:=True;
Form4.Visible:=True;
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
 if (FileExists('update\go.txt')) and (linet.Caption='Включен') then
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
   if (FileExists('update\go.txt')) and (linet.Caption<>'Включен') then
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
 if (FileExists('temp\downloading.txt')) and (linet.Caption='Включен') then
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
 if (FileExists('temp\downloading.txt')) and (linet.Caption<>'Включен') then
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
 if (FileExists('temp\downloading_inv.txt')) and (linet.Caption='Включен') then
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
 if (FileExists('temp\downloading_inv.txt')) and (linet.Caption<>'Включен') then
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
 if (FileExists('temp\downloading_doc.txt')) and (linet.Caption='Включен') then
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
 if (FileExists('temp\downloading_doc.txt')) and (linet.Caption<>'Включен') then
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
 if IsDigit(lz3.caption) and IsDigit(lz1.caption) then
 if StrToInt(lz3.Caption)<StrToInt(lz1.Caption) then
    if linet.Caption='Включен' then
    begin
     p1.Caption:='В данный момент отправляются отчеты. Не отключайтесь 10 минут.';
     p1.Font.Color:=clRed;
     p1.Cursor:=crDefault;
     ptimer.Enabled:=true;
      DisconnectT.Enabled:=False;
      DisconnectT.Interval:=300000;
     Exit;
    end else
    begin
     p1.Caption:='Имеются неотправленные отчеты! Подключитесь к Интернету на 10 минут.';
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
 if (linet.Caption='Включен') and (not DisconnectT.Enabled) then
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
 if not Form8.Visible then
 Form8.Visible:=True else Form8.Show;

 Form8.Timer1.Enabled:=True;
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
  ShowMessage('Архив с остатками будет помещен в C:\Инвентаризация_Шмоточка\');
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
  ShowMessage('Документы будут помещены в C:\Инвентаризация_Шмоточка\');
  N31.Enabled:=False;
  except
    ShowMessage('Нет доступа к диску!');
    end;
end;

procedure TForm1.N32Click(Sender: TObject);
begin
 Form16.Visible:=True;
 Form16.Show;
 form16.ComboBox1.Text:='Выбирите тип документа';
 Form16.ComboBox1.Items.Append('ПеремещениеТоваров');
 Form16.ComboBox1.Items.Append('ВводИзлишковТоваров');
 Form16.DateTimePicker1.DateTime:=Date;
 Form16.ListBox1.Clear;
 Form16.LabeledEdit1.Clear;
end;

end.
