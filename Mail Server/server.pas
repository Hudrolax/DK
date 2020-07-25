unit server;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBF, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP, ExtCtrls, Gvar;

type
  TForm1 = class(TForm)
    DBF: TDBF;
    Button1: TButton;
    DBF1: TDBF;
    ftp: TIdFTP;
    PTimer1: TTimer;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    DBF2: TDBF;
    procedure Button1Click(Sender: TObject);
    procedure PTimer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure WMHotkey( var msg: TWMHotkey ); message WM_HOTKEY;
    { Private declarations }
  public
    { Public declarations }
  end;
 Tmaginfo = record
 VInterface:string;
 VEngine:string;
 VUpdater:string;
 VUPDScript:string;
 Postupleniy:string;
 Otchetov:string;
 CompName:string;
 datep:string;

 end;

 Tzipinfo = record
 magaz:string;
 namezip:string;
 datez:string;
 end;


var
  Form1: TForm1;
  k:Integer;
  datet:string;

implementation

{$R *.dfm}
procedure GetMagInfo;
var i,j,k:Integer;
ls:TStringList;
f:TextFile;
est:Boolean;
maginfo:Tmaginfo;
s:string;
begin
 try
// Создаем списки для фильтрации файлов на ФТП
ls:=TStringList.Create;


  Form1.ftp.List(ls); //Забираем список файлов с FTP

    //Фильтруем, оставляя флаги загрузки.
     if ls.Count<>0 then
     for j:=0 to ls.Count-1 do
       if (AnsiPos('versionfile.txt',ls[j])<>0) then
        begin
         Form1.ftp.get('versionfile.txt','versionfile.txt',true,false);
          maginfo.VInterface:='';
          maginfo.VEngine:='';
          maginfo.VUpdater:='';
          maginfo.VUPDScript:='';
          maginfo.Postupleniy:='';
          maginfo.Otchetov:='';
          maginfo.CompName:='';
          maginfo.datep:='';
          AssignFile(f,'versionfile.txt');
          Reset(f);
          while not Eof(f) do
            begin
             Readln(f,s);
             if AnsiPos('DKR Interface version: ',s)>0 then
                maginfo.VInterface:=Copy(s,Pos('DKR Interface version: ',s)+23,10);
             if AnsiPos('DKR Engine version: ',s)>0 then
                maginfo.VEngine:=Copy(s,Pos('DKR Engine version: ',s)+20,10);
             if AnsiPos('DKR Updater version: ',s)>0 then
                maginfo.VUpdater:=Copy(s,Pos('DKR Updater version: ',s)+21,10);
             if AnsiPos('DKR UpdScript version: ',s)>0 then
                maginfo.VUPDScript:=Copy(s,Pos('DKR UpdScript version: ',s)+23,10);
             if AnsiPos('Поступлений: ',s)>0 then
                maginfo.Postupleniy:=Copy(s,Pos('Поступлений: ',s)+13,6);
             if AnsiPos('Отчетов: ',s)>0 then
                maginfo.Otchetov:=Copy(s,Pos('Отчетов: ',s)+9,6);
             if AnsiPos('Имя компьютера: ',s)>0 then
                maginfo.CompName:=Copy(s,Pos('Имя компьютера: ',s)+16,20);
             if AnsiPos('Дата: ',s)>0 then
                maginfo.datep:=Copy(s,Pos('Дата: ',s)+6,20);
            end;
          CloseFile(f);
          DeleteFile('versionfile.txt');
           try // Открываем БД магазов
          Form1.DBF.TableName:='base\versiondb.dbf';
          Form1.DBF.Exclusive:=false;
          Form1.DBF.Open;
          except
           end;
         est:=False;
          if Form1.DBF.RecordCount<>0 then // Если не пустая
           for k:=1 to Form1.DBF.RecordCount do
          try
           if Form1.DBF1.GetFieldData(1)=Form1.DBF.GetFieldData(1) then
            begin  // Если нашли повтор
             if maginfo.VInterface<>'' then
               form1.DBF.SetFieldData(2,maginfo.VInterface);
             if maginfo.VEngine<>'' then
              form1.DBF.SetFieldData(3,maginfo.VEngine);
             if maginfo.VUpdater<>'' then
              form1.DBF.SetFieldData(4,maginfo.VUpdater);
             if maginfo.VUPDScript<>'' then
              form1.DBF.SetFieldData(5,maginfo.VUPDScript);
             if maginfo.Postupleniy<>'' then
              form1.DBF.SetFieldData(6,maginfo.Postupleniy);
             if maginfo.Otchetov<>'' then
              form1.DBF.SetFieldData(7,maginfo.Otchetov);
             if maginfo.CompName<>'' then
              form1.DBF.SetFieldData(8,maginfo.CompName);
             if maginfo.datep<>'' then
              form1.DBF.SetFieldData(9,maginfo.datep);
             form1.DBF.SetFieldData(10,GetDateT);
             Form1.DBF.Post;
             est:=True;
             Break;
              end;

           Form1.DBF.Next;
          except
          end;

          if not est then // Если не нашли повтор
          begin
           form1.DBF.Append;
           form1.DBF.SetFieldData(1,Form1.DBF1.GetFieldData(1));
           form1.DBF.SetFieldData(2,maginfo.VInterface);
           form1.DBF.SetFieldData(3,maginfo.VEngine);
           form1.DBF.SetFieldData(4,maginfo.VUpdater);
           form1.DBF.SetFieldData(5,maginfo.VUPDScript);
           form1.DBF.SetFieldData(6,maginfo.Postupleniy);
           form1.DBF.SetFieldData(7,maginfo.Otchetov);
           form1.DBF.SetFieldData(8,maginfo.CompName);
           form1.DBF.SetFieldData(9,maginfo.datep);
           Form1.DBF.Post;
            end;

         try
          form1.ftp.Delete('versionfile.txt');
          except
             end;

         try
          AssignFile(f,'getversion.txt');
          Rewrite(f);
          CloseFile(f);
          form1.ftp.Put('getversion.txt','getversion.txt',false);
          DeleteFile('getversion.txt');
         except
         end;

         try
          Form1.DBF.Close;
           except
             end;
        end else if (AnsiPos('getversion.txt',ls[j])=0) then
        begin
         try
          AssignFile(f,'getversion.txt');
          Rewrite(f);
          CloseFile(f);
          form1.ftp.Put('getversion.txt','getversion.txt',false);
          DeleteFile('getversion.txt');
         except
         end;
          end;



  ls.Free;
      except

    end;
  end;

