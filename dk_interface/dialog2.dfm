object ExportDialog: TExportDialog
  Left = 484
  Top = 337
  BorderStyle = bsDialog
  Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072' '#1090#1086#1074#1072#1088#1086#1074
  ClientHeight = 167
  ClientWidth = 454
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 159
    Top = 132
    Width = 75
    Height = 25
    Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 375
    Top = 132
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 8
    Width = 121
    Height = 153
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1082#1072#1089#1089#1099':'
    TabOrder = 2
    object CheckBox1: TCheckBox
      Left = 8
      Top = 24
      Width = 73
      Height = 17
      Caption = #1050#1072#1089#1089#1072' '#8470'1'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 48
      Width = 73
      Height = 17
      Caption = #1050#1072#1089#1089#1072' '#8470'2'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 72
      Width = 73
      Height = 17
      Caption = #1050#1072#1089#1089#1072' '#8470'3'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 2
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 96
      Width = 73
      Height = 17
      Caption = #1050#1072#1089#1089#1072' '#8470'4'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 3
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 128
      Width = 97
      Height = 17
      Caption = #1053#1072' '#1074#1089#1077' '#1082#1072#1089#1089#1099
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = CheckBox5Click
    end
  end
  object Memo1: TMemo
    Left = 136
    Top = 8
    Width = 313
    Height = 97
    BorderStyle = bsNone
    Color = cl3DLight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      #1044#1083#1103' '#1090#1086#1075#1086', '#1095#1090#1086#1073#1099' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1092#1072#1081#1083' '
      #1074#1099#1075#1088#1091#1079#1082#1080' demo.spr, '#1074#1099#1073#1077#1088#1080#1090#1077' '#1085#1072' '
      #1082#1072#1082#1080#1077' '#1082#1072#1089#1089#1099' '#1076#1086#1083#1078#1085#1072' '#1073#1099#1090#1100' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1072
      #1074#1099#1075#1088#1091#1079#1082#1072', '#1080' '#1085#1072#1078#1084#1080#1090#1077' '#1082#1085#1086#1087#1082#1091' '
      '"'#1042#1099#1075#1088#1091#1079#1080#1090#1100'".')
    ParentFont = False
    TabOrder = 3
  end
  object DBF: TDBF
    Exclusive = False
    Left = 320
    Top = 136
  end
end
