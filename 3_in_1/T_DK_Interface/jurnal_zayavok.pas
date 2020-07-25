unit jurnal_zayavok;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, zayavka, ExtCtrls, DBF, gvar;

type
  TForm17 = class(TForm)
    sg1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Timer1: TTimer;
    DBF: TDBF;
    waitTimer: TTimer;
    Button5: TButton;
    Timer2: TTimer;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure waitTimerTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sg1DblClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Type TSelectPoz = record
 SelMagPoz:integer;
 SelPostKod:string[100];
 SelPostName:string[100];
 SelGruuzKod:string[100];
 SelGruuzName:string[100];
 SelKodSklada:string[100];
 SelFileLink:string[100];
 Text:string[100];
 Date:string[100];
 DateZayavk:string[100];
end;
var
Form17: TForm17;
  SelPoz:array[0..9999] of TSelectPoz;

implementation

{$R *.dfm}
procedure GetRow;
begin
 SelectRowJurnal:=form17.sg1.Row;
end;

procedure UpdateJurnal;
var i,j,LastRecord:integer;
//gc:TGridRect;
toprow:integer;
begin
GetRow;
toprow:=form17.sg1.TopRow;

 for i:=1 to form17.sg1.RowCount-1 do
  for j:=0 to form17.sg1.ColCount-1 do
    form17.sg1.Cells[j,i]:='';
 //form17.sg1.RowCount:=2;
 for i:=0 to 9999 do
  begin
    SelPoz[i].SelMagPoz:=0;
    SelPoz[i].SelPostKod:='';
    SelPoz[i].SelPostName:='';
    SelPoz[i].SelGruuzKod:='';
    SelPoz[i].SelGruuzName:='';
    SelPoz[i].SelKodSklada:='';
    SelPoz[i].SelFileLink:='';
    SelPoz[i].Text:='';
    SelPoz[i].Date:='';
    SelPoz[i].DateZayavk:='';
  end;
 try
  // Открываем БД
   Form17.DBF.TableName:='base\jurnal_zayavok.dbf';
   Form17.DBF.Exclusive:=false;
   Form17.DBF.Open;
 except
 end;

 for i:=1 to form17.DBF.RecordCount do
    begin
     if form17.DBF.GetFieldData(1) = '' then
       form17.DBF.Deleted := true;
     form17.DBF.Next;
    end;

 try
   form17.DBF.PackTable;
   Form17.DBF.Close;
   except
     end;

 try
  // Открываем БД
   Form17.DBF.TableName:='base\jurnal_zayavok.dbf';
   Form17.DBF.Exclusive:=false;
   Form17.DBF.Open;
 except
 end;
 form17.sg1.RowCount:= form17.dbf.recordcount+1;
 if form17.DBF.RecordCount>0 then
  for i:=1 to form17.DBF.RecordCount do
    begin
     form17.sg1.Cells[0,i]:=inttostr(i);
     form17.sg1.Cells[1,i]:=magaz[strtoint(form17.DBF.GetFieldData(1))].Name;
     form17.sg1.Cells[2,i]:=form17.DBF.GetFieldData(3);
     form17.sg1.Cells[3,i]:=form17.DBF.GetFieldData(4);
     form17.sg1.Cells[4,i]:=form17.DBF.GetFieldData(5);
     form17.sg1.Cells[5,i]:=form17.DBF.GetFieldData(7);
     form17.sg1.Cells[6,i]:=form17.DBF.GetFieldData(9);
     If form17.DBF.GetFieldData(11)='1' then
       form17.sg1.Cells[7,i]:='Да'
     else
       form17.sg1.Cells[7,i]:='';
     If form17.DBF.GetFieldData(12)='1' then
       form17.sg1.Cells[8,i]:='Да'
     else
       form17.sg1.Cells[8,i]:='';

      SelPoz[i-1].SelMagPoz:=strtoint(form17.DBF.GetFieldData(1));
      SelPoz[i-1].SelPostKod:=form17.DBF.GetFieldData(6);
      SelPoz[i-1].SelPostName:=form17.DBF.GetFieldData(7);
      SelPoz[i-1].SelGruuzKod:=form17.DBF.GetFieldData(8);
      SelPoz[i-1].SelGruuzName:=form17.DBF.GetFieldData(9);
      SelPoz[i-1].SelKodSklada:=form17.DBF.GetFieldData(2);
      SelPoz[i-1].SelFileLink:=form17.DBF.GetFieldData(10);
      SelPoz[i-1].Text:=form17.DBF.GetFieldData(5);
      SelPoz[i-1].Date:=form17.DBF.GetFieldData(4);
      SelPoz[i-1].DateZayavk:=form17.DBF.GetFieldData(3);
     form17.DBF.Next;
    end;

 try
   Form17.DBF.Close;
   except
     end;
