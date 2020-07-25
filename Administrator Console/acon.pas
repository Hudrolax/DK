unit acon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, DBF, Gvar, IniFiles, Math, Menus, report1,
  dlg1, db, zapros1, zapros2, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, settings;

type
  TForm1 = class(TForm)
    sg1: TStringGrid;
    DBF: TDBF;
    Button1: TButton;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    iv: TLabel;
    ev: TLabel;
    uv: TLabel;
    usv: TLabel;
    ShowTestMag: TCheckBox;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Label8: TLabel;
    PopupMenu1: TPopupMenu;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    DBF2: TDBF;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    Label9: TLabel;
    Edit1: TEdit;
    Label10: TLabel;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ftp: TIdFTP;
    N13: TMenuItem;
    N14: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure N7Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Ttable = record
  n:string;
  mag:string;
  iv:string;
  ev:string;
  uv:string;
  usv:string;
  post:string;
  otch:string;
  comp:string;
  dtime:string;
  dtimer:string;
  end;

  Tmaginfo = record
  phone:string;
  adress:string;
  firm:string;
  end;
var
  Form1: TForm1;
  DKRIV,DKREV,DKRUV,DKRUSV:string;
  ini:TIniFile;
  b:Ttable;
  maginfo:Tmaginfo;
  zp:Boolean;
  TimeInt:integer;

implementation

{$R *.dfm}
procedure flood;
var i,j,k,num,num2,n:Integer;
a:array of Ttable;
begin

 SetLength(a,1);
