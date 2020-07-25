unit dialog1;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls,Gvar;

type
  TOKBottomDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Memo1: TMemo;
    Label1: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OKBottomDlg: TOKBottomDlg;

implementation

{$R *.dfm}

procedure TOKBottomDlg.OKBtnClick(Sender: TObject);
begin
 OrdToExport:=True;
 dlg1:=True;
 OKBottomDlg.Visible:=False;
end;

procedure TOKBottomDlg.CancelBtnClick(Sender: TObject);
begin
 OrdToExport:=False;
 dlg1:=True;
 OKBottomDlg.Visible:=False;
end;

end.
