unit Mail_Client;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBF, Gvar, table, ZipForge, Menus, ComCtrls, userenter,
  Clipbrd, upmessage;

type
  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    DBF1: TDBF;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ListBox1: TListBox;
    Button6: TButton;
    Label5: TLabel;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    zp1: TZipForge;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    RichEdit1: TRichEdit;
    PopupMenu1: TPopupMenu;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    FontDialog1: TFontDialog;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure CutText;
var s:String;
begin
 s:=Copy(Form1.RichEdit1.Text,1,Form1.RichEdit1.SelStart);
 s:=s+Copy(Form1.RichEdit1.Text,Form1.RichEdit1.SelStart+Form1.RichEdit1.SelLength+1,Length(Form1.RichEdit1.text));
 form1.RichEdit1.Clear;
 Form1.RichEdit1.Lines.Append(s);
 end;

procedure CopyToBuff;
var s:string;
begin
  s:=Copy(Form1.RichEdit1.Text,form1.RichEdit1.SelStart+1,form1.RichEdit1.SelLength);
 Clipboard.AsText:= s;
end;

procedure CopyFromBuff;
var s:string;
begin
  s:=Clipboard.Astext;
SendMessage(Form1.RichEdit1.Handle, EM_REPLACESEL, 0, integer(PCHAR(s)));

end;


procedure TForm1.FormCreate(Sender: TObject);
var i:integer;
f:textfile;
begin
  // Убираем настройку пользователя если уже настроено 
  If FileExists('user.dat') then
    try
     AssignFile(f,'user.dat');
     Reset(f);
     Readln(f,GlobalUser);
     CloseFile(f);
     except
       ShowMessage('Не могу прочитать user.dat!');
       Close;
      end;

 if not DirectoryExists('temp') then
  CreateDir('temp');

    // Открываем БД магазинов
 try
  Form1.DBF1.TableName:='\\dk99.kopt.org\MS\magaz.dbf';
  Form1.DBF1.Exclusive:=false;
  Form1.DBF1.Open;
 except
   ShowMessage('Не могу получить доступ к БД магазинов');
 end;
 // Заполняем комбо бокс списком магазинов из БД
 try
 for i:=1 to Form1.DBF1.RecordCount do
  begin
   ComboBox1.Items.Add(Form1.DBF1.GetFieldData(1));
   form1.DBF1.Next;
  end;
 except
   ShowMessage('Ошибка доступа к БД: \\dk99.kopt.org\MS\magaz.dbf');
   end;
 // Выставляем первую запись видимой
 if ComboBox1.Items.Count > 0 then
   ComboBox1.ItemIndex := 0;

  // Закрываем БД
 try
   form1.DBF1.Close;
  except
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if OpenDialog1.Execute then
 begin
  FName := OpenDialog1.FileName;
  Label4.Caption:=FName;
 end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 if Label4.Caption<>'Нет' then
    begin
      FName := OpenDialog1.FileName;
      Form2.Visible:=True;
      form2.Timer1.Enabled:=True;
      end else
      ShowMessage('Не выбран файл для вложения!');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
label4.Caption:='Нет';
end;

