program Bahnausflug;

{ Ein Club plant einen Ausflug mit einer Privatbahn. Dort kostet ein
  Tarifkilometer 20 Pf und bei Gruppenreisen hat jeder 6. Reisende eine
  Freifahrt. Es ist ein Programm zu schreiben, da· die Fahrtkosten pro
  Person fÅr eine beliebige Anzahl von Reisenden und Kilometern ermittelt,
  wobei die Gesamtkosten auf alle Teilnehmer gleichmÑ·ig umgelegt werden. }

uses Crt,VFx;

const money=0.20;

var people,km: longint;


procedure Init;
var mon: string;
begin
  TextBackground(0);
  ClrScr;
  DrawBorder(40,12,15,1,5);
  FXWriteC('-=+ Bahnkostenberechnung +=-',14);
  WriteLn;
  TextColor(10);
  Str(money:0:2,mon);
  WriteCLn('Der Preis pro Tarifkilometer betrÑgt '+mon+' DM.');
  TextColor(11);
  WriteLn;
  ReadyBeep;
end;

procedure GetData;
begin
  Write('Okay, wieviel Leutchens sollen''s denn werden? ');
  ReadLn(people);
  AckBeep;
  if people=1 then Write('Und wieviel Kilometer will diese Person fahren? ')
    else Write('Und wieviel Kilometer wollen diese ',people,' Personen fahren? ');
  ReadLn(km);
  WriteLn;
  AckBeep;
end;

procedure PrintData;
var freepeople,restpeople: longint;
    geldges,geldpro: extended;
begin
  TextColor(15);
  freepeople := people div 6;
  case freepeople of
    0: CWriteLn('Es fÑhrt niemand kostenlos! %%12#(NICHTS IST UMSONST!!)%%15#');
    1: WriteLn('Es fÑhrt eine Person kostenlos.');
  else
    WriteLn('Es fahren ',freepeople:0,' Personen kostenlos.');
  end;
  restpeople := people - freepeople;
  if restpeople=1 then Write('Und diese eine Person mu· ')
    else Write('Und ',restpeople,' der ',people,' Personen mÅssen insgesamt ');
  geldges := restpeople * km * money;
  WriteLn(geldges:0:2,' DM  hinblÑttern.');
  geldpro := km * money;
  if restpeople>1 then WriteLn('Das hei·t, jeder mu· ',geldpro:0:2,' DM hinlegen.');
  WriteLn;
  TextColor(7);
  WriteLn('Vielen Dank, da· Sie dieses Program benutzt haben.');
  WaitBeep;
  WriteLn;
  CWriteLn('%%142#=== DrÅcken Sie eine Taste! ===%%7#');
  ReadKey;
end;

begin
  Init;
  GetData;
  PrintData;
end.