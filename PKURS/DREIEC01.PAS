program Dreieck;

uses Crt;
var X1,X2,X3,Y1,Y2,Y3: real;
    Flaeche, LAB, LBC, LCA, SAB, SBC, SCA, MABx, MABy, MBCx, MBCy, MCAx, MCAy: real;

function Mittelpunkt(P1,P2: real): real;
begin
  Mittelpunkt := (P1+P2)/2;
end;

function Laenge(X1,X2,Y1,Y2: real): real;
begin
  Laenge := Sqrt(Sqr(X2-X1)+Sqr(Y2-Y1));
end;


function SHB(X,MX,Y,MY: real): real;
begin
  SHB := Sqrt(Sqr(X-MX)+Sqr(Y-MY));
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

  Flaeche := 0.5*Abs((Y1*(X3-X2)+Y2*(X1-X3)+Y3*(X2-X1)));

  WriteLn('####### Jetzt beginnt die Ausgabe #######');
  Write('Die FlÑche des 3ecks ist ',Flaeche:5:3);

  if Flaeche = 0 then WriteLn(' --- kein Dreieck! Punkte sind kollinear') else WriteLn;

  LAB := Sqrt(Sqr(X2-X1)+Sqr(Y2-Y1));
  LBC := Sqrt(Sqr(X3-X2)+Sqr(Y3-Y2));
  LCA := Sqrt(Sqr(X1-X3)+Sqr(Y1-Y3));
  WriteLn('LÑnge Strecke AB: ',LAB:4:2);
  WriteLn('LÑnge Strecke BC: ',LBC:4:2);
  WriteLn('LÑnge Strecke CA: ',LCA:4:2);

  MABx := (X1+X2)/2;
  MABy := (Y1+Y2)/2;
  MBCx := (X2+X3)/2;
  MBCy := (Y2+Y3)/2;
  MCAx := (X3+X1)/2;
  MCAy := (Y3+Y1)/2;
  WriteLn('Mittelpunkt AB: ',MABx:3:1,'|',MABy:3:1);
  WriteLn('Mittelpunkt BC: ',MBCx:3:1,'|',MBCy:3:1);
  WriteLn('Mittelpunkt CA: ',MCAx:3:1,'|',MCAy:3:1);

  SAB := Sqrt(Sqr(X1-MBCx)+Sqr(Y1-MBCy));
  SBC := Sqrt(Sqr(X2-MCAx)+Sqr(Y2-MCAy));
  SCA := Sqrt(Sqr(X3-MABx)+Sqr(Y3-MABy));
  WriteLn('Seitenhalbierende AB: ',SAB:5:1);
  WriteLn('Seitenhalbierende BC: ',SBC:5:1);
  WriteLn('Seitenhalbierende CA: ',SCA:5:1);

  WriteLn;
  WriteLn('Bitte eine Taste drÅcken...');

  repeat until Keypressed;
end.