object Form7: TForm7
  Left = 404
  Top = 445
  BorderStyle = bsSingle
  Caption = #1047#1072#1087#1088#1086#1089' '#1087#1086#1083#1085#1086#1081' '#1074#1099#1075#1088#1091#1079#1082#1080
  ClientHeight = 134
  ClientWidth = 387
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
    Left = 8
    Top = 8
    Width = 314
    Height = 16
    Caption = #1047#1072#1087#1088#1086#1089#1080#1090#1100' '#1055#1054#1051#1053#1059#1070' '#1074#1099#1075#1088#1091#1079#1082#1091' '#1089' '#1084#1072#1075#1072#1079#1080#1085#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 328
    Top = 8
    Width = 37
    Height = 16
    Caption = 'DK22'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 40
    Width = 57
    Height = 17
    Caption = #1050#1050#1052'1'
    TabOrder = 0
  end
  object CheckBox2: TCheckBox
    Left = 112
    Top = 40
    Width = 49
    Height = 17
    Caption = #1050#1050#1052'2'
    TabOrder = 1
  end
  object CheckBox3: TCheckBox
    Left = 216
    Top = 40
    Width = 57
    Height = 17
    Caption = #1050#1050#1052'3'
    TabOrder = 2
  end
  object CheckBox4: TCheckBox
    Left = 312
    Top = 40
    Width = 57
    Height = 17
    Caption = #1050#1050#1052'4'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 80
    Top = 96
    Width = 73
    Height = 25
    Caption = #1047#1072#1087#1088#1086#1089#1080#1090#1100
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 232
    Top = 96
    Width = 73
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 5
    OnClick = Button2Click
  end
  object ftp: TIdFTP
    MaxLineAction = maException
    Host = '10.10.61.10'
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 344
    Top = 88
  end
end
