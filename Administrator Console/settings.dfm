object Form8: TForm8
  Left = 465
  Top = 471
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' - '#1054#1089#1085#1086#1074#1085#1099#1077
  ClientHeight = 264
  ClientWidth = 456
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
    Top = 0
    Width = 233
    Height = 16
    Caption = #1052#1077#1090#1086#1076' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103' '#1082' '#1089#1077#1088#1074#1077#1088#1091':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 60
    Height = 13
    Caption = 'SMB Server:'
  end
  object Label3: TLabel
    Left = 8
    Top = 120
    Width = 57
    Height = 13
    Caption = 'FTP Server:'
    Enabled = False
  end
  object Label4: TLabel
    Left = 8
    Top = 144
    Width = 45
    Height = 13
    Caption = 'FTP Port:'
    Enabled = False
  end
  object Label5: TLabel
    Left = 8
    Top = 176
    Width = 74
    Height = 13
    Caption = 'FTP Username:'
    Enabled = False
  end
  object Label6: TLabel
    Left = 8
    Top = 208
    Width = 49
    Height = 13
    Caption = 'FTP Pass:'
    Enabled = False
  end
  object RadioButton1: TRadioButton
    Left = 8
    Top = 24
    Width = 145
    Height = 25
    Caption = 'SMB (Microsoft Network)'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 8
    Top = 88
    Width = 113
    Height = 17
    Caption = 'FTP'
    TabOrder = 1
    OnClick = RadioButton2Click
  end
  object Edit1: TEdit
    Left = 88
    Top = 56
    Width = 129
    Height = 21
    TabOrder = 2
    Text = 'DK99'
  end
  object Edit2: TEdit
    Left = 88
    Top = 112
    Width = 129
    Height = 21
    Enabled = False
    TabOrder = 3
    Text = 'DK99'
  end
  object Edit3: TEdit
    Left = 88
    Top = 144
    Width = 49
    Height = 21
    Enabled = False
    TabOrder = 4
    Text = '21'
  end
  object Edit4: TEdit
    Left = 88
    Top = 168
    Width = 81
    Height = 21
    Enabled = False
    TabOrder = 5
    Text = 'ac'
  end
  object Edit5: TEdit
    Left = 88
    Top = 200
    Width = 81
    Height = 21
    Enabled = False
    TabOrder = 6
    Text = 'ac'
  end
  object Button1: TButton
    Left = 264
    Top = 232
    Width = 73
    Height = 25
    Caption = #1047#1072#1087#1080#1089#1072#1090#1100
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 376
    Top = 232
    Width = 73
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 8
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 344
    Top = 24
  end
end
