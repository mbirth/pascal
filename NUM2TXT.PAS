program Num2Txt;        { Invented and programmed by Markus Birth }
uses Crt, Logo;

label Ready, Again;

const
  one        = 'eins';
  one1       = 'ein';
  one2       = 'eine';
  eleven     = 'elf';
  two        = 'zwei';
  twelve     = 'zwîlf';
  three      = 'drei';
  four       = 'vier';
  five       = 'fÅnf';
  six        = 'sechs';
  six1       = 'sech';
  seven      = 'sieben';
  seven1     = 'sieb';
  eight      = 'acht';
  nine       = 'neun';
  zero       = 'null';
  teen       = 'zehn';
  twen       = 'zwan';
  and1       = 'und';
  ty         = 'zig';
  ty1        = '·ig';
  hundred    = 'hundert';
  thousand   = 'tausend';
  mill       = 'mill';
  ion        = 'ion';
  ion1       = 'ionen';
  iard       = 'iarde';
  iard1      = 'iarden';
  minus      = 'minus';
  point      = 'komma';
  connector  = '˙';
  language   = 'GERMAN';

var Number: real;
    NText: string;
    Chosen: Char;
    Mrd: real;
    Mil: real;
    Tau: real;
    Hun: real;

procedure Combi(Source: string);
  begin
    NText := NText + Source + connector;
  end;

procedure ZeichMal;
  begin
    GotoXY(1,7);
    WriteLn(NText);
  end;

procedure ConvertHundred(dreier: real);
  var H, Z, E, Z1: integer;
  begin
    H := Trunc(dreier/100);
    Z := Trunc(dreier/10) - H*10;
    E := Trunc(dreier) - Z*10 - H*100;
    Z1 := E + Z*10;
    case H of
      1: Combi(one1);
      2: Combi(two);
      3: Combi(three);
      4: Combi(four);
      5: Combi(five);
      6: Combi(six);
      7: Combi(seven);
      8: Combi(eight);
      9: Combi(nine);
    end;
    if H<>0 then Combi(hundred);

    case Z1 of                         { 10, 11 oder 12 }
      10: Combi(teen);
      11: Combi(eleven);
      12: Combi(twelve);
    end;

    if (Z=1) AND (E>2) then            { Einser von 13-19 }
      begin
        case E of
          3: Combi(three);
          4: Combi(four);
          5: Combi(five);
          6: Combi(six1);
          7: Combi(seven1);
          8: Combi(eight);
          9: Combi(nine);
        end;
        Combi(teen);
      end;

    if Z>1 then                      { Einser, Rest }
      begin
        case E of
          1: Combi(one1);
          2: Combi(two);
          3: Combi(three);
          4: Combi(four);
          5: Combi(five);
          6: Combi(six);
          7: Combi(seven);
          8: Combi(eight);
          9: Combi(nine);
        end;
      end;
    if (E<>0) AND (Z>1) then Combi(and1);

    case Z of                       { Zehner }
      2: Combi(twen);
      3: Combi(three);
      4: Combi(four);
      5: Combi(five);
      6: Combi(six1);
      7: Combi(seven1);
      8: Combi(eight);
      9: Combi(nine);
    end;
    if (Z<>3) AND (Z>1) then Combi(ty);
    if Z=3 then Combi(ty1);

    if Z=0 then                      { einstellige Zahlen }
      begin
        if E=1 then
          begin
            if (dreier=Hun) then Combi(one);
            if dreier=Tau then Combi(one1);
            if (dreier<>Hun) AND (dreier<>Tau) then Combi(one2);
          end;
        case E of
          2: Combi(two);
          3: Combi(three);
          4: Combi(four);
          5: Combi(five);
          6: Combi(six);
          7: Combi(seven);
          8: Combi(eight);
          9: Combi(nine);
        end;
      end;
  end;

begin
  ClrScr;
  TextColor(15);                          { White }
  WriteLn('Another fine program from');
  WriteLogo;
  WriteLn;
  TextColor(14);                          { Yellow }
  WriteLn('-=˛ Number2Text Converter ˛=-');
  WriteLn;
  TextColor(7);                           { LightGray }
  WriteLn('Press any key to continue...');
  ReadKey;
Again:
  NText := connector;
  ClrScr;
  TextColor(14);                          { Yellow }
  TextBackground(1);                      { Blue }
  Write('                               -=˛ Num2Text ˛=-                               ');
  TextColor(7);                           { LightGray }
  TextBackground(0);                      { Black }
  WriteLn(' written by RoboCop IND. of TRC Inc.');
  WriteLn;
  TextColor(14);                          { Yellow }
  Write('Enter a number: ');
  TextColor(15);                          { White }
  ReadLn(Number);
  TextColor(14);                          { Yellow }
  WriteLn('Beginning process using '+language+' language set ...');
  if Number<0 then
    begin
      Combi(minus);
    end;
  Number := Abs(Number);
  if Number=0 then
    begin
      Combi(zero);
      goto Ready;
    end;

ZeichMal;

{ Milliarden }
  Mrd := Int(Number / 1000000000);
  if Mrd=1 then
    begin
      Combi(one2);
      Combi(mill);
      Combi(iard);
    end;
  if Mrd=2 then
    begin
      Combi(two);
      Combi(mill);
      Combi(iard1);
    end;

ZeichMal;

{ Millionen }
  Mil := Int(Number / 1000000) - Mrd*1000;
  if Mil=1 then
    begin
      Combi(one2);
      Combi(mill);
      Combi(ion);
    end;
  if Mil>1 then
    begin
      ConvertHundred(Mil);
      Combi(mill);
      Combi(ion1);
    end;

ZeichMal;

{ Tausend }
  Tau := Int(Number / 1000) - Mil*1000 - Mrd*1000000;
  ConvertHundred(Tau);
  if Tau<>0 then Combi(thousand);

ZeichMal;

{ Hunderter }
  Hun := Int(Number) - Tau*1000 - Mil*1000000 - Mrd*1000000000;
  ConvertHundred(Hun);

ZeichMal;

Ready:
  GotoXY(1,6);
  WriteLn('Number converted to text with following result:');
  TextColor(15);                          { White }
  WriteLn(NText);
  WriteLn;
  TextColor(14);                          { Yellow }
  Write('Again (Y/N)? ');
  Chosen := ReadKey;
  if Chosen='y' then goto Again;
  if Chosen='Y' then goto Again;
  ClrScr;
  TextColor(7);                           { LightGray }
  WriteLn('Exiting...');
  WriteLn;
  if Chosen='!' then
    begin
      WriteLn('Greetz are going out to:');
      TextColor(12);                      { LightRed }
      Write('Mister X, ');
      TextColor(10);                      { LightGreen }
      Write('Fred KrÅger, ');
      TextColor(11);                      { LightCyan }
      Write('Calle vHH, ');
      TextColor(14);                      { Yellow }
      Write('Memphis, ');
      TextColor(13);                      { LightMagenta }
      Write('Scorpion ');
      TextColor(15);                      { White }
      WriteLn('and all others I forgot!');
      WriteLn;
      TextColor(15+128);                  { White + Blink }
      WriteLn('Go to the IRC irc.germany.net (Port 6667)! There you''ll find me.');
      WriteLn;
    end;
  TextColor(15);                          { White }
end.
