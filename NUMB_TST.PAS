uses Crt,Numbers;

var zahl: longint;

begin
  ClrScr;
  zahl := 1;
  while zahl<>0 do begin
    ReadLn(zahl);
    GotoXY(1,WhereY-1);
    WriteLn(zahl:0,': ',Dec2Bin(zahl));
  end;
end.
