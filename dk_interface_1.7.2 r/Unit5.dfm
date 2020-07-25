object Form5: TForm5
  Left = 223
  Top = 166
  BorderStyle = bsSingle
  Caption = #1047#1072#1087#1088#1086#1089#1080#1090#1100' '#1086#1090#1095#1077#1090' '#1079#1072' '#1087#1077#1088#1080#1086#1076
  ClientHeight = 167
  ClientWidth = 457
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
    Top = 8
    Width = 445
    Height = 13
    Caption = 
      #1042#1087#1080#1096#1080#1090#1077' '#1076#1072#1090#1091' '#1085#1072#1095#1072#1083#1072' '#1080' '#1082#1086#1085#1094#1072' '#1087#1077#1088#1080#1086#1076#1072', '#1079#1072' '#1082#1086#1090#1086#1088#1099#1081' '#1073#1091#1076#1077#1090' '#1079#1072#1087#1088#1086#1096#1077#1085' '#1086 +
      #1090#1095#1077#1090'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 0
    Top = 128
    Width = 79
    Height = 13
    Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1089':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 0
    Top = 24
    Width = 174
    Height = 16
    Caption = #1060#1086#1088#1084#1072#1090' '#1076#1072#1090#1099': '#1044#1044'.'#1052#1052'.'#1043#1043
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 144
    Top = 128
    Width = 15
    Height = 13
    Caption = #1087#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 0
    Top = 152
    Width = 349
    Height = 13
    Caption = #1047#1072#1087#1088#1086#1089' '#1085#1072' '#1082#1072#1089#1089#1099' '#1086#1090#1087#1088#1072#1074#1083#1077#1085'. '#1046#1076#1080#1090#1077' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103' '#1086#1090#1095#1077#1090#1086#1074'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Edit1: TEdit
    Left = 80
    Top = 120
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '01.01.09'
  end
  object Edit2: TEdit
    Left = 168
    Top = 120
    Width = 57
    Height = 21
    TabOrder = 1
    Text = '13.02.09'
  end
  object Button1: TButton
    Left = 240
    Top = 120
    Width = 73
    Height = 25
    Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 384
    Top = 120
    Width = 73
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 0
    Top = 48
    Width = 81
    Height = 17
    Caption = #1050#1072#1089#1089#1072' '#8470'1'
    Enabled = False
    TabOrder = 4
  end
  object CheckBox2: TCheckBox
    Left = 80
    Top = 48
    Width = 81
    Height = 17
    Caption = #1050#1072#1089#1089#1072' '#8470'2'
    Enabled = False
    TabOrder = 5
  end
  object CheckBox3: TCheckBox
    Left = 160
    Top = 48
    Width = 89
    Height = 17
    Caption = #1050#1072#1089#1089#1072' '#8470'3'
    Enabled = False
    TabOrder = 6
  end
  object CheckBox4: TCheckBox
    Left = 240
    Top = 48
    Width = 81
    Height = 17
    Caption = #1050#1072#1089#1089#1072' '#8470'4'
    Enabled = False
    TabOrder = 7
  end
  object CheckBox5: TCheckBox
    Left = 0
    Top = 80
    Width = 89
    Height = 25
    Caption = #1053#1072' '#1042#1057#1045
    Checked = True
    State = cbChecked
    TabOrder = 8
    OnClick = CheckBox5Click
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 416
    Top = 32
  end
end
