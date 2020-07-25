unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles;

type
  TForm6 = class(TForm)
    StaticText1: TStaticText;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Timer1: TTimer;
    procedure CheckBox5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;
  ini:TIniFile;
  npos:Integer;

implementation

{$R *.dfm}

procedure TForm6.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked then
 begin
   CheckBox1.Enabled:=false;
   CheckBox2.Enabled:=false;
   CheckBox3.Enabled:=false;
   CheckBox4.Enabled:=false;
   end else
   begin
     CheckBox1.Enabled:=true;
     CheckBox2.Enabled:=true;
     CheckBox3.Enabled:=true;
     CheckBox4.Enabled:=true;
     end;
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
 label1.Visible:=False;
 form6.Visible:=False;
end;

procedure TForm6.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=False;
 Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //создаем файл настроек
  npos:=ini.ReadInteger('POS','NPOS',1);
  Ini.Free;
end;

procedure TForm6.Button1Click(Sender: TObject);
var
unloadfile:textfile;
i:integer;
begin
  // Если для ВСЕХ
 if CheckBox5.Checked then
 begin
  try
  for i:=1 to npos do begin
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<all>');
   CloseFile(unloadfile);
   Label1.Visible:=True;
  end;
  except
    end;
 Button1.Enabled:=False;
  Exit;
 end;

 // Для первой кассы
  if CheckBox1.Checked then
 begin
  try
   i:=1;
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<all>');
   CloseFile(unloadfile);
   Label1.Visible:=True;

  except
    end;
 Button1.Enabled:=False;
 end;

  // Для второй кассы
  if CheckBox2.Checked then
 begin
  try
   i:=2;
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<all>');
   CloseFile(unloadfile);
   Label1.Visible:=True;

  except
    end;
 Button1.Enabled:=False;
 end;

  // Для третей кассы
  if CheckBox3.Checked then
 begin
  try
   i:=3;
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<all>');
   CloseFile(unloadfile);
   Label1.Visible:=True;

  except
    end;
 Button1.Enabled:=False;
 end;

  // Для четвертой кассы
  if CheckBox4.Checked then
 begin
 try
   i:=4;
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<all>');
   CloseFile(unloadfile);
   Label1.Visible:=True;

  except
    end;
 Button1.Enabled:=False;
 end;

end;

end.
