program Schwingungsberechnungen;             {Autor: RoboCop IND.}
uses Crt,Logo;
label ChosAgain, AllAgain, Ende;
var Chosen: Char;




  procedure Elong;
    label ChoAgain, ContHere, PerDKnown,FreqKnown;
    var Elongation, Amplitude, Wert, Omikron, Time: real;
        Choose: Char;
    begin;
      ClrScr;
      TextBackground(0);
      TextColor(15);
      WriteLn('-=˛ ELONGATIONSBERECHNUNG ˛=-');
      WriteLn;
      TextColor(7);
      Write('Amplitude eingeben (cm): ');
      TextColor(14);
      ReadLn(Amplitude);
      WriteLn;
      TextColor(15);
      WriteLn('AuswÑhlen: 1 - Frequenz bekannt');
      WriteLn('           2 - Periodendauer bekannt');

    ChoAgain:;
      TextColor(15);
      Write('Ihre Wahl: ');
      TextColor(14);
      Choose := ReadKey;
      WriteLn(Choose);
      if Choose = '1' then goto FreqKnown;
      if Choose = '2' then goto PerDKnown;
      TextColor(12);
      WriteLn('Falsche Auswahl! Es ist nur 1 oder 2 zugelassen.');
      goto ChoAgain;

    FreqKnown:;
      TextColor(7);
      Write ('Frequenz eingeben (Hz): ');
      TextColor(14);
      ReadLn (Wert);
      Omikron := 2*Pi*Wert;                    {Ausrechnen von Omikron (w)}
      goto ContHere;                           {bei Vorgabe der Frequenz.}

    PerDKnown:;
      TextColor(7);
      Write ('Periodendauer eingeben (s): ');
      TextColor(14);
      ReadLn (Wert);
      Omikron := (2*Pi)/Wert;                  {Ausrechnen von Omikron bei}
      goto ContHere;                           {Vorgabe der Frequenz.}

    ContHere:;
      TextColor(7);
      Write ('GewÅnschter Zeitpunkt (s): ');
      TextColor(14);
      ReadLn (Time);
      Elongation := Amplitude * sin(Omikron*Time); {Ausrechnen der Elongation}
      ClrScr;                                      {nach y=Ymax*sin(w*t)}
      TextColor(15);
      WriteLn ('-=˛ ELONGATIONSBERECHNUNG ˛=-');
      WriteLn;
      TextColor(10);
      WriteLn ('*** Auswertung ***');
      WriteLn;
      TextColor(14);
      WriteLn ('Amplitude: ',Amplitude:0:3,' cm');
      if Choose = '1' then WriteLn ('Frequenz: ',Wert:0:3,' Hz');
      if Choose = '2' then WriteLn ('Periodendauer: ',Wert:0:3,' s');
      WriteLn ('Zeitpunkt: ',Time:0:3,' s');
      WriteLn ('Elongation: ',Elongation:0:3,' cm');
      WriteLn;
      TextColor(7);
      WriteLn ('Die Elongation zum Zeitpunkt t=',Time:0:1,' s, bei einer maximalen');
      Write ('Auslenkung von Ymax=',Amplitude:0:1,' cm und einer ');
      if Choose = '1' then WriteLn ('Frequenz von f=',Wert:0:1,' Hz');
      if Choose = '2' then WriteLn ('Periodendauer von T=',Wert:0:1,' s');
      WriteLn ('betrÑgt y=',Elongation:0:2,' cm.');
      WriteLn;
      TextColor(14);
      WriteLn ('Wenn bereit, eine Taste drÅcken.');
      ReadKey;
  end;




  procedure PDauer;
    label ChoAgain, ContHere;
    var Length, Gravitation, PDauer: real;
        Choose: char;
        Planet: string[5];

    begin;
      ClrScr;
      TextBackground(0);
      TextColor(15);
      WriteLn('-=˛ PERIODENDAUERBERECHNUNG ˛=-');
      WriteLn;
      TextColor(7);
      Write('LÑnge des Pendels eingeben (cm): ');
      TextColor(14);
      ReadLn(Length);
      WriteLn;
      TextColor(15);
      WriteLn('Planet wÑhlen: 1 - Erde');
      WriteLn('               2 - Sonne');
      WriteLn('               3 - Mond');

    ChoAgain:;
      TextColor(15);
      Write('Ihre Wahl: ');
      TextColor(14);
      Choose := ReadKey;
      WriteLn(Choose);
      if Choose = '1' then
        begin;
          Gravitation := 9.80665;
          Planet := 'Erde';
          goto ContHere;
        end;
      if Choose = '2' then
        begin;
          Gravitation := 274;
          Planet := 'Sonne';
          goto ContHere;
        end;
      if Choose = '3' then
        begin;
          Gravitation := 1.62;
          Planet := 'Mond';
          goto ContHere;
        end;
      TextColor(12);
      WriteLn('Falsche Auswahl! Es sind nur 1, 2 oder 3 zugelassen.');
      goto ChoAgain;

    ContHere:;
      ClrScr;
      PDauer := 2*Pi*Sqrt(Length/Gravitation);
      TextColor(15);
      WriteLn('-=˛ PERIODENDAUERBERECHNUNG ˛=-');
      WriteLn;
      TextColor(10);
      WriteLn('*** AUSWERTUNG ***');
      WriteLn;
      TextColor(14);
      WriteLn('LÑnge des Pendels: ',Length:0:3,' cm');
      WriteLn('Basierend auf ',Planet,' [',Gravitation:0:5,']');
      WriteLn('Dauer einer Periode: ',PDauer:0:3,' s');
      WriteLn;
      TextColor(7);
      WriteLn('Die Dauer einer Periode eines Fadenpendels mit der LÑnge');
      WriteLn('l=',Length:0:1,' cm auf der/dem ',Planet,' mit einer');
      WriteLn('Anziehungskraft von g=',Gravitation:0:1,' m/s˝ betrÑgt');
      WriteLn('T=',PDauer:0:2,' s.');
      WriteLn;
      TextColor(14);
      WriteLn('Wenn bereit, eine Taste drÅcken.');
      ReadKey;
  end;




  procedure PLength;
    label ChoAgain, ContHere;
    var PDauer, Gravitation, Length: real;
        Planet: string[5];
        Choose: char;

    begin;
      ClrScr;
      TextBackground(0);
      TextColor(15);
      WriteLn('-=˛ PENDELLéNGENBERECHNUNG ˛=-');
      WriteLn;
      TextColor(7);
      Write('Dauer einer Periode eingeben (s): ');
      TextColor(14);
      ReadLn(PDauer);
      WriteLn;
      TextColor(15);
      WriteLn('Planet wÑhlen: 1 - Erde');
      WriteLn('               2 - Sonne');
      WriteLn('               3 - Mond');

    ChoAgain:;
      TextColor(15);
      Write('Ihre Wahl: ');
      TextColor(14);
      Choose := ReadKey;
      WriteLn(Choose);
      if Choose = '1' then
        begin;
          Gravitation := 9.80665;
          Planet := 'Erde';
          goto ContHere;
        end;
      if Choose = '2' then
        begin;
          Gravitation := 274;
          Planet := 'Sonne';
          goto ContHere;
        end;
      if Choose = '3' then
        begin;
          Gravitation := 1.62;
          Planet := 'Mond';
          goto ContHere;
        end;
      TextColor(12);
      WriteLn('Falsche Auswahl! Es sind nur 1, 2 oder 3 zugelassen.');
      goto ChoAgain;

    ContHere:;
      ClrScr;
      Length := (Sqr(PDauer)*Gravitation)/(4*Sqr(Pi));
      TextColor(15);
      WriteLn('-=˛ PENDELLéNGENBERECHNUNG ˛=-');
      WriteLn;
      TextColor(10);
      WriteLn('*** AUSWERTUNG ***');
      WriteLn;
      TextColor(14);
      WriteLn('Dauer einer Periode: ',PDauer:0:0,' s');
      WriteLn('Basierend auf ',Planet,' [',Gravitation:0:0,']');
      WriteLn('LÑnge des Pendels: ',Length:0:0,' cm');
      WriteLn;
      TextColor(7);
      WriteLn('Die LÑnge eines Fadenpendels mit der Periodendauer');
      WriteLn('T=',PDauer:0:0,' s auf der/dem ',Planet,' mit einer');
      WriteLn('Anziehungskraft von g=',Gravitation:0:0,' m/s˝ betrÑgt');
      WriteLn('l=',PDauer:0:0,' cm.');
      WriteLn;
      TextColor(14);
      WriteLn('Wenn bereit, eine Taste drÅcken.');
      ReadKey;
    end;




