unit TimeCalc;

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
    TC_ST := ( i*3600 + n*60 + t )*100 + iv;
  end;

  function TimeGone: longint;
  var h,m,s,hu: word;
      i,n,t,iv: longint;
  begin
    GetTime(h,m,s,hu);
    i:=h; n:=m; t:=s; iv:=hu;
    TimeGone := ((i*3600 + n*60 + t)*100 + iv) - TC_ST;
  end;

  function PerMin(what: longint): real;
  begin
    PerMin := what / ( TimeGone / 6000 );
  end;

  function PerSec(what: longint): real;
  begin
    PerSec := what / ( TimeGone / 100 );
  end;

  function PerMS(what: longint): real;
  begin
    PerMS := what / TimeGone;
  end;

  begin
    WriteLn('þ Loading Unit: TimeCalc - RoboCop of nOOb <Robo.Cop@gmx.net>');
  end.