{ Aufgabe fÅr den Bundeswettbewerb in Informatik

  Aufgabe 4

  Wetter in Quadratien

  Quadratien ist ein quadratisches Gebiet aus quadratischen Feldern. Das Feld
  in der Nordwest-Ecke hat die Zeilennummer 0 und die Spaltennummer 0.

  Das Wetter in Quadratien wird durch quadratische Wolken bestimmt, die genau
  ein Feld gro· sind. Solche Wolken rÅcken getaktet Åber Quadratien vor, und
  zwar von Norden nach SÅden 2 Felder pro Takt und, in einer anderen Hîhe,
  von Westen nach Osten 3 Felder pro Takt. Es regnet Åberall dort, wo sich
  nach einem VorrÅcken sowohl eine Nord-SÅd- als auch eine West-Ost-Wolke
  befindet. Wolken, aus denen regnet, lîsen sich auf.

  Die Wolkenvorhersage gibt an, an welchen Stellen (in der Form: Zeilennum-
  mer, Spaltennummer) sich zum aktuellen Zeitpunkt Wolken befinden. Daraus
  lÑ·t sich dann ermitteln, wo es in Quadratien regnen wird, denn es werden
  nur solche Wolken angegeben, die Åber Quadratien hinwegziehen werden.

  Beispiel:
  Wolkenvorhersage:
  -5/ 6  -4/ 6  -2/ 7   7/-6  -2/ 9  -5/ 7
   1/-2   8/-6   6/-6   7/-7   6/-7   1/-3  -2/ 8.

  Es wird jeweils einmal regnen an den Stellen 1,6, 1,7 und 8,9.

  Aufgabe:
  Schreibe ein Programm, welches folgendes leistet:
  1. Einlesen der Grî·e von Quadratien (Anzahl Zeilen bzw. Spalten)
  2. Einlesen einer Wolkenvorhersage
  3. Ausgabe, wo in Quadratien wie oft Regen fÑllt

  Sende uns 3 Beispiele, darunter eines fÅr ein Quadratien der Grî·e 10x10
  und folgender Wolkenvorhersage:
   2/-3  -5/ 5  -3/ 4   1/-4   6/-12 -3/ 5
  -7/ 5   3/-10 -6/ 6   6/-11 -7/ 4   3/-4
  -4/ 5  -3/ 3  -6/ 9   2/-4
}

program Wetter_in_Quadratien;
{ Lîsung ausgearbeitet von Markus Birth }

uses Crt;

type W=record
       x,y: integer;
       dir: integer;
     end;
     R=record
       x,y: integer;
       w1,w2: integer;
     end;

const simdel=500;

var Wolke: array[1..50] of W;
    Rain: array[1..50] of R;
    QX, QY: integer;
    count, rct: integer;
    MatrixX, MatrixY: integer;
    i, j, k, l: integer;
    maxtakes: integer;

procedure InitClouds;
{ Wolke.Dir: 1= li=>re
             2= ob=>un }
  begin
    for i:=1 to count do begin
      if Wolke[i].x<0 then Wolke[i].dir := 1;
      if Wolke[i].x<MatrixX then MatrixX := Wolke[i].x;
      if Wolke[i].y<0 then Wolke[i].dir := 2;
      if Wolke[i].y<MatrixY then MatrixY := Wolke[i].y;
    end;
  end;

procedure WriteMatrix(x,y: integer);
  begin
    for i := MatrixX to QX do begin
      for j := MatrixY to QY do begin
        GotoXY(x+(i-MatrixX),y+(j-MatrixY));
        TextColor(LightBlue);
        Write('˙');
      end;
    end;
    for i := MatrixX to QX do begin
      for j := MatrixY to QY do begin
        for k := 1 to count do begin
          GotoXY(x+(i-MatrixX),y+(j-MatrixY));
          if (Wolke[k].x=i) AND (Wolke[k].y=j) AND (Wolke[k].dir<>0) then begin
            TextColor(LightCyan);
            Write('˛');
          end;
        end;
      end;
    end;
  end;

