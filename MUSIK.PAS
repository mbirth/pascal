program Musik;

uses Crt,BasicStrings;

var c: char;
    o: longint;
    t: integer;
    x,y: integer;
    m: integer;

label Anfang,Ende;

begin
ClrScr;
m:=0;
Anfang:
  c:=ReadKey;
  o:=Ord(c);
  t:=o*m;
  Sound(t);
  Delay(50);
  NoSound;
  Write(c);
  x:=WhereX;
  y:=WhereY;
  if ((o=43) AND (m<99)) then Inc(m);
  if ((o=45) AND (m>0)) then Dec(m);
  TextColor(14);
  TextBackground(1);
  GotoXY(78,1);
  Write(o:3);
  GotoXY(79,2);
  Write(m:2);
  GotoXY(76,3);
  Write(t:5);
  TextBackground(0);
  TextColor(15);
  GotoXY(x,y);
  if o=27 then goto Ende;
  if o=13 then WriteLn;
  goto Anfang;
Ende:
end.