procedure GetFlagMD;
var i,j,k:Integer;
ls,flist,flist2,flist3:TStringList;
nozip:Boolean;
zipinfo:Tzipinfo;
s:string;
begin

try
// Создаем списки для фильтрации файлов на ФТП
ls:=TStringList.Create;
flist:=TStringList.Create;
flist2:=TStringList.Create;
flist3:=TStringList.Create;


         try
         Form1.DBF2.TableName:='base\notloadedarch.dbf';
         Form1.DBF2.Exclusive:=true;
         Form1.DBF2.Open;
         except
           end;


      zipinfo.magaz:='';
      zipinfo.namezip:='';
      zipinfo.datez:='';


     flist.Clear;
     ls.Clear;
     flist2.Clear;
     flist3.clear;

     try
     Form1.ftp.List(ls); //Забираем список файлов с FTP
     except
       flist.Free;
       ls.Free;
       flist2.Free;
       flist3.Free;
       Exit;
       end;

//     try
//    //Фильтруем, оставляя флаги загрузки для почтовых флагов
//       if ls.Count<>0 then
//      for j:=0 to ls.Count-1 do
//       if (AnsiPos('.md',ls[j])<>0) and (AnsiPos('.mdf',ls[j])=0) then
//          flist.add(Copy(ls[j],AnsiPos('.md',ls[j])-10,13));
//
//      except
//       end;
//
//     try
//       s:='';
//       if ls.Count<>0 then
//        for j:=0 to ls.Count-1 do
//         if AnsiPos('_repeated',ls[j])<>0 then
//          begin
//           s:=(Copy(ls[j],AnsiPos('_repeated',ls[j])-12,12));
//           try
//           Form1.ftp.Delete(s);
//           except
//             end;
//
//           s:=(Copy(ls[j],AnsiPos('_repeated',ls[j])-8,8))+'.flz';
//           try
//           Form1.ftp.Delete(s);
//           except
//             end;
//
//           s:=(Copy(ls[j],AnsiPos('_repeated',ls[j])-12,21));
//           try
//           Form1.ftp.Delete(s);
//           except
//             end;
//
//
//          end;
//     except
//     end;

     try // кокаем лишние флаги загрузки
        //Фильтруем, оставляя флаги загрузки для флагов поступлений
      if ls.Count<>0 then
        for j:=0 to ls.Count-1 do
         if AnsiPos('.flz',ls[j])<>0 then
           flist2.add(Copy(ls[j],AnsiPos('.flz',ls[j])-8,12));

      if ls.Count<>0 then  // фильтруем, оставляя имена архивов в папке
        for j:=0 to ls.Count-1 do
         if AnsiPos('.zip',ls[j])<>0 then
           flist3.add(Copy(ls[j],AnsiPos('.zip',ls[j])-8,12));

      if flist2.Count<>flist3.Count then // Если кол-во флагов не равно кол-ву архивов, то
        for j:=0 to flist2.Count-1 do
         begin
          nozip:=False;
           for k:=0 to flist3.Count-1 do
              if Copy(flist2[j],1,8)=Copy(flist3[k],1,8) then nozip:=True;
          if not nozip then
            Form1.ftp.Delete(flist2[j]); // Удаляем флаг, если для него нет архива
         end;
      except
       end;


     try
      if ls.Count<>0 then
       for j:=0 to ls.Count-1 do
        if AnsiPos('.zip',ls[j])<>0 then
         if Copy(ls[j],AnsiPos('.zip',ls[j])-8,1)='k' then
         begin

          zipinfo.magaz:=Form1.DBF1.GetFieldData(1);
          zipinfo.namezip:=Copy(ls[j],AnsiPos('.zip',ls[j])-8,12);
          zipinfo.datez:=Copy(ls[j],AnsiPos('.zip',ls[j])-21,13);

           Form1.DBF2.Append;
           Form1.DBF2.SetFieldData(1,zipinfo.magaz);
           Form1.DBF2.SetFieldData(2,zipinfo.namezip);
           Form1.DBF2.SetFieldData(3,zipinfo.datez);
           Form1.DBF2.Post;
          end;

        except
         end;

