object Form14: TForm14
  Left = 246
  Top = 172
  Width = 811
  Height = 678
  Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
  Color = clBtnFace
  Constraints.MinHeight = 678
  Constraints.MinWidth = 811
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    803
    651)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 8
    Width = 91
    Height = 20
    Caption = #1040#1076#1088#1077#1089#1072#1090#1099':'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 208
    Top = 24
    Width = 35
    Height = 13
    Caption = #1050#1086#1084#1091':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 0
    Top = 160
    Width = 43
    Height = 16
    Caption = #1058#1077#1084#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 0
    Top = 32
    Width = 193
    Height = 113
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 13
    Items.Strings = (
      #1042#1089#1077#1084)
    ParentFont = False
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 248
    Top = 16
    Width = 161
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 1
  end
  object Button1: TButton
    Left = 200
    Top = 48
    Width = 81
    Height = 17
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    Enabled = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 72
    Width = 81
    Height = 17
    Caption = #1059#1073#1088#1072#1090#1100
    Enabled = False
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 200
    Top = 96
    Width = 81
    Height = 17
    Caption = #1042#1089#1077#1084
    Enabled = False
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 632
    Top = 152
    Width = 145
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = Button4Click
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 184
    Width = 799
    Height = 441
    Anchors = [akLeft, akTop, akRight, akBottom]
    PopupMenu = PopupMenu1
    ScrollBars = ssBoth
    TabOrder = 6
  end
  object Edit1: TEdit
    Left = 48
    Top = 160
    Width = 569
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 7
  end
  object Button5: TButton
    Left = 200
    Top = 136
    Width = 73
    Height = 17
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    Enabled = False
    TabOrder = 8
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 696
    Top = 632
    Width = 105
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 9
    OnClick = Button6Click
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 688
    Top = 80
  end
  object PopupMenu1: TPopupMenu
    Left = 744
    Top = 80
    object N1: TMenuItem
      Caption = #1064#1088#1080#1092#1090
      OnClick = N1Click
    end
  end
  object DBF1: TDBF
    Exclusive = False
    Left = 744
    Top = 24
  end
  object zp1: TZipForge
    ExtractCorruptedFiles = False
    CompressionLevel = clMax
    CompressionMode = 9
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
    Left = 680
    Top = 24
  end
end
