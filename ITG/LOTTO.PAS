program Lotto_Ziehung;

uses Crt, CursorOnOff, Dos;

const prog:char='/';
      freq=30;
      pfreq=10;

var lotto: array[1..49] of longint;
    fulr: array[1..freq] of real;
    fuls: byte;
    pers: byte;
    full: real;
    isec: longint;
    h,m,s,ss: word;

procedure StartClock;
begin
  GetTime(h,m,s,ss);
  isec := h*3600+m*60+s;
end;

function RunSec: longint;
var nh,nm,ns,nss: word;
    nsec: longint;
begin
  GetTime(nh,nm,ns,nss);
  nsec := nh*3600+nm*60+ns;
  RunSec := nsec-isec;
end;

procedure Progress(how,much: real);
var wx,wy: word;
    secs,tfull,rest: real;
    i: byte;
    fsum: real;
begin
  secs := RunSec;
  if (fuls<freq) then begin
    tfull := secs / (how/much);
    Inc(fuls);
    fulr[fuls] := tfull;
    if (full<>0) then rest := full - secs else rest := 0;
  end else begin
    fsum := 0;
    for i:=1 to freq do fsum := fsum + fulr[i];
    full := fsum / freq;
    rest := full - secs;
    fuls := 0;
  end;
  if (pers>pfreq) then begin
    Write(prog,' [',(how/much)*100:6:2,'%] (',secs:4:0,'/',full:4:0,'  ',rest:4:0,' left)');
    pers := 0;
  end else begin
    Write(prog);
    GotoXY(WhereX+11,WhereY);
    Write('(',secs:4:0);
  end;
  Inc(pers);
  GotoXY(14,WhereY);
  case prog of
    '/': prog:= '-';
    '-': prog:= '\';
    '\': prog:= '|';
    '|': prog:= '/';
  end;
end;


procedure init;
var i:byte;
begin
  { clrscr; }
  fuls := 0;
  full := 0;
  pers := 0;
  writeLn;
  Randomize;
{  RandSeed := 123; }
  for i:=1 to 49 do Lotto[i]:=0;
end;

procedure Ziehung;
var i,n: longint;
begin
  write('Wieviel Ziehungen? '); ReadLn(n);
  StartClock;
  CursorOff;
  write('Berechne ... ');
  for i:=1 to n do begin
    if i MOD 100000=0 then Progress(i,n);
    inc(Lotto[Random(49)+1]);
  end;
  GotoXY(wherex-1,wherey); WriteLn(' fertig!                           ');
  CursorOn;
end;

procedure Auswertung;
var z,i,max: byte;
begin
  WriteLn('Die 6 h„ufigsten Ziehungen:');
  for z:=1 to 6 do begin
    max:=1;
    for i:=2 to 49 do if Lotto[i]>Lotto[max] then max:=i;
    WriteLn(z:1,': ',max:2,' [',Lotto[max],']');
    Lotto[max]:=0;
  end;
end;

begin
  init;
  Ziehung;
  auswertung;
end.