// try
//    if flist.Count>0 then
//      for k:=0 to flist.Count-1 do
//        begin
//            try // Открываем БД магаза
//            Form1.DBF.TableName:='base\upload\'+copy(flist[k],1,5)+'.dbf';
//            Form1.DBF.Exclusive:=false;
//            Form1.DBF.Open;
//            except
//          end;
//
//          // Ищем в БД магаза файл похожий на флаг
//          for j:=1 to Form1.DBF.RecordCount do
//            try
//              if Copy(Form1.DBF.GetFieldData(1),1,10)=Copy(flist[k],1,10) then
//                begin // Если наши, пишем, что доставлено и стираем флаг с ФТП
//                  Form1.DBF.SetFieldData(6,'1');
//                  Form1.DBF.Post;
//                 try
//                 Form1.ftp.Delete(flist[k]);
//                 except
//                   end;
//                  end;
//             Form1.DBF.Next;
//            except
//              end;
//
//          try
//            Form1.DBF.Close;
//          except
//          end;
//
//        end;
//   except
//   end;

   try
    ls.Free;
    flist.Free;
    flist2.Free;
    flist3.Free;
   except
   end;

   try
    form1.DBF2.Close;
     except
       end;
except
  end;
end;


// Прооцесс подсчета отправленных писем.
procedure process2;
var i,j:Integer;
Magaz:string;
flag:TextFile;
begin
  k:=0;
 // Открываем БД магазинов
 try
  Form1.DBF1.TableName:='base\magaz.dbf';
  Form1.DBF1.Exclusive:=false;
  Form1.DBF1.Open;
 except
     try
    Form1.DBF1.Close;
    except
      end;
 end;
 // Основной цыкл
 for i:=1 to Form1.DBF1.RecordCount do
 try
  Magaz:=Form1.DBF1.GetFieldData(1);
  // Открываем БД текущего магаза
   try
   Form1.DBF.TableName:='base\upload\'+Magaz+'.dbf';
   Form1.DBF.Exclusive:=false;
   Form1.DBF.Open;
  except
  end;
  if form1.DBF.RecordCount>0 then
  for j:=1 to Form1.DBF.RecordCount do
   try
    k:=k+1;
    Form1.DBF.Next;
   except
   end;
  //Закрываем БД текущего магаза
  try
  Form1.DBF.Close;
  except
  end;

  Form1.DBF1.Next;
  except
  end;
 // Закрываем БД магазинов
 try
  form1.dbf1.close;
   except
     end;
  Form1.Label2.Caption:=IntToStr(k);
