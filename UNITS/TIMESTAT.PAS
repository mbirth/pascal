unit TimeStatus;   { Unit TimeStatus - by RoboCop of nOOb }

interface
  var TC_ST: longint;

  procedure InitTimer;
  function TimeGone: longint;
  function PerMin(what: longint): real;
  function PerSec(what: longint): real;
  function PerMS(what: longint): real;

implementation

  uses Dos;

  procedure InitTimer;
  var h,m,s,hu: word;
      i,n,t,iv: longint;
  begin
    GetTime(h,m,s,hu);
    i:=h; n:=m; t:=s; iv:=hu;
    TC_ST := i*360000 + n*6000 + t*100 + iv;
  end;

  function TimeGone: longint;
  var h,m,s,hu: word;
      i,n,t,iv: longint;
  begin
    GetTime(h,m,s,hu);
    i:=h; n:=m; t:=s; iv:=hu;
    TimeGone := ( i*360000 + n*6000 + t*100 + iv ) - TC_ST;
  end;

  function PerMin(what: longint): real;
  var TG: longint;
  begin
    TG := TimeGone;
    if TG<>0 then PerMin := what / ( TimeGone / 6000 ) else PerMin := 0;
  end;

  function PerSec(what: longint): real;
  var TG: longint;
  begin
    TG := TimeGone;
    if TG<>0 then PerSec := what / ( TimeGone / 100 ) else PerSec := 0;
  end;

  function PerMS(what: longint): real;
  var TG: longint;
  begin
    TG := TimeGone;
    if TG<>0 then PerMS := what / TimeGone else PerMS := 0;
  end;

  begin
    WriteLn('þ Loading Unit: TimeStatus - RoboCop of nOOb <Robo.Cop@gmx.net>');
  end.