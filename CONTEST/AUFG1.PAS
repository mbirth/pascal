{ Aufgabe fÅr den Bundeswettbewerb in Informatik

  Aufgabe 1

  Belagerung um Farnsworth Castle

  AD 1314. Nicht mehr lange kînnen die Ritter Kînigin Eleonores auf Farns-
  worth Castle die Angreifer des Blythletwick-Clans abhalten. Die einzige
  Hoffnung der Kînigin ist die Benachrichtigung ihres Sohnes John, der sich
  mit Julee, der Prinzessin des Clans, verlobt hat. WÑre sie auf Farnsworth,
  mÅ·ten die Blythlethwicks verhandeln. Doch die Kînigin kann sich nicht
  sicher sein, da· ihr Bote nicht abgefangen wird. WÅrde ihr Plan bekannt,
  wÑre Blutvergie·en unvermeidbar. Eleonore schickt darum zwei Boten: Einen
  mit einer verschlÅsselten Botschaft, den anderen mit einem SchlÅssel. Bei
  der VerschlÅsselung geht sie folgenderma·en vor: Sie schneidet eine qua-
  dratische Schablone aus Leder, die in quadratische Felder eingeteilt ist.
  Manche dieser Felder sind ausgeschnitten. Diese Schablone legt die Kînigin
  auf ein StÅck Papier und schreibt die ersten Buchstaben ihrer Botschaft
  von links nach rechts, oben nach unten, durch die ausgeschnittenen Felder.
  Dann dreht sie die Schablone um 90 Grad im Uhrzeigersinn, schreibt weiter
  und wiederholt diesen Vorgang noch zwei weitere Male.
  Die Nachricht ist:

  KOMM UND BRING JULEE NACH FARNSWORTH

  Schablone und verschlÅsselte Nachricht sehen so aus:

  €€  €€   BRKOAE
  €€€€ €   ER IMN
  € € €€   NMS WN
  €€€€€€   OGA CJ
   €€ €    UHRNUD
   €€€€€    L FTH

  1. Welchen Anforderungen mÅssen Anzahl und Anordnung der Lîcher genÅgen,
     damit die Schablone zur VerschlÅsselung geeignet ist?
  2. Gib ein einfaches Verfahren fÅr den Entwurf von geeigneten Schablonen
     an.
  3. Schreibe ein Programm, das anhand einer gegebenen Schablone eine Nach-
     richt ver- und entschlÅsseln kann. Wie sieht die mit der obigen Scha-
     blone verschlÅsselte Fassung folgender RÅckantwort aus?

  JULEE MIT STALLKNECHT DURCHGEBRANNT
}

program Belagerung_um_Farnsworth_Castle;
{ Lîsung ausgearbeitet von Markus Birth }

uses Crt;

var Template: array[1..6] of string[6];
    chosen: char;
    i, j: integer;
    MaxC: integer;

procedure InitTemplate;
  begin
    Template[1] := '001100';
    Template[2] := '000010';
    Template[3] := '010100';
    Template[4] := '000000';
    Template[5] := '100101';
    Template[6] := '100000';
  end;

procedure WriteTemplate(y,x: integer);
  begin
    GotoXY(x,y);
    MaxC := 0;
    for i:=1 to 6 do begin
      for j:=1 to 6 do begin
        if Copy(Template[i],j,1)='0' then Write('€') else begin
          Write('˙');
          Inc(MaxC);
        end;
      end;
      GotoXY(x,y+i);
    end;
    MaxC := MaxC * 4;
  end;

procedure TurnTemplate;
  var Temp: array[1..6] of string[6];
  begin
    for i := 1 to 6 do begin
      Temp[i] := Template[i];
      Template[i] := '';
    end;
    for i := 1 to 6 do begin
      for j := 1 to 6 do Template[i] := Template[i] + Copy(Temp[7-j],i,1);
    end;
  end;

procedure Coding;
  var Text2Code: string;
      take, curchar: integer;

  const xco = 3;
        yco = 3;

  begin
    curchar := 1;
    ClrScr;
    TextColor(White);
    Write('Text eingeben (max. ', MaxC, ' Zeichen): ');
    TextColor(LightGray);
    ReadLn(Text2Code);
    TextColor(White);
    Write('Anzahl Buchstaben: ');
    TextColor(LightGray);
    WriteLn(Length(Text2Code));
    TextColor(White);
    for take := 1 to 4 do begin
      WriteTemplate(yco+1, xco+10);
      for i := 1 to 6 do begin
        for j := 1 to 6 do begin
          if Copy(Template[i],j,1)='1' then begin
            GotoXY(xco+j,yco+i);
            Write(Copy(Text2Code,curchar,1));
            GotoXY(xco+17+curchar,yco+6);
            Write(Copy(Text2Code,curchar,1));
            Inc(curchar);
          end;
          Delay(50);
        end;
      end;
      TurnTemplate;
    end;
    GotoXY(3, yco+10);
    TextColor(Yellow);
    WriteLn('Taste drÅcken, wenn bereit...');
    ReadKey;
  end;

procedure DeCoding;
  var Coded: array[1..6] of string[6];
      take, curchar: integer;

  const xco = 19;
        yco = 2;

  begin
    curchar := 1;
    ClrScr;
    WriteLn('Pro Zeile nur 6 Buchstaben!');
    for i := 1 to 6 do begin
      Write('Zeile ', i, ': ');
      ReadLn(Coded[i]);
      GotoXY(1,i+1);
      WriteLn('         ');
    end;
    for take := 1 to 4 do begin
      WriteTemplate(yco, xco);
      for i := 1 to 6 do begin
        for j := 1 to 6 do begin
          if Copy(Template[i],j,1)='1' then begin
            GotoXY(xco+curchar+8,yco+5);
            Write(Copy(Coded[i],j,1));
            Inc(curchar);
            GotoXY(j+9, i+1);
            Write(' ');
          end;
          Delay(50);
        end;
      end;
      TurnTemplate;
    end;
    GotoXY(3, yco+10);
    TextColor(Yellow);
    WriteLn('Taste drÅcken, wenn bereit...');
    ReadKey;
  end;

begin
  ClrScr;
  TextColor(White);
  WriteLn('-=˛ Belagerung um Farnsworth Castle ˛=-');
  TextColor(Cyan);
  WriteLn('Aufgabe 1 vom Bundeswettbewerb fÅr Informatik 97');
  TextColor(LightGray);
  WriteLn;
  WriteLn('Umgesetzt von Markus Birth');
  InitTemplate;
  TextColor(Yellow);
  WriteLn('Verwendete Schablone mit Drehergebnissen:');
  TextColor(LightGray);
  Delay(500);
  WriteTemplate(6,1);
  TextColor(DarkGray);
  TurnTemplate;
  Delay(500);
  WriteTemplate(6,11);
  TurnTemplate;
  Delay(500);
  WriteTemplate(6,21);
  TurnTemplate;
  Delay(500);
  WriteTemplate(6,31);
  TurnTemplate;
  TextColor(Yellow);
  WriteLn;
  Write('Maximale Zeichenanzahl: ');
  TextColor(LightGray);
  WriteLn(MaxC);
  WriteLn;
  Write('Wollen Sie ');
  TextColor(Yellow);
  Write('v');
  TextColor(LightGray);
  Write('erschlÅsseln oder ');
  TextColor(Yellow);
  Write('e');
  TextColor(LightGray);
  Write('ntschlÅsseln (andere Taste - quit)? ');
  chosen := UpCase(ReadKey);
  if chosen='V' then Coding;
  if chosen='E' then DeCoding;
end.