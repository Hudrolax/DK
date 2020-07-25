unit prikazi2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gvar, ExtCtrls;

type
  TForm11 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    LabeledEdit1: TLabeledEdit;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;
  SPos: integer;

implementation

{$R *.dfm}
// Ненужная процедура, но пусть будет.
procedure setline(Memo1:TMemo; Linenum:integer);
var
  Line, Position: LongInt;
  i, Sum: LongInt;
Begin
   Line := Linenum;      // Номер строки
   Position := 1;  // Позиция курсора

   i := 0;
   Sum := 0;
   while i+1 < Line do
   begin
      Sum := Sum + Length( Memo1.Lines[i] ) + 1;
      i := i + 1;
   end;
   Sum := Sum + Position + Line - 2;
   Memo1.SelStart := Sum;
   Memo1.SetFocus;


end;

// При запуске ставим выделение в 1 по умолчанию
procedure TForm11.FormCreate(Sender: TObject);
begin
PrikaziArowS:=1;
end;

// Закрываем форму
procedure TForm11.Button1Click(Sender: TObject);
begin
Form11.Visible:=False;
end;


// Супер процедура поиска, сам не понимаю как работает.
procedure TForm11.Button3Click(Sender: TObject);
var i:Integer;
est:Boolean;
begin
est:=False;
for i:=0 to memo1.Lines.Count-1 do
  if AnsiPos(AnsiLowerCase(LabeledEdit1.Text),AnsiLowerCase(Memo1.Lines.Strings[i]))>0 then
    est:=True;
if est then
  begin
    // Чисто наугад придумал, хз как работает
  Memo1.SelStart := Pos(AnsiLowerCase(LabeledEdit1.Text),
     AnsiLowerCase(Copy(Memo1.Lines.Text, SPos + 1,
         Length(Memo1.Lines.Text)))) + Spos - 1;
         Memo1.SetFocus;
  if Memo1.SelStart >= Spos
  then begin
     {выделение найденного текста}
     Memo1.SelLength := Length(LabeledEdit1.Text);
     {изменение начальной позиции поиска}
     SPos := Memo1.SelStart + Memo1.SelLength + 1;
   end else
   begin
    ShowMessage('Текст "'+labeledEdit1.Text+'" не найден.');
    spos:=0;
   end;
 end else
    begin
    ShowMessage('Текст "'+labeledEdit1.Text+'" не найден.');
    spos:=0;
   end;
 Button3.Default:=true;
 end;

// При показе формы фокусируемся на поле ввода
procedure TForm11.FormShow(Sender: TObject);
begin
Form11.LabeledEdit1.SetFocus;
end;

// При кликанье мышой обновляем Memo
procedure TForm11.Memo1Click(Sender: TObject);
begin
Memo1.Update;
end;

{Эта процедура реагирует на нажатие кнопок на Memo и если нопка Enter то ищем}
procedure TForm11.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
 if Ord(Key)=VK_Return then
   Button3Click(form11);
end;

end.
