{ Var Geschl:Char;
'Grî·e, Gewicht, Geschlecht angeben'
VAR Gr,Gew,Geschl eingeben
Geschl='m' ?
nein: Ideal := (gr-100)*0.9

ja: Ideal=(Gr-100)*0.95
    Gew <= Ideal*0.98
    Ja: 'Fliegengew'
       Var Ideal ausgeben
    Nein: Gew >= Ideal*1.02
          Ja: 'Alter Sack-zu schwer!'
              VAR Ideal ausgeben
          Nein: 'Gratulation' }

program Gewicht;

uses Crt;

var Gr, Gew, Ideal: real;
    Geschl: char;

begin
  Write('Grî·e: ');
  ReadLn(Gr);
  Write('Gewicht: ');
  ReadLn(Gew);
  Write('Geschlecht (m/w): ');
  Geschl := ReadKey;
  WriteLn(Geschl);
  WriteLn;
  if Geschl='m' then Ideal := (Gr-100)*0.95 else Ideal := (Gr-100)*0.9;
  if Gew <= Ideal*0.98 then WriteLn('Fliegengewicht! Idealgewicht: ', Ideal:3:5)
  else if Gew >= Ideal*1.02 then WriteLn('Alter Sack-zu schwer! Idealgewicht: ', Ideal:3:5)
  else WriteLn('Gratulation!');
  WriteLn;
  WriteLn('Bitte Taste drÅcken...');
  ReadKey;
end.