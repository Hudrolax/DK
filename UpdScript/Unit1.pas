unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ZipForge, ShlObj;

type
  TForm1 = class(TForm)
    tmr1: TTimer;
    zp1: TZipForge;
    Timer1: TTimer;
    procedure tmr1Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
    function GetSpecialPath(CSIDL: word): string;
var
  Form1: TForm1;

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

procedure process;
begin
  if FileExists(extractfilepath(paramstr(0))+'update\newversion.zip') then
  try
    // Распаковываем архив
           with Form1.zp1 do
           begin
            FileName:=extractfilepath(paramstr(0))+'update\newversion.zip';
            OpenArchive(fmOpenRead);
            BaseDir:=extractfilepath(paramstr(0));
            ExtractFiles('*.*');
            CloseArchive;
            end;
   // Удаляем архив с обновлением
           DeleteFile(extractfilepath(paramstr(0))+'update\newversion.zip');
           DeleteFile(extractfilepath(paramstr(0))+'goupdate.txt');
           DeleteFile(extractfilepath(paramstr(0))+'update\go.txt');

   // Восстанавливаем из бекапа модули, если их небыло в обновлении.        
   if not FileExists(extractfilepath(paramstr(0))+'dk_interface.exe') then
    RenameFile(extractfilepath(paramstr(0))+'dk_interface.exe_',extractfilepath(paramstr(0))+'dk_interface.exe');

   if not FileExists(extractfilepath(paramstr(0))+'dkengine.exe') then
    RenameFile(extractfilepath(paramstr(0))+'dkengine.exe_',extractfilepath(paramstr(0))+'dkengine.exe');

   if not FileExists(extractfilepath(paramstr(0))+'dkrupdater.exe') then
    RenameFile(extractfilepath(paramstr(0))+'dkrupdater.exe_',extractfilepath(paramstr(0))+'dkrupdater.exe');

    // Стартуем все модули
   if FileExists(extractfilepath(paramstr(0))+'dkengine.exe') then
      WinExec(PChar(extractfilepath(paramstr(0))+'dkengine.exe'),SW_NORMAL);

   if FileExists(extractfilepath(paramstr(0))+'dkrupdater.exe') then
      WinExec(PChar(extractfilepath(paramstr(0))+'dkrupdater.exe'),SW_NORMAL);

   if FileExists(extractfilepath(paramstr(0))+'dk_interface.exe') then
      WinExec(PChar(extractfilepath(paramstr(0))+'dk_interface'),SW_NORMAL);

    // Удаляем себя из автозагрузки
   DeleteFile(GetSpecialPath(CSIDL_COMMON_STARTUP)+'\updscript.lnk');
   Application.Terminate;

    except
          end;
       
  end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
 tmr1.Enabled:=False;
 Timer1.Enabled:=True;
 Form1.Visible:=False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  process;
  Timer1.Enabled:=True;
end;

end.
