program Bewege_Test;

uses Crt;

var howmuchcanyoutake: integer;
    step: integer;

procedure Bewege(n: integer; p1,p2,p3: char);
begin
  if n=1 then begin
    WriteLn(p1,' --> ',p2);
    Inc(step);
  end else begin
    Bewege(n-1,p1,p3,p2);
    Bewege(1,p1,p2,p3);
    Bewege(n-1,p3,p2,p1);
  end;
end;

begin
  ClrScr;
  Step := 0;
  TextMode(CO80+Font8x8);
  Write('Wieviel MÅnzen? ');
  ReadLn(howmuchcanyoutake);
  Bewege(howmuchcanyoutake,'1','2','3');
  WriteLn('Schritte: ',step);
  ReadKey;
end.