program Alkoholberechnung;               { Autor: Markus Birth }
uses Crt, Logo;
var Menge, Gewicht, Alkoholml, Alkoholg, Promille, Abbauzeit, AZh, AZm, AZs, Redfaktor: real;
    vol: integer;
    Geschlecht: char;

begin
  ClrScr;
  TextColor(15);
  WriteLn('-=˛ Alkoholberechnung ˛=-');
  WriteLn;
  WriteLn('3rd program by');
  WriteLogo;
  TextColor(15);
  Write('Aufgenommene Menge in ml: ');
  ReadLn(Menge);
  Write('Anteil Alkohol (% vol.):  ');
  ReadLn(vol);
  Write('Gewicht der Person in kg: ');
  ReadLn(Gewicht);
  TextColor(7);
  Write('Ist die Person ein ');
  TextColor(14);
  Write('M');
  TextColor(7);
  Write('ann oder eine ');
  TextColor(14);
  Write('F');
  TextColor(7);
  Write('rau? ');
  TextColor(15);
  Geschlecht := ReadKey;
  WriteLn(Geschlecht);
  case Geschlecht of
    'm','M': Redfaktor := 0.7;
    'f','F': Redfaktor := 0.6;
  else
    WriteLn('ERROR! Using male factor.');
    Redfaktor := 0.7;
  end;
  WriteLn('============');
  WriteLn('Reduktionsfaktor         : ',Redfaktor:1:1);
  Alkoholml := Menge*(vol/100);
  WriteLn('Enthaltener Alkohol in ml: ',Alkoholml:4:2);
  Alkoholg := Alkoholml*0.8;
  WriteLn('Enthaltener Alkohol in g : ',Alkoholg:4:2);
  Promille := Alkoholg/(Gewicht*Redfaktor);
  WriteLn('Promille im Blut         : ',Promille:1:4);
  if Promille > 3.2 then Write('Dieser Mensch ist schon so gut wie tot!');
  if Promille > 5 then WriteLn(' --- Berichtigung: Er IST tot! ---') else WriteLn;
  Abbauzeit := Promille/0.15;
  WriteLn('Abbauzeit in h           : ',Abbauzeit:3:4);
  AZh := Int(Abbauzeit);
  AZm := (Abbauzeit-Int(Abbauzeit))*60;
  AZs := (AZm-Int(AZm))*60;
  WriteLn('Abbauzeit                : ',AZh:2:0,'h ',AZm:2:0,'m ',AZs:2:0,'s');
  WriteLn;
  WriteLn('Bitte eine Taste drÅcken...');
  repeat until Keypressed;
end.