program DateCalc;

{ Tage zw. 2 Daten ausrechnen }

const Tage:array[1..12] of byte=(31,0,31,30,31,30,31,31,30,31,30,31);

var d1,m1,y1,d2,m2,y2: word;
    dbw: integer;

procedure GetDate(op: string;var d,m,y: word);
var dat: string[10];
    i,oldp: integer;
    co: integer;
begin
  Write(op,'. Datum eingeben [tt.mm.yyyy]: ');
  ReadLn(dat);
  oldp := 0;
  for i := 1 to Length(dat) do begin
    if dat[i]='.' then begin
      if oldp=0 then Val(Copy(dat,oldp+1,i-oldp-1),d,co);
      if oldp<>0 then Val(Copy(dat,oldp+1,i-oldp-1),m,co);
      oldp := i;
    end;
  end;
  Val(Copy(dat,oldp+1,Length(dat)-oldp),y,co);
end;

procedure ValCheck(d1,m1,y1,d2,m2,y2: word);
var err: boolean;
begin
  err := false;
  if (m1=m2) AND (y1=y2) AND (d1>d2) then err := true;
  if (y1=y2) AND (m1>m2) then err := true;
  if (y1>y2) then err := true;
  if (m1>13) OR (m2>13) OR (m1<1) OR (m2<1) then err := true;
  if (d1>31) OR (d2>31) OR (d1<1) OR (d2<1) then err := true;
  if err=true then begin
    WriteLn;
    WriteLn('Fehler im Datum. Datum 1 ist „lter als Datum 2 oder falsche Zahlen!');
    Halt;
  end;
end;

procedure CalcDays(d1,m1,y1,d2,m2,y2: word; var days: integer);
var i: integer;
begin
  if (m1=m2) AND (y1=y2) then begin
    days := days + (d2-d1);
    Exit;
  end;
  days := 0;
  if m1<>2 then days := days + (Tage[m1]-d1) else begin
    if y1/4=y1 DIV 4 then days := days + (29-d1) else days := days + (28-d1);
  end;
  if (y1=y2) AND (m2-1>=m1+1) then begin
    for i:=m1+1 to m2-1 do begin
      if i<>2 then days := days + Tage[i] else begin
        if y1/4=y1 DIV 4 then days := days + 29 else days := days + 28;
      end;
    end;
  end;
  days := days + d2;
end;

begin
  WriteLn('-=+ DateCalc +=- auf Wunsch von Anke');
  WriteLn;
  GetDate('1',d1,m1,y1);
  GetDate('2',d2,m2,y2);
  WriteLn('Datum 1: ',d1,'.',m1,'.',y1);
  WriteLn('Datum 2: ',d2,'.',m2,'.',y2);
  ValCheck(d1,m1,y1,d2,m2,y2);
  CalcDays(d1,m1,y1,d2,m2,y2,dbw);
  WriteLn('Tage: ',dbw);
end.
