program SingleChar;

uses Crt, TimeStatus, VFx;

var atall: longint;

procedure WriteSign;
begin
  { GotoXY(1,1); }
  Write('ù');
end;

procedure OutStat;
begin
  GotoXY(20,2);
  Write(PerSec(atall):6:3,' chars/s');
end;

begin
  CursorOff;
  ClrScr;
  atall := 0;
  InitTimer;
  repeat
    WriteSign;
    Inc(atall);
    if atall/1920=Int(atall/1920) then GotoXY(1,1);
  until keypressed;
  ReadKey;
  GotoXY(1,3);
  WriteLn(atall,' chars written in ',TimeGone,' milliseconds.');
  WriteLn(PerMS(atall):0:3,' chars/ms');
  WriteLn(PerSec(atall):0:3,' chars/sec');
  WriteLn(PerMin(atall):0:3,' chars/min');
  CursorOn;
end.
