program Verbrauchsberechnung;
uses crt;
var AltKM, Neukm: integer;
    Liter, Verbrauch, Gefahrenekm: real;
begin
  ClrScr;
  WriteLn ('Mit diesem Programm wird der durchschnittliche');
  WriteLn ('Benzinverbrauch auf 100 km berechnet');
  Write ('Kilometerstand beim vorletzten Tanken? ');
  ReadLn (AltKM);
  write ('Kilometerstand beim letzten Tanken? ');
  ReadLn (Neukm);
  write ('Wieviel Liter haben Sie getankt? ');
  ReadLn (Liter);
  Gefahrenekm := Neukm - AltKM
  ;
  Verbrauch := Liter / Gefahrenekm * 100;
  WriteLn ('Der Benzinverbrauch auf 100 km betrug ',Verbrauch:8:2,' Liter');
end.