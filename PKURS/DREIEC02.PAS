program Dreieck;

uses Crt;
var X1,X2,X3,Y1,Y2,Y3: real;
    Flaeche, LAB, LBC, LCA, SAB, SBC, SCA, MABx, MABy, MBCx, MBCy, MCAx, MCAy: real;


function Mittelpunkt(P1,P2: real): real;
begin
  Mittelpunkt := (P1+P2)/2;
end;

function Laenge(X1,Y1,X2,Y2: real): real;
begin
  Laenge := Sqrt(Sqr(X2-X1)+Sqr(Y2-Y1));
end;

function SHB(X,MX,Y,MY: real): real;
begin
  SHB := Sqrt(Sqr(X-MX)+Sqr(Y-MY));
end;

function A(X1,Y1,X2,Y2,X3,Y3: real): real;
begin
  A := 0.5*Abs((Y1*(X3-X2)+Y2*(X1-X3)+Y3*(X2-X1)));
end;

begin
  WriteLn('-=˛ Dreiecksberechnung ˛=-');
  WriteLn;
  Write('Punkt A (x): '); ReadLn(X1);
  Write('Punkt A (y): '); ReadLn(Y1);
  Write('Punkt B (x): '); ReadLn(X2);
  Write('Punkt B (y): '); ReadLn(Y2);
  Write('Punkt C (x): '); ReadLn(X3);
  Write('Punkt C (y): '); ReadLn(Y3);

  Flaeche := A(X1,Y1,X2,Y2,X3,Y3);

  WriteLn('####### Jetzt beginnt die Ausgabe #######');
  Write('Die FlÑche des 3ecks ist ',Flaeche:5:3);

  if Flaeche = 0 then WriteLn(' --- kein Dreieck! Punkte sind kollinear') else WriteLn;

  LAB := Laenge(X1,Y1,X2,Y2);
  LBC := Laenge(X2,Y2,X3,Y3);
  LCA := Laenge(X3,Y3,X1,Y1);
  WriteLn('LÑnge Strecke AB: ',LAB:4:2);
  WriteLn('LÑnge Strecke BC: ',LBC:4:2);
  WriteLn('LÑnge Strecke CA: ',LCA:4:2);

  MABx := Mittelpunkt(X1,X2);
  MABy := Mittelpunkt(Y1,Y2);
  MBCx := Mittelpunkt(X2,X3);
  MBCy := Mittelpunkt(Y2,Y3);
  MCAx := Mittelpunkt(X3,X1);
  MCAy := Mittelpunkt(Y3,Y1);
  WriteLn('Mittelpunkt AB: ',MABx:3:1,'|',MABy:3:1);
  WriteLn('Mittelpunkt BC: ',MBCx:3:1,'|',MBCy:3:1);
  WriteLn('Mittelpunkt CA: ',MCAx:3:1,'|',MCAy:3:1);

  SAB := SHB(X1,MBCx,Y1,MBCy);
  SBC := SHB(X2,MCAx,Y2,MCAy);
  SCA := SHB(X3,MABx,Y3,MABy);
  WriteLn('Seitenhalbierende AB: ',SAB:5:1);
  WriteLn('Seitenhalbierende BC: ',SBC:5:1);
  WriteLn('Seitenhalbierende CA: ',SCA:5:1);

  WriteLn;
  WriteLn('Bitte eine Taste drÅcken...');

  repeat until Keypressed;
end.