program Search;

uses Crt;

var Target,Max,LastTry,LBO,Try,Step,MaxSteps,MaxSTarget: longint;
    oldx,oldy: integer;
    oldestx,oldesty: integer;
    Steps:array[1..31] of longint;
    Time: integer;

procedure CursorOff;assembler;
asm
   xor  ax,ax
   mov  ah,01h
   mov  ch,20h
   mov  cl,20h
   int  10h
end;

procedure CursorOn;assembler;
asm
   mov  ah,01h
   mov  cx,0607h
   int  10h
end;

procedure AskForData;
begin
  WriteLn('úùþð Search-Prog þðùú');
  WriteLn;
  Write('Geben Sie den Zahlenbereich an (0 fr 2147483647): 0-');
  ReadLn(Max);
  if Max=0 then begin
    Max:=2147483647;
    GotoXY(54,3);
    Write(Max);
    GotoXY(1,4);
  end;
  Write('Geben Sie die Zahl ein, die ich suchen soll: ');
  ReadLn(Target);
  WriteLn;
  WriteLn('Dateneingabe komplett.');
  Delay(500);
  ClrScr;
end;

procedure GetRandomData;
begin
  Max:=2147483647;
  Target:=Round(Random*1E3+Random*1E6+Random*1E9);
end;

procedure GetAll;
begin
  Max:=2147483637;
  Inc(Target);
end;

function Half(v1,v2: longint):longint;
begin
  if v1>v2 then Half:=Round((v1-v2)/2);
  if v1<v2 then Half:=Round((v2-v1)/2);
  if v1=v2 then Half:=1;
end;

procedure MakeList;
var i:integer;
begin
  TextColor(7);
  for i:=1 to 24 do begin
    GotoXY(1,i);
    Write(i:3,' - ');
  end;
  for i:=25 to 31 do begin
    GotoXY(40,i-24);
    Write(i:3,' - ');
  end;
end;


procedure CalcPerc;
var i:integer;
    summe:longint;
    perc: real;
begin
  Summe:=0;
  TextColor(9);
  for i:=1 to 31 do begin
    Summe:=Summe+Steps[i];
  end;
  for i:=1 to 31 do begin
    perc:=(Steps[i]/Summe)*100;
    if i<25 then GotoXY(23,i) else GotoXY(63,i-24);
    if perc<10 then Write(' ');
    Write(perc:2:3,'% ');
    Write('(',Steps[i],') ');
  end;
end;

procedure Calculate;
var T:string;
    co,li: integer;
label TryAgain;
begin
  co:=7;
  li:=0;
  Try:=0;
  LastTry:=Max;
  TextColor(7);
  GotoXY(1,24);
TryAgain:
  Inc(Step);
  Inc(li);
  if li>24 then begin
    co:=co+40;
    li:=1;
  end;
  LBO:=LastTry;
  LastTry:=Try;
  if Try<Target then Try:=LastTry+Half(LastTry,LBO) else Try:=LastTry-Half(LastTry,LBO);
  Str(Try:10,T);
  GotoXY(co,li);
  if Try<Target then Write(Try:10,' ',Chr(17),' 1');
  if Try>Target then Write(Try:10,' ',Chr(16),' 0');
  if Try=Target then begin
    if ((oldestx<>0) AND (oldesty<>0)) then begin
      GotoXY(oldestx,oldesty);
      TextColor(8);
      Write(Chr(16));
    end;
    oldestx:=oldx;
    oldesty:=oldy;
    if ((oldx<>0) AND (oldy<>0)) then begin
      GotoXY(oldx,oldy);
      TextColor(4);
      Write(Chr(16));
    end;
    oldx:=co-1;
    oldy:=li;
    GotoXY(co-1,li);
    TextColor(12);
    Write(Chr(16),Try:10,' ',Chr(29),' ');
    Inc(Steps[step]);
  end;
  if Try<>Target then goto TryAgain;
  { Delay(2000); }
  Inc(Time);
  if Time>1000 then begin
    Time := 0;
    CalcPerc;
  end;
  { CursorOn; }
end;

begin
  Time := 0;
  TextBackground(0);
  CursorOff;
  ClrScr;
  Randomize;
  { AskForData; }
  MakeList;
  while not keypressed do begin
    Step:=0;
    GetRandomData;
    { GetAll; }
    Calculate;
    if Step>MaxSteps then begin
      MaxSteps:=Step;
      MaxSTarget:=Target;
    end;
  end;
  ReadKey;
end.