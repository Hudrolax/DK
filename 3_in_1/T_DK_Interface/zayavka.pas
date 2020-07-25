unit zayavka;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBF, gvar, ExtCtrls, DateUtils;

type
  TForm18 = class(TForm)
    sg1: TStringGrid;
    ListBox1: TListBox;
    Label1: TLabel;
    ListBox2: TListBox;
    Label2: TLabel;
    ListBox3: TListBox;
    Label3: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DBF: TDBF;
    Timer1: TTimer;
    FN: TEdit;
    Magg: TEdit;
    KodSklada: TEdit;
    KodPostav: TEdit;
    KodGruuz: TEdit;
    PostName: TEdit;
    GruuzName: TEdit;
    prosmotr: TCheckBox;
    DBF2: TDBF;
    DBF3: TDBF;
    tv1: TTreeView;
    Button4: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sg1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure sg1KeyPress(Sender: TObject; var Key: Char);
    procedure tv1Click(Sender: TObject);
    procedure sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
        { Public declarations }
  end;
Type TSelectPoz2 = record
 SelMagPoz:integer;
 SelPostKod:string;
 SelPostName:string;
 SelGruuzKod:string;
 SelGruuzName:string;
 SelKodSklada:string;
end;
type
  Postav = record
  kod:string[10];
  name:string[100];
  dni:string[10];
  end;
type
  Gruuz = record
  kod:string[10];
  kodPost:string[10];
  name:string[100];
  end;

type TTovBD = record
  KodSklada:string;
  KodPostav:string;
  NamePostav:string;
  KodGruzootpr:string;
  NameGruzootpr:string;
  TimeZayavk:string;
  DniNedeli:string;
  Kod:string;
  Tovar:string;
  ED:string;
  SrokGodn:string;
  MinZakaz:string;
  Status:string;
  rub:string;
  Kolvo:real;
  EtoGruppa:string;
end;

var
  Form18: TForm18;
  SelectPoz:TSelectPoz2;
  a:array[0..9999] of Postav;
  b:array[0..9999] of Gruuz;
  Tovar:array of TTovBD;
  PrevSelRow:integer;
  RootNode : TTreeNode;
  TovBD:array of TTovBD;
  TempKolVo:array of TTovBD;

implementation

{$R *.dfm}
// Проверка дней недели на вхождение в список
function DniVhodyat(s:string):boolean;
var i:integer;
s2:string;
DOFW:integer;
begin
  DOFW:=DayOfTheWeek(Date);
 if form18.CheckBox1.Checked then
  begin
    Result:=true;
    Exit;
  end;
 Result:=false;
  try
   s2:=copy(s,DOFW,1);
  except
    Exit;
  end;

  if (s2='1') then
    begin
     result:=true;
     Exit;
    end;


end;

// Заполниеие списка магазинов
procedure CreateNewZayavka;
var i:integer;
begin
  Form18.ListBox1.Clear;
  for i:=1 to 5 do
   begin
   // ShowMessage(Magaz[i].FTPDir);
    if Magaz[i].FTPDir<>'' then
      Form18.ListBox1.Items.Append(Magaz[i].Name);
   end;
   SetLength(Tovar,0);
end;

