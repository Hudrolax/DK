unit testbsort;
interface
uses Math, Ap, Sysutils, bsort;

function TestBubbleSort(Silent : Boolean):Boolean;
function testbsort_test_silent():Boolean;
function testbsort_test():Boolean;

implementation

function TestBubbleSort(Silent : Boolean):Boolean;
var
    WasErrors : Boolean;
    I : Integer;
    J : Integer;
    N : Integer;
    Pass : Integer;
    MaxN : Integer;
    PassCount : Integer;
    A : TReal1DArray;
    B : TReal1DArray;
    Tmp : Double;
begin
    WasErrors := False;
    MaxN := 50;
    PassCount := 10;
    
    //
    //
    //
    N:=1;
    while N<=MaxN do
    begin
        SetLength(A, N-1+1);
        SetLength(B, N-1+1);
        Pass:=1;
        while Pass<=PassCount do
        begin
            
            //
            // Random entries
            //
            I:=0;
            while I<=N-1 do
            begin
                A[I] := 2*RandomReal-1;
                B[I] := A[I];
                Inc(I);
            end;
            BubbleSort(A, N);
            I:=0;
            while I<=N-1 do
            begin
                J:=0;
                while J<=N-2-I do
                begin
                    if B[j]>B[j+1] then
                    begin
                        Tmp := B[j];
                        B[j] := B[j+1];
                        B[j+1] := Tmp;
                    end;
                    Inc(J);
                end;
                Inc(I);
            end;
            I:=0;
            while I<=N-2 do
            begin
                if A[I]>A[I+1] then
                begin
                    WasErrors := True;
                end;
                Inc(I);
            end;
            I:=0;
            while I<=N-1 do
            begin
                if A[I]<>B[I] then
                begin
                    WasErrors := True;
                end;
                Inc(I);
            end;
            
            //
            // +1, 0 or -1
            //
            I:=0;
            while I<=N-1 do
            begin
                A[I] := Sign(2*RandomReal-1);
                B[I] := A[I];
                Inc(I);
            end;
            BubbleSort(A, N);
            I:=0;
            while I<=N-1 do
            begin
                J:=0;
                while J<=N-2-I do
                begin
                    if B[j]>B[j+1] then
                    begin
                        Tmp := B[j];
                        B[j] := B[j+1];
                        B[j+1] := Tmp;
                    end;
                    Inc(J);
                end;
                Inc(I);
            end;
            I:=0;
            while I<=N-2 do
            begin
                if A[I]>A[I+1] then
                begin
                    WasErrors := True;
                end;
                Inc(I);
            end;
            I:=0;
            while I<=N-1 do
            begin
                if A[I]<>B[I] then
                begin
                    WasErrors := True;
                end;
                Inc(I);
            end;
            Inc(Pass);
        end;
        Inc(N);
    end;
    
    //
    // Report
    //
    if  not Silent then
    begin
        Write(Format('TESTING BUBBLE SORT'#13#10'',[]));
        if WasErrors then
        begin
            Write(Format('TEST FAILED'#13#10'',[]));
        end
        else
        begin
            Write(Format('TEST PASSED'#13#10'',[]));
        end;
        Write(Format(''#13#10''#13#10'',[]));
    end;
    Result :=  not WasErrors;
end;


(*************************************************************************
Silent unit test
*************************************************************************)
function testbsort_test_silent():Boolean;
begin
    Result := TestBubbleSort(True);
end;


(*************************************************************************
Unit test
*************************************************************************)
function testbsort_test():Boolean;
begin
    Result := TestBubbleSort(False);
end;


end.