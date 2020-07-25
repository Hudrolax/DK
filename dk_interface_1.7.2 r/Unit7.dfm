object Form7: TForm7
  Left = 69
  Top = 77
  BorderStyle = bsSingle
  Caption = #1055#1086#1084#1086#1097#1100
  ClientHeight = 585
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 857
    Height = 553
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 352
    Top = 560
    Width = 137
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 576
    Top = 552
  end
end
