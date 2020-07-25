object Form6: TForm6
  Left = 171
  Top = 147
  Width = 398
  Height = 158
  Caption = #1047#1072#1087#1088#1086#1089' '#1085#1072' '#1087#1086#1083#1085#1091#1102' '#1074#1099#1075#1088#1091#1079#1082#1091
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
    Left = 0
    Top = 112
    Width = 350
    Height = 13
    Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1079#1072#1087#1088#1086#1089' '#1085#1072' '#1082#1072#1089#1089#1099'. '#1046#1076#1080#1090#1077' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103' '#1086#1090#1095#1077#1090#1086#1074'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 0
    Width = 359
    Height = 20
    Caption = #1042#1099#1073#1080#1088#1080#1090#1077' '#1082#1072#1089#1089#1099', '#1085#1072' '#1082#1086#1090#1086#1088#1099#1077' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1079#1072#1087#1088#1086#1089':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object CheckBox1: TCheckBox
    Left = 0
    Top = 24
    Width = 81
    Height = 17
    Caption = #1050#1072#1089#1089#1072' '#8470'1'
    Enabled = False
    TabOrder = 1
  end
  object CheckBox2: TCheckBox
    Left = 80
    Top = 24
    Width = 81
    Height = 17
    Caption = #1050#1072#1089#1089#1072' '#8470'2'
    Enabled = False
    TabOrder = 2
  end
  object CheckBox3: TCheckBox
    Left = 168
    Top = 24
    Width = 73
    Height = 17
    Caption = #1050#1072#1089#1089#1072' '#8470'3'
    Enabled = False
    TabOrder = 3
  end
  object CheckBox4: TCheckBox
    Left = 248
    Top = 24
    Width = 73
    Height = 17
    Caption = #1050#1072#1089#1089#1072' '#8470'4'
    Enabled = False
    TabOrder = 4
  end
  object CheckBox5: TCheckBox
    Left = 0
    Top = 48
    Width = 65
    Height = 25
    Caption = #1053#1072' '#1042#1057#1045
    Checked = True
    State = cbChecked
    TabOrder = 5
    OnClick = CheckBox5Click
  end
  object Button1: TButton
    Left = 0
    Top = 80
    Width = 97
    Height = 25
    Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 304
    Top = 80
    Width = 81
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 7
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 360
    Top = 24
  end
end
