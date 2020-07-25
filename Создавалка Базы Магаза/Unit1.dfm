object Form1: TForm1
  Left = 270
  Top = 196
  BorderStyle = bsSingle
  Caption = 'DB Creator'
  ClientHeight = 171
  ClientWidth = 161
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
    Top = 64
    Width = 152
    Height = 13
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1041#1044' download.dbf'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 96
    Width = 9
    Height = 13
    Caption = #1057
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 72
    Top = 96
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
  object Label3: TLabel
    Left = 8
    Top = 128
    Width = 71
    Height = 13
    Caption = #1053#1072' '#1084#1072#1075#1072#1079#1080#1085
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object RadioButton1: TRadioButton
    Left = 8
    Top = 8
    Width = 105
    Height = 17
    Caption = #1050#1086#1083#1073#1072#1089#1085#1103
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 8
    Top = 32
    Width = 105
    Height = 17
    Caption = #1064#1084#1086#1090#1082#1072
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 24
    Top = 88
    Width = 41
    Height = 21
    TabOrder = 2
    Text = '1'
  end
  object edt1: TEdit
    Left = 96
    Top = 88
    Width = 49
    Height = 21
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 96
    Top = 120
    Width = 49
    Height = 21
    TabOrder = 4
  end
  object Button1: TButton
    Left = 8
    Top = 152
    Width = 137
    Height = 17
    Caption = #1046#1072#1093#1085#1091#1090#1100
    TabOrder = 5
    OnClick = Button1Click
  end
  object DBF1: TDBF
    Exclusive = False
    Left = 128
    Top = 24
  end
end