procedure LoadFromBD(m:integer;kodPost,KodGruuz:string;rejim:integer);
var i,k:integer;
begin
  SetLength(TovBD,0);
  k:=1;
     // Открываем БД
   try
     Form18.DBF.TableName:='base\zayavka_BD'+inttostr(m)+'.dbf';
     Form18.DBF.Exclusive:=false;
     Form18.DBF.Open;
   except
     end;
   // Загрузим из DBF в массив записей
   if form18.DBF.RecordCount<>0 THEN
    for i:=1 to form18.DBF.RecordCount do
     begin
        if rejim=1 then // Обновление при выборе магаза
         begin
          SetLength(TovBD,length(TovBD)+1);
          TovBD[k-1].KodSklada := form18.DBF.GetFieldData(1);
          TovBD[k-1].KodPostav := form18.DBF.GetFieldData(2);
          TovBD[k-1].NamePostav := form18.DBF.GetFieldData(3);
          TovBD[k-1].KodGruzootpr := form18.DBF.GetFieldData(4);
          TovBD[k-1].NameGruzootpr := form18.DBF.GetFieldData(5);
          TovBD[k-1].TimeZayavk := form18.DBF.GetFieldData(6);
          TovBD[k-1].DniNedeli := form18.DBF.GetFieldData(7);
          TovBD[k-1].Kod := form18.DBF.GetFieldData(8);
          TovBD[k-1].Tovar := form18.DBF.GetFieldData(9);
          TovBD[k-1].ED := form18.DBF.GetFieldData(10);
          TovBD[k-1].SrokGodn := form18.DBF.GetFieldData(11);
          TovBD[k-1].MinZakaz := form18.DBF.GetFieldData(12);
          TovBD[k-1].Status := form18.DBF.GetFieldData(13);
          TovBD[k-1].rub := form18.DBF.GetFieldData(14);
          TovBD[k-1].EtoGruppa := form18.DBF.GetFieldData(15);
          k:=k+1;
         end
        else if rejim=2 then // Обновление при выборе поставщика
          begin
           if KodPost=form18.DBF.GetFieldData(2) then
              begin
                SetLength(TovBD,length(TovBD)+1);
                TovBD[k-1].KodSklada := form18.DBF.GetFieldData(1);
                TovBD[k-1].KodPostav := form18.DBF.GetFieldData(2);
                TovBD[k-1].NamePostav := form18.DBF.GetFieldData(3);
                TovBD[k-1].KodGruzootpr := form18.DBF.GetFieldData(4);
                TovBD[k-1].NameGruzootpr := form18.DBF.GetFieldData(5);
                TovBD[k-1].TimeZayavk := form18.DBF.GetFieldData(6);
                TovBD[k-1].DniNedeli := form18.DBF.GetFieldData(7);
                TovBD[k-1].Kod := form18.DBF.GetFieldData(8);
                TovBD[k-1].Tovar := form18.DBF.GetFieldData(9);
                TovBD[k-1].ED := form18.DBF.GetFieldData(10);
                TovBD[k-1].SrokGodn := form18.DBF.GetFieldData(11);
                TovBD[k-1].MinZakaz := form18.DBF.GetFieldData(12);
                TovBD[k-1].Status := form18.DBF.GetFieldData(13);
                TovBD[k-1].rub := form18.DBF.GetFieldData(14);
                TovBD[k-1].EtoGruppa := form18.DBF.GetFieldData(15);
                k:=k+1;
              end
          end
         else if rejim=3 then // Обновление при выборе грузоотправителя
          begin
            if (KodPost=form18.DBF.GetFieldData(2)) and (KodGruuz=form18.DBF.GetFieldData(4)) then
              begin
                SetLength(TovBD,length(TovBD)+1);
                TovBD[k-1].KodSklada := form18.DBF.GetFieldData(1);
                TovBD[k-1].KodPostav := form18.DBF.GetFieldData(2);
                TovBD[k-1].NamePostav := form18.DBF.GetFieldData(3);
                TovBD[k-1].KodGruzootpr := form18.DBF.GetFieldData(4);
                TovBD[k-1].NameGruzootpr := form18.DBF.GetFieldData(5);
                TovBD[k-1].TimeZayavk := form18.DBF.GetFieldData(6);
                TovBD[k-1].DniNedeli := form18.DBF.GetFieldData(7);
                TovBD[k-1].Kod := form18.DBF.GetFieldData(8);
                TovBD[k-1].Tovar := form18.DBF.GetFieldData(9);
                TovBD[k-1].ED := form18.DBF.GetFieldData(10);
                TovBD[k-1].SrokGodn := form18.DBF.GetFieldData(11);
                TovBD[k-1].MinZakaz := form18.DBF.GetFieldData(12);
                TovBD[k-1].Status := form18.DBF.GetFieldData(13);
                TovBD[k-1].rub := form18.DBF.GetFieldData(14);
                TovBD[k-1].EtoGruppa := form18.DBF.GetFieldData(15);
                k:=k+1;
              end
          end;

      form18.DBF.Next;
     end;
   try
     form18.dbf.close;
   except
   end;
end;

// Обновление списка потсавщиков
procedure UpdatePostav;
var i,j,k:integer;
EstUje:boolean;
s:Postav;
begin
  Form18.ListBox2.Clear;
   k:=0;
   if length(TovBD)>0 THEN
     for i:=0 to length(TovBD)-1 do
       if TovBD[i].EtoGruppa='0' then
       begin
        s.kod:=TovBD[i].KodPostav;
        s.name:=TovBD[i].NamePostav;
        s.dni:=TovBD[i].DniNedeli;
        EstUje:=false;
        for j:=0 to 9999 do
         begin
          if (a[j].kod='') then Break;
          if (a[j].kod = s.kod) then
            begin
             EstUje:=true;
             Break;
            end;
         end;
        If (NOT EstUje) AND (DniVhodyat(s.dni)) then
         begin
          a[k]:=s;
          k:=k+1;
         end;
       end;
  for i:=0 to 9999 do
    begin
     if a[i].kod='' then Break;
     if a[i].name='' then a[i].name:='*Без наименования*';
     Form18.ListBox2.Items.Append(a[i].name);
    end;
