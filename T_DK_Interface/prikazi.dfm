object Form10: TForm10
  Left = 371
  Top = 185
  Width = 488
  Height = 645
  Caption = #1055#1088#1080#1082#1072#1079#1099'...'
  Color = clBtnFace
  Constraints.MinHeight = 645
  Constraints.MinWidth = 488
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    480
    618)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 328
    Top = 136
    Width = 137
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081
    TabOrder = 0
    OnClick = Button1Click
  end
  object sg1: TStringGrid
    Left = 0
    Top = 0
    Width = 313
    Height = 617
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 4
    DefaultColWidth = 26
    DefaultRowHeight = 16
    RowCount = 37
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 1
    OnDblClick = sg1DblClick
    OnSelectCell = sg1SelectCell
    ColWidths = (
      26
      59
      63
      136)
  end
  object Button2: TButton
    Left = 352
    Top = 584
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object LabeledEdit1: TLabeledEdit
    Left = 320
    Top = 24
    Width = 153
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
    TabOrder = 3
  end
  object Button3: TButton
    Left = 320
    Top = 56
    Width = 65
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1042#1074#1077#1088#1093
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 408
    Top = 56
    Width = 65
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1042#1085#1080#1079
    TabOrder = 5
    OnClick = Button4Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 448
    Top = 184
  end
end
