unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,WinInet, StdCtrls,Registry,ShellAPI;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TRasConn = record
    Size: DWORD;
    Handle: THandle;
    Name: array[0..20] of AnsiChar;
  end;
  
  TRasEnumConnections = function(var RasConn: TRasConn; var Size: DWORD;
    var Connections: DWORD): DWORD stdcall;
  TRasHangUp = function(Handle: THandle): DWORD stdcall;



var
  Form1: TForm1;
  l:TStringList;

implementation

{$R *.dfm}


function DisconnectDialUp: Boolean;
var
  Lib: HINST;
  RasEnumConnections: TRasEnumConnections;
  RasHangUp: TRasHangUp;
  RasConn: TRasConn;
  Code, Size, Connections: DWORD;
begin
  Result := True;
  try
    Lib := LoadLibrary('rasapi32.dll');
    try
      if Lib = 0 then
        Abort;
      RasEnumConnections := GetProcAddress(Lib, 'RasEnumConnectionsA');
      if not Assigned(@RasEnumConnections) then
        Abort;
      RasHangUp := GetProcAddress(Lib, 'RasHangUpA');
      if not Assigned(@RasHangUp) then
        Abort;
      FillChar(RasConn, SizeOf(RasConn), 0);
      RasConn.Size := SizeOf(RasConn);
      Code := RasEnumConnections(RasConn, Size, Connections);
      if (Connections <> 1) or (Code <> 0) then
        Abort;
      if RasHangUp(RasConn.Handle) <> 0 then
        Abort;
      Sleep(3000);
    finally
      FreeLibrary(Lib);
    end;
  except
    on E: EAbort do
      Result := False;
  else
    raise;
  end;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
if DisconnectDialUp = true then
  ShowMessage('Соединение разорвано')
else
  ShowMessage('Не удалось разорвать соединение');
end;

end.
