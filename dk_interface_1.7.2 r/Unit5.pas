unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles, Gvar;

type
  TForm5 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label5: TLabel;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
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
 if IsDigit(Copy(Edit1.Text,1,2)) and (IsDigit(Copy(Edit1.Text,4,2))) and
  IsDigit(Copy(Edit1.Text,7,2)) and (Copy(Edit1.Text,3,1)='.') and (Copy(Edit1.Text,6,1)='.') and
  IsDigit(Copy(Edit2.Text,1,2)) and (IsDigit(Copy(Edit2.Text,4,2))) and
  IsDigit(Copy(Edit2.Text,7,2)) and (Copy(Edit2.Text,3,1)='.') and (Copy(Edit2.Text,6,1)='.') then
 try
  for i:=1 to npos do begin
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<d>');
   Writeln(unloadfile,edit1.text+';'+edit2.text);
   CloseFile(unloadfile);
   Label5.Visible:=True;
  end;
  except
    end else ShowMessage('Формат даты не верен!');
 Button1.Enabled:=False;
  Exit;
 end;

 // Для первой кассы
  if CheckBox1.Checked then
 begin
 if IsDigit(Copy(Edit1.Text,1,2)) and (IsDigit(Copy(Edit1.Text,4,2))) and
  IsDigit(Copy(Edit1.Text,7,2)) and (Copy(Edit1.Text,3,1)='.') and (Copy(Edit1.Text,6,1)='.') and
  IsDigit(Copy(Edit2.Text,1,2)) and (IsDigit(Copy(Edit2.Text,4,2))) and
  IsDigit(Copy(Edit2.Text,7,2)) and (Copy(Edit2.Text,3,1)='.') and (Copy(Edit2.Text,6,1)='.') then
 try
   i:=1;
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<d>');
   Writeln(unloadfile,edit1.text+';'+edit2.text);
   CloseFile(unloadfile);
   Label5.Visible:=True;

  except
    end else ShowMessage('Формат даты не верен!');
 Button1.Enabled:=False;
 end;

  // Для второй кассы
  if CheckBox2.Checked then
 begin
 if IsDigit(Copy(Edit1.Text,1,2)) and (IsDigit(Copy(Edit1.Text,4,2))) and
  IsDigit(Copy(Edit1.Text,7,2)) and (Copy(Edit1.Text,3,1)='.') and (Copy(Edit1.Text,6,1)='.') and
  IsDigit(Copy(Edit2.Text,1,2)) and (IsDigit(Copy(Edit2.Text,4,2))) and
  IsDigit(Copy(Edit2.Text,7,2)) and (Copy(Edit2.Text,3,1)='.') and (Copy(Edit2.Text,6,1)='.') then
 try
   i:=2;
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<d>');
   Writeln(unloadfile,edit1.text+';'+edit2.text);
   CloseFile(unloadfile);
   Label5.Visible:=True;

  except
    end else ShowMessage('Формат даты не верен!');
 Button1.Enabled:=False;
 end;

  // Для третей кассы
  if CheckBox3.Checked then
 begin
 if IsDigit(Copy(Edit1.Text,1,2)) and (IsDigit(Copy(Edit1.Text,4,2))) and
  IsDigit(Copy(Edit1.Text,7,2)) and (Copy(Edit1.Text,3,1)='.') and (Copy(Edit1.Text,6,1)='.') and
  IsDigit(Copy(Edit2.Text,1,2)) and (IsDigit(Copy(Edit2.Text,4,2))) and
  IsDigit(Copy(Edit2.Text,7,2)) and (Copy(Edit2.Text,3,1)='.') and (Copy(Edit2.Text,6,1)='.') then
 try
   i:=3;
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<d>');
   Writeln(unloadfile,edit1.text+';'+edit2.text);
   CloseFile(unloadfile);
   Label5.Visible:=True;

  except
    end else ShowMessage('Формат даты не верен!');
 Button1.Enabled:=False;
 end;

  // Для четвертой кассы
  if CheckBox4.Checked then
 begin
 if IsDigit(Copy(Edit1.Text,1,2)) and (IsDigit(Copy(Edit1.Text,4,2))) and
  IsDigit(Copy(Edit1.Text,7,2)) and (Copy(Edit1.Text,3,1)='.') and (Copy(Edit1.Text,6,1)='.') and
  IsDigit(Copy(Edit2.Text,1,2)) and (IsDigit(Copy(Edit2.Text,4,2))) and
  IsDigit(Copy(Edit2.Text,7,2)) and (Copy(Edit2.Text,3,1)='.') and (Copy(Edit2.Text,6,1)='.') then
 try
   i:=4;
   AssignFile(unloadfile,'c:\pos\pos0'+inttostr(i)+'\unload.flr');
   Rewrite(unloadfile);
   Writeln(unloadfile,'<d>');
   Writeln(unloadfile,edit1.text+';'+edit2.text);
   CloseFile(unloadfile);
   Label5.Visible:=True;

  except
    end else ShowMessage('Формат даты не верен!');
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

end.