// Чистим таблицу
 for i:=0 to form1.sg1.ColCount-1 do
    for j:=1 to Form1.sg1.RowCount-2 do
      form1.sg1.Cells[i,j]:='';
      
 Form1.sg1.RowCount:=49; // Установим стандартную длинну

 if GUPDMode='SMB' then
  try // Откроем БД
  Form1.DBF.TableName:='\\'+GSMBServ+'\MS\versiondb.dbf';
  Form1.DBF.Exclusive:=false;
  Form1.DBF.Open;
  except
    Form1.Timer1.Enabled:=False;
    ShowMessage('Не могу подключиться к серверу (SMB)!');
    Exit;
    end
 else
    if GUPDMode='FTP' then
  try // Откроем БД
   Form1.ftp.Host:=GFTPServ;
   Form1.ftp.Port:=GFTPPort;
   Form1.ftp.Username:=GFTPUser;
   Form1.ftp.Password:=GFTPPass;
   Form1.ftp.Connect();
   if Form1.ftp.Connected then
    begin
      Form1.ftp.Get('versiondb.dbf',EXEPath+'temp\versiondb.dbf',false);
      Form1.ftp.Disconnect;
      end;

   if FileExists(EXEPath+'temp\versiondb.dbf') then
    try
      Form1.DBF.TableName:=EXEPath+'temp\versiondb.dbf';
      Form1.DBF.Exclusive:=false;
      Form1.DBF.Open;
    except
      ShowMessage('Не могу открыть БД '+EXEPath+'temp\versiondb.dbf');
    end;
  except
    Form1.Timer1.Enabled:=False;
    ShowMessage('Не могу подключиться к серверу (FTP)!');
    DeleteFile(EXEPath+'temp\versiondb.dbf');
    Exit;
    end;


  k:=1;
   // Заполняем таблицу в массив
  for i:=1 to Form1.DBF.RecordCount do
    begin
     if not Form1.ShowTestMag.checked then
      if Form1.DBF.GetFieldData(1)='dk099' then
        begin
         form1.DBF.Next;
         Continue;
          end;

     if Length(a)<k+1 then SetLength(a,Length(a)+1);

     a[k].n:=inttostr(k);
     a[k].mag:=Form1.DBF.GetFieldData(1);
     a[k].iv:=Form1.DBF.GetFieldData(2);
     a[k].ev:=Form1.DBF.GetFieldData(3);
     a[k].uv:=Form1.DBF.GetFieldData(4);
     a[k].usv:=Form1.DBF.GetFieldData(5);
     a[k].post:=Form1.DBF.GetFieldData(6);
     a[k].otch:=Form1.DBF.GetFieldData(7);
     a[k].comp:=Form1.DBF.GetFieldData(8);
     a[k].dtime:=Form1.DBF.GetFieldData(9);
     a[k].dtimer:=Form1.DBF.GetFieldData(10);

     k:=k+1;
     form1.DBF.Next;
    end;

  try // закрываем БД
   Form1.DBF.Close;
   DeleteFile(EXEPath+'temp\versiondb.dbf');
  except
  end;

  // Далее идет супер сортировка методом пузырька :)
  k:=Length(a)-2;
  for i:=1 to Length(a)-2 do
   begin
    for j:=1 to k do
      begin
       num:=StrToInt(Copy(a[j].mag,3,3));
       num2:=StrToInt(Copy(a[j+1].mag,3,3));
       if num>num2 then
         begin
         b:=a[j+1];
         a[j+1]:=a[j];
         a[j]:=b;
         end;
      end;

   k:=k-1;
   end;

  // Заполняем таблицу из массива
  Form1.sg1.RowCount:=Length(a);

  n:=1;
   {Для Шмотки}
     if form1.CheckBox3.Checked then
       for i:=1 to Length(a)-1 do
        if Pos('dt',a[i].mag)>0 then
         begin
          Form1.sg1.Cells[0,n]:=IntToStr(n);
          Form1.sg1.Cells[1,n]:=a[i].mag;
          Form1.sg1.Cells[2,n]:=a[i].iv;
          Form1.sg1.Cells[3,n]:=a[i].ev;
          Form1.sg1.Cells[4,n]:=a[i].uv;
          Form1.sg1.Cells[5,n]:=a[i].usv;
          Form1.sg1.Cells[6,n]:=a[i].post;
          Form1.sg1.Cells[7,n]:=a[i].otch;
          Form1.sg1.Cells[8,n]:=a[i].comp;
          Form1.sg1.Cells[9,n]:=a[i].dtimer;
          Form1.sg1.Cells[10,n]:=a[i].dtime;
          n:=n+1;
         end;

    {Для Колбасы}
     if form1.CheckBox2.Checked then
       for i:=1 to Length(a)-1 do
        if Pos('dk',a[i].mag)>0 then
         begin
          Form1.sg1.Cells[0,n]:=IntToStr(n);
          Form1.sg1.Cells[1,n]:=a[i].mag;
          Form1.sg1.Cells[2,n]:=a[i].iv;
          Form1.sg1.Cells[3,n]:=a[i].ev;
          Form1.sg1.Cells[4,n]:=a[i].uv;
          Form1.sg1.Cells[5,n]:=a[i].usv;
          Form1.sg1.Cells[6,n]:=a[i].post;
          Form1.sg1.Cells[7,n]:=a[i].otch;
          Form1.sg1.Cells[8,n]:=a[i].comp;
          Form1.sg1.Cells[9,n]:=a[i].dtimer;
          Form1.sg1.Cells[10,n]:=a[i].dtime;
          n:=n+1;
         end;

 if form1.sg1.RowCount<48 then Form1.sg1.RowCount:=48;
  SetLength(a,0);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
 EXEPath:=extractfilepath(paramstr(0));
 sg1.Cells[0,0]:='№:';
 sg1.Cells[1,0]:='Магазин:';
 sg1.Cells[2,0]:='Interface V.:';
 sg1.Cells[3,0]:='Engine V.:';
 sg1.Cells[4,0]:='Updater V.:';
 sg1.Cells[5,0]:='UPDScript V.:';
 sg1.Cells[6,0]:='Поступлений:';
 sg1.Cells[7,0]:='Отчетов:';
 sg1.Cells[8,0]:='Имя компа:';
 sg1.Cells[9,0]:='Сеанс реальный:';
 sg1.Cells[10,0]:='Сеанс по буку:';

 //Подгружаем настройки
 try
  Ini:=TiniFile.Create(EXEPath+'config.ini'); //создаем файл настроек
  TimeInt:= ini.ReadInteger('Base','updtime',10);
  GUPDMode:= ini.ReadString('Base','UpdMode','SMB');
  GSMBServ:= Ini.ReadString('Base','SMBServer','dk99');
  GFTPServ:= Ini.ReadString('Base','FTPServer','dk99');
  GFTPPort:= Ini.ReadInteger('Base','FTPPort',21);
  GFTPUser:= Ini.ReadString('Base','FTPUser','ac');
  GFTPPass:= Ini.ReadString('Base','FTPPass','ac');
  Ini.Free;
  Edit1.Text:=IntToStr(TimeInt);
  except
    ShowMessage('Не могу загрузить настройки из config.ini');
     //если нет файла настроек, то создаем его
   try
   if not FileExists(EXEPath+'config.ini') then begin
    Ini:=TiniFile.Create(EXEPath+'config.ini'); //создаем файл настроек
    Ini.WriteInteger('Base','updtime',10);
    Ini.WriteString('Base','UpdMode','SMB');
    Ini.WriteString('Base','SMBServer','dk99');
    Ini.WriteString('Base','FTPServer','dk99');
    Ini.WriteInteger('Base','FTPPort',21);
    Ini.WriteString('Base','FTPUser','ac');
     Ini.WriteString('Base','FTPPass','ac');
     Ini.Free;
    end;
    except
    ShowMessage('Не могу записать файл настроек config.ini');
    end;
    end;
  if GUPDMode='SMB' then
  try
  Ini:=TiniFile.Create('\\'+GSMBServ+'\MS\versions.ini'); //создаем файл настроек
  DKRIV:=ini.ReadString('DKR','DKRI','');
  DKREV:=ini.ReadString('DKR','DKRE','');
  DKRUV:=ini.ReadString('DKR','DKRU','');
  DKRUSV:=ini.ReadString('DKR','DKRUS','');
  Ini.Free;
  except
    ShowMessage('Не могу получить файл настроек!');
    end;
    Timer1.Enabled:=True;
  iv.Caption:=DKRIV;
  ev.Caption:=DKREV;
  uv.Caption:=DKRUV;
  usv.Caption:=DKRUSV;

  Form1.Caption:='DK Report Administrator Console v.'+FileVersion(Paramstr(0));
 MMagaz:='dk001';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