end;

// Обновление списка грузоотправителей
procedure UpdateGruuz;
var i,j,k,l:integer;
s:Gruuz;
EstUje:boolean;
begin
 Form18.ListBox3.Clear;
   k:=0;
   if length(TovBD)>0 THEN
     for i:=0 to length(TovBD)-1 do
       if TovBD[i].EtoGruppa='0' then
       begin
        s.kod:=TovBD[i].KodGruzootpr;
        s.kodPost:=TovBD[i].KodPostav;
        s.name:=TovBD[i].NameGruzootpr;
        EstUje:=false;
        for j:=0 to 9999 do
         begin
          if (b[j].kod='') then Break;
          if (b[j].kod = s.kod) then
            begin
             EstUje:=true;
             Break;
            end;
         end;

        If (NOT EstUje) AND (s.kodPost = SelectPoz.SelPostKod) then
         begin
          b[k]:=s;
          k:=k+1;
         end;
       end;

   for i:=0 to 9999 do
    begin
     if b[i].kod='' then Break;
     if b[i].name='' then b[i].name:='*Без наименования*';
     Form18.ListBox3.Items.Append(b[i].name);
    end;
end;

procedure PutInTree(Rod,Kod,Nam:string);
var i:integer;
Rec:PMyRec;
PNode : TTreeNode;
begin
 if form18.tv1.Items.Count = 0 then
  begin
   Rec:=New(PMyRec);
   Rec.kod:='';
   RootNode := Form18.tv1.Items.AddObject(Nil, 'Кореневая группа', Rec);
   PMyRec(RootNode.Data).kod := 'root';
  end;

 if Rod='root' then
  begin
   Rec:=New(PMyRec);
   Rec.kod:='';
   PNode := Form18.tv1.Items.AddChildObject(RootNode, Nam, Rec);
   PMyRec(PNode.Data).kod := Kod;
  end
 else
  for i:=0 to form18.tv1.Items.Count-1 do
    if PMyRec(form18.tv1.Items.Item[i].Data).kod = Rod then
    begin
     Rec:=New(PMyRec);
     Rec.kod:='';
     PNode := Form18.tv1.Items.AddChildObject(form18.tv1.Items.Item[i], Nam, Rec);
     PMyRec(PNode.Data).kod := Kod;
    end;

 RootNode.Expanded:=true;   
end;

procedure ShowZakaz;
var i,j,k:integer;
begin
 // Чистим сетку на форме
   for i:=1 to form18.sg1.RowCount-1 do
    for j:=0 to form18.sg1.ColCount-1 do
      form18.sg1.Cells[j,i]:='';
  form18.sg1.RowCount:=1;
  form18.sg1.Cells[0,0]:='№';
  form18.sg1.Cells[1,0]:='Код';
  form18.sg1.Cells[2,0]:='Наименование';
  form18.sg1.Cells[3,0]:='Ед.';
  form18.sg1.Cells[4,0]:='Цена';
  form18.sg1.Cells[5,0]:='Срок годн.';
  form18.sg1.Cells[6,0]:='Мин.заказ';
  form18.sg1.Cells[7,0]:='Статус';
  form18.sg1.Cells[8,0]:='Кол-во';
  k:=1;
  if length(Tovar)>0 then
    for i:=0 to length(tovar)-1 do
      begin
       form18.sg1.RowCount:=form18.sg1.RowCount+1;
       form18.sg1.Cells[0,k]:=inttostr(k);
       form18.sg1.Cells[1,k]:=Tovar[i].Kod;
       form18.sg1.Cells[2,k]:=Tovar[i].Tovar;
       form18.sg1.Cells[3,k]:=Tovar[i].ED;
       form18.sg1.Cells[4,k]:=Tovar[i].rub;
       form18.sg1.Cells[5,k]:=Tovar[i].SrokGodn;
       form18.sg1.Cells[6,k]:=Tovar[i].MinZakaz;
       form18.sg1.Cells[7,k]:=Tovar[i].Status;
       form18.sg1.Cells[8,k]:=T4kToZap(floattostr(Tovar[i].Kolvo));
       k:=k+1;
      end;
  if form18.sg1.RowCount>1 then
    form18.sg1.FixedRows:=1;    
end;

