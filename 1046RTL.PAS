program RTL;

uses Crt, VFx;

var d: array[0..9999] of boolean;
var cd,cn: integer;

function Form(i: integer): string;
var t: string;
begin
  Str(i,t);
  while (Length(t)<4) do t := '0'+t;
  Form := t;
end;

procedure SetDone;
var f: text;
    x: string;
    t,ec: integer;
    msg: string;
begin
  for t:=0 to 9999 do d[t] := false;
  assign(f,'1046rtl.txt');
  reset(f);
  ReadLn(f,x);
  WriteLn(x);
  msg := '';
  while Not Eof(f) do begin
    ReadLn(f,x);
    Val(x,t,ec);
    if NOT d[t] then d[t] := true else msg := msg + Form(t)+' doppelt getippt!'+crlf;
  end;
  close(f);
  Alert(msg);
  WriteLn('Datenbank mit Tipps geladen und verarbeitet.');
end;

procedure DoStats;
var i: integer;
begin
  cd := 0;
  cn := 0;
  for i:=0 to 9999 do begin
    if d[i] then Inc(cd) else Inc(cn);
  end;
end;

procedure ShowStats;
var mon: real;
begin
  mon := cd;
  mon := mon*500;
  WriteLn('Getippt: ',cd:5,' = ',cd/100:6:2,'% = ',mon:10:2,' DM in ',cd DIV 10:3,' Tagen bei 5.000,- DM pro Tag');
  mon := cn;
  mon := mon*500;
  WriteLn('šbrig  : ',cn:5,' = ',cn/100:6:2,'% = ',mon:10:2,' DM in ',cn DIV 10:3,' Tagen');
  WriteLn('Gesamt : ',cd+cn:5);
end;

procedure ShowNotDone;
var i: integer;
begin
  for i:=0 to 9999 do begin
    if not d[i] then Write(Form(i),' ');
  end;
end;

function Ten(i,e: integer): longint;
var x: integer;
    t: longint;
begin
  if (e>0) then begin
    for x:=1 to e do i := i * 10;
  end;
  Ten := i;
end;

procedure WriteNum(x: integer);
begin
  GotoXY(16,12);
  Write(x DIV 1000);
  GotoXY(18,12);
  Write((x MOD 1000) DIV 100);
  GotoXY(20,12);
  Write((x MOD 100) DIV 10);
  GotoXY(22,12);
  Write(x MOD 10);
end;

procedure WriteNumFX(x: integer);
begin
  GotoXY(16,12);
  FXWriteC(Num2Str(x DIV 1000)+' '+Num2Str((x MOD 1000) DIV 100)+' '+Num2Str((x MOD 100) DIV 10)+' '+Num2Str(x MOD 10),15);
end;

procedure GetRandomNumber;
var i,x: integer;
begin
  i := 0;
  Randomize;
  repeat
    repeat
      x := Random(10000);
    until NOT d[x];
    WriteNum(x);
    Sound(1950);
    Delay(25);
    NoSound;
    Delay(i);
    i := i + 1 + (i DIV 5);
  until (i>=750);
  WriteNumFX(x);
  CursorOff;
end;

procedure DoAsking;
var k: char;
    kc: byte;
    c: byte;
    co: integer;
    i: integer;
begin
  DrawBorder2(20,5,60,20,11,1);
  Window(21,6,59,19);
  GotoXY(1,2);
  FXWriteC('* * * 104.6 RTL * * *',14); WriteLn;
  FXWriteC('* EURO - MILLIONAER *',15); WriteLn;
  FXWriteC('* * * * * * * * * * *',14); WriteLn;
  TextColor(11);
  WriteLn;
  WriteFlt('   Knacken Sie den vierstelligen');
  WriteFlt('    Zahlencode und gewinnen Sie  ');
  WriteLn;
  TextColor(12);
  WriteImp('         EINE MILLION EURO');
  TextColor(11);
  GotoXY(1,14); FXWriteC('Beenden mit ESC',7);
  GotoXY(1,12); FXWriteC('_ _ _ _',7);
  CursorOff;
  WaitBeep;
  c := 0;
  co := 0;
  repeat
    k := ReadKey;
    if k<>#27 then begin
      if k IN [#48..#57] then begin
        if (c=0) then begin
          GotoXY(18,12); TextColor(7); Write('_ _ _');
        end;
        GotoXY(16+2*c,12); FXChar(k,15); CursorOff;
        Inc(c);
        kc := Ord(k)-48;
        co := co + Ten(kc,4-c);
        AckBeep;
      end;
      if (k=#8) AND (c>0) then begin
        Dec(c);
        GotoXY(16+2*c,12); FXChar('_',7); CursorOff;
        co := (co DIV Ten(1,4-c)) * Ten(1,4-c);
        ErrorBeep;
      end;
      if (k='r') OR (k='R') then begin
        TextColor(8);
        GotoXY(10,13);
        Write(Space(20));
        GetRandomNumber;
        WaitBeep;
      end;
    end;
    if (c=4) then begin
      GotoXY(10,13);
      if d[co] then begin
        TextColor(12);
        ErrorBeep;
        WriteFlt('*** CODE FALSCH ***');
      end else begin
        TextColor(10);
        ReadyBeep;
        WriteFlt('*** PRUEFE CODE ***');
      end;
      co := 0;
      c := 0;
      CursorOff;
    end;
  until k=#27;
  Window(1,1,80,25);
  CursorOn;
end;

begin
  SaveScreen;
  TextMode(co80);
  TextColor(7);
  TextBackground(0);
  ClrScr;
  SetDone;
  DoStats;
 { ShowNotDone; }
  ShowStats;
  DoAsking;
  RestoreScreen;
end.
