object Form1: TForm1
  Left = 300
  Top = 233
  Width = 404
  Height = 220
  Caption = 'terminate Updater v 1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 360
    Top = 8
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 360
    Top = 64
  end
end
