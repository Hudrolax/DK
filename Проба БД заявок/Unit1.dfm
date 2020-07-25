object Form1: TForm1
  Left = 333
  Top = 304
  Width = 620
  Height = 289
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ComboBox1: TComboBox
    Left = 8
    Top = 8
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'ComboBox1'
  end
  object ComboBox2: TComboBox
    Left = 8
    Top = 40
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'ComboBox2'
  end
  object sg1: TStringGrid
    Left = 8
    Top = 80
    Width = 497
    Height = 169
    ColCount = 3
    DefaultColWidth = 40
    DefaultRowHeight = 15
    TabOrder = 2
    ColWidths = (
      40
      67
      219)
  end
end
