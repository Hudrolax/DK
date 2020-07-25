unit nomencl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, DBF, ExtCtrls, Gvar, serch, Menus, printlist1,
  ComCtrls;

type
  TForm8 = class(TForm)
    sg1: TStringGrid;
    ListBox1: TListBox;
    StaticText1: TStaticText;
    Button1: TButton;
    DBF3: TDBF;
    Button2: TButton;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label1: TLabel;
    VibranMag: TEdit;
    ListBox2: TListBox;
    GroupBox2: TGroupBox;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    ListBox3: TListBox;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    DBF: TDBF;
    tv1: TTreeView;
    NotGroup: TCheckBox;
    Button10: TButton;
    Label2: TLabel;
    Button11: TButton;
    Timer2: TTimer;
    CheckBox4: TCheckBox;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ListBox2Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure sg1DblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sg1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tv1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure NotGroupClick(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TTovBD = record
    kod:string;
    nam:string;
    rub:string;
    date:string;
    ostatok:string;
    BAR1:string;
    BAR2:string;
    BAR3:string;
    BAR4:string;
    BAR5:string;
    KT:string;
    ART:string;
    proizvod:string;
    ed:string;
    prikaz:string;
    EtoGruppa:string;
end;

var
  Form8: TForm8;
  myrect:TGridRect;
  Sort:integer;
  TovBD:array of TTovBD;
  RootNode : TTreeNode;
  PrikazFiltr:string;
implementation

{$R *.dfm}
procedure FloodPrikaz();
type
  APrikaz = record
    date:TDateTime;
    prikaz:string;
end;
var APrik:array of APrikaz;
i,j,k:Integer;
UjeEst:Boolean;
TempPrik:APrikaz;
begin
  Form8.ComboBox1.Clear;
  Form8.ComboBox1.Items.Clear;
  SetLength(APrik,0);


  if length(TovBD)=0 then
  begin
   Showmessage('Не выбран магазин!');
   Exit;
  end;

  k:=0;
  for i:=0 to Length(TovBD)-1 do
  begin
    UjeEst := false;
    for j:=0 to Length(APrik)-1 do
      if (APrik[j].prikaz = TovBD[i].prikaz) or (TovBD[i].date='') then UjeEst:=True;;
    if (not UjeEst) then
    begin
      if (Time - StrToDateTime(TovBD[i].date) > 604800) then Continue;

      SetLength(APrik,Length(APrik)+1);
      APrik[k].prikaz := TovBD[i].prikaz;
      APrik[k].date := StrToDateTime(TovBD[i].date);
      k:=k+1;
    end;
  end;

  for i:=0 to Length(APrik)-2 do      // Сортировка
    for j:=0 to Length(APrik)-2 do
      if APrik[i].date > APrik[j].date then
      begin
        TempPrik:= Aprik[i];
        APrik[i] := Aprik[j];
        APrik[j] := TempPrik;
      end;

  for i:=0 to Length(APrik)-1 do
  begin
    Form8.ComboBox1.Items.Append(APrik[i].prikaz+' - '+DateTimeToStr(APrik[i].date));
  end;
end;

function KdnRect(Rect: TRect; DLeft,DTop,DRight,DBottom: Integer): TRect;
begin
With Result do
  begin
   Left:= Rect.Left + DLeft;
   Top:= Rect.Top + DTop;
   Right:= Rect.Right + DRight;
   Bottom:= Rect.Bottom + DBottom;
  end;
end;

procedure ReloadList;
var i:integer;
begin
 Form8.ListBox3.Clear;
 if Length(PrintList) > 0 then
   for i:=0 to Length(PrintList)-1 do
    Form8.ListBox3.Items.Append(PrintList[i].kod+' - '+PrintList[i].name);
end;

procedure ClearList;
begin
  SetLength(PrintList,0);
  form8.ListBox3.Clear;
end;

procedure CheckUpdStatus;
begin
  if FileExists('temp/get_ost.txt') then
    begin
     form8.Button2.Enabled:=false;
     form8.button2.Caption:='Запрос отправлен...';
    end
  else
    form8.Button2.Enabled:=true;
    form8.button2.Caption:='Обновить {Crtl+R}';
end;

procedure Addlist;
var el,i:integer;
begin
 if form8.sg1.Cells[1,form8.sg1.row] <> '' then
  begin
   if length(PrintList)>0 then
    for i:=0 to length(PrintList)-1 do
      if PrintList[i].kod = form8.sg1.Cells[1,form8.sg1.row] then
        begin
          ShowMessage('Этот товар уже есть в списке печати!');
          Exit;
          end;
   el:= Length(PrintList)+1;
   SetLength(PrintList,el);
   PrintList[el-1].kod:=form8.sg1.Cells[1,form8.sg1.row];
   PrintList[el-1].name:=form8.sg1.Cells[2,form8.sg1.row];
   form8.ListBox3.Items.Append(PrintList[el-1].kod+' - '+PrintList[el-1].name);
  end;
 //ReloadList;
end;

procedure AddlistALL;
var el,i,j:integer;
begin
 for j:=1 to form8.sg1.RowCount-1 do
 begin
  form8.sg1.Row:=j;
 if form8.sg1.Cells[1,form8.sg1.row] <> '' then
  begin
   if length(PrintList)>0 then
    for i:=0 to length(PrintList)-1 do
      if PrintList[i].kod = form8.sg1.Cells[1,form8.sg1.row] then
        begin
          ShowMessage('Этот товар уже есть в списке печати!');
          Exit;
          end;
   el:= Length(PrintList)+1;
   SetLength(PrintList,el);
   PrintList[el-1].kod:=form8.sg1.Cells[1,form8.sg1.row];
   PrintList[el-1].name:=form8.sg1.Cells[2,form8.sg1.row];
   form8.ListBox3.Items.Append(PrintList[el-1].kod+' - '+PrintList[el-1].name);
  end
 end;
 //ReloadList;
end;

procedure DelList;
var i:integer;
pl:array of TPrintList;
s,s1:string;
begin
  if form8.ListBox3.itemIndex = -1 then Exit;
   s:= form8.ListBox3.Items.Strings[form8.ListBox3.itemIndex];
   for i:=1 to length(s) do
    if copy(s,i,1)<>' ' then
      s1:=s1+copy(s,i,1)
    else break;
   if Length(PrintList) > 0 then
     for i:=0 to Length(PrintList)-1 do
      if PrintList[i].kod = s1 then
        begin
          PrintList[i].kod:='';
          PrintList[i].name:='';
          Break;
          end;
   if NOT IsDigit(s1) then Exit;

   SetLength(pl,0);
   for i:=0 to length(PrintList)-1 do
    if PrintList[i].kod <> '' then
    begin
     SetLength(pl,length(pl)+1);
     pl[length(pl)-1].kod:=Printlist[i].kod;
     pl[length(pl)-1].name:=Printlist[i].name;
    end;
   SetLength(PrintList,0);
   SetLength(PrintList,length(pl));
   for i:=0 to length(pl)-1 do
    begin
     PrintList[i].kod := pl[i].kod;
     PrintList[i].name := pl[i].name;
    end;
   ReloadList;
end;

procedure PutBar(ARow:integer);
 var
   i,j:Integer;
   code:TCodeString;
begin
  Form8.ListBox1.Clear;
  if form8.sg1.Cells[1,ARow]<>'' then
    for i:=0 to length(TovBD)-1 do
      if TovBD[i].EtoGruppa = '0' then
       begin
        code := CodeStringToArray(TovBD[i].kod);
        if form8.sg1.Cells[1,ARow] = code[length(code)-1] then // Если код товара в ячейке совпал с кодом в БД
          begin
            if TovBD[i].BAR1<>'' then form8.ListBox1.Items.Append(TovBD[i].BAR1);
            if TovBD[i].BAR2<>'' then form8.ListBox1.Items.Append(TovBD[i].BAR2);
            if TovBD[i].BAR3<>'' then form8.ListBox1.Items.Append(TovBD[i].BAR3);
            if TovBD[i].BAR4<>'' then form8.ListBox1.Items.Append(TovBD[i].BAR4);
            if TovBD[i].BAR5<>'' then form8.ListBox1.Items.Append(TovBD[i].BAR5);
          end
       end
end;


procedure PutInTree(Rod,Kod,Nam:string);
var i:integer;
Rec:PMyRec;
PNode : TTreeNode;
begin
 if form8.tv1.Items.Count = 0 then
  begin
   Rec:=New(PMyRec);
   Rec.kod:='';
   RootNode := Form8.tv1.Items.AddObject(Nil, 'Кореневая группа', Rec);
   PMyRec(RootNode.Data).kod := 'root';
  end;

 if Rod='' then
  begin
   Rec:=New(PMyRec);
   Rec.kod:='';
   PNode := Form8.tv1.Items.AddChildObject(RootNode, Nam, Rec);
   PMyRec(PNode.Data).kod := Kod;
  end
 else
  for i:=0 to form8.tv1.Items.Count-1 do
    if PMyRec(form8.tv1.Items.Item[i].Data).kod = Rod then
    begin
     Rec:=New(PMyRec);
     Rec.kod:='';
     PNode := Form8.tv1.Items.AddChildObject(form8.tv1.Items.Item[i], Nam, Rec);
     PMyRec(PNode.Data).kod := Kod;
    end;

 RootNode.Expanded:=true;   
end;

procedure flood(GCode:string);
var i,j,k,ii:Integer;
codes:TCodeString;
bars:string;
begin
 if length(TovBD)=0 then
  begin
   Showmessage('Не выбран магазин!');
   Exit;
  end;

 form8.ListBox1.Clear;
   // Чистим табличку.

  for i:=1 to Form8.sg1.RowCount-1 do
    for j:=0 to Form8.sg1.ColCount do
      Form8.sg1.Cells[j,i]:='';

  form8.sg1.RowCount:=1;

  //Заполняем записями из БД

 ii:=0;
 if form8.NotGroup.Checked then
  if PrikazFiltr<>'' then
    begin
     for i:=0 to length(TovBD)-1 do
      if (TovBd[i].EtoGruppa = '0') and (TovBd[i].prikaz = PrikazFiltr) then
      begin
        bars:='';
        codes:=CodeStringToArray(TovBD[i].kod);
        form8.sg1.RowCount:=form8.sg1.RowCount+1;
        k:=0;
        ii:=ii+1;
        Form8.sg1.Cells[0,ii]:=inttostr(ii); // Номер по порядку
        Form8.sg1.Cells[1,ii]:=codes[length(codes)-1]; // Код товара
        Form8.sg1.Cells[2,ii]:=TovBD[i].nam; // Наименование
        Form8.sg1.Cells[7,ii]:=TovBD[i].ostatok; // Остаток
        if TovBD[i].BAR1<>'' then begin bars:=bars+TovBD[i].BAR1; k:=k+1; end;
        if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
        if TovBD[i].BAR2<>'' then begin bars:=bars+TovBD[i].BAR2; k:=k+1; end;
        if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
        if TovBD[i].BAR3<>'' then begin bars:=bars+TovBD[i].BAR3; k:=k+1; end;
        if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
        if TovBD[i].BAR4<>'' then begin bars:=bars+TovBD[i].BAR4; k:=k+1; end;
        if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
        if TovBD[i].BAR5<>'' then begin bars:=bars+TovBD[i].BAR5; k:=k+1; end;
        Form8.sg1.Cells[4,ii]:=inttostr(k); // Кол-во штрихкодов
        Form8.sg1.Cells[5,ii]:=TovBD[i].rub; // цена
        Form8.sg1.Cells[6,ii]:=TovBD[i].date; // Дата приказа
        Form8.sg1.Cells[3,ii]:=TovBD[i].ed;  // ЕД измерения
        Form8.sg1.Cells[8,ii]:=TovBD[i].ART; // Артикул
        Form8.sg1.Cells[9,ii]:=bars; // Баркоды
      end
    end
  else
    begin
     for i:=0 to length(TovBD)-1 do
      if TovBd[i].EtoGruppa = '0' then
      begin
        bars:='';
        codes:=CodeStringToArray(TovBD[i].kod);
        form8.sg1.RowCount:=form8.sg1.RowCount+1;
        k:=0;
        ii:=ii+1;
        Form8.sg1.Cells[0,ii]:=inttostr(ii); // Номер по порядку
        Form8.sg1.Cells[1,ii]:=codes[length(codes)-1]; // Код товара
        Form8.sg1.Cells[2,ii]:=TovBD[i].nam; // Наименование
        Form8.sg1.Cells[7,ii]:=TovBD[i].ostatok; // Остаток
        if TovBD[i].BAR1<>'' then begin bars:=bars+TovBD[i].BAR1; k:=k+1; end;
        if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
        if TovBD[i].BAR2<>'' then begin bars:=bars+TovBD[i].BAR2; k:=k+1; end;
        if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
        if TovBD[i].BAR3<>'' then begin bars:=bars+TovBD[i].BAR3; k:=k+1; end;
        if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
        if TovBD[i].BAR4<>'' then begin bars:=bars+TovBD[i].BAR4; k:=k+1; end;
        if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
        if TovBD[i].BAR5<>'' then begin bars:=bars+TovBD[i].BAR5; k:=k+1; end;
        Form8.sg1.Cells[4,ii]:=inttostr(k); // Кол-во штрихкодов
        Form8.sg1.Cells[5,ii]:=TovBD[i].rub; // цена
        Form8.sg1.Cells[6,ii]:=TovBD[i].date; // Дата приказа
        Form8.sg1.Cells[3,ii]:=TovBD[i].ed;  // ЕД измерения
        Form8.sg1.Cells[8,ii]:=TovBD[i].ART; // Артикул
        Form8.sg1.Cells[9,ii]:=bars; // Баркоды
      end
    end;
 if NOT form8.NotGroup.Checked then
 for i:=0 to length(TovBD)-1 do
  if TovBd[i].EtoGruppa = '0' then
  begin
   codes:=CodeStringToArray(TovBD[i].kod);
   if Gcode <> 'root' then // Если без кода группы
   begin
    if length(codes)>1 then
     begin
      if codes[length(codes)-2] = Gcode then // Если код группировки совпадает - выводим
       begin
         bars:='';
         form8.sg1.RowCount:=form8.sg1.RowCount+1;
         k:=0;
         ii:=ii+1;
         Form8.sg1.Cells[0,ii]:=inttostr(ii); // Номер по порядку
         Form8.sg1.Cells[1,ii]:=codes[length(codes)-1]; // Код товара
         Form8.sg1.Cells[2,ii]:=TovBD[i].nam; // Наименование
         Form8.sg1.Cells[7,ii]:=TovBD[i].ostatok; // Остаток
         if TovBD[i].BAR1<>'' then begin bars:=bars+TovBD[i].BAR1; k:=k+1; end;
         if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
         if TovBD[i].BAR2<>'' then begin bars:=bars+TovBD[i].BAR2; k:=k+1; end;
         if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
         if TovBD[i].BAR3<>'' then begin bars:=bars+TovBD[i].BAR3; k:=k+1; end;
         if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
         if TovBD[i].BAR4<>'' then begin bars:=bars+TovBD[i].BAR4; k:=k+1; end;
         if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
         if TovBD[i].BAR5<>'' then begin bars:=bars+TovBD[i].BAR5; k:=k+1; end;
         Form8.sg1.Cells[4,ii]:=inttostr(k); // Кол-во штрихкодов
         Form8.sg1.Cells[5,ii]:=TovBD[i].rub; // цена
         Form8.sg1.Cells[6,ii]:=TovBD[i].date; // Дата приказа
         Form8.sg1.Cells[3,ii]:=TovBD[i].ed;  // ЕД измерения
         Form8.sg1.Cells[8,ii]:=TovBD[i].ART; // Артикул
         Form8.sg1.Cells[9,ii]:=bars; // Баркоды
        end;
      end
    else
     continue;
   end
   else
    begin
     if length(codes)=1 then
     begin
         bars:='';
         form8.sg1.RowCount:=form8.sg1.RowCount+1;
         k:=0;
         ii:=ii+1;
         Form8.sg1.Cells[0,ii]:=inttostr(ii); // Номер по порядку
         Form8.sg1.Cells[1,ii]:=codes[0]; // Код товара
         Form8.sg1.Cells[2,ii]:=TovBD[i].nam; // Наименование
         Form8.sg1.Cells[7,ii]:=TovBD[i].ostatok; // Остаток
         if TovBD[i].BAR1<>'' then begin bars:=bars+TovBD[i].BAR1; k:=k+1; end;
         if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
         if TovBD[i].BAR2<>'' then begin bars:=bars+TovBD[i].BAR2; k:=k+1; end;
         if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
         if TovBD[i].BAR3<>'' then begin bars:=bars+TovBD[i].BAR3; k:=k+1; end;
         if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
         if TovBD[i].BAR4<>'' then begin bars:=bars+TovBD[i].BAR4; k:=k+1; end;
         if (bars<>'') and (Copy(bars,Length(bars),1)<>',') then bars:=bars+',';
         if TovBD[i].BAR5<>'' then begin bars:=bars+TovBD[i].BAR5; k:=k+1; end;
         Form8.sg1.Cells[4,ii]:=inttostr(k); // Кол-во штрихкодов
         Form8.sg1.Cells[5,ii]:=TovBD[i].rub; // цена
         Form8.sg1.Cells[6,ii]:=TovBD[i].date; // Дата приказа
         Form8.sg1.Cells[3,ii]:=TovBD[i].ed;  // ЕД измерения
         Form8.sg1.Cells[8,ii]:=TovBD[i].ART; // Артикул
         Form8.sg1.Cells[9,ii]:=bars; // Баркоды
      end
     else
     continue;
    end;

   end;

  if form8.sg1.RowCount>1 then
   form8.sg1.FixedRows:=1;
   // Открываем БД database.dbf
  form8.ListBox1.Clear;
  PutBar(1);

 Form8.Edit1.SetFocus;
end;

procedure FloodGroup(m:integer);
var i,j,levels:Integer;
codes:TCodeString;
begin
  form8.tv1.Items.Clear;
   // Заполняем массив из БД
   // Открываем БД database.dbf
 try
  form8.DBF.TableName:=EXEPath+'base\database'+inttostr(m)+'.dbf';
  Form8.DBF.Exclusive:=false;
  Form8.DBF.Open;
  except
    ShowMessage('Не могу открыть base\database'+inttostr(m)+'.dbf. Попробуйте еще раз.');
    Exit;
   end;

  if Form8.DBF.RecordCount=0 then
     begin
      try
       Form8.DBF.Close;
      except
      end;
      Exit;
      end;
     // записываем всю БД в массив для удобства работы с ней
  SetLength(TovBD,Form8.DBF.RecordCount);
  for i:=0 to form8.DBF.RecordCount-1 do
    begin
      TovBD[i].kod := form8.DBF.GetFieldData(1);
      TovBD[i].nam := form8.DBF.GetFieldData(2);
      TovBD[i].rub := form8.DBF.GetFieldData(3);
      TovBD[i].date := form8.DBF.GetFieldData(4);
      TovBD[i].ostatok := form8.DBF.GetFieldData(5);
      TovBD[i].BAR1 := form8.DBF.GetFieldData(6);
      TovBD[i].BAR2 := form8.DBF.GetFieldData(7);
      TovBD[i].BAR3 := form8.DBF.GetFieldData(8);
      TovBD[i].BAR4 := form8.DBF.GetFieldData(9);
      TovBD[i].BAR5 := form8.DBF.GetFieldData(10);
      TovBD[i].KT := form8.DBF.GetFieldData(11);
      TovBD[i].ART := form8.DBF.GetFieldData(12);
      TovBD[i].proizvod := form8.DBF.GetFieldData(13);
      TovBD[i].ed := form8.DBF.GetFieldData(14);
      TovBD[i].prikaz := form8.DBF.GetFieldData(15);
      TovBD[i].EtoGruppa := form8.DBF.GetFieldData(16);
      form8.DBF.Next;
    end;

  // Закрываем БД
 try
  Form8.DBF.Close;
 except
   end;


   levels:=0;
   // Заполним дерево группами
 for i:=0 to length(TovBD)-1 do
  if TovBD[i].EtoGruppa='1' then // Это группа
  begin
   codes:=CodeStringToArray(TovBD[i].kod);
   if length(codes)>levels then levels:=length(codes);
  end;

  for j:=1 to levels do
    for i:=0 to length(TovBD)-1 do
      if TovBD[i].EtoGruppa='1' then // Это группа
      begin
       codes:=CodeStringToArray(TovBD[i].kod);
       if length(codes) = j then
        if length(codes)=1 then
          PutInTree('',codes[length(codes)-1],TovBD[i].nam)
        else
          PutInTree(codes[length(codes)-2],codes[length(codes)-1],TovBD[i].nam);
       end;

  flood('root');

 end;


procedure SortStringGrid(var GenStrGrid: TStringGrid; ThatCol: Integer);
 const
  TheSeparator = '@';
 var
   CountItem, I, J, K, ThePosition: integer;
   MyList: TStringList;
   MyString, TempString: string;
   jj:integer;
begin
  CountItem := GenStrGrid.RowCount;
  MyList        := TStringList.Create;
   MyList.Sorted := False;
   try
     begin
       for I := 1 to (CountItem - 1) do
         MyList.Add(GenStrGrid.Rows[i].Strings[ThatCol] + TheSeparator +
           GenStrGrid.Rows[i].Text);
      Mylist.Sort;
       for K := 1 to Mylist.Count do
       begin
        MyString := MyList.Strings[(K - 1)];
        ThePosition := Pos(TheSeparator, MyString);
         TempString  := '';
         TempString := Copy(MyString, (ThePosition + 1), Length(MyString));
         MyList.Strings[(K - 1)] := '';
         MyList.Strings[(K - 1)] := TempString;
       end;
      if Sort=0 then
        for J := 1 to (CountItem - 1) do
           GenStrGrid.Rows[J].Text := MyList.Strings[(J - 1)]
      else
        begin
          jj:=(CountItem - 1);
          for J := 1 to (CountItem - 1) do
            begin
             GenStrGrid.Rows[J].Text := MyList.Strings[(jj - 1)];
             jj:=jj-1
            end 
        end;
     end;
   finally
    MyList.Free;
   end;
end;

procedure SortRows1(col:integer);
var i,j,n,k:integer;
temp:string;
begin
  n:=form8.sg1.RowCount;
  For i := n - 1 downto 1 do
    For j := 1 to i do
    begin
      if (form8.sg1.Cells[col,j]='') or (form8.sg1.Cells[col,j+1]='') then
        Continue;
      if Sort=0 then
        begin
          if StrToFloatDef(T4kToZap(form8.sg1.Cells[col,j]),0) > StrToFloatDef(T4kToZap(form8.sg1.Cells[col,j+1]),0) then
           for k:=0 to form8.sg1.ColCount-1 do
              begin
                temp:=form8.sg1.Cells[k,j];
               form8.sg1.Cells[k,j]:=form8.sg1.Cells[k,j+1];
               form8.sg1.Cells[k,j+1]:=temp;
              end
        end
      else
        if StrToFloatDef(T4kToZap(form8.sg1.Cells[col,j]),0) < StrToFloatDef(T4kToZap(form8.sg1.Cells[col,j+1]),0) then
           for k:=0 to form8.sg1.ColCount-1 do
              begin
                temp:=form8.sg1.Cells[k,j];
               form8.sg1.Cells[k,j]:=form8.sg1.Cells[k,j+1];
               form8.sg1.Cells[k,j+1]:=temp;
              end

    end;
  end;

procedure TForm8.FormCreate(Sender: TObject);
begin
 sg1.Cells[0,0]:='№';
 sg1.Cells[1,0]:='Код:';
 sg1.Cells[2,0]:='Наименование:';
 sg1.Cells[3,0]:='Ед:';
 sg1.Cells[4,0]:='ШК:';
 sg1.Cells[5,0]:='Цена:';
 sg1.Cells[6,0]:='Дата получения';
 sg1.Cells[7,0]:='Ост.';
 sg1.Cells[8,0]:='Артикул';
 sg1.Cells[9,0]:='ШтрихКоды';
 end;

procedure TForm8.Button1Click(Sender: TObject);
begin
 ListBox2.Clear;
 ListBox1.Clear;
 VibranMag.Text:='0';
Form8.Visible:=False;
end;

procedure TForm8.Button2Click(Sender: TObject);
var f:textfile;
begin
 if VibranMag.Text='' then
  begin
    ShowMessage('Не выбран магазин!');
    Exit
  end;
 Button2.Enabled:=false;
 button2.Caption:='Запрос отправлен...';
 assignfile(f,'temp/mag'+VibranMag.Text+'/get_ost.txt');
 rewrite(f);
 closefile(f);
end;

procedure TForm8.sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
PutBar(ARow);
end;

procedure TForm8.Timer1Timer(Sender: TObject);
var j:Integer;
begin
 Timer1.Enabled:=false;
 ListBox2.Clear;
 for j:=1 to 5 do
   if Magaz[j].FTPDir<>'' then
     ListBox2.Items.Append(inttostr(j)+' - '+Magaz[j].Name);
end;

procedure TForm8.Button3Click(Sender: TObject);
var i,m:Integer;
begin
  m:=Form8.sg1.Selection.Top;
 for i:=m+1 to Form8.sg1.RowCount do
  begin
  if CheckBox1.checked then
    if AnsiPos(Edit1.Text,sg1.Cells[1,i])>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    if VibranMag.Text<>'0' then
      PutBar(i);
    Break;
   end;

  if CheckBox2.checked then
    if AnsiPos(alphamin(Edit1.Text),alphamin(sg1.Cells[2,i]))>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    if VibranMag.Text<>'0' then
      PutBar(i);
    Break;
   end;

  if CheckBox3.checked then
    if AnsiPos(Edit1.Text,sg1.Cells[5,i])>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    if VibranMag.Text<>'0' then
      PutBar(i);
    Break;
   end;

   if CheckBox4.checked then
    if AnsiPos(Edit1.Text,sg1.Cells[9,i])>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    if VibranMag.Text<>'0' then
      PutBar(i);
    Break;
   end;

  end;
  Edit1.SetFocus;
  Button3.Default:=True;
  Button4.Default:=False;
end;

procedure TForm8.Button4Click(Sender: TObject);
var i,m:Integer;
begin
  m:=Form8.sg1.Selection.Top;
 for i:=m-1 downto 1 do
  begin
  if CheckBox1.checked then
    if AnsiPos(Edit1.Text,sg1.Cells[1,i])>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    if VibranMag.Text<>'0' then
      PutBar(i);
    Break;
   end;

  if CheckBox2.checked then
    if AnsiPos(alphamin(Edit1.Text),alphamin(sg1.Cells[2,i]))>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    if VibranMag.Text<>'0' then
      PutBar(i);
    Break;
   end;

  if CheckBox3.checked then
    if AnsiPos(Edit1.Text,sg1.Cells[5,i])>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    if VibranMag.Text<>'0' then
      PutBar(i);
    Break;
   end;

   if CheckBox4.checked then
    if AnsiPos(Edit1.Text,sg1.Cells[9,i])>0 then
   begin
    myrect.top:=i;
    myrect.bottom:=i;
    myrect.Right:=10;
    sg1.Selection:=myrect;
    sg1.TopRow:=i;
    if VibranMag.Text<>'0' then
      PutBar(i);
    Break;
   end;

  end;
  Edit1.SetFocus;
  Button3.Default:=False;
  Button4.Default:=True;
end;

procedure TForm8.Button5Click(Sender: TObject);
var i:Integer;
begin

 SetLength(tbl,sg1.RowCount-1);

 for i:=1 to sg1.RowCount-1 do
  begin
    tbl[i-1].kod:=sg1.Cells[1,i];
    tbl[i-1].nam:=sg1.Cells[2,i];
    tbl[i-1].bar:=sg1.Cells[4,i];
    tbl[i-1].rub:=sg1.Cells[5,i];
    tbl[i-1].date:=sg1.Cells[6,i];
    tbl[i-1].bars:=sg1.Cells[9,i];
    end;
 // Если форму открывали - просто показываем ее впереди.

 Form9.Visible:=True;
 Form9.Show;

 // Ставим чекбоксы так же как на основной форме
 if CheckBox1.Checked then Form9.checkbox1.checked:=True else
    Form9.CheckBox1.Checked:=false;
 if CheckBox2.Checked then Form9.checkbox2.checked:=True else
    Form9.CheckBox2.Checked:=false;
 if CheckBox3.Checked then Form9.checkbox3.checked:=True else
    Form9.CheckBox3.Checked:=False;
 if CheckBox4.Checked then Form9.checkbox4.checked:=True else
    Form9.CheckBox4.Checked:=False;

  Form9.Edit1.Text:=Edit1.Text;
 Form9.Timer1.Enabled:=True;
end;

// Процедура отрисовки ячейки
// Вызывается при каждом изменении ячейки
procedure TForm8.sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var r: TRect;
begin
  // Прорисовываем заголовки таблицы
  if (ARow=0) then
  with sg1 do
  begin
   Canvas.Font.Color:=clBlue;
   Canvas.Font.Style:=[fsBold];
   Canvas.TextOut(Rect.Left+2,Rect.Top+2,sg1.Cells[Acol,Arow]);
   end;

end;


procedure TForm8.ListBox2Click(Sender: TObject);
begin
 if IsDigit(copy(listbox2.Items.Strings[Listbox2.ItemIndex],1,1)) then
  begin
   VibranMag.Text:=copy(listbox2.Items.Strings[Listbox2.ItemIndex],1,1);
   FloodGroup(strtoint(VibranMag.Text));
   FloodPrikaz();
  end;
  //ShowMessage(copy(listbox2.Items.Strings[Listbox2.ItemIndex],1,1));
end;

procedure TForm8.Button8Click(Sender: TObject);
begin
 Addlist;
end;

procedure TForm8.Button7Click(Sender: TObject);
begin
ClearList;
end;

procedure TForm8.Button9Click(Sender: TObject);
begin
 DelList;
end;

procedure TForm8.sg1DblClick(Sender: TObject);
begin
Addlist;
end;

procedure TForm8.N1Click(Sender: TObject);
begin
Addlist;
end;

procedure TForm8.N2Click(Sender: TObject);
begin
DelList;
end;

procedure TForm8.Button6Click(Sender: TObject);
begin
 If ListBox3.Items.Count = 0 then
  begin
   ShowMessage('Лист печати пуст...');
   Exit;
  end;
 form16.Visible:=true;
 form16.Timer1.Enabled:=true;
 form16.Edit1.Text:=VibranMag.Text;
end;

procedure TForm8.FormActivate(Sender: TObject);
begin
ReloadList;
end;

procedure TForm8.sg1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  r : integer;
  c : integer;
begin
  sg1.MouseToCell(X, Y, C, R);
  if (r=0) then
    begin
      if (c=2) or (c=6) or (c=7) or (c=5) then
       SortStringGrid(sg1,c)
      else if (c=0) or (c=1) or (c=3) or (c=4) then
        SortRows1(c);

      if Sort=0 then
        sort:=1
      else
        sort:=0;
    end;
end;

procedure TForm8.tv1Click(Sender: TObject);
var
n:TTreeNode;
begin
  if length(TovBD)=0 then
  begin
   Showmessage('Не выбран магазин!');
   Exit;
  end;
  
 n:= tv1.Selected;
 flood(PMyRec(n.Data).kod);
end;

procedure TForm8.Button10Click(Sender: TObject);
begin
AddlistALL;
end;

procedure TForm8.NotGroupClick(Sender: TObject);
begin
 If NotGroup.Checked then
     tv1.Enabled:=false
 else
   begin
      tv1.Enabled:=true;
      PrikazFiltr:='';
   end;
  flood('root');
end;

procedure TForm8.Button11Click(Sender: TObject);
var PrikN:string;
i:integer;
begin
 if Form8.ComboBox1.Text<>'' then
  begin
    for i:=1 to Length(Form8.ComboBox1.Text) do
      if(Copy(Form8.ComboBox1.Text,i,1)<>' ') then PrikN := PrikN+Copy(Form8.ComboBox1.Text,i,1)
      else Break;
    NotGroup.Checked:=true;
    tv1.Enabled:=false;
    PrikazFiltr:=PrikN;
    flood('');
  end;
end;

procedure TForm8.Timer2Timer(Sender: TObject);
begin
 CheckUpdStatus; // Проверяем статус запроса товаров
end;

end.
