unit prikazi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShlObj, Grids, prikazi2, Gvar, ExtCtrls;

type
  TForm10 = class(TForm)
    Button1: TButton;
    sg1: TStringGrid;
    Button2: TButton;
    LabeledEdit1: TLabeledEdit;
    Button3: TButton;
    Button4: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sg1DblClick(Sender: TObject);
    procedure sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;
  FileList:TStringList;
  myrect:TGridRect;

implementation

{$R *.dfm}
// Эта хрень возвращает пути к папкам по ключам
function GetSpecialPath(CSIDL: word): string;
var s:  string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
  then s := '';
  result := PChar(s);
end;

// Супер процедура поиска
procedure ScanDir(StartDir: string; Mask:string; List:TStrings);
var
  SearchRec : TSearchRec;
begin
 if Mask = '' then Mask := '*.*';
 if StartDir[Length(StartDir)] <>  '\' then StartDir := StartDir + '\';
 if FindFirst(StartDir+Mask, faAnyFile, SearchRec) = 0 then
   begin
     repeat
      Application.ProcessMessages;
       if (SearchRec.Attr and faDirectory) <>  faDirectory then List.Add(SearchRec.Name)
        else
         if (SearchRec.Name <>  '..') and (SearchRec.Name <>  '.') then
           begin
//           List.Add(StartDir + SearchRec.Name + '\');
           ScanDir(StartDir + SearchRec.Name + '\',Mask,List);
           end;
     until FindNext(SearchRec) <>  0;
   FindClose(SearchRec);
   end;
end;

// Процедура заполнения таблицы.
procedure flood;
var i,j:Integer;
f:TextFile;
s:string;
begin
 FileList:=TStringList.Create;
 FileList.Clear;
 ScanDir(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы\','k*.txt',FileList);
 Form10.sg1.RowCount:=1;
 for i:=0 to FileList.Count-1 do
  begin
      if Form10.sg1.RowCount-1<(i+1) then
     Form10.sg1.RowCount:=Form10.sg1.RowCount+1;


   Form10.sg1.Cells[0,i+1]:=IntToStr(i+1);
   AssignFile(f,GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы\'+Filelist[i]);
   Reset(f);
   while not Eof(f) do
    begin
     Readln(f,s);
     if AnsiPos('Приказ № ',s)>0 then
         begin
          Form10.sg1.Cells[1,i+1]:=Copy(s,Pos('Приказ № ',s)+9,8);
          break;
         end;
    end;
    CloseFile(f);

    Reset(f);
   while not Eof(f) do
    begin
     Readln(f,s);
     if AnsiPos(' от ',s)>0 then
         begin
          Form10.sg1.Cells[3,i+1]:=Copy(s,Pos(' от ',s)+4,Pos(' г. В связи',s)-Pos(' от ',s)-3);
          break;
         end;
    end;
    CloseFile(f);
    s:=Copy(FileList[i],1,8);
    Form10.sg1.cells[2,i+1]:=s;
  end;

  FileList.Free;
end;

// Открываем выбранный приказ.
procedure TForm10.Button1Click(Sender: TObject);
begin
   if FileExists(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы\'+sg1.Cells[2,PrikaziArowS]+'.txt') then
  begin
   form11.Memo1.Lines.LoadFromFile(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы\'+sg1.Cells[2,PrikaziArowS]+'.txt');
   Form11.Caption:='Приказ № '+sg1.Cells[1,PrikaziArowS];
   Form11.Visible:=True;
  end;

 end;

// Заполняем заголовки таблицы при открытии формы.
procedure TForm10.FormCreate(Sender: TObject);
begin
 sg1.Cells[0,0]:='№:';
 sg1.Cells[1,0]:='Приказ:';
 sg1.Cells[2,0]:='Поступлен.';
 sg1.Cells[3,0]:='Дата:';
 end;

// Открываем приказ по двойному клику
procedure TForm10.sg1DblClick(Sender: TObject);
begin
  if FileExists(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы\'+sg1.Cells[2,PrikaziArowS]+'.txt') then
  begin
   form11.Memo1.Lines.LoadFromFile(GetSpecialPath(CSIDL_COMMON_DESKTOPDIRECTORY )+'\Приказы\'+sg1.Cells[2,PrikaziArowS]+'.txt');
   Form11.Caption:='Приказ № '+sg1.Cells[1,PrikaziArowS];
   Form11.Visible:=True;
     end;
 end;

// Записываем в глобальную переменную номер выделенной строки
procedure TForm10.sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
   PrikaziArowS:=Arow;
end;

// Поиск в таблице ВВЕРХ
procedure TForm10.Button3Click(Sender: TObject);
var i,j,m:Integer;
begin
 m:=Form10.sg1.Selection.Top;
 for i:=m-1 downto 1 do
    for j:=1 to sg1.ColCount-1 do
      if AnsiPos(LabeledEdit1.Text,sg1.Cells[j,i])>0 then
        begin
         myrect.top:=i;
         myrect.bottom:=i;
         myrect.Right:=10;
         sg1.Selection:=myrect;
         sg1.TopRow:=i;
          end;
end;

// поиск в таблице ВНИЗ
procedure TForm10.Button4Click(Sender: TObject);
var m,i,j:Integer;
begin
 m:=Form10.sg1.Selection.Top;
 for i:=m+1 to sg1.RowCount-1 do
    for j:=1 to sg1.ColCount-1 do
      if AnsiPos(LabeledEdit1.Text,sg1.Cells[j,i])>0 then
        begin
         myrect.top:=i;
         myrect.bottom:=i;
         myrect.Right:=10;
         sg1.Selection:=myrect;
         sg1.TopRow:=i;
          end;
end;

procedure TForm10.Button2Click(Sender: TObject);
begin
form10.Visible:=False;
end;

procedure TForm10.Timer1Timer(Sender: TObject);
begin
 flood;
 Timer1.Enabled:=False;
end;

end.
