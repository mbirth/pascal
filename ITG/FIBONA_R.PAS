program Fibonacci_rekursiv;

{ Die Fibonacci-Folge ist wie folgt aufgebaut: Jeder Wert wird aus der Summe
  der zwei vorhergehenden  Werte errechnet.  Gegeben sind die  ersten beiden
  Zahlen: 0 und 1.
  Der Anfang der Folge sieht so aus: 0,1,1,2,3,5,8,13,21,34,55,89,144,233,
                                     377,610,987,1597,2584,4181,6765,....    }

uses crt;

var take: integer;

procedure Fibonacci_Recursive(a,b: longint);
begin
  Inc(take);
  WriteLn(a:10);
  if take<47 then Fibonacci_Recursive(b,a+b);
end;

function Fibo(a: integer): longint;
begin
  if (a=1) OR (a=2) then Fibo := 1
    else if a=0 then Fibo := 0
    else Fibo := Fibo(a-1)+Fibo(a-2);
end;


begin
  TextMode(C80 + Font8x8);
  take := 0;
  Fibonacci_Recursive(0,1);
  WriteLn(Fibo(20));
end.