selected:integer;
begin
 if not zp then
  begin
   Timer1.Interval:=TimeInt*1000;
   zp:=True;
    end;
if Form1.Showing then

selected:=sg1.Selection.Top;
flood;
sg1.Row:= selected;
//if sg1.RowCount > sg1.VisibleRowCount then
//sg1.TopRow := sg1.RowCount - sg1.VisibleRowCount;
//sg1.Row := sg1.RowCount - 1;

end;

procedure TForm1.sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  // Прорисовываем заголовки таблицы
  if (ARow=0) then
  with sg1 do
  begin
   Canvas.Font.Color:=clBlue;
   Canvas.Font.Style:=[fsBold];
   Canvas.TextOut(Rect.Left+2,Rect.Top+2,sg1.Cells[Acol,Arow]);
   Exit;
   end;

 if ARow<>0 then
 if sg1.Cells[9,Arow]<>'' then
   if (SecondsBetweenRound(StrToDateTime(GetDateT),StrToDateTime(sg1.Cells[9,Arow]))<300) and (sg1.Cells[5,Arow]<>'') then
     Begin
      sg1.Canvas.Brush.Color:=clYellow;
      sg1.Canvas.FrameRect(Rect);
      Exit;
      // Все ОК
      end;


if CheckBox1.Checked then
if ARow<>0 then
 if sg1.Cells[1,Arow]<>'' then
  if sg1.Cells[2,Arow]<>'' then
   if sg1.Cells[3,Arow]<>'' then
    if sg1.Cells[4,Arow]<>'' then
  if (sg1.Cells[2,ARow]<>DKRIV) or (sg1.Cells[3,ARow]<>DKREV) or (sg1.Cells[4,ARow]<>DKRUV)  then
     Begin
       // Старая версия ПО
      sg1.Canvas.Brush.Color:=clBlue;
      sg1.Canvas.FrameRect(Rect);
      Exit;
      end;

if ARow<>0 then
 if sg1.Cells[9,Arow]<>'' then
   if (SecondsBetweenRound(StrToDateTime(GetDateT),StrToDateTime(sg1.Cells[9,Arow]))<86400) and (sg1.Cells[5,Arow]<>'') then
     Begin
      sg1.Canvas.Brush.Color:=clGreen;
      sg1.Canvas.FrameRect(Rect);
      Exit;
      // Все ОК
      end;

if ARow<>0 then
 if sg1.Cells[9,Arow]<>'' then
   if (SecondsBetweenRound(StrToDateTime(GetDateT),StrToDateTime(sg1.Cells[9,Arow]))>86400) and (SecondsBetweenRound(StrToDateTime(GetDateT),StrToDateTime(sg1.Cells[9,Arow]))<172800) and (sg1.Cells[5,Arow]<>'') then
     Begin
       // Более 24 часов
      sg1.Canvas.Brush.Color:=$000086FF;
      sg1.Canvas.FrameRect(Rect);
      Exit;
      end;

if ARow<>0 then
 if sg1.Cells[9,Arow]<>'' then
   if (SecondsBetweenRound(StrToDateTime(GetDateT),StrToDateTime(sg1.Cells[9,Arow]))>172800) and (sg1.Cells[5,Arow]<>'') then
     Begin
       // Более 48 часов
      sg1.Canvas.Brush.Color:=clRed;
      sg1.Canvas.FrameRect(Rect);
      Exit;
      end;

end;

procedure TForm1.N2Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
 Form2.Visible:=True;
 Form2.Show;
 form2.Timer1.Enabled:=True;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
if MMagaz<>'' then
begin
 form4.Label2.Caption:='Отключить магазин '+Mmagaz+'?';
 Form4.Visible:=True;
 Form4.Show;
