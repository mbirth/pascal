program MemTest;

uses Crt;

var i: longint;

procedure FillMem(x: longint);
begin
  WriteLn('FillMem [',x,'] <-');
  if x<1982 then FillMem(x+1);
  WriteLn('FillMem [',x,'] ->');
end;

begin
  ClrScr;
  { i := 0;
  repeat
    Inc(i);
    FillMem(i);
  until keypressed;
  ReadKey; }
  FillMem(1);
end.