end;

// Процедура отправки писем на ФТП
procedure process;
var i,j:Integer;
Magaz:string;
flag:TextFile;
begin
 try
  //Открываем БД магазинов
 try
  Form1.DBF1.TableName:='base\magaz.dbf';
  Form1.DBF1.Exclusive:=false;
  Form1.DBF1.Open;
 except
     try
    Form1.DBF1.Close;
    exit;
    except
      end;
 end;

      // Пробуем подключиться
     try
     Form1.ftp.Host:='10.10.61.10';
     Form1.ftp.Port:=21;
     Form1.ftp.Username:='dk';
     form1.ftp.Password:='dk';
     form1.ftp.Connect();
     except
     end;

  DeleteFile('base\notloadedarch.dbf');
     //Пробуем создать БД для списка незакачанных архивов
  try
   Form1.dbf2.TableName:='base\notloadedarch.dbf';
   if not FileExists('base\notloadedarch.dbf') then begin
    Form1.dbf2.AddFieldDefs('magazin',bfString,20,0);
    Form1.dbf2.AddFieldDefs('archname',bfString,20,0);
    Form1.dbf2.AddFieldDefs('date',bfString,20,0);
    Form1.dbf2.CreateTable;
    Form1.DBF2.close;
   end;
  except
    end;

 // Основной цыкл
  for i:=1 to Form1.DBF1.RecordCount do // Идем по папкам магазинов
  try

   Magaz:=Form1.DBF1.GetFieldData(1);
  // Открываем БД текущего магаза
//   try
//    Form1.DBF.TableName:='base\upload\'+Magaz+'.dbf';
//    Form1.DBF.Exclusive:=false;
//    Form1.DBF.Open;
//   except
//   end;
          // Пытаемся выйти в корень
      try
        Form1.ftp.ChangeDirUp;
        except
          Continue;
          end;

      // Зайдем в нужную папку
      try
       form1.ftp.ChangeDir(Magaz);
      except
          Continue;
        end;


//   for j:=1 to Form1.DBF.RecordCount do // Идем по БД магазина
//   try
//
//    if Form1.DBF.GetFieldData(4)='0' then
//     if Form1.ftp.Connected then
//     try
//
//       // Положим архив
//       Form1.ftp.Put('base\upload\'+Magaz+'\'+form1.DBF.GetFieldData(1),form1.DBF.GetFieldData(1),false);
//       // Создадим флаг
//       AssignFile(flag,Copy(form1.DBF.GetFieldData(1),1,10)+'.mdf');
//       Rewrite(flag);
//       CloseFile(flag);
//       // Положим флаг на FTP
//       Form1.ftp.Put(Copy(form1.DBF.GetFieldData(1),1,10)+'.mdf',Copy(form1.DBF.GetFieldData(1),1,10)+'.mdf',false);
//       // Удалим флаг
//       DeleteFile(Copy(form1.DBF.GetFieldData(1),1,10)+'.mdf');
//       Form1.DBF.SetFieldData(4,'1');
//       Form1.DBF.Post;
//
//      except
//        end;
//
//    Form1.DBF.Next;
//   except
//   end;
//
//  //Закрываем БД текущего магаза
//  try
//  Form1.DBF.Close;
//  except
//  end;
      // Собрали почту, можно выполнять другие действия.
     // Мы в папке магазина

  GetMagInfo;
  GetFlagMD;

  Form1.DBF1.Next;
  Sleep(100);
  except;
  end;


      // Пробуем отколючиться.
  try
    Form1.ftp.Disconnect;
    except
    end;

 // Закрываем БД магазинов
  try
  form1.dbf1.close;
   except
     end;

 except
 end;    
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if Button1.Caption='Включить' then
    begin
     Button1.Caption:='Выключить';
     Ptimer1.Enabled:=True;
    end else
    begin
     Button1.Caption:='Включить';
     Ptimer1.Enabled:=False;
    end
 end;

