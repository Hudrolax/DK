object Form1: TForm1
  Left = 360
  Top = 357
  BorderStyle = bsSingle
  Caption = 'DK Mail Server'
  ClientHeight = 130
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 8
    Width = 141
    Height = 16
    Caption = #1042#1089#1077#1075#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1086':'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 152
    Top = 8
    Width = 9
    Height = 16
    Caption = '0'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 0
    Top = 104
    Width = 113
    Height = 25
    Caption = #1042#1082#1083#1102#1095#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 128
    Top = 104
    Width = 129
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1041#1044' '#1084#1072#1075#1072#1079#1080#1085#1086#1074
    Enabled = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object DBF: TDBF
    Exclusive = False
    Left = 64
    Top = 56
  end
  object DBF1: TDBF
    Exclusive = False
    Left = 120
    Top = 56
  end
  object ftp: TIdFTP
    MaxLineAction = maException
    Host = '10.10.61.10'
    Password = 'dk'
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Username = 'dk'
    Left = 160
    Top = 56
  end
  object PTimer1: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = PTimer1Timer
    Left = 208
    Top = 56
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 8
    Top = 56
  end
  object DBF2: TDBF
    Exclusive = False
    Left = 208
    Top = 16
  end
end
