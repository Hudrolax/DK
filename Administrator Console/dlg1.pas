unit dlg1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gvar, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP;

type
  TForm4 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    ftp: TIdFTP;
    Label2: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button2Click(Sender: TObject);
begin
Form4.Visible:=False;
end;

procedure TForm4.Button1Click(Sender: TObject);
var f:TextFile;
begin
 If MMagaz='' then Exit;

 {Подключаемся к ФТП}
 try
       ftp.Host:='10.10.61.10';
       ftp.Port:=21;
       ftp.Username:='dk';
       ftp.Password:='dk';
       ftp.Connect();
       ftp.ChangeDir(MMagaz);
       except
    ShowMessage('Не могу подключиться к FTP 10.10.61.10 !!!');
       end;

  {Создаем локальную копию флага}
  try
   AssignFile(f,'disconnect.txt');
   Rewrite(f);
   CloseFile(f);
    except
   ShowMessage('Не могу создать файл disconnect.txt !!!');
      end;

  {Кладем файл на ФТП}
  try
  ftp.Put('disconnect.txt','disconnect.txt',false);
  ShowMessage('Запрос на отключение отправлен для магазина '+Mmagaz+'.');
  except
    ShowMessage('Не могу скопировать disconnect.txt на ФТП в папку '+Mmagaz+' !!!')
    end;

  {Удаляем локальную копию флага}
  If not DeleteFile('disconnect.txt') then ShowMessage('Не могу удалить disconnect.txt');

  {Отключаемся от FTP}
  try
   ftp.Disconnect;
    except
    ShowMessage('Не могу отключиться от FTP');
      end;

  Form4.Visible:=False;
end;

end.
