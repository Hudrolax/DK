object Form9: TForm9
  Left = 362
  Top = 304
  Width = 826
  Height = 381
  Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1074#1093#1086#1078#1076#1077#1085#1080#1102
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    810
    343)
  PixelsPerInch = 96
  TextHeight = 13
  object sg1: TStringGrid
    Left = 0
    Top = 0
    Width = 817
    Height = 315
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 7
    DefaultColWidth = 30
    DefaultRowHeight = 16
    RowCount = 15
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 0
    OnDblClick = sg1DblClick
    OnDrawCell = sg1DrawCell
    ColWidths = (
      30
      43
      372
      27
      50
      107
      175)
  end
  object Button1: TButton
    Left = 752
    Top = 319
    Width = 65
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 0
    Top = 319
    Width = 65
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1055#1086' '#1082#1086#1076#1091
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 344
    Top = 319
    Width = 217
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 72
    Top = 319
    Width = 81
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1055#1086' '#1085#1072#1080#1084#1077#1085'.'
    TabOrder = 4
  end
  object CheckBox3: TCheckBox
    Left = 160
    Top = 319
    Width = 65
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1055#1086' '#1094#1077#1085#1077
    TabOrder = 5
  end
  object Button2: TButton
    Left = 568
    Top = 319
    Width = 65
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1053#1072#1081#1090#1080
    Default = True
    TabOrder = 6
    OnClick = Button2Click
  end
  object CheckBox4: TCheckBox
    Left = 224
    Top = 320
    Width = 97
    Height = 17
    Caption = #1055#1086' '#1041#1072#1088#1050#1086#1076#1091
    TabOrder = 7
  end
  object DBF1: TDBF
    Exclusive = False
    Left = 552
    Top = 256
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 536
    Top = 256
  end
end