procedure SimClouds;
  begin
    for i:=1 to count do begin
      if Wolke[i].dir=1 then Wolke[i].x:=Wolke[i].x+3;
      if Wolke[i].dir=2 then Wolke[i].y:=Wolke[i].y+2;
      if (Wolke[i].dir<0) OR (Wolke[i].dir>2) then WriteLn('ERRRORRR!!!');
    end;
  end;

procedure CheckForRain;
  begin
    for j:=1 to count do begin
      for k:=j to count do begin
        if (Wolke[j].x=Wolke[k].x) AND (Wolke[j].y=Wolke[k].y) AND (j<>k)
        AND (Wolke[j].dir<>0) AND (Wolke[k].dir<>0) then begin
          Rain[rct].x := Wolke[j].x; Rain[rct].y := Wolke[j].y;
          Rain[rct].w1 := j;         Rain[rct].w2 := k;
          Inc(rct);
          Wolke[k].x := 0; Wolke[k].y := 0; Wolke[k].dir := 0;
          Wolke[j].x := 0; Wolke[j].y := 0; Wolke[j].dir := 0;
        end;
      end;
    end;
  end;

procedure ProgHeader;
  begin
    TextColor(White);
    WriteLn('-=˛ Wetter in Quadratien ˛=-');
    TextColor(Cyan);
    WriteLn('Aufgabe 4 vom Bundeswettbewerb fÅr Informatik');
    TextColor(LightGray);
    WriteLn;
    WriteLn('Umgesetzt von Markus Birth');
    WriteLn;
  end;

procedure InputData;
  begin
    TextColor(Yellow);
    Write('Geben Sie die Breite Quadratiens ein: ');
    TextColor(LightGray);
    ReadLn(QX);
    TextColor(Yellow);
    Write('Geben Sie nun die Hîhe Quadratiens ein: ');
    TextColor(LightGray);
    ReadLn(QY);
    WriteLn;
    TextColor(White);
    WriteLn('Jetzt kommen die Wolken... (Beenden durch Eingabe von 0 und 0! 5|-10;-5|5)');
    for i:=1 to 50 do begin
      if k=0 then j := 0;
      if k=1 then j := 27;
      if k=2 then j := 54;
      Inc(k);
      if k>2 then k := 0;
      GotoXY(j, WhereY-1);
      TextColor(Yellow);
      Write('Wolke ', i, ' Y: ');
      TextColor(LightGray);
      ReadLn(Wolke[i].y);
      GotoXY(16+j, WhereY-1);
      TextColor(Yellow);
      Write('X: ');
      TextColor(LightGray);
      ReadLn(Wolke[i].x);
      if (Wolke[i].y = 0) AND (Wolke[i].x = 0) then break;
      Inc(count);
    end;
  end;

begin
  ClrScr;
  Inc(rct);
  ProgHeader;
  InputData;
  TextColor(Yellow);
  Write('Anzahl Wolken: ');
  TextColor(LightGray);
  WriteLn(count);
  InitClouds;
  ClrScr;
  TextColor(Yellow);
  WriteLn('-=˛ Simulation ˛=-');
  WriteMatrix(1,3);
  maxtakes := Trunc((QX-MatrixX)/3);
  if Trunc((QY-MatrixY)/2)>maxtakes then maxtakes := Trunc((QY-MatrixY)/2);
  maxtakes := maxtakes+1;
  for l:=1 to maxtakes do begin
    SimClouds;
    Delay(simdel);
    WriteMatrix(1,3);
    CheckForRain;
  end;

  for i:=1 to rct-1 do begin
    GotoXY(1,i);
    TextColor(White);
    GotoXY(QX-MatrixX+5,2+i);
    WriteLn(i,'. Regen bei ',Rain[i].y,'|',Rain[i].x,'  - Wolken: ',Rain[i].w1,' + ',Rain[i].w2);
  end;
  GotoXY(5,24);
  TextColor(Yellow);
  WriteLn('Bitte eine Taste drÅcken...');
  ReadKey;
end.