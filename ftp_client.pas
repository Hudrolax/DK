unit ftp_client;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP, ZipForge, DBF, Grids;

type
  TForm1 = class(TForm)
    ftp: TIdFTP;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button2: TButton;
    zp1: TZipForge;
    dbf: TDBF;
    strngrd1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  flist:TStringList;


implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//если уже соединено, то отключаемся.
if ftp.Connected
 then
  try
   ftp.Abort;
   ftp.Quit;
  except
  //пишем лог ошибок
  end;
 //пробуем подключиться. 
 try
  ftp.Host:=edit1.Text;
  ftp.Username:=edit2.Text;
  ftp.Password:=edit3.Text;
  ftp.Connect();
  ftp.ChangeDir('/dk001');
  showmessage('Получилось');
  button2.Enabled:=true;
 except
  showmessage('СБой подключения');
  button2.Enabled:=false;
 end;
end;


procedure TForm1.Button2Click(Sender: TObject);
var i:Integer;
p:Integer;
s:string;
begin
flist:=TStringList.Create;
ftp.List(flist);
for i:=0 to flist.Count-1 do
if Ansipos('.flg',flist.Strings[i])<>0 then begin
p:=Ansipos('.flg',flist.Strings[i]);
s:=Copy(flist.Strings[i],p-8,12);
ShowMessage(s);
 end;
 ShortDateFormat:='ddmmyy';
 dbf.TableName:='base\download.dbf';
 dbf.Exclusive:=false;
 dbf.Open;
 dbf.Append;
 dbf.SetFieldData(1,s);
 dbf.SetFieldData(2,DateToStr(date));
 dbf.SetFieldData(3,'False');
 dbf.Post;
 dbf.Close;
for i:=0 to flist.Count do
if AnsiPos('.flg',flist.Strings[i])<>0 then
ShowMessage(flist.Strings[i]);

// if NOT fileexists('c:\3\demo.zip') then begin
// //пробуем скачать файл
// try
// ftp.Get('demo.zip','c:\3\demo.zip',false,true);
// except
// showmessage('файла demo.zip нет');
// end;
//
// //если скачали, удаляем с фтп.
// if fileexists('c:\3\demo.zip') then
//    try
//    ftp.Delete('demo.zip');
//    except
//    showmessage('не удается удалить файл');
//    end;
//  ftp.Disconnect;
// end else
// showmessage('файл уже есть');
//
// if fileexists('c:\3\demo.zip') then
//  try
//  with zp1 do
//  begin
//  FileName:='c:\3\demo.zip';
//  OpenArchive(fmOpenRead);
//  BaseDir:='c:\3\1';
//  ExtractFiles('*.*');
//  CloseArchive;
//  DeleteFile('c:\3\demo.zip');
//  end
//  except
//    end;
end;

end.
