uses numbers, Crt;

var inu: longint;
    hex: string;
    y: integer;

begin
  repeat
    WriteLn('===================');
    y := WhereY;
    if (y=25) then y:=24;
    Write('Enter number: ');
    ReadLn(inu);
    GotoXY(1,y);
    ClrEol;
    GotoXY(1,y);  Write('d ',inu);
    GotoXY(20,y); Write('h ',Dec2Hex(inu),'     ');
    GotoXY(40,y); WriteLn('b ',Dec2Bin(inu));
  until (inu=0);
  { repeat
    Write('Enter Hex-string: ');
    ReadLn(hex);
    WriteLn('Dec: ',Hex2Dec(hex));
  until (hex='q'); }
end.
