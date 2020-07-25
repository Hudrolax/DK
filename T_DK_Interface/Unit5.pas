unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles, Gvar, ComCtrls;

type
  TForm5 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label5: TLabel;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    DTP1: TDateTimePicker;
    DTP2: TDateTimePicker;
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  npos:Integer;
  ini:TIniFile;

implementation

{$R *.dfm}

procedure TForm5.Button2Click(Sender: TObject);
begin
 label5.Visible:=False;
 form5.Visible:=False;
end;

procedure TForm5.Timer1Timer(Sender: TObject);
begin
 try
   timer1.Enabled:=False;
 Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //создаем файл настроек
  npos:=ini.ReadInteger('POS','NPOS',1);
  Ini.Free;
 except
   end;
end;

procedure TForm5.Button1Click(Sender: TObject);
var
unloadfile:textfile;
i:integer;
begin
  // Если для ВСЕХ
 if CheckBox5.Checked then
 begin
 try
  for i:=1 to npos do begin
   AssignFile(unloadfile,'c:\T_pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<d>');
   Writeln(unloadfile,datetostr(DTP1.Date)+';'+datetostr(DTP2.Date));
   CloseFile(unloadfile);
   Label5.Visible:=True;
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
   AssignFile(unloadfile,'c:\T_pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<d>');
   Writeln(unloadfile,datetostr(DTP1.Date)+';'+datetostr(DTP2.Date));
   CloseFile(unloadfile);
   Label5.Visible:=True;

  except
    end;
 Button1.Enabled:=False;
 end;

  // Для второй кассы
  if CheckBox2.Checked then
 begin
  try
   i:=2;
   AssignFile(unloadfile,'c:\T_pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<d>');
   Writeln(unloadfile,datetostr(DTP1.Date)+';'+datetostr(DTP2.Date));
   CloseFile(unloadfile);
   Label5.Visible:=True;

  except
    end;
 Button1.Enabled:=False;
 end;

  // Для третей кассы
  if CheckBox3.Checked then
 begin
  try
   i:=3;
   AssignFile(unloadfile,'c:\T_pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<d>');
   Writeln(unloadfile,datetostr(DTP1.Date)+';'+datetostr(DTP2.Date));
   CloseFile(unloadfile);
   Label5.Visible:=True;

  except
    end;
 Button1.Enabled:=False;
 end;

  // Для четвертой кассы
  if CheckBox4.Checked then
 begin
  try
   i:=4;
   AssignFile(unloadfile,'c:\T_pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<d>');
   Writeln(unloadfile,datetostr(DTP1.Date)+';'+datetostr(DTP2.Date));
   CloseFile(unloadfile);
   Label5.Visible:=True;

  except
    end;
 Button1.Enabled:=False;
 end;


end;

procedure TForm5.CheckBox5Click(Sender: TObject);
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

procedure TForm5.FormCreate(Sender: TObject);
begin
 DTP2.Date:=Date;
 DTP2.Time:=Time;
end;

end.