// ShowMessage(inttostr(SelectRowJurnal));
 LastRecord:=0;
 For i:=0 to form17.sg1.RowCount-1 do
  if form17.sg1.Cells[2,i]='' then
    LastRecord:=i-1;
 If LastRecord = 0 then LastRecord:=form17.sg1.RowCount-1;
 if SelectRowJurnal>LastRecord then SelectRowJurnal:=LastRecord;
 //gc.Top:=SelectRowJurnal;
 //gc.Bottom:=SelectRowJurnal;
 //gc.Left:=1;
 //gc.Right:=8;
// form17.sg1.Selection:=gc;
 form17.sg1.Row:=SelectRowJurnal;
 form17.sg1.TopRow:=toprow;
end;

procedure TForm17.Button1Click(Sender: TObject);
var i,j:integer;
begin
 //Timer2.Enabled:=false;
 Form18.Caption:='Заявка - Новая*';
 Form18.KodSklada.Text:='';
 Form18.KodPostav.Text:='';
 Form18.KodGruuz.Text:='';
 Form18.PostName.Text:='';
 form18.GruuzName.Text:='';
  Form18.Magg.Text:='';
 Form18.FN.Text:='';
 Form18.Edit1.Text:='';
 Form18.DateTimePicker1.Date:=Date-1;
 Form18.ListBox1.Clear;
 Form18.ListBox2.Clear;
 Form18.ListBox3.Clear;
 Form18.CheckBox1.Checked:=false;
 for i:=1 to form18.sg1.RowCount-1 do
  for j:=0 to form18.sg1.ColCount -1 do
    form18.sg1.Cells[j,i]:='';
 form18.sg1.RowCount:=2;
 form18.sg1.Enabled:=false;  
 Form18.Visible:=true;
 form17.Enabled:=false;
 waitTimer.Enabled:=true;
 Form18.Timer1.Enabled:=true;
 //Timer2.Enabled:=true;
end;

procedure TForm17.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=false;
Timer1.Interval:=3000;
UpdateJurnal;
if form17.Visible then
  Timer1.Enabled:=true;
//Timer2.Enabled:=true;;
end;

procedure TForm17.waitTimerTimer(Sender: TObject);
begin
 if NOT form18.Visible then
  begin
   form18.prosmotr.Checked:=false;
   waitTimer.Enabled:=false;
   UpdateJurnal;
   form17.Enabled:=true;
   form17.Show;
  end;
end;

procedure TForm17.Button2Click(Sender: TObject);
var i,j:integer;
begin
 // Timer2.Enabled:=false;
  UpdateJurnal;
  if (SelectRowJurnal>0) and (sg1.Cells[1,1]<>'') then
  begin
    if sg1.Cells[8,SelectRowJurnal]='Да' then
      begin
       ShowMessage('Заявка отправлена и редактированию не подлежит!');
       Exit;
      end;

    Form18.Caption:='Заявка - '+Magaz[SelPoz[SelectRowJurnal-1].SelMagPoz].Name+', Поставщик '+SelPoz[SelectRowJurnal-1].SelPostName+', отправитель '+SelPoz[SelectRowJurnal-1].SelGruuzName;
    Form18.FN.Text:=SelPoz[SelectRowJurnal-1].SelFileLink;
    Form18.KodSklada.Text:=SelPoz[SelectRowJurnal-1].SelKodSklada;
    Form18.KodPostav.Text:=SelPoz[SelectRowJurnal-1].SelPostKod;
    Form18.KodGruuz.Text:=SelPoz[SelectRowJurnal-1].SelGruuzKod;
    Form18.PostName.Text:=SelPoz[SelectRowJurnal-1].SelPostName;
    form18.GruuzName.Text:=SelPoz[SelectRowJurnal-1].SelGruuzName;
    Form18.Magg.Text:=inttostr(SelPoz[SelectRowJurnal-1].SelMagPoz);

    Form18.Edit1.Text:=SelPoz[SelectRowJurnal-1].Text;
    Form18.DateTimePicker1.Date:=strtodate(SelPoz[SelectRowJurnal-1].Date);
    Form18.ListBox1.Clear;
    Form18.ListBox2.Clear;
    Form18.ListBox3.Clear;
    for i:=1 to form18.sg1.RowCount-1 do
       for j:=0 to form18.sg1.ColCount -1 do
         form18.sg1.Cells[j,i]:='';
    form18.sg1.RowCount:=2;
    form18.sg1.Enabled:=true;

    Form18.Visible:=true;
    form17.Enabled:=false;
    waitTimer.Enabled:=true;
    Form18.Timer1.Enabled:=true;
  end;
 // Timer2.Enabled:=true;;