end;
end;




procedure TForm1.sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 MMagaz:=sg1.Cells[1,Arow];
end;

procedure TForm1.N7Click(Sender: TObject);
begin
 if GUPDMode='SMB' then
  begin
    form5.Visible:=True;
    Form5.Show;
    Form5.Timer1.Enabled:=True;
  end
  else
    ShowMessage('Функция доступна только в SMB режиме!');
end;

procedure TForm1.N9Click(Sender: TObject);
var i,j:integer;
s,ss:string;
begin
 s:='';
 ss:='';
 maginfo.phone:='';
 maginfo.adress:='';
 maginfo.firm:='';
  If GUPDMode='SMB' then
   try // Откроем БД
  Form1.DBF.TableName:='\\'+GSMBServ+'\MS\telephone.dbf';
  Form1.DBF.Exclusive:=true;
  Form1.DBF.Open;
  except
    ShowMessage('Не могу подключиться к серверу!');
    Exit;
    end
    else
      ShowMessage('Функция доступна только в SMB режиме.');

 try
   for i:=1 to Form1.DBF.RecordCount do
    begin
     if Form1.DBF.GetFieldData(1)=MMagaz then
       begin
        for j:=1 to Form1.DBF.FieldCount do
          begin
          ss:=Form1.DBF.GetFieldData(j);
          if j=2 then maginfo.phone:=ss else
            if j=3 then maginfo.adress:=ss else
              if j=4 then maginfo.firm:=ss;
          end;
        Break;
        end;
    Form1.DBF.Next;
      end;

 except
 end;

  try
    Form1.DBF.Close;
  except
  end;
  ShowMessage('Магазин: '+Mmagaz+#13#10+'Телефон: '+maginfo.phone+#13#10+'Адрес: '+maginfo.adress+#13#10+'Фирма: '+maginfo.firm);
end;

{Запрос выгрузки по датам}
procedure TForm1.N11Click(Sender: TObject);
begin
Form6.Visible:=True;
Form6.Show;
Form6.DateTimePicker2.Date:=Date;
Form6.CheckBox1.Checked:=False;
Form6.CheckBox2.Checked:=False;
Form6.CheckBox3.Checked:=False;
Form6.CheckBox4.Checked:=False;
Form6.Label2.Caption:=MMagaz;
end;

{Запрос полной выгрузки}
procedure TForm1.N12Click(Sender: TObject);
begin
Form7.Visible:=True;
Form7.Show;
Form7.CheckBox1.Checked:=False;
Form7.CheckBox2.Checked:=False;
Form7.CheckBox3.Checked:=False;
Form7.CheckBox4.Checked:=False;
Form7.Label2.Caption:=MMagaz;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
Button2.Enabled:=True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 if not IsDigit(Edit1.Text) then
  begin
   ShowMessage('Введеный интервал не верен!');
   Exit;
    end;

  if StrToInt(Edit1.Text)<1 then
  begin
   ShowMessage('Интервал слишком мал Йопт!!');
   Exit;
    end;


  try
   Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //создаем файл настроек
   Ini.WriteInteger('Base','updtime',StrToInt(Edit1.Text));
   Ini.Free;
  except
    ShowMessage('Не могу записать файл настроек config.ini');
    end;

 Timer1.Interval:=StrToInt(Edit1.Text)*1000;
 Button2.Enabled:=false;

  if (StrToInt(Edit1.Text)=1) or (StrToInt(Edit1.Text)=21) or (StrToInt(Edit1.Text)=31) or (StrToInt(Edit1.Text)=41) or (StrToInt(Edit1.Text)=51)then
 begin
 ShowMessage('Интервал обновления выставлен на '+Edit1.Text+' секунду.' );
 Exit;
 end;

 if (StrToInt(Edit1.Text)>1) and (StrToInt(Edit1.Text)<5) then
 begin
 ShowMessage('Интервал обновления выставлен на '+Edit1.Text+' секунды.' );
 Exit;
 end;

  if (StrToInt(Edit1.Text)>4) and (StrToInt(Edit1.Text)<21) then
 begin
 ShowMessage('Интервал обновления выставлен на '+Edit1.Text+' секунд.' );
 Exit;
 end;

  if StrToInt(Edit1.Text)>21 then
 begin
 ShowMessage('Интервал обновления выставлен на '+Edit1.Text+' секунды.' );
 Exit;
 end;

end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
flood;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
flood;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
flood;
end;

procedure TForm1.N14Click(Sender: TObject);
begin
 Form8.Visible:=True;
 Form8.Show;
 Form8.Timer1.Enabled:=True;
end;

end.
