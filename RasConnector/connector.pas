unit connector;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RasClient, TlHelp32;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

    TRasI = record
      name:string;
      i:Integer;
      end;

var
  Form1: TForm1;
  ras:TRASClient;
  rascount,k:Integer;
  RasI:array[0..10] of TRasI;
  connected:Boolean;

implementation

{$R *.dfm}
function GetProcess:TStringList;
const
PROCESS_TERMINATE=$0001;
var
Co:BOOL;
FS:THandle;
FP:TProcessEntry32;
begin
result:=TStringList.Create;
FS:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
FP.dwSize:=Sizeof(FP);
Co:=Process32First(FS,FP);
while integer(Co) <> 0 do
begin
result.Add(FP.szExeFile);
Co:=Process32Next(FS,FP);
end;
CloseHandle(FS);
end;


procedure connect;
var i,j:Integer;
begin
  // Если объекта нет, создадим его.
 if ras=nil then
 try
  ras:=TRASClient.Create(nil);
  except

   end;
 // Очищаем поле лога
  rascount:=-1;
  //Собираем имена всех Dialup и VPN соединений в системе
 for i := 0 to Pred(RAS.Entries.Count) do
    begin
      rascount:=rascount+1;
      RasI[rascount].name:=RAS.Entries[i].Name;
      RasI[rascount].i:=i;
      end;

 Application.ProcessMessages;
 for k:=0 to rascount do
 begin
   connected:=false;
  if k>0 then
    if ras.Entries[RasI[k-1].i].Connected then Continue;

 if RasI[k].i>-1 //если есть к чему коннектиться
 then
  begin
       RAS.Entries[RasI[k].i].GetProperties; // Получим новые сведения о подключении
   // Если нет устройства, то выходим из процедуры.
  if ras.Entries[RasI[k].i].DeviceName='' then
         Continue;


  // Если все Ok - пробуем выполнить соединение.
  if not ras.Entries[RasI[k].i].Connected then
   begin
      // На тот случай, если статус был изменен другой прогой или пользователем:
    Application.ProcessMessages;
   try
   RAS.ClearRasEntriesStatus; // Очищаем статус соединений (подключено / отключено)
   RAS.GetRASEntriesStatus;   // И получаем его снова.
   RAS.Entries[RasI[k].i].Connect; // Коннектимся к выбранному соединению
    for j:=0 to 10 do
      if not RAS.Entries[RasI[k].i].Connected then
        begin
        Sleep(1000);
        Application.Terminate;
        end else Break;
    except
     Application.Terminate;
     end;
   
   end;
  end;

   end;
      // Уничтожим за собой объект.
          try
        ras.free;
       except
         end;
 Application.Terminate;        
end;




procedure TForm1.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=False;
Form1.Visible:=False;
connect;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i,pcount:Integer;
  process:TStringList;
begin
 // Завершам работу, если копия уже запущена
 pcount:=0;
 process:=TStringList.Create;
 process.Clear;
 process:=GetProcess;
 for i:=0 to process.Count-1 do
    if (process[i]='rasc.exe') or (process[i]='rasd.exe') then pcount:=pcount+1;
 if pcount>1 then Application.Terminate;
end;

end.
 