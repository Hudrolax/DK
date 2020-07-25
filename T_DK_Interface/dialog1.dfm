object OKBottomDlg: TOKBottomDlg
  Left = 502
  Top = 296
  BorderStyle = bsDialog
  Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1086#1090#1095#1077#1090#1072'...'
  ClientHeight = 214
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 161
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 112
    Top = 16
    Width = 87
    Height = 16
    Caption = #1042#1085#1080#1084#1072#1085#1080#1077'!!!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object OKBtn: TButton
    Left = 79
    Top = 180
    Width = 75
    Height = 25
    Caption = #1044#1072
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 159
    Top = 180
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1053#1077#1090
    ModalResult = 2
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 40
    Width = 281
    Height = 121
    BorderStyle = bsNone
    Color = cl3DLight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      #1042#1099' '#1091#1078#1077' '#1085#1072#1078#1080#1084#1072#1083#1080' '#1082#1085#1086#1087#1082#1091' "'#1055#1086#1083#1091#1095#1080#1090#1100' '#1054#1090#1095#1077#1090' '#1089' '#1050#1072#1089#1089'" '
      #1086#1076#1080#1085' '#1088#1072#1079' '#1079#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1077' 12 '#1095#1072#1089#1086#1074'.'
      #1055#1086#1084#1085#1080#1090#1077', '#1095#1090#1086' '#1079#1072#1087#1088#1072#1096#1080#1074#1072#1090#1100' '#1086#1090#1095#1077#1090' '#1089' '#1082#1072#1089#1089' '#1085#1091#1078#1085#1086' '#1085#1077' '#1095#1072#1097#1077' '
      #1095#1077#1084' '#1088#1072#1079' '#1074' '#1089#1091#1090#1082#1080'.'
      #1058#1072#1082' '#1078#1077' '#1087#1086#1084#1085#1080#1090#1077', '#1095#1090#1086' '#1079#1072#1087#1088#1086#1089' '#1086#1090#1087#1088#1072#1074#1083#1103#1077#1090#1089#1103' '#1089#1088#1072#1079#1091' '#1085#1072' '
      #1042#1057#1045' '#1082#1072#1089#1089#1099'.'
      ''
      #1042#1099' '#1091#1074#1077#1088#1077#1085#1099', '#1095#1090#1086' '#1093#1086#1090#1080#1090#1077' '#1079#1072#1087#1088#1086#1089#1080#1090#1100' '#1086#1090#1095#1077#1090' '#1089' '#1082#1072#1089#1089' '#1077#1097#1077' '
      #1088#1072#1079'?')
    ParentFont = False
    TabOrder = 2
  end
end
