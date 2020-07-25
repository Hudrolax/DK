object Form8: TForm8
  Left = 69
  Top = 82
  Width = 869
  Height = 709
  Caption = 'DK Report Interface - '#1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    861
    682)
  PixelsPerInch = 96
  TextHeight = 13
  object sg1: TStringGrid
    Left = 0
    Top = 0
    Width = 657
    Height = 673
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 6
    DefaultColWidth = 30
    DefaultRowHeight = 16
    RowCount = 40
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    ParentShowHint = False
    ScrollBars = ssVertical
    ShowHint = False
    TabOrder = 0
    OnDrawCell = sg1DrawCell
    OnSelectCell = sg1SelectCell
    ColWidths = (
      30
      45
      370
      25
      51
      108)
    RowHeights = (
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16
      16)
  end
  object ListBox1: TListBox
    Left = 664
    Top = 24
    Width = 129
    Height = 65
    Anchors = [akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
  end
  object StaticText1: TStaticText
    Left = 664
    Top = 0
    Width = 123
    Height = 17
    Anchors = [akTop, akRight]
    Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076#1099' '#1090#1086#1074#1072#1088#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object Button1: TButton
    Left = 792
    Top = 648
    Width = 65
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 664
    Top = 632
    Width = 105
    Height = 41
    Anchors = [akRight, akBottom]
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100' {Crtl+R}'
    TabOrder = 4
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 664
    Top = 96
    Width = 193
    Height = 145
    Anchors = [akTop, akRight]
    Caption = #1055#1086#1080#1089#1082':'
    TabOrder = 5
    object Edit1: TEdit
      Left = 8
      Top = 16
      Width = 177
      Height = 21
      TabOrder = 0
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 40
      Width = 65
      Height = 17
      Caption = #1055#1086' '#1082#1086#1076#1091
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 64
      Width = 81
      Height = 17
      Caption = #1055#1086' '#1085#1072#1080#1084#1077#1085'.'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 88
      Width = 65
      Height = 17
      Caption = #1055#1086' '#1094#1077#1085#1077
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object Button3: TButton
      Left = 104
      Top = 80
      Width = 73
      Height = 25
      Caption = #1053#1072#1081#1090#1080' '#1074#1085#1080#1079
      Default = True
      TabOrder = 4
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 104
      Top = 48
      Width = 73
      Height = 25
      Caption = #1053#1072#1081#1090#1080' '#1074#1074#1077#1088#1093
      TabOrder = 5
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 8
      Top = 112
      Width = 97
      Height = 25
      Caption = #1055#1086' '#1074#1093#1086#1078#1076#1077#1085#1080#1102
      TabOrder = 6
      OnClick = Button5Click
    end
  end
  object DBF3: TDBF
    Exclusive = False
    Left = 800
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 832
    Top = 8
  end
end
