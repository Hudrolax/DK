unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBF, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    DBF1: TDBF;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
i,j:Integer;
name:string;
begin
 for i:=1 to 99 do
  begin
   if length(IntToStr(i))=1 then
   name:='dk00'+inttostr(i) else
   name:='dk0'+inttostr(i);

   if FileExists(name+'.dbf') then
   begin
    try
      DBF1.TableName:=name+'.dbf';
      DBF1.Exclusive:=false;
      DBF1.Open;
    except
    end;
    if DBF1.RecordCount>0 then
    for j:=1 to DBF1.RecordCount do
      begin
      DBF1.Deleted:=True;
      DBF1.Next;
      end;

     try
       DBF1.PackTable;
       except
         end;

     try
     DBF1.Close;
      except
        end;
        end;
  end;
end;

end.
