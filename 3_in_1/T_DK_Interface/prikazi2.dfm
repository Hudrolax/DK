object Form11: TForm11
  Left = 257
  Top = 155
  Width = 786
  Height = 694
  Caption = 'Form11'
  Color = clBtnFace
  Constraints.MinHeight = 694
  Constraints.MinWidth = 786
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    778
    667)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 777
    Height = 625
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    OnClick = Memo1Click
    OnKeyPress = Memo1KeyPress
  end
  object Button1: TButton
    Left = 680
    Top = 632
    Width = 97
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 640
    Width = 177
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1086#1080#1089#1082':'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    TabOrder = 2
  end
  object Button3: TButton
    Left = 208
    Top = 640
    Width = 81
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1053#1072#1081#1090#1080' '#1076#1072#1083#1077#1077
    Default = True
    TabOrder = 3
    OnClick = Button3Click
  end
end
