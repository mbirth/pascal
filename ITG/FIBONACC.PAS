program Fibonacci;

{ Die Fibonacci-Folge ist wie folgt aufgebaut: Jeder Wert wird aus der Summe
  der zwei vorhergehenden  Werte errechnet.  Gegeben sind die  ersten beiden
  Zahlen: 0 und 1.
  Der Anfang der Folge sieht so aus: 0,1,1,2,3,5,8,13,21,34,55,89,144,233,
                                     377,610,987,1597,2584,4181,6765,....    }

uses crt;

var i: integer;

function Fibonacci_Loop(n: integer): longint;
var tmp,last1,last2,i: longint;
begin
  last1:=0; last2:=0; tmp:=1;
  if n>=2 then begin
    for i:=1 to n do begin
      tmp:=tmp+last2; last2:=last1; last1:=tmp;
    end;
    Fibonacci_Loop:=tmp;
  end else Fibonacci_Loop:=n;
end;

begin
  TextMode(C80 + Font8x8);
  Window(1,1,40,50);
  for i:=0 to 48 do begin
    WriteLn(Fibonacci_Loop(i));
  end;
  Window(40,1,80,50);
  for i:=49 to 97 do begin
    WriteLn(Fibonacci_Loop(i));
  end;
end.