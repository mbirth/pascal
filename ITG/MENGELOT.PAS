uses crt;

type TMenge = SET of 1..49;
var Tip1, Tip2, Tip3: TMenge;

procedure Init(var Menge: TMenge);
begin
  (**) Menge := []; (**)
end;

procedure LottoZiehung(var Zahlen: TMenge);
var anzahl, ZufZahl: byte;
begin
  anzahl := 0;
  repeat
    repeat
      ZufZahl := random(49)+1;
    until NOT (**) (ZufZahl IN Zahlen) (**) ;
    (**) Zahlen := Zahlen + [ZufZahl] (**) ;
    (**) Inc(anzahl) (**) ;
  until anzahl = 6;
end;

procedure Ausgabe(Zahlen: TMenge);
var i: byte;
begin
  for i:= (**) 1 to 49 (**) do
    (**) if i IN Zahlen then write(i, ' ') (**) ;
  (**) writeln (**) ;
end;

begin
  clrscr; Randomize;

  Init( (**) Tip1 (**) );
  LottoZiehung( (**) Tip1 (**) );
  Ausgabe( (**) Tip1 (**) );

  Init( (**) Tip2 (**) );
  LottoZiehung( (**) Tip2 (**) );
  Ausgabe( (**) Tip2 (**) );

  Init( (**) Tip3 (**) );
  LottoZiehung( (**) Tip3 (**) );
  Ausgabe( (**) Tip3 (**) );
end.