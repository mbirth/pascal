program Wassertemp;

uses Crt;

const un='øC';

var l: real;
    T1,T2,Tw: real;

procedure CalcTemp(l,T1,T2,Tw: real);
var x: real;
begin
  if ((Tw>T1) AND (Tw>T2)) then begin
    TextColor(12);
    WriteLn('Du Idiot! Hast Du ''ne Mikrowelle neben Deiner Badewanne?');
    WriteLn('Das Wasser kann doch nicht w„rmer werden, wie die max. Temp!');
    Exit;
  end;
  if ((Tw<T1) AND (Tw<T2)) then begin
    TextColor(12);
    WriteLn('Du Arsch! Hast Du etwa Deinen Khlschrank in der Badewanne?');
    WriteLn('Das Wasser kann doch nicht k„lter als die k„lteste Temp. werden!');
    Exit;
  end;
  x := ((Tw-T2)*l)/(T1-T2);
  WriteLn('Dafr brauchst Du ',x:0:2,'l Wasser mit einer Temperatur von ',T1:0:2,un,' und');
  WriteLn(l-x:0:2,'l Wasser mit einer Temperatur von ',T2:0:2,un,' und fertig ist die');
  WriteLn('gewnschte Mixtur.');
end;


begin
  ClrScr;
  TextColor(15);
  WriteLn('-=+ MBUWTBPADIU +=-'); { Markus Birth's ultimatives WasserTemperatur }
  WriteLn;                        { Berechnungs Programm Aus Dem InformatikUnterricht }
  TextColor(7);
  Write('Wieviel Liter sollen rein? ');
  ReadLn(l);
  Write('Was fr ''ne Temperatur hat die erste Wasserquelle (in ',un,')? ');
  ReadLn(T1);
  Write('Und die zweite, h„h? ');
  ReadLn(T2);
  WriteLn;
  Write('Und wie warm soll es denn jetzt werden (in ',un,')? ');
  ReadLn(Tw);
  WriteLn;
  WriteLn('Na, dann wollen wir mal schau''n ...');
  Delay(500);
  Write('*knatter* ');
  Delay(500);
  Write('*ratter* ');
  Delay(500);
  Write('*klapper* ');
  Delay(500);
  WriteLn('*pling*');
  WriteLn;
  CalcTemp(l,T1,T2,Tw);
  TextColor(7);
  WriteLn;
  WriteLn('Fertich, Meista! Nu'' drck'' mal auf ''ne Taste!!');
  ReadKey;
end.