// Обновление списка товара
procedure UpdateTovar(GGroup:string);
var i,j,k,l:integer;
s:TTovBD;
codes:TCodeString;
perviy:boolean;
begin

  // Чистим сетку на форме
   for i:=1 to form18.sg1.RowCount-1 do
    for j:=0 to form18.sg1.ColCount-1 do
      form18.sg1.Cells[j,i]:='';
  form18.sg1.RowCount:=1;

  form18.sg1.Cells[0,0]:='№';
  form18.sg1.Cells[1,0]:='Код';
  form18.sg1.Cells[2,0]:='Наименование';
  form18.sg1.Cells[3,0]:='Ед.';
  form18.sg1.Cells[4,0]:='Цена';
  form18.sg1.Cells[5,0]:='Срок годн.';
  form18.sg1.Cells[6,0]:='Мин.заказ';
  form18.sg1.Cells[7,0]:='Статус';
  form18.sg1.Cells[8,0]:='Кол-во';
  perviy:=true;
k:=1;
   if length(TovBD)>0 THEN
     for l:=0 to length(TovBD)-1 do
       begin
        s:=TovBD[l];
        if s.Status='Неактивный' then
           Continue;
        codes:=CodeStringToArray(TovBD[l].Kod);
        if GGroup<>'root' then
          if length(codes)>1 then
          begin
            If (codes[length(codes)-2]=GGroup) AND (s.KodPostav = SelectPoz.SelPostKod) AND (s.KodGruzootpr = SelectPoz.SelGruuzKod) AND (s.EtoGruppa = '0') then
              begin
                if perviy then
                  begin
                    SelectPoz.SelKodSklada:=s.KodSklada;
                    perviy:=false;
                  end;

                form18.sg1.RowCount:=form18.sg1.RowCount+1;
                form18.sg1.Cells[0,k]:=inttostr(k);
                form18.sg1.Cells[1,k]:=codes[length(codes)-1];
                form18.sg1.Cells[2,k]:=s.Tovar;
                form18.sg1.Cells[3,k]:=s.ED;
                form18.sg1.Cells[4,k]:=s.rub;
                form18.sg1.Cells[5,k]:=s.SrokGodn;
                form18.sg1.Cells[6,k]:=s.MinZakaz;
                form18.sg1.Cells[7,k]:=s.Status;
                form18.sg1.Cells[8,k]:='';
                k:=k+1;
               end
          end
          else Continue;


        if GGroup='root' then
         If (length(codes)=1) AND (s.KodPostav = SelectPoz.SelPostKod) AND (s.KodGruzootpr = SelectPoz.SelGruuzKod) AND (s.EtoGruppa = '0') then
         begin
          if perviy then
             begin
              SelectPoz.SelKodSklada:=s.KodSklada;
              perviy:=false;
             end;

          form18.sg1.RowCount:=form18.sg1.RowCount+1;
          form18.sg1.Cells[0,k]:=inttostr(k);
          form18.sg1.Cells[1,k]:=codes[length(codes)-1];
          form18.sg1.Cells[2,k]:=s.Tovar;
          form18.sg1.Cells[3,k]:=s.ED;
          form18.sg1.Cells[4,k]:=s.rub;
          form18.sg1.Cells[5,k]:=s.SrokGodn;
          form18.sg1.Cells[6,k]:=s.MinZakaz;
          form18.sg1.Cells[7,k]:=s.Status;
          form18.sg1.Cells[8,k]:='';
          k:=k+1;
         end;
       end;
   k:=0;
  // if form18.FN.Text<>'' then     // Проставляем количество, если заявка изменяется
    if length(Tovar)<>0 then
    for i:=1 to form18.sg1.RowCount-1 do
    begin
      for l:=0 to length(Tovar)-1 do
        if form18.sg1.Cells[1,i]=Tovar[l].Kod then
          form18.sg1.Cells[8,i]:=T4kToZap(floattostr(Tovar[l].Kolvo));
    end;
   if form18.sg1.RowCount>1 then
    form18.sg1.FixedRows:=1;
   form18.sg1.Enabled:=true;
end;

procedure FloodGroups();
var i,j,levels:integer;
codes:TCodeString;
begin
 form18.tv1.Items.Clear;
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
          PutInTree('root',codes[length(codes)-1],TovBD[i].Tovar)
        else
          PutInTree(codes[length(codes)-2],codes[length(codes)-1],TovBD[i].Tovar);
       end;
    UpdateTovar('root')
end;

// Сохранение файла заявки
procedure SaveZayavka(filename:string;Otpravit:boolean);
var namefile:string;
i:integer;
PosToStr:integer;
b1:boolean;
begin

