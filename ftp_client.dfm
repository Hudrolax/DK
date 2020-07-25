object Form1: TForm1
  Left = 201
  Top = 155
  Width = 474
  Height = 309
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 136
    Width = 97
    Height = 33
    Caption = #1087#1086#1076#1082#1083#1102#1095#1072#1077#1084#1089#1103
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 168
    Top = 24
    Width = 169
    Height = 21
    TabOrder = 1
    Text = 'hud.net.ru'
  end
  object Edit2: TEdit
    Left = 168
    Top = 56
    Width = 169
    Height = 21
    TabOrder = 2
    Text = 'dk'
  end
  object Edit3: TEdit
    Left = 168
    Top = 88
    Width = 169
    Height = 21
    TabOrder = 3
    Text = 'dk'
  end
  object Button2: TButton
    Left = 136
    Top = 136
    Width = 97
    Height = 33
    Caption = #1087#1088#1080#1085#1103#1090#1100' '#1092#1072#1081#1083
    Enabled = False
    TabOrder = 4
    OnClick = Button2Click
  end
  object strngrd1: TStringGrid
    Left = 8
    Top = 184
    Width = 449
    Height = 97
    ColCount = 1
    DefaultColWidth = 400
    DefaultRowHeight = 20
    FixedCols = 0
    TabOrder = 5
  end
  object ftp: TIdFTP
    MaxLineAction = maException
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 40
    Top = 32
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
    Left = 8
    Top = 8
  end
  object dbf: TDBF
    Exclusive = False
    Left = 88
    Top = 32
  end
end
