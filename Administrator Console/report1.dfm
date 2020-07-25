object Form2: TForm2
  Left = 301
  Top = 212
  Width = 356
  Height = 606
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1085#1077#1079#1072#1073#1088#1072#1085#1085#1099#1084' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103#1084
  Color = clBtnFace
  Constraints.MaxHeight = 991
  Constraints.MaxWidth = 356
  Constraints.MinHeight = 605
  Constraints.MinWidth = 356
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    348
    579)
  PixelsPerInch = 96
  TextHeight = 13
  object sg1: TStringGrid
    Left = 0
    Top = 0
    Width = 345
    Height = 545
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 0
    OnDblClick = sg1DblClick
    OnDrawCell = sg1DrawCell
    ColWidths = (
      64
      118
      151)
  end
  object Button1: TButton
    Left = 280
    Top = 552
    Width = 65
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 0
    Top = 552
    Width = 65
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 112
    Top = 544
  end
  object DBF: TDBF
    Exclusive = False
    Left = 160
    Top = 544
  end
end
