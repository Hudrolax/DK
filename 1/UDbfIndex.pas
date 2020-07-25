unit UDbfIndex;

interface

uses
  sysutils,classes, db,
  UDbfPagedFile,UDbfCursor,UDbfIndexFile,UDbfCommon;

type
//====================================================================
//=== Index support
//====================================================================

  TIndexCursor = class(TVirtualCursor)
  public
    OnBracketStr:TOnBracketStr;
    OnBracketNum:TOnBracketNum;
    constructor Create(dbfIndexFile:TIndexFile);
    function Next:boolean; override;
    function Prev:boolean; override;
    procedure First; override;
    procedure Last; override;

    function GetPhysicalRecno:integer; override;
    procedure SetPhysicalRecno(Recno:integer); override;
    function GetSequentialRecordCount:integer; override;
    function GetSequentialRecno:integer; override;
    procedure SetSequentialRecno(Recno:integer); override;

    procedure GotoBookmark(Bookmark:rBookmarkData); override;
    function GetBookMark:rBookmarkData; override;
    procedure Insert(Recno:integer; Buffer:PChar); override;
    procedure Update(Recno: integer; PrevBuffer,NewBuffer: PChar); override;
    function SetIndexFile:TIndexFile;
  public
    IndexBookmark:rBookmarkData;

    destructor Destroy; override;
  end;

//====================================================================
//  TIndexCursor = class;
//====================================================================
  PIndexPosInfo = ^TIndexPage;

//====================================================================
implementation


//==========================================================
//============ TIndexCursor
//==========================================================
constructor TIndexCursor.Create(dbfIndexFile:TIndexFile);
begin
  inherited Create(dbfIndexFile);
  //IndexBookmark.BookmarkFlag:=TBookmarkFlag(-1);
  IndexBookmark.IndexBookmark:=-1;
  IndexBookmark.RecNo:=-1;
end;

destructor TIndexCursor.Destroy; {override;}
begin
  inherited Destroy;
end;

procedure TIndexCursor.Insert(Recno:integer; Buffer:PChar);
begin
  // Insert doesn't need checkpos.
  SetIndexFile.Insert(Recno,Buffer);
  // TODO SET RecNo and Key
end;

procedure TIndexCursor.Update(Recno: integer; PrevBuffer,NewBuffer: PChar);
begin
  with SetIndexFile do begin
    CheckPos(IndexBookmark);
    Update(Recno,PrevBuffer,NewBuffer);
  end;
end;

procedure TIndexCursor.First;
begin
  with SetIndexFile do begin
    // CheckPos(IndexBookmark); not needed
    First;
    IndexBookmark:=GetBookmark;
  end;
end;

procedure TIndexCursor.Last;
begin
  with SetIndexFile do begin
    // CheckPos(IndexBookmark); not needed
    Last;
    IndexBookmark:=GetBookmark;
  end;
end;

function TIndexCursor.Prev:boolean;
begin
  with SetIndexFile do begin
    CheckPos(IndexBookmark);
    if Prev then begin
      Result:=true;
      IndexBookmark:=GetBookmark;
    end else begin
      Result:=false;
      //IndexBookmark.BookmarkFlag:=TBookmarkFlag(-1);
      IndexBookmark.IndexBookmark:=-1;
      IndexBookmark.RecNo:=-1;
    end;
  end;
end;

function TIndexCursor.Next:boolean;
begin
  with SetIndexFile do begin
    CheckPos(IndexBookmark);
    if Next then begin
      Result:=true;
      IndexBookmark:=GetBookmark;
    end else begin
      Result:=false;
      //IndexBookmark.BookmarkFlag:=TBookmarkFlag(-1);
      IndexBookmark.IndexBookmark:=-1;
      IndexBookmark.RecNo:=-1;
    end;
  end;
end;

function TIndexCursor.GetPhysicalRecno:integer;
begin
  SetIndexFile.CheckPos(IndexBookmark);
  Result:=SetIndexFile.PhysicalRecno;
end;

procedure TIndexCursor.SetPhysicalRecno(Recno:integer); 
begin
  with SetIndexFile do begin
    GotoRecno(Recno);
    IndexBookmark:=GetBookMark;
  end;
end;

function TIndexCursor.GetSequentialRecordCount:integer;
begin
  with SetIndexFile do begin
    result:=GetSequentialRecordCount;
  end;
end;

function TIndexCursor.GetSequentialRecno:integer;
begin
  with SetIndexFile do begin
    CheckPos(IndexBookmark);
    result:=GetSequentialRecno;
  end;
end;

procedure TIndexCursor.SetSequentialRecNo(Recno:integer);
begin
  SetIndexFile.SetSequentialRecno(Recno);
end;

procedure TIndexCursor.GotoBookmark(Bookmark:rBookmarkData);
begin
  with SetIndexFile do begin
    GotoBookMark(Bookmark);
    IndexBookmark:=GetBookmark;
  end;
  if (IndexBookmark.RecNo<>Bookmark.RecNo) then begin
    Bookmark.RecNo:=IndexBookmark.RecNo;
  end;
end;

function TIndexCursor.GetBookMark:rBookmarkData;
begin
  Result:=IndexBookmark;
end;

function TIndexCursor.SetIndexFile:TIndexFile;
begin
  Result:=TIndexFile(PagedFile);
  Result.OnBracketStr:=OnBracketStr;
  Result.OnBracketNum:=OnBracketNum;
end;

end.


