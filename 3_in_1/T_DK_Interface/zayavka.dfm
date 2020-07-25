object Form18: TForm18
  Left = 156
  Top = 198
  Width = 1095
  Height = 673
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1047#1072#1103#1074#1082#1072' - '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  DesignSize = (
    1087
    646)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 188
    Top = 8
    Width = 69
    Height = 16
    Anchors = [akTop, akRight]
    Caption = #1052#1072#1075#1072#1079#1080#1085':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 316
    Top = 8
    Width = 86
    Height = 16
    Anchors = [akTop, akRight]
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 508
    Top = 8
    Width = 145
    Height = 16
    Anchors = [akTop, akRight]
    Caption = #1043#1088#1091#1079#1086#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 700
    Top = 8
    Width = 130
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #1055#1086#1089#1090#1091#1087#1083#1077#1085#1080#1077' '#1085#1072' '#1076#1072#1090#1091':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 699
    Top = 112
    Width = 106
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #1047#1072#1103#1074#1082#1091' '#1089#1086#1089#1090#1072#1074#1080#1083':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object sg1: TStringGrid
    Left = 180
    Top = 152
    Width = 905
    Height = 457
    Anchors = [akTop, akRight, akBottom]
    ColCount = 9
    DefaultColWidth = 40
    DefaultRowHeight = 15
    Enabled = False
    RowCount = 2
    TabOrder = 0
    OnDrawCell = sg1DrawCell
    OnKeyPress = sg1KeyPress
    OnSelectCell = sg1SelectCell
    OnSetEditText = sg1SetEditText
    ColWidths = (
      40
      70
      354
      33
      51
      87
      78
      82
      81)
  end
  object ListBox1: TListBox
    Left = 180
    Top = 24
    Width = 129
    Height = 129
    Anchors = [akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBox1Click
  end
  object ListBox2: TListBox
    Left = 316
    Top = 24
    Width = 185
    Height = 129
    Anchors = [akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    OnClick = ListBox2Click
  end
  object ListBox3: TListBox
    Left = 508
    Top = 24
    Width = 185
    Height = 129
    Anchors = [akTop, akRight]
    ItemHeight = 13
    TabOrder = 3
    OnClick = ListBox3Click
  end
  object DateTimePicker1: TDateTimePicker
    Left = 830
    Top = 8
    Width = 113
    Height = 17
    Anchors = [akTop, akRight]
    Date = 40179.524679224540000000
    Time = 40179.524679224540000000
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 697
    Top = 128
    Width = 361
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 5
  end
  object CheckBox1: TCheckBox
    Left = 698
    Top = 32
    Width = 153
    Height = 17
    Anchors = [akTop]
    Caption = #1042#1085#1077#1087#1083#1072#1085#1086#1074#1072#1103' '#1079#1072#1103#1074#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = CheckBox1Click
  end
  object Button1: TButton
    Left = 8
    Top = 621
    Width = 89
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 624
    Width = 145
    Height = 14
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080' '#1086#1090#1087#1088#1072#1074#1080#1090#1100
    TabOrder = 8
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 992
    Top = 621
    Width = 89
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 9
    OnClick = Button3Click
  end
  object FN: TEdit
    Left = 992
    Top = 48
    Width = 65
    Height = 21
    Anchors = [akTop, akRight]
    Enabled = False
    TabOrder = 10
    Visible = False
  end
  object Magg: TEdit
    Left = 1000
    Top = 72
    Width = 65
    Height = 21
    Enabled = False
    TabOrder = 11
    Visible = False
  end
  object KodSklada: TEdit
    Left = 904
    Top = 48
    Width = 65
    Height = 21
    Enabled = False
    TabOrder = 12
    Visible = False
  end
  object KodPostav: TEdit
    Left = 920
    Top = 96
    Width = 65
    Height = 21
    Enabled = False
    TabOrder = 13
    Visible = False
  end
  object KodGruuz: TEdit
    Left = 904
    Top = 72
    Width = 65
    Height = 21
    Enabled = False
    TabOrder = 14
    Visible = False
  end
  object PostName: TEdit
    Left = 968
    Top = 8
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 15
    Visible = False
  end
  object GruuzName: TEdit
    Left = 1016
    Top = 96
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 16
    Visible = False
  end
  object prosmotr: TCheckBox
    Left = 860
    Top = 96
    Width = 41
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'prosmotr'
    TabOrder = 17
    Visible = False
  end
  object tv1: TTreeView
    Left = 0
    Top = 24
    Width = 177
    Height = 585
    Anchors = [akLeft, akTop, akRight, akBottom]
    Indent = 19
    ReadOnly = True
    TabOrder = 18
    OnClick = tv1Click
  end
  object Button4: TButton
    Left = 696
    Top = 56
    Width = 137
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1079#1072#1082#1072#1079'!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 19
    OnClick = Button4Click
  end
  object DBF: TDBF
    Exclusive = False
    Left = 832
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 30
    OnTimer = Timer1Timer
    Left = 872
    Top = 16
  end
  object DBF2: TDBF
    Exclusive = False
    Left = 800
    Top = 8
  end
  object DBF3: TDBF
    Exclusive = False
    Left = 768
    Top = 8
  end
end
