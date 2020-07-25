object Form3: TForm3
  Left = 224
  Top = 144
  Width = 834
  Height = 782
  Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1072#1088#1093#1080#1074#1072':'
  Color = clBtnFace
  Constraints.MinHeight = 371
  Constraints.MinWidth = 699
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    826
    748)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 657
    Top = 8
    Width = 107
    Height = 16
    Anchors = [akTop, akRight]
    Caption = #1050#1083#1102#1095' '#1086#1095#1080#1089#1090#1082#1080':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 769
    Top = 8
    Width = 13
    Height = 16
    Anchors = [akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 657
    Top = 32
    Width = 26
    Height = 17
    Anchors = [akTop, akRight]
    Caption = #1064#1050':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object sg1: TStringGrid
    Left = 0
    Top = 0
    Width = 650
    Height = 748
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultColWidth = 34
    DefaultRowHeight = 16
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 0
    OnDrawCell = sg1DrawCell
    OnSelectCell = sg1SelectCell
    ColWidths = (
      34
      83
      407
      34
      83)
  end
  object LabeledEdit1: TLabeledEdit
    Left = 657
    Top = 160
    Width = 161
    Height = 21
    Anchors = [akTop, akRight]
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1086#1080#1089#1082':'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    TabOrder = 1
    OnChange = LabeledEdit1Change
  end
  object Button1: TButton
    Left = 737
    Top = 707
    Width = 81
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 657
    Top = 48
    Width = 161
    Height = 81
    Anchors = [akTop, akRight]
    ItemHeight = 13
    TabOrder = 3
  end
  object CheckBox1: TCheckBox
    Left = 657
    Top = 184
    Width = 65
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1055#1086' '#1082#1086#1076#1091':'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object CheckBox2: TCheckBox
    Left = 657
    Top = 208
    Width = 113
    Height = 17
    Anchors = [akTop, akRight]
    Caption = #1055#1086' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1102':'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object CheckBox3: TCheckBox
    Left = 657
    Top = 232
    Width = 97
    Height = 17
    Anchors = [akTop, akRight]
    Caption = #1055#1086' '#1094#1077#1085#1077':'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object Button2: TButton
    Left = 761
    Top = 256
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1042#1085#1080#1079
    TabOrder = 7
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 665
    Top = 256
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1042#1074#1077#1088#1093
    TabOrder = 8
    OnClick = Button3Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 768
    Top = 504
  end
  object zp1: TZipForge
    ExtractCorruptedFiles = False
    CompressionLevel = clFastest
    CompressionMode = 1
    CurrentVersion = '5.01 '
    SpanningMode = smNone
    SpanningOptions.AdvancedNaming = False
    SpanningOptions.VolumeSize = vsAutoDetect
    Options.FlushBuffers = True
    Options.OEMFileNames = True
    InMemory = False
    Zip64Mode = zmDisabled
    UnicodeFilenames = True
    EncryptionMethod = caPkzipClassic
    Left = 728
    Top = 512
  end
  object ftp: TIdFTP
    MaxLineAction = maException
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 696
    Top = 512
  end
  object DBF3: TDBF
    Exclusive = False
    Left = 720
    Top = 464
  end
  object DBF1: TDBF
    Exclusive = False
    Left = 704
    Top = 416
  end
end
