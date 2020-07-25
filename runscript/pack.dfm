object Form1: TForm1
  Left = 233
  Top = 177
  Width = 427
  Height = 221
  Caption = 'runscript for 1cv7 base pack'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 368
    Top = 136
  end
  object ftp: TIdFTP
    MaxLineAction = maException
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 368
    Top = 48
  end
  object Timer2: TTimer
    Interval = 20
    OnTimer = Timer2Timer
    Left = 296
    Top = 152
  end
end
