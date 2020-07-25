object Form3: TForm3
  Left = 281
  Top = 225
  Width = 805
  Height = 610
  Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1077
  Color = clBtnFace
  Constraints.MinHeight = 544
  Constraints.MinWidth = 804
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    797
    583)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 162
    Height = 13
    Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 0
    Top = 256
    Width = 110
    Height = 13
    Caption = #1058#1077#1082#1089#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object sg1: TStringGrid
    Left = 0
    Top = 16
    Width = 786
    Height = 241
    Anchors = [akLeft, akTop, akRight]
    ColCount = 6
    DefaultColWidth = 20
    DefaultRowHeight = 14
    RowCount = 5000
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 0
    OnDblClick = sg1DblClick
    OnSelectCell = sg1SelectCell
    ColWidths = (
      20
      111
      396
      66
      71
      111)
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 272
    Width = 794
    Height = 273
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button1: TButton
    Left = 705
    Top = 554
    Width = 89
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 0
    Top = 554
    Width = 129
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074#1083#1086#1078#1077#1085#1080#1077
    Enabled = False
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 144
    Top = 554
    Width = 129
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 4
    OnClick = Button3Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 632
    Top = 544
  end
  object DBF1: TDBF
    Exclusive = False
    Left = 592
    Top = 544
  end
  object DBF2: TDBF
    Exclusive = False
    Left = 552
    Top = 544
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
    Left = 512
    Top = 544
  end
end
