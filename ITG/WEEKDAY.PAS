program DayOfYear;

uses Crt;

var d,m,y,h,Rest,WD: integer;

procedure GetDate;
begin
  Write('Tag            : '); ReadLn(d);
  Write('Monat          : '); ReadLn(m);
  Write('Jahr (4stellig): '); ReadLn(y);
end;

procedure CalcWD;
begin
  if (m=1) OR (m=2) then begin
    Inc(m,12);
    Dec(y);
  end;
  h    := y DIV 100;
  Rest := y MOD 100;
  WriteLn('h',h,' Rest',Rest);
  WD   := (d+(m+1)*26 DIV 10+5*Rest DIV 4+h DIV 4-2*h-1) MOD 7;
end;

procedure OutWD1;
begin
  Write('OutWD1: Das war ein ');
  case WD of
    0: Write('Sonntag');
    1: Write('Montag');
    2: Write('Dienstag');
    3: Write('Mittwoch');
    4: Write('Donnerstag');
    5: Write('Freitag');
    6: Write('Samstag');
  end;
  WriteLn('. [',WD,']');
end;

procedure OutWD2;
const Days:array[0..6] of string=('Sonntag','Montag','Dienstag','Mittwoch',
                                  'Donnerstag','Freitag','Samstag');
begin
  Write('OutWD2: Das war ein ',Days[WD],'. [',WD,']');
end;

begin
  ClrScr;
  WriteLn('Problemzonen: 19.5.2000');
  GetDate;
  CalcWD;
  OutWD1;
  OutWD2;
end.
