unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Math;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  v:Integer;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var i,j,k,n,x1,x2,x3,x4,x5,x6,x7,x8,x9:LongInt;
est,est2,pov:Boolean;
a:array[1..3,1..3] of Integer;
begin
  for x1:=1 to 9 do
   for x2:=1 to 9 do
    for x3:=1 to 9 do
     for x4:=1 to 9 do
      for x5:=1 to 9 do
       for x6:=1 to 9 do
        for x7:=1 to 9 do
         for x8:=1 to 9 do
          for x9:=1 to 9 do
          begin
           a[1,1]:=x1;
           a[1,2]:=x2;
           a[1,3]:=x3;
           a[2,1]:=x4;
           a[2,2]:=x5;
           a[2,3]:=x6;
           a[3,1]:=x7;
           a[3,2]:=x8;
           a[3,3]:=x9;
           pov:=False;
           for k:=1 to 9 do
           begin
           n:=0;
            for i:=1 to 3 do
             for j:=1 to 3 do
             if a[i,j]=k then n:=n+1;
            if n>1 then pov:=True;
              if pov then Break;
            end;
              if not pov then
              if (a[1,1]+a[1,2]+a[1,3]=a[1,1]+a[2,1]+a[3,1]) and
              (a[1,1]+a[1,2]+a[1,3]=a[2,1]+a[2,2]+a[2,3]) and
              (a[1,1]+a[1,2]+a[1,3]=a[3,1]+a[3,2]+a[3,3]) and
              (a[1,1]+a[1,2]+a[1,3]=a[1,2]+a[2,2]+a[3,2]) and
              (a[1,1]+a[1,2]+a[1,3]=a[1,3]+a[2,3]+a[3,3]) and
              (a[1,1]+a[1,2]+a[1,3]=a[1,1]+a[2,2]+a[3,3]) and
              (a[1,1]+a[1,2]+a[1,3]=a[3,1]+a[2,2]+a[1,3])
            then
            est:=True;
            if est then begin
              for i:=1 to 3 do
                for j:=1 to 3 do
                 StringGrid1.Cells[i-1,j-1]:=IntToStr(a[i,j]);
               v:=v+1;
              Label1.Caption:=IntToStr(v);
              Application.ProcessMessages;
              ShowMessage('Нашли!');
              est:=false;
               end;
            end;







end;

end.
