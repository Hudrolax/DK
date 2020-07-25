object Form15: TForm15
  Left = 237
  Top = 210
  Width = 643
  Height = 511
  Caption = #1050#1072#1089#1089#1086#1074#1072#1103' '#1050#1085#1080#1075#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    635
    484)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 440
    Top = 8
    Width = 31
    Height = 16
    Anchors = [akTop, akRight]
    Caption = #1050#1050#1052
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 440
    Top = 40
    Width = 41
    Height = 16
    Anchors = [akTop, akRight]
    Caption = #1044#1072#1090#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 440
    Top = 64
    Width = 51
    Height = 16
    Anchors = [akTop, akRight]
    Caption = #1042#1088#1077#1084#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 440
    Top = 88
    Width = 78
    Height = 16
    Anchors = [akTop, akRight]
    Caption = #8470' '#1054#1090#1095#1077#1090#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 433
    Height = 473
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 488
    Top = 8
    Width = 137
    Height = 21
    Anchors = [akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
    OnSelect = ComboBox1Select
  end
  object DateTimePicker1: TDateTimePicker
    Left = 496
    Top = 40
    Width = 89
    Height = 17
    Anchors = [akTop, akRight]
    Date = 39938.713614166660000000
    Time = 39938.713614166660000000
    TabOrder = 2
  end
  object DateTimePicker2: TDateTimePicker
    Left = 496
    Top = 64
    Width = 73
    Height = 17
    Anchors = [akTop, akRight]
    Date = 39938.715099270840000000
    Time = 39938.715099270840000000
    Kind = dtkTime
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 520
    Top = 88
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 4
    Text = '1'
  end
  object LabeledEdit1: TLabeledEdit
    Left = 440
    Top = 136
    Width = 185
    Height = 21
    Anchors = [akTop, akRight]
    EditLabel.Width = 187
    EditLabel.Height = 13
    EditLabel.Caption = #1053#1077#1086#1073#1085#1072#1083'. '#1089#1091#1084#1084#1072' '#1085#1072' '#1085#1072#1095'. '#1089#1084#1077#1085#1099
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    ReadOnly = True
    TabOrder = 5
    Text = '0'
  end
  object LabeledEdit2: TLabeledEdit
    Left = 440
    Top = 264
    Width = 137
    Height = 21
    Anchors = [akTop, akRight]
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1099#1088#1091#1095#1082#1072
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clRed
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    TabOrder = 6
  end
  object Button1: TButton
    Left = 568
    Top = 448
    Width = 57
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 448
    Top = 304
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1047#1072#1087#1080#1089#1072#1090#1100
    TabOrder = 8
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 544
    Top = 304
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1057#1073#1088#1086#1089
    TabOrder = 9
  end
  object LabeledEdit4: TLabeledEdit
    Left = 440
    Top = 184
    Width = 137
    Height = 21
    EditLabel.Width = 110
    EditLabel.Height = 13
    EditLabel.Caption = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1086#1074':'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clGreen
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    TabOrder = 10
    Text = '0'
  end
  object LabeledEdit5: TLabeledEdit
    Left = 440
    Top = 224
    Width = 137
    Height = 21
    EditLabel.Width = 77
    EditLabel.Height = 13
    EditLabel.Caption = #1048#1085#1082#1072#1089#1089#1072#1094#1080#1103':'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clNavy
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    TabOrder = 11
    Text = '0'
  end
  object DBF1: TDBF
    Exclusive = False
    Left = 448
    Top = 424
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 592
    Top = 400
  end
  object DBF2: TDBF
    Exclusive = False
    Left = 496
    Top = 424
  end
end
