program Nennen_wir_es_Dreiecksberechnung;            {Autor: RoboCop IND.}
uses Crt,Logo;
var AX,AY,BX,BY,CX,CY,LAB,LBC,LCA,F,MABX,MABY,MBCX,MBCY,MCAX,MCAY,SA,SB,SC: real;

function Mittelpunkt(P1,P2:real):real;
begin
  Mittelpunkt := (P1+P2)/2;
end;

function Laenge(P1X,P1Y,P2X,P2Y:real):real;
begin
  Laenge := Sqrt(Sqr(P2X-P1X)+Sqr(P2Y-P1Y));
end;

function Flaeche(P1X,P1Y,P2X,P2Y,P3X,P3Y:real):real;
begin
  Flaeche := 0.5*Abs(P1Y*(P3X-P2X)+P2Y*(P1X-P3X)+P3Y*(P2X-P1X));
end;

begin;
  ClrScr;
  TextColor(15);
  WriteLn('-=˛ DREIECKSBERECHNUNG ˛=-');
  WriteLn;
  WriteLn('2nd program by');
  WriteLogo;
  TextColor(7);
  Write('Punkt A - X:');
  ReadLn(AX);
  Write('Punkt A - Y:');
  ReadLn(AY);
  Write('Punkt B - X:');
  ReadLn(BX);
  Write('Punkt B - Y:');
  ReadLn(BY);
  Write('Punkt C - X:');
  ReadLn(CX);
  Write('Punkt C - Y:');
  ReadLn(CY);
    MABX := Mittelpunkt(AX,BX);
    MABY := Mittelpunkt(AY,BY);
    MBCX := Mittelpunkt(BX,CX);
    MBCY := Mittelpunkt(BY,CY);
    MCAX := Mittelpunkt(CX,AX);
    MCAY := Mittelpunkt(CY,AY);
  WriteLn('M-AB: ',MABX:2:2,'|',MABY:2:2);
  WriteLn('M-BC: ',MBCX:2:2,'|',MBCY:2:2);
  WriteLn('M-CA: ',MCAX:2:2,'|',MCAY:2:2);
    LAB := Laenge(AX,AY,BX,BY);
    LBC := Laenge(BX,BY,CX,CY);
    LCA := Laenge(CX,CY,AX,AY);
  WriteLn('LÑnge AB: ',LAB:5:2,' LE');
  WriteLn('LÑnge BC: ',LBC:5:2,' LE');
  WriteLn('LÑnge CA: ',LCA:5:2,' LE');
    F := Flaeche(AX,AY,BX,BY,CX,CY);
  Write('FlÑche: ',F:5:2,' FE');
  IF F=0 THEN WriteLn(' === Die Punkte sind kollinear. DAS IST KEIN 3ECK!!') ELSE WriteLn;
    SA := Laenge(MBCX,MBCY,AX,AY);
    SB := Laenge(MCAX,MCAY,BX,BY);
    SC := Laenge(MABX,MABY,CX,CY);
  WriteLn('Seitenhalbierende A-MBC: ',SA:5:2,' LE');
  WriteLn('Seitenhalbierende B-MCA: ',SB:5:2,' LE');
  WriteLn('Seitenhalbierende C-MAB: ',SC:5:2,' LE');
  WriteLn;
  WriteLn('Bitte Taste drÅcken...');
  ReadKey;
  WriteLn('=== FERTIG! ===');
end.