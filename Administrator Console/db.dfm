object Form5: TForm5
  Left = 184
  Top = 119
  Width = 899
  Height = 851
  Caption = #1040#1076#1088#1077#1089#1085#1072#1103' '#1082#1085#1080#1075#1072
  Color = clBtnFace
  Constraints.MaxHeight = 851
  Constraints.MaxWidth = 899
  Constraints.MinHeight = 368
  Constraints.MinWidth = 829
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    891
    824)
  PixelsPerInch = 96
  TextHeight = 13
  object sg1: TStringGrid
    Left = 0
    Top = 0
    Width = 889
    Height = 774
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultColWidth = 30
    DefaultRowHeight = 15
    RowCount = 500
    TabOrder = 0
    OnDblClick = sg1DblClick
    OnKeyDown = sg1KeyDown
    OnSelectCell = sg1SelectCell
    ColWidths = (
      30
      86
      146
      333
      197)
  end
  object Button1: TButton
    Left = 272
    Top = 781
    Width = 121
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1047#1072#1087#1080#1089#1072#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 464
    Top = 781
    Width = 121
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object DBF: TDBF
    Exclusive = False
    Left = 880
    Top = 632
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 824
    Top = 632
  end
end
