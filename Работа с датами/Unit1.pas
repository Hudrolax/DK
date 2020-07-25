unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,DateUtils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    Edit1: TEdit;
    Edit2: TEdit;
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
function SecondsBetweenRound(const ANow, AThen: TDateTime): Int64;
begin
  Result := Round(SecondSpan(ANow, AThen));
end;

procedure TForm1.Button1Click(Sender: TObject);
var s:string;
date1,time1,datetime:string;
datetimet:TDateTime;
begin
 date1:=DateToStr(date);
 time1:=TimeToStr(time);
 datetime:=date1+' '+time1;
 datetimet:=StrToDateTime(datetime);

 if SecondsBetweenRound(datetimet,StrToDateTime(Edit1.Text))>43200 then
ShowMessage('Более 12 часов!');
end;

end.
