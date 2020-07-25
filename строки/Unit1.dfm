object Form1: TForm1
  Left = 321
  Top = 227
  Width = 547
  Height = 664
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 240
    Top = 136
    Width = 69
    Height = 13
    Caption = #1048#1079' 6.txt '#1074' 7.txt'
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 225
    Height = 33
    Caption = #1054#1090#1092#1080#1083#1100#1090#1088#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1073#1077#1079' #'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 48
    Width = 225
    Height = 33
    Caption = #1054#1090#1092#1080#1083#1100#1090#1088#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1082#1086#1076#1099' '#1080#1079' demo.spr'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 88
    Width = 225
    Height = 33
    Caption = #1054#1090#1092#1080#1083#1100#1090#1088#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1103
    TabOrder = 2
  end
  object Button5: TButton
    Left = 8
    Top = 128
    Width = 225
    Height = 25
    Caption = #1059#1073#1088#1072#1090#1100' '#1079#1072#1076#1074#1086#1077#1085#1085#1099#1077' '#1089#1090#1088#1086#1082#1080' '
    TabOrder = 3
    OnClick = Button5Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 232
    Width = 497
    Height = 25
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 4
    Visible = False
  end
  object Memo33: TMemo
    Left = 8
    Top = 424
    Width = 529
    Height = 89
    Lines.Strings = (
      '')
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object Button4: TButton
    Left = 8
    Top = 160
    Width = 225
    Height = 25
    Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1087#1086#1088#1103#1076#1086#1082
    TabOrder = 6
    OnClick = Button4Click
  end
  object Memo3: TMemo
    Left = 8
    Top = 272
    Width = 505
    Height = 65
    ScrollBars = ssBoth
    TabOrder = 7
  end
  object Memo4: TMemo
    Left = 8
    Top = 344
    Width = 505
    Height = 65
    ScrollBars = ssBoth
    TabOrder = 8
  end
  object Button6: TButton
    Left = 360
    Top = 64
    Width = 73
    Height = 25
    Caption = 'Button6'
    TabOrder = 9
    OnClick = Button6Click
  end
  object Memo44: TMemo
    Left = 8
    Top = 520
    Width = 529
    Height = 89
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 10
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 280
    Top = 16
  end
end
