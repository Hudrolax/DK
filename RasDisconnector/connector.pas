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


procedure Disconnect;
var i:Integer;
begin
 try
     // Если объекта нет, создадим его.
  if ras=nil then
  try
   ras:=TRASClient.Create(nil);
  except
    Application.Terminate;
   end;

   RAS.ClearRasEntriesStatus; //Очищаем статус соединений (подключено / отключено)
   RAS.GetRASEntriesStatus; // И получаем его снова.
    // Разрываем все установленные соединения
   for i := 0 to Pred(RAS.Entries.Count) do
      try
      RAS.Entries[i].Disconnect;
      except
        end;
   ras.free;
  except
    end;
  Application.Terminate;
end;



procedure TForm1.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=False;
Form1.Visible:=False;
Disconnect;
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
 
