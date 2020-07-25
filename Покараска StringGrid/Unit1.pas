unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function KdnRect(Rect: TRect; DLeft,DTop,DRight,DBottom: Integer): TRect;
begin
With Result do
  begin
   Left:= Rect.Left + DLeft;
   Top:= Rect.Top + DTop;
   Right:= Rect.Right + DRight;
   Bottom:= Rect.Bottom + DBottom;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
i,j:Integer;
begin
 for i:=1 to 5 do
  for j:=1 to 10 do
  StringGrid1.Cells[i,j]:=IntToStr(i+j);
 StringGrid1.Cells[2,5]:='кк33ккк';
  end;


// Процедура вызывается при прорисовки ячейки
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var r: TRect;
  Sprev,s,Spost:string;
  begin
  With Sender as TStringGrid do
  begin
   With Canvas do
    begin
      // Можно закрашивать фон желтым цветом у выделенной ячейки

     if (StringGrid1.Col = ACol) and (StringGrid1.Row = ARow) then
      Brush.Color:= clYellow else Brush.Color := clWhite;
     Font.Color:= clRed; // Цвет текста выводимого
          FillRect(Rect);
    end;

      r:= KdnRect(Rect,2,4,0,0); // Вункция задает нужное смещение
   // А эта хрень рисует текст такой же как в ячейке с заданным смещением
   DrawText(Canvas.Handle, PChar(StringGrid1.Cells[ACol, ARow]),
            Length(StringGrid1.Cells[ACol, ARow]),r,
            DrawTextBiDiModeFlags(DT_LEFT));
   end;



    //   if Pos('33',StringGrid1.Cells[ACol,Arow])=0 then
//   begin
//   Font.Color:= clRed; // Цвет текста выводимого
//   r:= KdnRect(Rect,2,4,0,0); // Вункция задает нужное смещение
//   // А эта хрень рисует текст такой же как в ячейке с заданным смещением
//   DrawText(Canvas.Handle, PChar(StringGrid1.Cells[ACol, ARow]),
//            Length(StringGrid1.Cells[ACol, ARow]),r,
//            DrawTextBiDiModeFlags(DT_LEFT));
//   end else Font.Color:= clBlack;



//    if AnsiPos('33',StringGrid1.Cells[ACol,Arow])>0 then
//      begin
//       sprev:=Copy(s,1,Pos('33',StringGrid1.Cells[ACol,Arow])-1);
//       spost:=Copy(s,Pos('33',StringGrid1.Cells[ACol,Arow]),Length(s)-length('33')-length(Sprev));
//
//         Font.Color:= clBlack;
//          DrawText(Canvas.Handle, PChar(Sprev),
//            Length(Sprev),r,
//            DrawTextBiDiModeFlags(DT_LEFT));
//
//         Font.Color:= clRed;
//          DrawText(Canvas.Handle, PChar('33'),
//            Length('33'),r,
//            DrawTextBiDiModeFlags(DT_LEFT));
//
//         Font.Color:= clBlack;
//          DrawText(Canvas.Handle, PChar(Spost),
//            Length(Spost),r,
//            DrawTextBiDiModeFlags(DT_LEFT));
//      end;

  end;

end.