end;

procedure TForm17.sg1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 //SelectRowJurnal:=ARow;
 //ShowMessage(inttostr(SelectRowJurnal));
 end;

procedure TForm17.Button3Click(Sender: TObject);
var i:integer;
begin
 //Timer2.Enabled:=false;
 UpdateJurnal;

 if sg1.Cells[8,SelectRowJurnal]='Да' then
  begin
    ShowMessage('Заявка отправлена и редактированию не подлежит!');
    Exit;
    end;
 if sg1.Cells[1,SelectRowJurnal]<>'' then
  begin
    try
     // Открываем БД
      Form17.DBF.TableName:='base\jurnal_zayavok.dbf';
      Form17.DBF.Exclusive:=true;
      Form17.DBF.Open;
     except
    end;
    try
      if form17.DBF.RecordCount>0 then
        for i:=1 to form17.DBF.RecordCount do
          begin
            if form17.DBF.GetFieldData(10) = SelPoz[SelectRowJurnal-1].SelFileLink then
              begin
                form17.DBF.SetFieldData(11,'1');
                sg1.Cells[7,SelectRowJurnal]:='Да';
              end;
            form17.DBF.Next;
            end;
      form17.DBF.Post
      except
        end;
    try
      form17.DBF.Close;
      except
        end
  end;
 // Timer2.Enabled:=true;
end;

procedure TForm17.FormCreate(Sender: TObject);
begin
 SelectRowJurnal:=1;
 sg1.Row:=1;
end;

procedure TForm17.Button4Click(Sender: TObject);
var i:integer;
begin
 //Timer2.Enabled:=false;
 UpdateJurnal;

 if sg1.Cells[8,SelectRowJurnal]='Да' then
  begin
    ShowMessage('Заявка отправлена и редактированию не подлежит!');
    Exit;
    end;
 if sg1.Cells[1,SelectRowJurnal]<>'' then
  begin
    try
     // Открываем БД
      Form17.DBF.TableName:='base\jurnal_zayavok.dbf';
      Form17.DBF.Exclusive:=true;
      Form17.DBF.Open;
     except
    end;
    try
      if form17.DBF.RecordCount>0 then
        for i:=1 to form17.DBF.RecordCount do
          begin
            if form17.DBF.GetFieldData(10) = SelPoz[SelectRowJurnal-1].SelFileLink then
              begin
                form17.DBF.SetFieldData(11,'0');
                sg1.Cells[7,SelectRowJurnal]:='';
              end;
            form17.DBF.Next;
            end;
      form17.DBF.Post
      except
        end;
    try
      form17.DBF.Close;
      except
        end
  end;
 // Timer2.Enabled:=true;
end;

