object Form12: TForm12
  Left = 208
  Top = 193
  Width = 946
  Height = 712
  Caption = #1055#1086#1095#1090#1072
  Color = clBtnFace
  Constraints.MinHeight = 712
  Constraints.MinWidth = 946
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    938
    685)
  PixelsPerInch = 96
  TextHeight = 13
  object sg1: TStringGrid
    Left = 0
    Top = 0
    Width = 641
    Height = 305
    ColCount = 6
    DefaultColWidth = 28
    DefaultRowHeight = 16
    RowCount = 35
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 0
    OnClick = sg1Click
    OnDblClick = sg1DblClick
    OnKeyPress = sg1KeyPress
    OnSelectCell = sg1SelectCell
    ColWidths = (
      28
      312
      34
      106
      64
      68)
  end
  object LabeledEdit1: TLabeledEdit
    Left = 648
    Top = 16
    Width = 281
    Height = 21
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
    Left = 688
    Top = 48
    Width = 73
    Height = 17
    Caption = #1042#1074#1077#1088#1093
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 808
    Top = 48
    Width = 73
    Height = 17
    Caption = #1042#1085#1080#1079
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 648
    Top = 88
    Width = 177
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074#1083#1086#1078#1077#1085#1080#1077
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 848
    Top = 272
    Width = 81
    Height = 33
    Anchors = [akTop, akRight]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 5
    OnClick = Button4Click
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 312
    Width = 937
    Height = 369
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 6
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 680
    Top = 264
  end
  object DBF: TDBF
    Exclusive = False
    Left = 648
    Top = 216
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
    Left = 712
    Top = 264
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer2Timer
    Left = 648
    Top = 264
  end
end
