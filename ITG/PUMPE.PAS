program Pumpensteuerung;

uses Crt;

const Full='ÛÛÛÛÛÛÛÛÛ';
      Half='ÜÜÜÜÜÜÜÜÜ';
      Empt='         ';
      timemult: integer=10;
      B1E: boolean=true;
      B2E: boolean=true;
      B1D: integer=4;
      B2D: integer=4;
      B1: real=2950;
      B2: real=2750;

var Y1,Y2,Y3,A,B,C,D: boolean;
    x: char;

{ 1 Beh„lter = 5700 l = in 2 Minuten voll }

procedure Init;
begin
  ClrScr;
  TextColor(7);
  GotoXY(20,18); Write('1 - B1',#127,' an/aus');
  GotoXY(20,19); Write('Q - B1',#127,'max +600');
  GotoXY(20,20); Write('A - B1',#127,'max -600');
  GotoXY(50,18); Write('2 - B2',#127,' an/aus');
  GotoXY(50,19); Write('W - B2',#127,'max +600');
  GotoXY(50,20); Write('S - B2',#127,'max -600');
  GotoXY(35,22); Write('^ - Ventil umschalten');
  GotoXY(35,23); Write('E - Zeitraffer +1');
  GotoXY(35,24); Write('D - Zeitraffer -1');
  GotoXY(33,25); Write('ESC - Simulation beenden');
  Randomize;
  Y1 := false;
  Y2 := false;
  Y3 := false;
end;

procedure SetLEDs;
var a: byte absolute 0:1047;
begin
  a := 0;
  if Y1 then Inc(a,32);
  if Y2 then Inc(a,64);
  if Y3 then Inc(a,16);
end;

procedure ResetLEDs;
var a: byte absolute 0:1047;
begin
  a := 32;
end;

procedure DrawPumpe;
var i: integer;
begin
  GotoXY(1,1); if Y1 then TextColor(14) else TextColor(8); Write('Y1 (NUM)');
  GotoXY(1,2); if Y2 then TextColor(14) else TextColor(8); Write('Y2 (CAPS)');
  GotoXY(1,3); if Y3 then TextColor(14) else TextColor(8); Write('Y3 (SCROLL)');
  GotoXY(1,5); if (B1E) then TextColor(15) else TextColor(8);
    Write('B1',#127,'max: ',B1D*600:5,' l/min');
  GotoXY(1,6); if (B2E) then TextColor(15) else TextColor(8);
    Write('B2',#127,'max: ',B2D*600:5,' l/min');
  TextColor(15);
  GotoXY(1,8); Write('Zeitraffung: ',timemult:2,'x');

  if (Y1) OR (Y2) then TextColor(11) else TextColor(7);
  GotoXY(40, 5); Write('ÚÄÄÄÄÄÄÄ');
  if (Y1) OR (Y2) then TextColor(10+blink); Write('(P)');
  TextColor(15);
  if NOT (Y1) AND NOT (Y2) then Write(' [0 l/min]     ');
  if NOT (Y1) AND (Y2) then Write(' [750 l/min]   ');
  if (Y1) AND NOT (Y2) then Write(' [1450 l/min]  ');
  if (Y1) AND (Y2) then Write(' [2850 l/min]  ');
  if (Y1) OR (Y2) then TextColor(11) else TextColor(7);
  GotoXY(40, 6); Write('³');
  GotoXY(39,7); if Y3 then Write(' ÀÄ') else Write('ÄÙ ');

  GotoXY(25,7);
  if NOT (Y3) AND ((Y2) OR (Y1)) then TextColor(11) else TextColor(7);
  Write('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ');
  GotoXY(42,7);
  if (Y3) AND ((Y2) OR (Y1)) then TextColor(11) else TextColor(7);
  Write('ÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');

  for i:=1 to 7 do begin
    if (B1E) then TextColor(15) else TextColor(8);
    GotoXY(20,7+i); Write('³');
    if (B1>=950*(8-i)) then Write(Full)
      else if (B1>=950*(8-i)-475) then Write(Half)
      else Write(Empt);
    Write('³');
    if (B2E) then TextColor(15) else TextColor(8);
    GotoXY(50,7+i); Write('³');
    if (B2>=950*(8-i)) then Write(Full)
      else if (B2>=950*(8-i)-475) then Write(Half)
      else Write(Empt);
    Write('³');
  end;

  if (B1E) then TextColor(15) else TextColor(8);
  GotoXY(19,15); Write('ÚÁÄ[',B1:4:0,'l]ÄÙ');
  GotoXY(19,16); Write('³');
  if (B2E) then TextColor(15) else TextColor(8);
  GotoXY(50,15); Write('ÀÄ[',B2:4:0,'l]ÄÁ¿');
  GotoXY(61,16); Write('³');

  GotoXY(31,9); if (A) then TextColor(14) else TextColor(8); Write('ß A');
  GotoXY(31,12); if (C) then TextColor(14) else TextColor(8); Write('ß C');
  GotoXY(47,9); if (B) then TextColor(14) else TextColor(8); Write('B ß');
  GotoXY(47,12); if (D) then TextColor(14) else TextColor(8); Write('D ß');
end;

procedure CalcSensors;
begin
  if (B1>=5700) then A := true else A := false;
  if (B1>=2850) then C := true else C := false;
  if (B2>=5700) then B := true else B := false;
  if (B2>=2850) then D := true else D := false;
end;

procedure CalcSteering;
begin
  if (A) AND (B) AND (C) AND (D) then begin
    Y1 := false;
    Y2 := false;
  end;
  if NOT (A) AND NOT (B) AND NOT (C) AND NOT (D) then begin
    Y1 := true;
    Y2 := true;
  end;
  if ((A) AND NOT (B)) OR (NOT (A) AND (B)) AND (C) AND (D) then begin
    Y1 := false;
    Y2 := true;
  end;
  if (NOT (A) AND NOT (B) AND (C) AND (D))
      OR ((A) AND NOT (B) AND (C) AND NOT (D))
      OR (NOT (A) AND (B) AND NOT (C) AND (D)) then begin
    Y1 := true;
    Y2 := false;
  end;

  if (A) AND NOT (B) then Y3 := true;
  if (B) AND NOT (A) then Y3 := false;
  if (C) AND NOT (D) then Y3 := true;
  if (D) AND NOT (C) then Y3 := false;
end;

procedure NimmWas;
var x: integer;
begin
  if (B1E) then begin
    x := Round(Random(B1D*2)/2)*timemult;
    if (B1-x<0) then B1 := 0 else B1 := B1 - x;
  end;
  if (B2E) then begin
    x := Round(Random(B2D*2)/2)*timemult;
    if (B2-x<0) then B2 := 0 else B2 := B2 - x;
  end;
end;

procedure Pump;
var sp: real;
begin
  if NOT (Y1) AND NOT (Y2) then sp := 0;
  if NOT (Y1) AND (Y2) then sp :=  750 / (600/timemult);
  if (Y1) AND NOT (Y2) then sp := 1450 / (600/timemult);
  if (Y1) AND (Y2) then sp := 2850 / (600/timemult);

  if (Y3) then B2 := B2 + sp else B1 := B1 + sp;
end;

begin
  Init;
  repeat
    CalcSensors;
    CalcSteering;
    SetLEDs;
    NimmWas;
    DrawPumpe;
    Pump;
    Delay(100);
    if (keypressed) then x := ReadKey else x := #000;
    if (x<>#000) then begin
      case x of
        '1','!': if (B1E) then B1E := false else B1E := true;
        '2','"': if (B2E) then B2E := false else B2E := true;
        'q','Q': if B1D<20 then Inc(B1D);
        'a','A': if B1D>0 then Dec(B1D);
        'w','W': if B2D<20 then Inc(B2D);
        's','S': if B2D>0 then Dec(B2D);
        '^','ø': if (Y3) then Y3 := false else Y3 := true;
        'e','E': if timemult<50 then Inc(timemult);
        'd','D': if timemult>1 then Dec(timemult);
      end;
    end;
  until x=#027;
  ResetLEDs;
end.