begin;
AllAgain:;
  ClrScr;
  TextColor(15);
  WriteLn('-=˛ SCHWINGUNGSBERECHNUNGEN ˛=-');
  WriteLn;
  WriteLn('1st program by');
  WriteLogo;
  TextColor(7);
  WriteLn('Bitte Auswahl treffen:');
  WriteLn('  1 - Unter Eingabe von Ymax,f od. T & t, Ausrechnung von y');
  WriteLn('  2 - Unter Eingabe von l und Auswahl von g, Ausrechnung von T');
  WriteLn('  3 - Unter Eingabe von T und Auswahl von g, Ausrechnung von l');
  WriteLn('  4 - Programm beenden.');
  WriteLn;
ChosAgain:;
  TextColor(14);
  Write('Ihre Wahl: ');
  Chosen := ReadKey;
  WriteLn(Chosen);
  if Chosen = '1' then
    begin;
      Elong;
      goto AllAgain;
    end;
  if Chosen = '2' then
    begin;
      PDauer;
      goto AllAgain;
    end;
  if Chosen = '3' then
    begin;
      PLength;
      goto AllAgain;
    end;
  if Chosen = '4' then
    begin;
      ClrScr;
      TextColor(7);
      WriteLn('SCHWINGUNGEN normal beendet.');
      goto Ende;
    end;
  TextColor(12);
  WriteLn('Falsche Auswahl, drÅcken Sie bitte eine Taste von 1-4.');
  goto ChosAgain;
Ende:;
end.