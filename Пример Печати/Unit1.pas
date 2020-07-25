unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Printers, StdCtrls, RpRenderPreview, RpRender, RpRenderCanvas,
  RpRenderPrinter, RpDefine, RpRave, RpBase, RpSystem, RvCsStd, RvClass, RvProj;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    RvProject1: TRvProject;
    RvRenderPrinter1: TRvRenderPrinter;
    RvRenderPreview1: TRvRenderPreview;
    RvSystem1: TRvSystem;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  rvMem:TRaveMemo;
rvPage: TRavePage;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var TovName:String;
Begin
 RvProject1.Open;
 RvProject1.SelectReport('Report1',false);
 TovName:= 'Голд Классик 0,95';

  rvPage := RvProject1.ProjMan.FindRaveComponent('Report1.Page1', nil) as TRavePage;
  rvMem := RvProject1.ProjMan.FindRaveComponent('DataMemo1', rvPage) as TRaveMemo;
  rvMem.Font.Size:=20;

  if Length(TovName)>18 then
    rvMem.Font.Size:=18;

  if Length(TovName)>30 then
    rvMem.Font.Size:=16;

 RvProject1.SetParam('Name',TovName);
 RvProject1.SetParam('Prikaz','k0350678');
 RvProject1.SetParam('Bar','9000002536171');
 RvProject1.SetParam('Kod','253 617');
 RvProject1.SetParam('Cena','32-50');
 RvProject1.SetParam('Data',Datetostr(Date));
 RvProject1.ExecuteReport('Report1');
 RvProject1.Close;
end;

procedure PrintT(List)
begin
  Po9 := list.count div 9;
  for i:=1 to 9 do
    begin
     RvProject1.Open;
     RvProject1.SelectReport('Report1',false);
     for j:=1 to 9 do
      begin
        RvProject1.SetParam('Name'+inttostr(j),TovName);
        RvProject1.SetParam('Prikaz','k0350678');
        RvProject1.SetParam('Bar','9000002536171');
        RvProject1.SetParam('Kod','253 617');
        RvProject1.SetParam('Cena','32-50');
        RvProject1.SetParam('Data',Datetostr(Date));
      end;
     RvProject1.ExecuteReport('Report1');
     RvProject1.Close;
         end;
end;

end.
