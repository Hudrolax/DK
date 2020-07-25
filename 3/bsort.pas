unit bsort;
interface
uses Math, Ap, Sysutils;

procedure BubbleSort(var Arr : TReal1DArray; const N : Integer);

implementation

(*************************************************************************
��������� ��� ���������� ������� ������� ��������

������� ���������:
    Arr -   ����������� ������.
            ��������� ��������� �� 0 �� N-1
    N   -   ������ �������

�������� ���������:
    Arr -   ������, ������������� �� �����������.
            ��������� ��������� �� 0 �� N-1
*************************************************************************)
procedure BubbleSort(var Arr : TReal1DArray; const N : Integer);
var
    I : Integer;
    J : Integer;
    Tmp : Double;
begin
    i:=0;
    while i<=N-1 do
    begin
        j:=0;
        while j<=n-2-i do
        begin
            if Arr[j]>Arr[j+1] then
            begin
                Tmp := Arr[j];
                Arr[j] := Arr[j+1];
                Arr[j+1] := Tmp;
            end;
            Inc(j);
        end;
        Inc(i);
    end;
end;


end.