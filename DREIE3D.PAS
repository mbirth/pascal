program Dreiecksberechnung_3D;            {Autor: RoboCop of nOOb}



{ Die Volumenberechnung ist nicht komplett!!! }



uses Crt,Logo;
var AX,AY,AZ,BX,BY,BZ,CX,CY,CZ,LAB,LBC,LCA,V,MABX,MABY,MABZ,MBCX,MBCY,MBCZ,MCAX,MCAY,MCAZ,SA,SB,SC: real;

function Mittelpunkt(P1,P2:real):real;
begin
  Mittelpunkt := (P1+P2)/2;
end;

function Laenge(P1X,P1Y,P1Z,P2X,P2Y,P2Z:real):real;
begin
  Laenge := Sqrt(Sqr(P2X-P1X)+Sqr(P2Y-P1Y)+Sqr(P2Z-P1Z));
end;

function Volumen(P1X,P1Y,P1Z,P2X,P2Y,P2Z,P3X,P3Y,P3Z:real):real;
begin
  Volumen := 0.5*Abs(P1Y*(P3X-P2X)+P2Y*(P1X-P3X)+P3Y*(P2X-P1X));
end;

begin;
  ClrScr;
  TextColor(15);
  WriteLn('-=˛ 3D - DREIECKSBERECHNUNG ˛=-');
  WriteLn;
  WriteLn('Another program by');
  WriteLogo;
  TextColor(7);
  Write('Punkt A - X:');
  ReadLn(AX);
  Write('Punkt A - Y:');
  ReadLn(AY);
  Write('Punkt A - Z:');
  ReadLn(AZ);
  Write('Punkt B - X:');
  ReadLn(BX);
  Write('Punkt B - Y:');
  ReadLn(BY);
  Write('Punkt B - Z:');
  ReadLn(BZ);
  Write('Punkt C - X:');
  ReadLn(CX);
  Write('Punkt C - Y:');
  ReadLn(CY);
  Write('Punkt C - Z:');
  ReadLn(CZ);
    MABX := Mittelpunkt(AX,BX);
    MABY := Mittelpunkt(AY,BY);
    MABZ := Mittelpunkt(AZ,BZ);
    MBCX := Mittelpunkt(BX,CX);
    MBCY := Mittelpunkt(BY,CY);
    MBCZ := Mittelpunkt(BZ,CZ);
    MCAX := Mittelpunkt(CX,AX);
    MCAY := Mittelpunkt(CY,AY);
    MCAZ := Mittelpunkt(CZ,AZ);
  WriteLn('M-AB: ',MABX:0:2,'|',MABY:0:2,'|',MABZ:0:2);
  WriteLn('M-BC: ',MBCX:0:2,'|',MBCY:0:2,'|',MBCZ:0:2);
  WriteLn('M-CA: ',MCAX:0:2,'|',MCAY:0:2,'|',MCAZ:0:2);
    LAB := Laenge(AX,AY,AZ,BX,BY,BZ);
    LBC := Laenge(BX,BY,BZ,CX,CY,CZ);
    LCA := Laenge(CX,CY,CZ,AX,AY,AZ);
  WriteLn('LÑnge AB: ',LAB:5:2,' LE');
  WriteLn('LÑnge BC: ',LBC:5:2,' LE');
  WriteLn('LÑnge CA: ',LCA:5:2,' LE');
    V := Volumen(AX,AY,AZ,BX,BY,BZ,CX,CY,CZ);
  Write('Volumeninhalt: ',V:5:2,' VE');
  { IF F=0 THEN WriteLn(' === Die Punkte sind kollinear. DAS IST KEIN 3ECK!!') ELSE WriteLn; }
    SA := Laenge(MBCX,MBCY,MBCZ,AX,AY,AZ);
    SB := Laenge(MCAX,MCAY,MCAZ,BX,BY,BZ);
    SC := Laenge(MABX,MABY,MABZ,CX,CY,CZ);
  WriteLn('Seitenhalbierende A-MBC: ',SA:5:2,' LE');
  WriteLn('Seitenhalbierende B-MCA: ',SB:5:2,' LE');
  WriteLn('Seitenhalbierende C-MAB: ',SC:5:2,' LE');
  WriteLn;
  WriteLn('Bitte Taste drÅcken...');
  ReadKey;
  WriteLn('=== FERTIG! ===');
end.