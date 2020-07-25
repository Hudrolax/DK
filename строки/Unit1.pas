unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gvar, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button5: TButton;
    Memo1: TMemo;
    Memo33: TMemo;
    Label1: TLabel;
    Button4: TButton;
    Memo3: TMemo;
    Memo4: TMemo;
    Button6: TButton;
    Timer1: TTimer;
    Memo44: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  // Описываем класс для потока 1
Tproc1 = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;

  // Описываем класс для потока 2
Tproc2 = class(tthread)
private
  { private declarations }
protected
procedure execute; override;
end;

var
  Form1: TForm1;
  proc1end,proc2end:Boolean;
  tproc11:tproc1;
  tproc22:Tproc2;

implementation

{Tproc1}
procedure tproc1.execute;
var i,j:LongInt;
est:Boolean;
begin
 Form1.Memo33.Lines.Clear;
 for i:=0 to Form1.memo3.Lines.Count-1 do
 begin
 est:=False;
 // Смотрим есть ли уже такая запись.

 for j:=0 to Form1.Memo33.Lines.Count-1 do
  begin
   if Form1.Memo33.Lines.Strings[j]=Form1.memo3.Lines.Strings[i] then est:=True;
   end;


 if not est then
 Form1.Memo33.Lines.Append(Form1.Memo3.Lines.Strings[i]);

 end;
 proc1end:=True;
end;

{Tproc2}
procedure tproc2.execute;
var i,j:LongInt;
est:Boolean;
begin
 Form1.Memo44.Lines.Clear;
 for i:=0 to Form1.memo4.Lines.Count-1 do
 begin
 est:=False;
 // Смотрим есть ли уже такая запись.

 for j:=0 to Form1.Memo44.Lines.Count-1 do
  begin
   if Form1.Memo44.Lines.Strings[j]=Form1.memo4.Lines.Strings[i] then est:=True;
   end;


 if not est then
 Form1.Memo44.Lines.Append(Form1.Memo4.Lines.Strings[i]);

 end;
 proc2end:=True;
end;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
s:string;
f,f2:textfile;
begin
 AssignFile(f,'demo.spr');
 AssignFile(f2,'demo2.spr');
 Reset(f);
 Rewrite(f2);
 while not Eof(f) do
 begin
  readln(f,s);
  if Copy(s,1,1)<>'#' then Writeln(f2,s);
  end;
  CloseFile(f);
  CloseFile(f2);
  end;

procedure TForm1.Button2Click(Sender: TObject);
var
s,s2:string;
f,f2:textfile;
i:Integer;
begin

 AssignFile(f,'pos.rep');
 AssignFile(f2,'5.txt');
  Reset(f);
 Rewrite(f2);
 while not Eof(f) do
 begin
  readln(f,s);
  s2:='';
  for i:=1 to length(s) do
  if Copy(s,i,1)<>';' then s2:=s2+Copy(s,i,1) else Break;
  Writeln(f2,s2);
  end;
  CloseFile(f);
  CloseFile(f2);
end;

procedure TForm1.Button5Click(Sender: TObject);
var 
i,j:LongInt;
s:string;
est:Boolean;
modm:LongInt;
begin
 memo1.Lines.Clear;
 Memo3.Lines.Clear;
 Memo4.Lines.Clear;
 Memo1.Lines.LoadFromFile('6.txt');
 modm:=memo1.Lines.Count div 2;
 for i:=0 to modm do
   Memo3.Lines.Append(Memo1.Lines.Strings[i]);

if Memo3.Lines.Strings[Memo3.Lines.Count-1]<>Memo1.Lines.Strings[modm+1] then
 for i:=modm+1 to memo1.Lines.Count-1 do
   Memo4.Lines.Append(Memo1.Lines.Strings[i]) else
 for i:=modm+2 to memo1.Lines.Count-1 do
   Memo4.Lines.Append(Memo1.Lines.Strings[i]);

    tproc11 := tproc1.create(true);
    tproc11.freeonterminate := true;
    tproc11.priority := tpTimeCritical;
    tproc11.Resume;

    tproc22 := tproc2.create(true);
    tproc22.freeonterminate := true;
    tproc22.priority := tpTimeCritical;
    tproc22.Resume;

    Timer1.Enabled:=True;

//for i:=0 to memo1.Lines.Count do
//begin
// est:=False;
// // Смотрим есть ли уже такая запись.
//
// for j:=0 to Memo2.Lines.Count do
//  begin
//   if Memo2.Lines.Strings[j]=memo1.Lines.Strings[i] then est:=True;
//   end;
//
//
// if not est then
// Memo2.Lines.Append(Memo1.Lines.Strings[i]);
//
// end;
// Memo2.Lines.SaveToFile('7.txt');
end;

procedure TForm1.Button4Click(Sender: TObject);
var i:LongInt;
begin
  memo1.Lines.Clear;
 Memo1.Lines.LoadFromFile('7.txt');
 for i:=0 to memo1.Lines.Count-1 do
   if IsDigit(Memo1.Lines.Strings[i+1]) and IsDigit(Memo1.Lines.Strings[i]) then
    if StrToInt(Memo1.Lines.Strings[i])+1<>StrToInt(Memo1.Lines.Strings[i+1]) then
    ShowMessage(Memo1.Lines.Strings[i]);
end;

procedure TForm1.Button6Click(Sender: TObject);
var ff:textfile;
i:integer;
begin
 for i:=64 to 99 do
 begin
 AssignFile(ff,'k02000'+inttostr(i)+'.txt');
 Rewrite(ff);

 CloseFile(ff);
 end;
 end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i:LongInt;
f:textfile;
begin
 if proc1end and proc2end then
 begin
   Timer1.Enabled:=False;
   proc1end:=false;
   proc2end:=false;
    AssignFile(f,'7.txt');
    Rewrite(f);
   for i:=0 to Memo33.Lines.Count-1 do
      Writeln(f,memo33.lines.strings[i]);
   for i:=0 to Memo44.Lines.Count-1 do
      Writeln(f,memo44.lines.strings[i]);
      CloseFile(f);
   end;
end;

end.
