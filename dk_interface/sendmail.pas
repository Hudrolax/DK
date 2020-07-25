unit sendmail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, ZipForge, DBF, Gvar;

type
  TForm14 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    RichEdit1: TRichEdit;
    FontDialog1: TFontDialog;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Label3: TLabel;
    Edit1: TEdit;
    Button5: TButton;
    DBF1: TDBF;
    zp1: TZipForge;
    Button6: TButton;
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form14: TForm14;

implementation

{$R *.dfm}

procedure TForm14.Button5Click(Sender: TObject);
begin
ListBox1.Clear;
end;

procedure TForm14.Button6Click(Sender: TObject);
begin
Form14.Visible:=false;
end;

procedure TForm14.N1Click(Sender: TObject);
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

procedure TForm14.Button3Click(Sender: TObject);
var i:Integer;
begin
 ListBox1.Clear;
 for i:=0 to ComboBox1.Items.Count-1 do
   ListBox1.Items.Append(ComboBox1.Items.Strings[ComboBox1.ItemIndex+i]);
end;

procedure TForm14.Button2Click(Sender: TObject);
begin
 ListBox1.DeleteSelected;
end;

procedure TForm14.Button1Click(Sender: TObject);
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


procedure TForm14.Button4Click(Sender: TObject);
var i,j,ntemp:integer;
f:TextFile;
name,gname,adresats:string;
begin
 If ListBox1.Items.Count=0 then
    begin
      ShowMessage('Вы забыли выбрать адресата');
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
   AssignFile(f,'temp\them.txt');
   Rewrite(f);
   Writeln(f,edit1.text);
   CloseFile(f);
   except
     ShowMessage('Не могу записать temp\them.txt');
     end;

   try
   // Записываем сообщение
   RichEdit1.Lines.SaveToFile('temp\text.rtf');
   except
     ShowMessage('Не могу записать temp\text.rtf');
     end;

    // Открываем БД
    try
     Form14.DBF1.TableName:='base\mail_up.dbf';
     Form14.DBF1.Exclusive:=false;
     Form14.DBF1.Open;
     except
     Exit;
     end;

          // Назначаем уникальное имя
     if Form14.DBF1.RecordCount=0 then
     name:='messg00001.zip' else
      begin
       form14.DBF1.Last;
       ntemp:=StrToInt(Copy(form14.DBF1.GetFieldData(1),6,5))+1;
       name:='0000'+inttostr(ntemp);
       name:='messg'+copy(name,Length(name)-4,5)+'.zip';
       end;
       gname:='temp\'+name;
       with Form14.zp1 do
       begin
       FileName:=gname;
       OpenArchive(fmCreate);
       BaseDir:='temp\';
       AddFiles('them.txt');
       AddFiles('text.rtf');
       if FileExists('temp\include.xls') then
          AddFiles('include.xls');
       CloseArchive;
      end;

    if FileExists('temp\'+name) then
      begin
       if CopyFile(PChar('temp\'+name),PChar('mail\upload\'+name),false) then
       begin
       adresats:='';
        for i:=0 to ListBox1.Items.Count-1 do
          adresats:=adresats+listbox1.Items[i]+';';
       Form14.DBF1.Append;
       Form14.DBF1.SetFieldData(1,name);
       Form14.DBF1.SetFieldData(2,GetDateT);
       Form14.DBF1.SetFieldData(4,Edit1.Text);
       Form14.DBF1.SetFieldData(3,'0');
       Form14.DBF1.SetFieldData(5,adresats);
       Form14.DBF1.SetFieldData(6,'0');
       Form14.DBF1.Post;
       DeleteFile('temp\'+name);
       end;

      end;

   //****************************************************************
   // Тут надо вписать процедуру отправки на ФТП
   //****************************************************************

    try
     Form14.DBF1.Close;
    except
    end;


        DeleteFile('temp\them.txt');
       DeleteFile('temp\text.rtf');
       if FileExists('temp\include.xls') then
         DeleteFile('temp\include.xls');
         
        ShowMessage('Сообщение отправлено!');
       RichEdit1.Clear;
//       ListBox1.Clear;
       Edit1.Clear;

end;

end.
