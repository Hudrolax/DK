unit dkinterface;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, inifiles, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent,
  IdRawBase, IdRawClient, IdIcmpClient, DBF, Gvar, Registry, ComCtrls, ShlObj, shellapi,
  IdTCPConnection, IdTCPClient, Menus, unit2, unit3, Unit4, unit5, Unit6, unit7;

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
  repdelta,port:Integer;
implementation
{Tping}
procedure tping.execute;
var ip:integer;
s:string;
begin
  while True do begin
    // Посылаем запрос на 21 порт в интерент (81.26.128.170 ) и на каждую кассу.
   try
     try
     s:='';
     Form1.tcp.Host:='81.26.128.170';
     Form1.tcp.Port:=21;
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

function GetSpecialPath(CSIDL: word): string;
var s:  string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
  then s := '';
  result := PChar(s);
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
  if process[i]='dk_interface.exe' then pcount:=pcount+1;
  if pcount>1 then Application.Terminate;


if not FileExists(GetSpecialPath(CSIDL_COMMON_STARTUP)+'dk_interface.lnk') then
    CopyFile(PChar(extractfilepath(paramstr(0))+'\dk_interface.lnk'),PChar(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\dk_interface.lnk'),false);

 try
 Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //создаем файл настроек
  npos:=ini.ReadInteger('POS','NPOS',0);
  pos01:=ini.ReadString('POS','POS01','192.168.0.2');
  pos02:=ini.ReadString('POS','POS02','192.168.0.3');
  pos03:=ini.ReadString('POS','POS03','192.168.0.4');
  pos04:=ini.ReadString('POS','POS04','192.168.0.5');
  host:=ini.ReadString('FTP','Host','ugrus.com');
  port:=ini.ReadInteger('FTP','Port',21);
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
 dku:=false;
 dke:=false;
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 // Смотрим в процессах и отображаем состояние модулей
 try
  for i:=0 to process.Count-1 do
   if process[i]='dkengine.exe' then dke:=True;
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
        end;

 for i:=0 to process.Count-1 do
  if process[i]='dkrupdater.exe' then dku:=True;

    if dku then
      begin
       lmu.Caption:='Включен';
       lmu.Font.Color:=clGreen;
      end else
      begin
       lmu.Caption:='Выключен';
       lmu.Font.Color:=clRed;
        end;

  process.Destroy;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
unloadfile:textfile;
i:integer;
begin
 try
  for i:=1 to npos do begin
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   CloseFile(unloadfile);
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
unloadfile:textfile;
i:integer;
begin
 try
  for i:=1 to npos do begin
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   CloseFile(unloadfile);
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

end.