// Кнопка ОТПРАВИТЬ
procedure TForm1.Button1Click(Sender: TObject);
var i,j,ntemp:integer;
f:TextFile;
name,gname:string;
begin
 if GlobalUser='' then
      begin
      ShowMessage('Вы забыли выбрать магазин для отправки!');
      Exit;
    end;

 If ListBox1.Items.Count=0 then
    begin
      ShowMessage('Вы забыли выбрать магазин для отправки!');
      Exit;
    end;

 If Edit1.Text='' then
    begin
      ShowMessage('Вы забыли вписать Тему сообщения!');
      Exit;
    end;

 If RichEdit1.Lines.Count=0 then
    begin
      ShowMessage('Вы забыли вписать Текст сообщения!!');
      Exit;
    end;

   try
   // Записываем тему
   AssignFile(f,extractfilepath(paramstr(0))+'\temp\them.txt');
   Rewrite(f);
   Writeln(f,edit1.text);
   CloseFile(f);
   except
     ShowMessage('Не могу записать temp\them.txt');
     end;

   try
   // Записываем сообщение
   RichEdit1.Lines.SaveToFile(extractfilepath(paramstr(0))+'\temp\text.rtf');
   except
     ShowMessage('Не могу записать temp\text.rtf');
     end;

   // копируем вложение
   if Label4.Caption<>'Нет' then
    if not CopyFile(PChar(label4.Caption),PChar(extractfilepath(paramstr(0))+'\temp\include.xls'),false) then
      ShowMessage('Не могу скопировать '+label4.Caption+'!! Обратитесь к системному администратору.');

 for i:=0 to ListBox1.Items.Count-1 do
  begin

    // Открываем БД
    try
     Form1.DBF1.TableName:='\\dk99.kopt.org\MS\upload\'+listbox1.Items.Strings[i]+'.dbf';
     Form1.DBF1.Exclusive:=false;
     Form1.DBF1.Open;
     except
     ShowMessage('Не могу открыть БД '+'\\dk99.kopt.org\MS\upload\'+listbox1.Items.Strings[i]+'.dbf');
     Exit;
     end;

          // Назначаем уникальное имя
     if Form1.DBF1.RecordCount=0 then
     name:=ListBox1.Items.Strings[i]+'00001.zip' else
      begin
       form1.DBF1.Last;
       ntemp:=StrToInt(Copy(form1.DBF1.GetFieldData(1),6,5))+1;
       name:='0000'+inttostr(ntemp);
       name:=ListBox1.Items.Strings[i]+copy(name,Length(name)-4,5)+'.zip';
       end;
       gname:=extractfilepath(paramstr(0))+'\temp\'+name;
       with Form1.zp1 do
       begin
       FileName:=gname;
       OpenArchive(fmCreate);
       BaseDir:=extractfilepath(paramstr(0))+'\temp\';
       AddFiles('them.txt');
       AddFiles('text.rtf');
       if FileExists(extractfilepath(paramstr(0))+'\temp\include.xls') then
          AddFiles('include.xls');
       CloseArchive;
      end;

    if FileExists(extractfilepath(paramstr(0))+'\temp\'+name) then
      begin
       if CopyFile(PChar(extractfilepath(paramstr(0))+'\temp\'+name),PChar('\\dk99.kopt.org\MS\upload\'+listbox1.Items.Strings[i]+'\'+name),false) then
       begin
       Form1.DBF1.Append;
       Form1.DBF1.SetFieldData(1,name);
       Form1.DBF1.SetFieldData(2,GetDateT);
       Form1.DBF1.SetFieldData(3,Edit1.Text);
       Form1.DBF1.SetFieldData(4,'0');
       if Label4.Caption='Нет' then
        Form1.DBF1.SetFieldData(5,'0') else
          Form1.DBF1.SetFieldData(5,'1');
       Form1.DBF1.SetFieldData(6,'0');
       Form1.DBF1.SetFieldData(7,GlobalUser);
       Form1.DBF1.Post;
       DeleteFile(extractfilepath(paramstr(0))+'\temp\'+name);
       end;

      end;

    try
     Form1.DBF1.Close;
    except
    end;

 end;
        DeleteFile(extractfilepath(paramstr(0))+'\temp\them.txt');
       DeleteFile(extractfilepath(paramstr(0))+'\temp\text.rtf');
       if FileExists(extractfilepath(paramstr(0))+'\temp\include.xls') then
         DeleteFile(extractfilepath(paramstr(0))+'\temp\include.xls');
         
        ShowMessage('Сообщение отправлено!');
//       RichEdit1.Clear;
       ListBox1.Clear;
//       Edit1.Clear;
       label4.Caption:='Нет';

end;

// Кнопка Удалить
procedure TForm1.Button7Click(Sender: TObject);
begin
 ListBox1.DeleteSelected;
end;

//Кнопка очистить
procedure TForm1.Button8Click(Sender: TObject);
begin
ListBox1.Clear;
end;

// Кнопка Добавить
procedure TForm1.Button6Click(Sender: TObject);
var i:Integer;
est:Boolean;
begin
 // Проверяем нет ли такого уже в списке
est:=False;
if ComboBox1.Items.Strings[ComboBox1.ItemIndex]<>'' then
 for i:=0 to ListBox1.Count-1 do
  if ComboBox1.Items.Strings[ComboBox1.ItemIndex]=ListBox1.Items.Strings[i] then
      begin
      est:=True;
      Break;
      end;

 // Если нет, то вставляем.
if ComboBox1.Items.Strings[ComboBox1.ItemIndex]<>'' then
 if not est then
   ListBox1.Items.Append(ComboBox1.Items.Strings[ComboBox1.ItemIndex]);
end;

// Кнопка ВСЕ
procedure TForm1.Button9Click(Sender: TObject);
var i:integer;
begin
 ListBox1.Clear;
 for i:=0 to ComboBox1.Items.Count-1 do
   ListBox1.Items.Append(ComboBox1.Items.Strings[ComboBox1.ItemIndex+i]);

end;

procedure TForm1.N2Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
if FontDialog1.Execute then
 with RichEdit1.SelAttributes do
  begin
   Color:=FontDialog1.Font.Color;
   Name:=FontDialog1.Font.Name;
   Size:=FontDialog1.Font.Size;
   Style:=FontDialog1.Font.Style;
  end;
RichEdit1.SetFocus;
end;

procedure TForm1.N11Click(Sender: TObject);
begin
OKBottomDlg.Visible:=True;
end;

procedure TForm1.N10Click(Sender: TObject);
begin
 if FileExists('user.dat') then N11.Enabled:=False;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
 SelectRow:=1;
 Form3.Visible:=True;
 Form3.Timer1.Enabled:=True;
end;

procedure TForm1.N8Click(Sender: TObject);
begin
CopyFromBuff;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
CopyToBuff;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
CutText;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
if (Clipboard.Astext='') or (Clipboard.Astext='Clipboard.Astext') then N8.Enabled:=False else N8.Enabled:=True;
end;

end.
