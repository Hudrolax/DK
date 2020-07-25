object Form4: TForm4
  Left = 454
  Top = 446
  BorderStyle = bsDialog
  Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1079#1072#1087#1088#1086#1089#1072' '#1085#1072' '#1086#1090#1082#1083#1102#1095#1077#1085#1080#1077'...'
  ClientHeight = 142
  ClientWidth = 470
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
    Left = 16
    Top = 8
    Width = 447
    Height = 64
    Caption = 
      #1042#1085#1080#1084#1072#1085#1080#1077'! '#1054#1090#1087#1088#1072#1074#1082#1072' '#1079#1072#1087#1088#1086#1089#1072' '#1085#1072' '#1086#1090#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1088#1080#1074#1077#1076#1077#1090#13#10#1082' '#1086#1090#1082#1083#1102#1095#1077#1085#1080#1102' ' +
      #1084#1072#1075#1072#1079#1080#1085#1072' '#1086#1090' '#1048#1085#1090#1077#1088#1085#1077#1090#1072'! '#1045#1089#1083#1080' '#1084#1072#1075#1072#1079#1080#1085#13#10#1053#1045' '#1087#1086#1076#1082#1083#1102#1095#1077#1085', '#1090#1086' '#1086#1085' '#1086#1090#1082#1083#1102#1095#1080 +
      #1090#1089#1103' '#1089#1088#1072#1079#1091' '#1087#1086#1089#1083#1077' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103#13#10'1 '#1088#1072#1079'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 80
    Width = 176
    Height = 20
    Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1084#1072#1075#1072#1079#1080#1085' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 104
    Top = 112
    Width = 89
    Height = 25
    Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 272
    Top = 112
    Width = 89
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button2Click
  end
  object ftp: TIdFTP
    MaxLineAction = maException
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 416
    Top = 80
  end
end
