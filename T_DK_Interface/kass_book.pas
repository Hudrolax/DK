unit kass_book;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Gvar, ExtCtrls, DBF;

type
  TForm15 = class(TForm)
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label3: TLabel;
    DateTimePicker2: TDateTimePicker;
    Label4: TLabel;
    Edit1: TEdit;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DBF1: TDBF;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    Timer1: TTimer;
    DBF2: TDBF;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var  Form15: TForm15;

implementation

{$R *.dfm}
procedure flood;
var i:integer;
s:string;
begin
Form15.ListBox1.Clear;
Form15.ComboBox1.Clear;
Form15.ComboBox1.Items.Append(Gkass.kass1);
Form15.ComboBox1.Items.Append(Gkass.kass2);
Form15.ComboBox1.Items.Append(Gkass.kass3);
Form15.ComboBox1.Items.Append(Gkass.kass4);

Form15.DateTimePicker1.Date:=Date;
Form15.DateTimePicker2.Time:=Time;
Form15.Edit1.text:='1';
Form15.LabeledEdit1.Text:='0';
Form15.LabeledEdit2.Text:='0';
Form15.LabeledEdit4.Text:='0';
Form15.LabeledEdit5.Text:='0';

  try // Открываем БД
  Form15.dbf1.TableName:=GPath+'base\kassbook.dbf';
  form15.dbf1.Exclusive:=false;
  Form15.DBF1.Open;
 except
   ShowMessage('Не могу открыть БД base\kassbook.dbf');
   try
    Form15.DBF1.Close;
     except
       end;
  Exit;
   end;

 if Form15.DBF1.RecordCount>0 then  
 for i:=1 to Form15.DBF1.RecordCount do
 begin
  s:=Form15.DBF1.GetFieldData(1)+'    '+Form15.DBF1.GetFieldData(2)+' '+Form15.DBF1.GetFieldData(3)+
    '    смена '+Form15.DBF1.GetFieldData(4)+'    Выручка - '+Form15.DBF1.GetFieldData(8);
  Form15.ListBox1.Items.Append(s);


  Form15.DBF1.Next;
  end;

 try
    Form15.DBF1.Close;
     except
       end;
Form15.ListBox1.SetFocus();
Form15.ListBox1.TopIndex:=Form15.ListBox1.Items.Count;
end;

procedure TForm15.Button1Click(Sender: TObject);
begin

 {Чистим форму и закрываем}
ComboBox1.Clear;
ListBox1.Clear;
Edit1.Text:='1';
LabeledEdit1.text:='0';
LabeledEdit2.text:='0';
Form15.Visible:=false;
end;

procedure TForm15.Button2Click(Sender: TObject);
var i:integer;
s:string;
begin
  s:='';
  for i:=1 to Length(LabeledEdit2.text) do
    if LabeledEdit2.Text[i]<>'.' then s:=s+LabeledEdit2.Text[i] else
      s:=s+',';
  LabeledEdit2.Text:=s;

    s:='';
  for i:=1 to Length(LabeledEdit5.text) do
    if LabeledEdit5.Text[i]<>'.' then s:=s+LabeledEdit5.Text[i] else
      s:=s+',';
  LabeledEdit5.Text:=s;

    s:='';
  for i:=1 to Length(LabeledEdit4.text) do
    if LabeledEdit4.Text[i]<>'.' then s:=s+LabeledEdit4.Text[i] else
      s:=s+',';
  LabeledEdit4.Text:=s;

  If ComboBox1.Items.Strings[ComboBox1.ItemIndex]='' then
  begin
    ShowMessage('ККМ не выбрана!');
    Exit;
    end;

 If LabeledEdit2.Text='' then
  begin
    ShowMessage('Выручка не введена!');
    Exit;
    end;

 If not IsSumm(LabeledEdit2.Text) then
  begin
    ShowMessage('Выручка введена НЕ ВЕРНО!');
    Exit;
    end;

  If not IsSumm(LabeledEdit4.Text) then
  begin
    ShowMessage('Сумма возврата введена НЕ ВЕРНО!');
    Exit;
    end;

  If not IsSumm(LabeledEdit5.Text) then
  begin
    ShowMessage('Сумма инкассации введена НЕ ВЕРНО!');
    Exit;
    end;

 try // Открываем БД
  Form15.dbf1.TableName:='base\kassbook.dbf';
  form15.dbf1.Exclusive:=false;
  Form15.DBF1.Open;
 except
   ShowMessage('Не могу открыть БД base\kassbook.dbf');
   try
    Form15.dbf1.Close;
     except
       end;
  Exit;
   end;

 LabeledEdit1.Text:=FloatToStr(StrToFloat(LabeledEdit1.Text)+strtofloat(LabeledEdit2.Text)+strtofloat(LabeledEdit4.Text));

 Form15.DBF1.Append;
 Form15.DBF1.SetFieldData(1,ComboBox1.Items.Strings[ComboBox1.ItemIndex]);
 Form15.DBF1.SetFieldData(2,DateToStr(DateTimePicker1.date));
 Form15.DBF1.SetFieldData(3,TimeToStr(DateTimePicker2.time));
 Form15.DBF1.SetFieldData(4,Edit1.Text);
 Form15.DBF1.SetFieldData(5,LabeledEdit1.Text);
 Form15.DBF1.SetFieldData(6,LabeledEdit4.Text);
 Form15.DBF1.SetFieldData(7,LabeledEdit5.Text);
 Form15.DBF1.SetFieldData(8,LabeledEdit2.Text);
 Form15.DBF1.SetFieldData(9,'0');
 Form15.DBF1.Post;

 try // Закрываем БД
    Form15.DBF1.Close;
     except
       end;

  flood;
end;

procedure TForm15.Timer1Timer(Sender: TObject);
begin
timer1.Enabled:=False;
flood;
end;

procedure TForm15.ComboBox1Select(Sender: TObject);
var i:integer;
begin
 LabeledEdit1.Text:='0';
 Edit1.text:='1';

   try // Открываем БД
  Form15.dbf2.TableName:=GPath+'base\kassbook.dbf';
  form15.dbf2.Exclusive:=false;
  Form15.DBF2.Open;
 except
   ShowMessage('ComboSelect^ Не могу открыть БД base\kassbook.dbf');
   try
    Form15.DBF2.Close;
     except
       end;
  Exit;
   end;
 if Form15.DBF2.RecordCount>0 then
 Form15.DBF2.Last else
 begin
   try
    Form15.DBF2.Close;
     except
       end;
  exit;
 end;
 for i:=Form15.DBF2.RecordCount downto 1 do
  begin
   if form15.DBF2.GetFieldData(1)=ComboBox1.Items.Strings[ComboBox1.ItemIndex] then
    begin
     Edit1.Text:=IntToStr(1+strtoint(DBF2.GetFieldData(4)));
     LabeledEdit1.Text:=DBF2.GetFieldData(5);
     try
      Form15.DBF2.Close;
     except
       end;
     Exit;
      end;

  form15.DBF2.Prior;
  end;


 try
    Form15.DBF2.Close;
     except
       end;
end;

end.
