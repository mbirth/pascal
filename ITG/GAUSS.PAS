program GAUSS;

uses Crt;

type GaRec=record
       x: integer;
       y: integer;
     end;

var n: integer;
    P: array[1..500] of GaRec;
    A: real;

procedure Init;
var i: integer;
begin
  for i:=1 to 500 do begin
    P[i].x:=0;
    P[i].y:=0;
  end;
end;

procedure Input;
var i: integer;
    tmp,t2: string;
begin
  i:=1;
  repeat
    Str(i:0,t2);
    tmp := 'P'+t2+'(';
    Write(tmp);
    ReadLn(P[i].x);
    Str(P[i].x:0,t2);
    tmp := tmp+t2+'|';
    GotoXY(1,WhereY-1);
    Write(tmp);
    ReadLn(P[i].y);
    Str(P[i].y:0,t2);
    tmp := tmp+t2+')';
    GotoXY(1,WhereY-1);
    WriteLn(tmp);
    Inc(i);
  until (P[i-1].x=P[1].x) AND (P[i-1].y=P[1].y) AND (i>2);
  n := i-2;
end;

procedure Calc;
var i: integer;
begin
  A := 0;
  for i:=1 to n do A := A + (P[i].x*P[i+1].y - P[i+1].x*P[i].y);
  A := A / 2;
end;

procedure Output;
begin
  WriteLn;
  WriteLn('Fl„cheninhalt: ',A:0:5,' quadratsonstwas');
end;

begin
  Init;
  Input;
  Calc;
  Output;
end.