// Создаем, заполняем и сохраняем файл с самой заявкой
  PosToStr:=0;
 //генерируем имя для файла заявки
 if filename='' then
   for i:=0 to 10 do
    begin
     if i=10 then
      begin
       ShowMessage('Не могу создать файл для заявки!!!');
       Exit;
       end;
     namefile:=Setname2(0)+inttostr(i)+'.dbf';
     if NOT FileExists(namefile) then
      Break;
    end
 else
    namefile:=filename;
      //Пробуем создать БД заяки
 if filename<>'' then
   try
         // Открываем БД заявок
    Form18.DBF2.TableName:='zayavki\'+namefile;
    Form18.DBF2.Exclusive:=false;
    Form18.DBF2.Open;
    if Form18.DBF2.RecordCount>0 then
      for i:=1 to form18.DBF2.RecordCount do
        begin
         form18.DBF2.Deleted:=true;
         form18.DBF2.Next;
        end;
    Form18.DBF2.PackTable;

    Form18.DBF2.Close;
   except
   end;

 try
  if not FileExists('zayavki\'+namefile) then
    begin
      Form18.dbf2.TableName:='zayavki\'+namefile;
    // Form18.dbf.AddFieldDefs('KodSklada',bfString,7,0);
    // Form18.dbf.AddFieldDefs('KodPostav',bfString,10,0);
    // Form18.dbf.AddFieldDefs('KodGruzootpr',bfString,7,0);
    // Form18.dbf.AddFieldDefs('Date',bfString,13,0);
    // Form18.dbf.AddFieldDefs('Sostavil',bfString,7,0);
      Form18.dbf2.AddFieldDefs('kod',bfString,13,0);
      Form18.dbf2.AddFieldDefs('Tovar',bfString,100,0);
      Form18.dbf2.AddFieldDefs('Ed',bfString,13,0);
      Form18.dbf2.AddFieldDefs('Cena',bfString,13,0);
      Form18.dbf2.AddFieldDefs('SrokGod',bfString,10,0);
      Form18.dbf2.AddFieldDefs('MinZakaz',bfString,10,0);
      Form18.dbf2.AddFieldDefs('Status',bfString,15,0);
      Form18.dbf2.AddFieldDefs('kolvo',bfString,15,0);

      Form18.dbf2.CreateTable;
      Form18.DBF2.close;
    end;

       // Открываем БД заявок
   Form18.DBF2.TableName:='zayavki\'+namefile;
   Form18.DBF2.Exclusive:=false;
   Form18.DBF2.Open;


//   form18.DBF.SetFieldData(1,SelectPoz.SelKodSklada);
//   form18.DBF.SetFieldData(2,SelectPoz.SelPostKod);
//   form18.DBF.SetFieldData(3,SelectPoz.SelGruuzKod);
//   form18.DBF.SetFieldData(4,DateToStr(Form18.DateTimePicker1.Date));
//   form18.DBF.SetFieldData(5,Form18.Edit1.Text);
//   form18.DBF.Next;
   for i:=0 to length(Tovar)-1 do
    if Tovar[i].Kolvo<>0 then
    begin
      form18.DBF2.Append;
      form18.DBF2.SetFieldData(1,Tovar[i].kod);
      form18.DBF2.SetFieldData(2,Tovar[i].Tovar);
      form18.DBF2.SetFieldData(3,Tovar[i].Ed);
      form18.DBF2.SetFieldData(4,Tovar[i].rub);
      form18.DBF2.SetFieldData(5,Tovar[i].SrokGodn);
      form18.DBF2.SetFieldData(6,Tovar[i].MinZakaz);
      form18.DBF2.SetFieldData(7,Tovar[i].Status);
      form18.DBF2.SetFieldData(8,floattostr(Tovar[i].KolVo));
     end;
   form18.DBF2.Post;
     except
    ShowMessage('Не могу создать файл zayavki\'+namefile);
    Exit
       end;
 // Заполнили, закрыли БД
 try
   Form18.DBF2.Close;
   except
     end;

 // Теперь добавляем данные о созданной заявке в журнал заявок (открываем БД журнала)
 b1:=false;
 for i:=1 to 10 do
  try
   if b1 then break;
  // Открываем БД
   Form18.DBF3.TableName:='base\jurnal_zayavok.dbf';
   Form18.DBF3.Exclusive:=true;
   Form18.DBF3.Open;
   b1:=true;
  except
  end;
 if not b1 then
  begin
   ShowMessage('Не могу открыть базу заявок. Попробуйте еще раз!');
   Exit;
    end;

 if form18.DBF3.RecordCount>0 then
  for i:=1 to form18.DBF3.RecordCount do
    begin
     if form18.DBF3.GetFieldData(10) = namefile then
      begin
        PosToStr:=i;
        Break;
       end;
     form18.DBF3.Next;
    end;
 // Если эта заявка уже есть, то редактируем ее данные
 If PosToStr<>0 then
  form18.DBF3.GoToRecord(PosToStr)
 else
  form18.DBF3.Append;

 form18.DBF3.SetFieldData(1,inttostr(SelectPoz.SelMagPoz));
 form18.DBF3.SetFieldData(2,SelectPoz.SelKodSklada);
 form18.DBF3.SetFieldData(3,datetostr(date));
 form18.DBF3.SetFieldData(4,datetostr(form18.DateTimePicker1.Date));
 form18.DBF3.SetFieldData(5,form18.Edit1.Text);
 form18.DBF3.SetFieldData(6,SelectPoz.SelPostKod);
 form18.DBF3.SetFieldData(7,SelectPoz.SelPostName);
 form18.DBF3.SetFieldData(8,SelectPoz.SelGruuzKod);
 form18.DBF3.SetFieldData(9,SelectPoz.SelGruuzName);
 form18.DBF3.SetFieldData(10,namefile);
 if Otpravit then
  form18.DBF3.SetFieldData(11,'1')
 else
  form18.DBF3.SetFieldData(11,'0');
 form18.DBF3.SetFieldData(12,'0');
 form18.DBF3.Post;

 try
   Form18.DBF3.Close;
   except
     end;

end;

procedure EditZayavka(filename:string);
begin

end;

procedure TForm18.Button3Click(Sender: TObject);
var
  i,j:integer;
begin
 prosmotr.Checked:=false;
 ListBox1.Clear;
 ListBox2.Clear;
 ListBox3.Clear;
 for i:=1 to sg1.RowCount-1 do
  for j:=0 to sg1.ColCount-1 do
    sg1.Cells[j,i]:='';
 form18.tv1.Items.Clear;   
 sg1.RowCount:=2;
 Form18.Visible:=false;
end;

procedure TForm18.Timer1Timer(Sender: TObject);
var
  j,k:integer;
begin
timer1.Enabled:=false;
CreateNewZayavka;
 If form18.prosmotr.Checked then
  begin
    Button1.Enabled:=false;
    Button2.Enabled:=false;
  end
 else
  begin
    Button1.Enabled:=true;
    Button2.Enabled:=true;
  end;


 if form18.FN.Text<>'' then
  begin
    form18.ListBox1.Enabled:=false;
    form18.ListBox2.Enabled:=false;
    form18.ListBox3.Enabled:=false;
   // form18.Edit1.Enabled:=false;
   // form18.DateTimePicker1.Enabled:=false;
    form18.Label1.Enabled:=false;
    form18.Label2.Enabled:=false;
    form18.Label3.Enabled:=false;
    form18.Label4.Enabled:=false;
    form18.Label5.Enabled:=false;
    form18.CheckBox1.Enabled:=false;
    SelectPoz.SelMagPoz:=StrToInt(Magg.text);
    SelectPoz.SelPostKod:=KodPostav.Text;
    SelectPoz.SelPostName:=PostName.Text;
    SelectPoz.SelGruuzKod:=KodGruuz.Text;
    SelectPoz.SelGruuzName:=GruuzName.Text;
    SelectPoz.SelKodSklada:=KodSklada.Text;

     try // Загрузим в массив заявку целиком
      // Открываем БД заявок
       Form18.DBF2.TableName:='zayavki\'+form18.FN.Text;
       Form18.DBF2.Exclusive:=false;
       Form18.DBF2.Open;
       if form18.dbf2.RecordCount<>0 then
       for j:=1 to form18.DBF2.RecordCount do
       begin
          if form18.DBF2.GetFieldData(8)<>'0' then
           begin
            SetLength(Tovar,length(Tovar)+1);
            k:=length(Tovar)-1;
            Tovar[k].Kod:=form18.DBF2.GetFieldData(1);
            Tovar[k].Tovar:=form18.DBF2.GetFieldData(2);
            Tovar[k].ED:=form18.DBF2.GetFieldData(3);
            Tovar[k].rub:=form18.DBF2.GetFieldData(4);
            Tovar[k].SrokGodn:=form18.DBF2.GetFieldData(5);
            Tovar[k].MinZakaz:=form18.DBF2.GetFieldData(6);
            Tovar[k].Status:=form18.DBF2.GetFieldData(7);
            Tovar[k].KolVo:= StrToFloat(Form18.DBF2.GetFieldData(8));
           end;
         form18.DBF2.Next;
       end;
     except
       end;
     try
      form18.DBF2.Close;
     except
     end;

    LoadFromBD(SelectPoz.SelMagPoz,SelectPoz.SelPostKod,SelectPoz.SelGruuzKod,3);
    FloodGroups();
  end
 else
    begin
      form18.ListBox1.Enabled:=true;
      form18.ListBox2.Enabled:=true;
      form18.ListBox3.Enabled:=true;
     // form18.Edit1.Enabled:=true;
      //form18.DateTimePicker1.Enabled:=true;
      form18.Label1.Enabled:=true;
      form18.Label2.Enabled:=true;
      form18.Label3.Enabled:=true;
      form18.Label4.Enabled:=true;
      form18.Label5.Enabled:=true;
      form18.CheckBox1.Enabled:=true;
    end;

end;

procedure TForm18.ListBox1Click(Sender: TObject);
var i:integer;
begin
  if listbox1.ItemIndex<>-1 then
   begin
    //form18.sg1.Enabled:=false;
    SelectPoz.SelMagPoz:=listbox1.ItemIndex+1;
    for i:=0 to 9999 do
     begin
      a[i].kod:='';
      a[i].name:='';
      a[i].dni:='';
     end;
    SetLength(Tovar,0); 
    LoadFromBD(SelectPoz.SelMagPoz,SelectPoz.SelPostKod,SelectPoz.SelGruuzKod,1);
    UpdatePostav;
   end;
end;

procedure TForm18.CheckBox1Click(Sender: TObject);
var i:integer;
begin
 if (form18.ListBox1.ItemIndex<>-1) then
  begin
    for i:=0 to 9999 do
     begin
      a[i].kod:='';
      a[i].name:='';
      a[i].dni:='';
     end;
    LoadFromBD(SelectPoz.SelMagPoz,SelectPoz.SelPostKod,SelectPoz.SelGruuzKod,1);
    UpdatePostav;
  end;
end;

procedure TForm18.ListBox2Click(Sender: TObject);
var i:integer;
begin
 If ListBox2.ItemIndex<>-1 then
  begin
  // form18.sg1.Enabled:=false;
   SelectPoz.SelPostKod:=a[ListBox2.ItemIndex].kod;
   SelectPoz.SelPostName:=a[ListBox2.ItemIndex].name;
   for i:=0 to 9999 do
     begin
      b[i].kod:='';
      b[i].name:='';
      b[i].kodPost:='';
     end;
   LoadFromBD(SelectPoz.SelMagPoz,SelectPoz.SelPostKod,SelectPoz.SelGruuzKod,2);
   UpdateGruuz;
   SetLength(Tovar,0);
  end;
end;

procedure TForm18.FormShow(Sender: TObject);
begin
  sg1.Cells[0,0]:='№';
  sg1.Cells[1,0]:='Код';
  sg1.Cells[2,0]:='Наименование';
  sg1.Cells[3,0]:='Цена';
  sg1.Cells[4,0]:='Ед.';
  sg1.Cells[5,0]:='Срок годн.';
  sg1.Cells[6,0]:='Мин.заказ';
  sg1.Cells[7,0]:='Статус';
  sg1.Cells[8,0]:='Кол-во';
end;

procedure TForm18.ListBox3Click(Sender: TObject);
var i:integer;
begin
 If ListBox3.ItemIndex<>-1 then
  begin
   SelectPoz.SelGruuzKod:=b[ListBox3.ItemIndex].kod;
   SelectPoz.SelGruuzName:=b[ListBox3.ItemIndex].name;
   LoadFromBD(SelectPoz.SelMagPoz,SelectPoz.SelPostKod,SelectPoz.SelGruuzKod,3);
   FloodGroups();
   PrevSelRow:=0;
  end;
end;

procedure TForm18.sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
  var S1,S2:real;
begin
  if (ACol=8) and (NOT prosmotr.Checked) and (sg1.Cells[7,ARow]<>'Выводимый') and (sg1.Cells[7,ARow]<>'Тестируемый') then sg1.Options:=sg1.Options +[goEditing] else sg1.Options:=sg1.Options -[goEditing];
  if (ARow<>PrevSelRow) and (PrevSelRow<>0) and (ARow<>0) and (ACol=8) and (sg1.Cells[7,PrevSelRow]<>'') and (sg1.Cells[8,PrevSelRow]<>'0') then
    begin
      try
        S1:=strtofloat(sg1.Cells[8,PrevSelRow]);
        S2:=strtofloat(sg1.Cells[6,PrevSelRow]);
      except
        s1:=0;
        s2:=0;
        end;
     if S1/S2 <> round(S1/S2) then
      begin
       ShowMessage('Для товара ('+sg1.Cells[1,PrevSelRow]+') '+sg1.cells[2,PrevSelRow]+' НЕ верно выбрано кол-во.');
       sg1.Cells[8,PrevSelRow]:='';
       Tovar[PrevSelRow-1].KolVo:=0;
       sg1.Col:=8;
       sg1.Row:=PrevSelRow;
      end;
    end;
end;

procedure TForm18.sg1SetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
var
  s:string;
  i,k:integer;
  codes:TCodeString;
  zamena:boolean;
begin
  s:=Value;
  If ACol=8 then
  begin
    zamena:=false;
   if IsSumm(s) then
    begin
     s:=T4kToZap(s);
     if length(Tovar)>0 then
     For i:=0 to length(Tovar)-1 do
      Begin
        if Tovar[i].Kod = sg1.Cells[1,ARow] then
          begin
           Tovar[i].Kolvo := strtofloat(s);
           zamena:=true;
           Break;
          end;
      end;
      if NOT zamena then
        begin
          Setlength(Tovar,length(Tovar)+1);
          k:=length(Tovar)-1;
          Tovar[k].Kod:=sg1.Cells[1,ARow];
          Tovar[k].Tovar:=sg1.Cells[2,ARow];
          Tovar[k].ED:=sg1.Cells[3,ARow];
          Tovar[k].rub:=sg1.Cells[4,ARow];
          Tovar[k].SrokGodn:=sg1.Cells[5,ARow];
          Tovar[k].MinZakaz:=sg1.Cells[6,ARow];
          Tovar[k].Status:=sg1.Cells[7,ARow];
          Tovar[k].Kolvo := strtofloat(s);
        end;
     PrevSelRow:=ARow;
    end
   else
    begin
     if length(Tovar)>0 then
     For i:=0 to length(Tovar)-1 do
      Begin
        if Tovar[i].Kod = sg1.Cells[1,ARow] then
          begin
           Tovar[k].Kolvo := 0;
           Break;
          end;
      end;

      sg1.Cells[ACol,ARow]:='';
    end;
  end;
end;

procedure TForm18.Button1Click(Sender: TObject);
var s:string;
i:integer;
pusto:boolean;
begin
  pusto:=true;
  // Проверка на дурака
  If Edit1.Text='' then
    begin
     ShowMessage('Не заполнен отправитель заявки!');
     Exit;
    end;
  If datetostr(DateTimePicker1.Date)=datetostr(Date-1) then
    begin
     ShowMessage('Не заполнено поле "Поступление на дату"!');
     Exit;
    end;
  if length(Tovar)=0 then
    begin
     ShowMessage('Заявка не заполнена!');
     Exit
    end;
  for i:=0 to length(Tovar) do
    if Tovar[i].Kolvo<>0 then
      begin
        pusto:=false;
        Break;
      end;
  if pusto then
    begin
     ShowMessage('Ни у одного товара нет количества!');
     Exit
    end;
  s:='';
 if Form18.FN.Text<>'' then
  s:=Form18.FN.Text;
 SaveZayavka(s,false);
 form18.Visible:=false;
end;

procedure TForm18.Button2Click(Sender: TObject);
var s:string;
i:integer;
pusto:boolean;
begin
  pusto:=true;
   // Проверка на дурака
  If Edit1.Text='' then
    begin
     ShowMessage('Не заполнен отправитель заявки!');
     Exit;
    end;
  If datetostr(DateTimePicker1.Date)=datetostr(Date-1) then
    begin
     ShowMessage('Не заполнено поле "Поступление на дату"!');
     Exit;
    end;
  if length(Tovar)=0 then
    begin
     ShowMessage('Заявка не заполнена!');
     Exit
    end;

  for i:=0 to length(Tovar) do
    if Tovar[i].Kolvo<>0 then
      begin
        pusto:=false;
        Break;
      end;
  if pusto then
    begin
     ShowMessage('Ни у одного товара нет количества!');
     Exit
    end;
  
  s:='';
 if Form18.FN.Text<>'' then
  s:=Form18.FN.Text;
 SaveZayavka(s,true);
 form18.Visible:=false;
end;

procedure TForm18.sg1KeyPress(Sender: TObject; var Key: Char);
const
vk_enter=#13;
begin
 If Key = vk_enter then
  begin
    if sg1.Row+1 < sg1.RowCount then
      Sg1.Row:=Sg1.Row+1;
    exit;
    end;
 if NOT((Key in ['0'..'9']) or (key = ',')) then key :=#0;
end;

procedure TForm18.tv1Click(Sender: TObject);
var PNode : TTreeNode;
begin
 PNode:=tv1.Selected;
 UpdateTovar(PMyRec(PNode.Data).kod);
end;

procedure TForm18.sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var R:TRect;
begin


end;

procedure TForm18.Button4Click(Sender: TObject);
begin
ShowZakaz;
end;

end.