procedure TForm17.Button5Click(Sender: TObject);
var i:integer;
begin
 // Timer2.Enabled:=false;
 UpdateJurnal;

 if sg1.Cells[8,SelectRowJurnal]='Да' then
  begin
    ShowMessage('Заявка отправлена и редактированию не подлежит!');
    Exit;
    end;
 if sg1.Cells[2,SelectRowJurnal]<>'' then
  begin
    try
     // Открываем БД
      Form17.DBF.TableName:='base\jurnal_zayavok.dbf';
      Form17.DBF.Exclusive:=true;
      Form17.DBF.Open;
     except
    end;
    try
        for i:=1 to form17.DBF.RecordCount do
          begin
            if form17.DBF.GetFieldData(10) = SelPoz[SelectRowJurnal-1].SelFileLink then
              begin
                form17.DBF.Deleted:=true;
                form17.DBF.PackTable;
                try
                   form17.DBF.Close;
                except
                end;
                DeleteFile('zayavki\'+SelPoz[SelectRowJurnal-1].SelFileLink);

                UpdateJurnal;
                Timer2.Enabled:=true;
                Exit;
              end;
            form17.DBF.Next;
            end;
      except
        end;
    try
      form17.DBF.Close;
      except
        end
  end;
  //Timer2.Enabled:=true;
end;

procedure TForm17.sg1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  // Прорисовываем заголовки таблицы
  if (ARow=0) then
  with sg1 do
  begin
   Canvas.Font.Color:=clBlue;
   Canvas.Font.Style:=[fsBold];
   Canvas.TextOut(Rect.Left+2,Rect.Top+2,sg1.Cells[Acol,Arow]);
   Exit;
   end;
end;

procedure TForm17.FormHide(Sender: TObject);
begin
 Timer1.Interval:=10;
 //Timer2.Enabled:=false;
end;

procedure TForm17.FormShow(Sender: TObject);
begin
// SelectRowJurnal:=1;
 //sg1.Row:=1;

 sg1.Cells[0,0]:='№';
sg1.Cells[1,0]:='Магазин';
sg1.Cells[2,0]:='Дата';
sg1.Cells[3,0]:='На Дату';
sg1.Cells[4,0]:='Составил';
sg1.Cells[5,0]:='Поставщик';
sg1.Cells[6,0]:='Грузоотправитель';
sg1.Cells[7,0]:='Пометка';
sg1.Cells[8,0]:='Отправлен';
Timer1.Enabled:=true;
end;

procedure TForm17.sg1DblClick(Sender: TObject);
var i,j:integer;
begin
 // Timer2.Enabled:=false;
  UpdateJurnal;
  if (SelectRowJurnal>0) and (sg1.Cells[1,1]<>'') then
  begin

    Form18.Caption:='Заявка - '+Magaz[SelPoz[SelectRowJurnal-1].SelMagPoz].Name+', Поставщик '+SelPoz[SelectRowJurnal-1].SelPostName+', отправитель '+SelPoz[SelectRowJurnal-1].SelGruuzName;
    Form18.FN.Text:=SelPoz[SelectRowJurnal-1].SelFileLink;
    Form18.KodSklada.Text:=SelPoz[SelectRowJurnal-1].SelKodSklada;
    Form18.KodPostav.Text:=SelPoz[SelectRowJurnal-1].SelPostKod;
    Form18.KodGruuz.Text:=SelPoz[SelectRowJurnal-1].SelGruuzKod;
    Form18.PostName.Text:=SelPoz[SelectRowJurnal-1].SelPostName;
    form18.GruuzName.Text:=SelPoz[SelectRowJurnal-1].SelGruuzName;
    Form18.Magg.Text:=inttostr(SelPoz[SelectRowJurnal-1].SelMagPoz);

    Form18.Edit1.Text:=SelPoz[SelectRowJurnal-1].Text;
    Form18.DateTimePicker1.Date:=strtodate(SelPoz[SelectRowJurnal-1].Date);;
    Form18.ListBox1.Clear;
    Form18.ListBox2.Clear;
    Form18.ListBox3.Clear;
    for i:=1 to form18.sg1.RowCount-1 do
       for j:=0 to form18.sg1.ColCount -1 do
         form18.sg1.Cells[j,i]:='';
    form18.sg1.RowCount:=2;
    form18.sg1.Enabled:=False;
    if sg1.Cells[8,SelectRowJurnal]='Да' then
       form18.prosmotr.Checked:=true
    else
       form18.prosmotr.Checked:=false;

    Form18.Visible:=true;

    form17.Enabled:=false;
    waitTimer.Enabled:=true;
    Form18.Timer1.Enabled:=true;
  end;
 // Timer2.Enabled:=true;
end;
procedure TForm17.Timer2Timer(Sender: TObject);
begin
//Timer2.Enabled:=false;
//UpdateJurnal;
//Timer2.Enabled:=true;
end;

procedure TForm17.Button6Click(Sender: TObject);
var i,j:integer;
Rec:TSelectPoz;
namefile:string;
begin
 // Timer2.Enabled:=false;
 try
  // Открываем БД
   Form17.DBF.TableName:='base\jurnal_zayavok.dbf';
   Form17.DBF.Exclusive:=false;
   Form17.DBF.Open;

   for i:=1 to form17.dbf.RecordCount do
    begin
     if form17.DBF.GetFieldData(10)=SelPoz[SelectRowJurnal-1].SelFileLink then
      begin
       Rec.SelMagPoz:=strtoint(form17.DBF.GetFieldData(1));
       Rec.SelKodSklada:=form17.DBF.GetFieldData(2);
       Rec.DateZayavk:=form17.DBF.GetFieldData(3);
       Rec.Date:=form17.DBF.GetFieldData(4);
       Rec.Text:=form17.DBF.GetFieldData(5);
       Rec.SelPostKod:=form17.DBF.GetFieldData(6);
       Rec.SelPostName:=form17.DBF.GetFieldData(7);
       Rec.SelGruuzKod:=form17.DBF.GetFieldData(8);
       Rec.SelGruuzName:=form17.DBF.GetFieldData(9);
       Rec.SelFileLink:=form17.DBF.GetFieldData(10);

       Form17.DBF.Append;
       Form17.DBF.SetFieldData(1,inttostr(Rec.SelMagPoz));
       Form17.DBF.SetFieldData(2,Rec.SelKodSklada);
       Form17.DBF.SetFieldData(3,Rec.DateZayavk);
       Form17.DBF.SetFieldData(4,Rec.Date);
       Form17.DBF.SetFieldData(5,Rec.Text);
       Form17.DBF.SetFieldData(6,Rec.SelPostKod);
       Form17.DBF.SetFieldData(7,Rec.SelPostName);
       Form17.DBF.SetFieldData(8,Rec.SelGruuzKod);
       Form17.DBF.SetFieldData(9,Rec.SelGruuzName);
       for j:=0 to 10 do
        begin
         if j=10 then
          begin
           ShowMessage('Не могу создать файл для заявки!!!');
          // Timer2.Enabled:=true;
           Exit;
          end;
         namefile:=Setname2(0)+inttostr(j)+'.dbf';
         if NOT FileExists(namefile) then
         Break;
        end;
       if CopyFile(Pchar(EXEPath+'zayavki\'+Rec.SelFileLink),PChar(EXEPath+'zayavki\'+namefile),TRUE) then
        begin
          Form17.DBF.SetFieldData(10,namefile);
          Form17.DBF.SetFieldData(11,'0');
          Form17.DBF.SetFieldData(12,'0');
          Form17.DBF.Post;
          Form17.DBF.Close;
          Break;
          end
       else
          begin
            Form17.DBF.Close;
            ShowMessage('Не удалось скопировать заявку!');
            Break;
          end;
      end;
     Form17.DBF.Next;
    end;

    try
      Form17.DBF.Close;
      except
        end;

   UpdateJurnal;

   For i:=1 to form17.sg1.RowCount-1 do
    if (form17.sg1.Cells[1,i]='') then
     begin
      Form17.sg1.Row:=i-1;
      SelectRowJurnal:=i-1;
      Break;
     end
     else if (i = form17.sg1.RowCount-1) then
      begin
        Form17.sg1.Row:=i;
       SelectRowJurnal:=i;
       Break;
        end;

  if (SelectRowJurnal>0) and (sg1.Cells[1,1]<>'') then
  begin
    if sg1.Cells[8,SelectRowJurnal]='Да' then
      begin
       ShowMessage('Заявка отправлена и редактированию не подлежит!');
       Exit;
      end;

    Form18.Caption:='Заявка - '+Magaz[SelPoz[SelectRowJurnal-1].SelMagPoz].Name+', Поставщик '+SelPoz[SelectRowJurnal-1].SelPostName+', отправитель '+SelPoz[SelectRowJurnal-1].SelGruuzName;
    Form18.FN.Text:=SelPoz[SelectRowJurnal-1].SelFileLink;
    Form18.KodSklada.Text:=SelPoz[SelectRowJurnal-1].SelKodSklada;
    Form18.KodPostav.Text:=SelPoz[SelectRowJurnal-1].SelPostKod;
    Form18.KodGruuz.Text:=SelPoz[SelectRowJurnal-1].SelGruuzKod;
    Form18.PostName.Text:=SelPoz[SelectRowJurnal-1].SelPostName;
    form18.GruuzName.Text:=SelPoz[SelectRowJurnal-1].SelGruuzName;
    Form18.Magg.Text:=inttostr(SelPoz[SelectRowJurnal-1].SelMagPoz);

    Form18.Edit1.Text:=SelPoz[SelectRowJurnal-1].Text;
    Form18.DateTimePicker1.Date:=strtodate(SelPoz[SelectRowJurnal-1].Date);
    Form18.ListBox1.Clear;
    Form18.ListBox2.Clear;
    Form18.ListBox3.Clear;
    for i:=1 to form18.sg1.RowCount-1 do
       for j:=0 to form18.sg1.ColCount -1 do
         form18.sg1.Cells[j,i]:='';
    form18.sg1.RowCount:=2;
    form18.sg1.Enabled:=true;

    Form18.Visible:=true;
    form17.Enabled:=false;
    waitTimer.Enabled:=true;
    Form18.Timer1.Enabled:=true;
  end;

    except
  end;
 // Timer2.Enabled:=true;
end;

end.