procedure TForm1.PTimer1Timer(Sender: TObject);
var f:TextFile;
begin
 Application.ProcessMessages;
 process; // Главный процесс

 //GetFlagMD; // Подбираем флаги доставки с ФТП
 GetMagInfo; // Собирвем инфу о магазинах
 //if Form1.Visible then
  //  process2; // Если форма на виду, то показываем кол-во отправленных сообщений

 {Далее делаем скрипт для перезапуска и тря ля ля....}   
     // Если есть файл метки времени, то откроем его.
    if FileExists('starttime.dt') then
     begin
       try
       AssignFile(f,'starttime.dt');
       Reset(f);
       Readln(f,datet);
       CloseFile(f);
       except
      end;

       if SecondsBetweenRound(StrToDateTime(GetDateT),StrToDateTime(datet))>28800 then

       try
       AssignFile(f,'restart.bat');
       Rewrite(f);
//       Writeln(f,'start /wait taskkill.exe /F /IM dkengine.exe');
       Writeln(f,'PING 1.1.1.1 -n 1 -w 5000 2>NUL | FIND "TTL=" >NUL');
       Writeln(f,'start dk_mail_server.exe');
       CloseFile(f);
        //Убиваем хотей при закрытии.

          DeleteFile('starttime.dt');

         try
          UnRegisterHotkey( Handle, 1 );
        except
        end;

                try
        winexec('restart.bat',0);
        finally
        Close;
        end;
     except;
     end;

 end;
end;

   procedure TForm1.Button2Click(Sender: TObject);
var i:Integer;
begin
//  for i:=1 to 99 do
//  try
//  if not FileExists('base\upload\dk0'+inttostr(i)+'.dbf') then begin
//   dbf.TableName:='base\upload\dk0'+inttostr(i)+'.dbf';
//   dbf.Exclusive:=false;
//   dbf.AddFieldDefs('file',bfString,16,0);
//   dbf.AddFieldDefs('date',bfString,20,0);
//   dbf.AddFieldDefs('them',bfString,160,0);
//   dbf.AddFieldDefs('tomag',bfString,1,0);
//   dbf.AddFieldDefs('include',bfString,1,0);
//   dbf.AddFieldDefs('dostavlen',bfString,1,0);
//   dbf.AddFieldDefs('compname',bfString,25,0);
//   DBF.CreateTable;
//   DBF.close;
//  end;
//  except
//    end;
 end;

  //Реакция на горячие клавиши
procedure TForm1.WMHotkey( var msg: TWMHotkey );
begin
  if msg.hotkey = 1 then
    if Form1.Visible then
      Form1.Visible:=False
    else
  begin
  Form1.Visible:=True;
  Form1.Show;
  end;
 end;

 //Процедура уничтожения формы
procedure TForm1.FormDestroy(Sender: TObject);
begin
 try
  UnRegisterHotkey( Handle, 1 );
 except
 end;
end;


procedure TForm1.FormCreate(Sender: TObject);
var dateflag:textfile;
begin
  //биндим хоткей при запуске
  try
if not RegisterHotkey(Handle, 1, MOD_ALT, VK_F12) then
  ShowMessage('Клавиши Alt+F12 уже заняты.');
  except
    ShowMessage('Не могу зарегистрировать клавиши Alt+F12');
    end;


    //Пробуем создать БД данных по магазину
 try
  dbf1.TableName:='base\versiondb.dbf';
  if not FileExists('base\versiondb.dbf') then begin
   dbf1.AddFieldDefs('magazin',bfString,20,0);
   dbf1.AddFieldDefs('VInterface',bfString,20,0);
   dbf1.AddFieldDefs('VEngine',bfString,20,0);
   dbf1.AddFieldDefs('VUpdater',bfString,20,0);
   dbf1.AddFieldDefs('VUPDScript',bfString,20,0);
   dbf1.AddFieldDefs('Postupleniy',bfString,20,0);
   dbf1.AddFieldDefs('Otchetov',bfString,20,0);
   dbf1.AddFieldDefs('CompName',bfString,20,0);
   dbf1.AddFieldDefs('dateB',bfString,20,0);
   dbf1.AddFieldDefs('dateR',bfString,20,0);
   dbf1.CreateTable;
   DBF1.close;
  end;
  except
    end;


   // Удалим скрипт перезапуска, если он остался
  if FileExists('restart.bat') then
    DeleteFile('restart.bat');
  // Создадим метку времени, для перезапуска.  
    try
     AssignFile(dateflag,'starttime.dt');
     Rewrite(dateflag);
     Writeln(dateflag,GetdateT);
     CloseFile(dateflag);
    except
     end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=False;
 Button1.Caption:='Выключить';
 Ptimer1.Enabled:=True;
 Form1.Visible:=False;
end;

end.
