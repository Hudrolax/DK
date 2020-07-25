unit mail2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AxCtrls, OleCtrls, VCF1, ExtCtrls, ZipForge, Gvar, DBF;

type
  TForm13 = class(TForm)
    F1Book1: TF1Book;
    Button1: TButton;
    Timer1: TTimer;
    zp1: TZipForge;
    DBF: TDBF;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form13: TForm13;

implementation

{$R *.dfm}
procedure ClearTable;
var
i,j:Integer;
begin
 Form13.F1Book1.ClearRange(1,1,5000,20,F1ClearAll);
end;

procedure unpack;
begin
   // Открываем БД
    try
     Form13.DBF.TableName:='base\mail_down.dbf';
     Form13.DBF.Exclusive:=false;
     Form13.DBF.Open;
     Form13.DBF.GoToRecord(mailtamrowselect);
   except
     Exit;
     end;
         with form13.zp1 do
      try
      FileName:='mail\download\'+form13.dbf.GetFieldData(1);
      OpenArchive(fmOpenRead);
      BaseDir:=extractfilepath(paramstr(0))+'\temp\';
      ExtractFiles('*.*');
      CloseArchive;
      except
        end;
      // Если не прочитано, то ставим прочитано.  
      if (Form13.DBF.GetFieldData(4)='0') then
       begin
          Form13.DBF.SetFieldData(4,'1');
         Form13.DBF.Post;
       end;

      // Закрываем БД
   try
     Form13.DBF.Close;
     except
       end;
end;

procedure LoadTable;
var k: smallint;
efile:WideString;
i,j:Integer;
begin
  try

    k:=F1FileExcel5;
    efile:='temp\include.xls';
    Form13.F1Book1.Read(efile,k);
    for i:=1 to 15 do
      for j:=1 to 5000 do
    begin
     Form13.F1Book1.SetActiveCell(j,i);//выбираем куда писать
     Form13.F1book1.SetFont('MS Sans Serif',10,false,false,false,false,0,false,false); //выставляем кирилический шрифт
    end;
    except
      end;
end;

procedure DeleteFilesProc;
begin
   DeleteFile('temp\them.txt');
   DeleteFile('temp\text.txt');
   DeleteFile('temp\include.xls');
end;

procedure TForm13.Button1Click(Sender: TObject);
begin
ClearTable;
form13.Visible:=False;
end;

procedure TForm13.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=False;
 ClearTable;
 unpack;
 LoadTable;
 DeleteFilesProc;

end;

procedure TForm13.FormResize(Sender: TObject);
begin
F1Book1.Height:=Form13.Height-59;
F1Book1.Width:=Form13.Width-9;
end;

end.
