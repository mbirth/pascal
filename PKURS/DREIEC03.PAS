program Dreieck;          { Programmname }

uses Crt;                 { Crt ist fÅr Textausgabe und anderes Zeugs }

type Punkt=record         { Der 1. Record fÅr die einzelnen Punkte }
       x,y: real;           { Record enthÑlt x und y }
     end;
     Mittelp=record       { 2. Record fÅr Mittelpunkte }
       x,y: real;           { und nochmal x und y }
     end;

var P: array[0..2] of Punkt;   { Arrays fÅr die Records }
    M: array[0..2] of Mittelp;
    Flaeche, LAB, LBC, LCA, SAB, SBC, SCA: real; { misc. Vars }
    i: integer;           { Das i fÅr FOR-Schleifen }
    MPS: string;          { Mittelpunktbeschreibung }


function Mittelpunkt(P1,P2: real): real;    { Berechnet das arithmetische Mittel aus 2 Zahlen }
begin
  Mittelpunkt := (P1+P2)/2;
end;

function Laenge(X1,Y1,X2,Y2: real): real;   { Berechnet LÑnge 2er Koordinatenpaare }
begin
  Laenge := Sqrt(Sqr(X2-X1)+Sqr(Y2-Y1));
end;

function SHB(X,MX,Y,MY: real): real;        { Berechnet Seitenhalbierende aus 1 Punkt und 1 Mittelpunkt }
begin
  SHB := Sqrt(Sqr(X-MX)+Sqr(Y-MY));
end;

function A(X1,Y1,X2,Y2,X3,Y3: real): real;  { Berechnet FlÑche eines 3ecks beschrieben durch 3 KO-Paare }
begin
  A := 0.5*Abs((Y1*(X3-X2)+Y2*(X1-X3)+Y3*(X2-X1)));
end;

procedure GetPoint(rec: integer; ot: string); { Krallt sich die Eingaben }
  begin
    Write('Punkt '+ot+' (x): ');
    ReadLn(P[rec].x);
    Write('Punkt '+ot+' (y): ');
    ReadLn(P[rec].y);
  end;

begin
  ClrScr;  { Erstmal Platz schaffen }
  WriteLn('-=˛ Dreiecksberechnung ˛=-');
  WriteLn;
  GetPoint(0, 'A');  { Krall Dir x und y von Punkt A }
  GetPoint(1, 'B');  { und jetzt hol Dir B }
  GetPoint(2, 'C');  { und C, aber mehr kriegst Du nicht aus mir heraus }

  Flaeche := A(P[0].x,P[0].y,P[1].x,P[1].y,P[2].x,P[2].y);

  WriteLn('####### Jetzt beginnt die Ausgabe #######');
  Write('Die FlÑche des 3ecks ist ',Flaeche:5:3);

  if Flaeche = 0 then      { FlÑche = 0? Dann kein Dreieck! }
    WriteLn(' --- kein Dreieck! Punkte sind kollinear')
  else
    WriteLn;

  LAB := Laenge(P[0].x,P[0].y,P[1].x,P[1].y);
  LBC := Laenge(P[1].x,P[1].y,P[2].x,P[2].y);
  LCA := Laenge(P[2].x,P[2].y,P[0].x,P[0].y);
  WriteLn('LÑnge Strecke AB: ',LAB:4:2);
  WriteLn('LÑnge Strecke BC: ',LBC:4:2);
  WriteLn('LÑnge Strecke CA: ',LCA:4:2);

  for i:=0 to 1 do begin
    M[i].x := Mittelpunkt(P[i].x,P[i+1].x);
    M[i].y := Mittelpunkt(P[i].y,P[i+1].x);
  end;
  M[2].x := Mittelpunkt(P[2].x,P[0].x);
  M[2].y := Mittelpunkt(P[2].y,P[0].y);

  for i:=0 to 2 do begin
    if i=0 then MPS := 'AB';
    if i=1 then MPS := 'BC';
    if i=2 then MPS := 'CA';
    WriteLn('Mittelpunkt '+MPS+': ',M[i].x:3:1,'|',M[i].y:3:1);
  end;

  SAB := SHB(P[0].x,M[1].x,P[0].y,M[1].y);
  SBC := SHB(P[1].x,M[2].x,P[1].y,M[2].y);
  SCA := SHB(P[2].x,M[0].x,P[2].y,M[0].y);

  WriteLn('Seitenhalbierende AB: ',SAB:5:1);
  WriteLn('Seitenhalbierende BC: ',SBC:5:1);
  WriteLn('Seitenhalbierende CA: ',SCA:5:1);

  WriteLn;
  WriteLn('Bitte eine Taste drÅcken...');

  ReadKey;
end.