object Form6: TForm6
  Left = 424
  Top = 296
  BorderStyle = bsSingle
  Caption = #1047#1072#1087#1088#1086#1089' '#1090#1088#1072#1085#1079#1072#1082#1094#1080#1081' '#1087#1086' '#1076#1072#1090#1072#1084
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
    Width = 298
    Height = 20
    Caption = #1047#1072#1087#1088#1086#1089#1080#1090#1100' '#1090#1088#1072#1085#1079#1072#1082#1094#1080#1080' '#1089' '#1084#1072#1075#1072#1079#1080#1085#1072' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 312
    Top = 8
    Width = 70
    Height = 20
    Caption = #1084#1072#1075#1072#1079#1080#1085
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 40
    Width = 82
    Height = 16
    Caption = #1055#1086' '#1076#1072#1090#1072#1084' '#1089
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 208
    Top = 40
    Width = 19
    Height = 16
    Caption = #1087#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 72
    Width = 52
    Height = 16
    Caption = #1057' '#1082#1072#1089#1089':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DateTimePicker1: TDateTimePicker
    Left = 104
    Top = 40
    Width = 97
    Height = 17
    Date = 39965.452705601850000000
    Time = 39965.452705601850000000
    TabOrder = 0
  end
  object DateTimePicker2: TDateTimePicker
    Left = 232
    Top = 40
    Width = 89
    Height = 17
    Date = 39974.452765104170000000
    Time = 39974.452765104170000000
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 64
    Top = 72
    Width = 65
    Height = 17
    Caption = #1050#1072#1089#1089#1072' 1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object CheckBox2: TCheckBox
    Left = 136
    Top = 72
    Width = 65
    Height = 17
    Caption = #1050#1072#1089#1089#1072' 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object CheckBox3: TCheckBox
    Left = 216
    Top = 72
    Width = 73
    Height = 17
    Caption = #1050#1072#1089#1089#1072' 3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object CheckBox4: TCheckBox
    Left = 296
    Top = 72
    Width = 65
    Height = 17
    Caption = #1050#1072#1089#1089#1072'4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object Button1: TButton
    Left = 80
    Top = 104
    Width = 89
    Height = 25
    Caption = #1047#1072#1087#1088#1086#1089#1080#1090#1100
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 216
    Top = 104
    Width = 97
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 7
    OnClick = Button2Click
  end
  object ftp: TIdFTP
    MaxLineAction = maException
    BoundPort = 21
    Host = '10.10.61.10'
    Password = 'dk'
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Username = 'dk'
    Left = 352
    Top = 96
  end
end
