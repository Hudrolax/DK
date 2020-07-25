object Form1: TForm1
  Left = 288
  Top = 237
  Width = 653
  Height = 331
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
  object Button1: TButton
    Left = 24
    Top = 240
    Width = 153
    Height = 41
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 136
    Top = 16
    Width = 289
    Height = 49
    ItemHeight = 13
    TabOrder = 1
  end
  object Button2: TButton
    Left = 232
    Top = 232
    Width = 169
    Height = 41
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 32
    Top = 184
    Width = 137
    Height = 33
    Caption = 'Button3'
    TabOrder = 3
    OnClick = Button3Click
  end
  object DBF: TDBF
    Exclusive = False
    Left = 8
    Top = 8
  end
end
