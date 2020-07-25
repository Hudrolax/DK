uses Math, Ap;

procedure DemoBubbleSort();forward;


(*************************************************************************
Демонстрация работы подпрограммы BubbleSort
*************************************************************************)
procedure DemoBubbleSort();
var
    I : Integer;
    A : TReal1DArray;
begin
    SetLength(A, 4+1);
    A[0] := 2;
    A[1] := 1;
    A[2] := 4;
    A[3] := 5;
    A[4] := 3;
    BubbleSort(A, 5);
    I:=0;
    while I<=4 do
    begin
        Write(Format('A[%0d] = %3.1f'#13#10'',[
            I,
            A[I]]));
        Inc(I);
    end;
end;



