program Augensumme;

uses Crt;

const p: char='|';

var A: array[1..12] of longint;
    n: longint;

procedure Progress;
begin
  case p of
    '|': p:='/';
    '/': p:='-';
    '-': p:='\';
    '\': p:='|';
  end;
  GotoXY(WhereX-1,WhereY);
  Write(p);
end;

procedure Calc;
var x: byte;
begin
  x := Random(6)+Random(6)+2;
  Inc(A[x]);
  Inc(A[1]);
end;

procedure Auswertung;
var x: byte;
begin
  for x:=2 to 12 do begin
    WriteLn(x:2,' Augen: ',A[x]:7,' Treffer = ',(A[x]/A[1])*100:6:2,'%');
  end;
end;


begin
  WriteLn('<====*====>');
  Write('DrÅcken Sie eine Taste, um den Versuch zu beenden.  ');
  repeat
    Calc;
    if A[1]/50000=A[1] DIV 50000 then Progress;
  until keypressed;
  ReadKey;
  GotoXY(WhereX-1,WhereY); WriteLn(' ');
  WriteLn;
  Auswertung;
  WriteLn;
  WriteLn('Bitte eine Taste drÅcken');
  ReadKey;
end.