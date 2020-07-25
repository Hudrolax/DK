object Form1: TForm1
  Left = 238
  Top = 171
  Width = 870
  Height = 640
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
  object Label1: TLabel
    Left = 256
    Top = 56
    Width = 48
    Height = 16
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 24
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object RvProject1: TRvProject
    Engine = RvSystem1
    LoadDesigner = True
    ProjectFile = 'C:\DK\'#1055#1088#1080#1084#1077#1088' '#1055#1077#1095#1072#1090#1080'\Project2.rav'
    Left = 136
    Top = 192
  end
  object RvRenderPrinter1: TRvRenderPrinter
    DisplayName = 'RPRender'
    Left = 256
    Top = 192
  end
  object RvRenderPreview1: TRvRenderPreview
    DisplayName = 'RPRender'
    ZoomFactor = 100.000000000000000000
    ShadowDepth = 0
    Left = 352
    Top = 200
  end
  object RvSystem1: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'ReportPrinter Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    Left = 136
    Top = 248
  end
end
