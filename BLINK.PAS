program blink;

uses Crt,CursorOnOff;

const xlen=20;
      ylen=10;

var x1,x2,y1,y2: byte;

procedure FillCol(col: byte);
var i,j: byte;
begin
  TextColor(col);
  GotoXY(1,1);
  for i:=y1 to y2 do begin
    for j:=x1 to x2 do begin
      Write('Û');
    end;
  end;
  delay(50);
end;

begin
  ClrScr;
  x1 := 40-xlen div 2;
  x2 := 40+xlen div 2;
  y1 := 12-ylen div 2;
  y2 := 12+ylen div 2;

  window(x1,y1,x2,y2);
  CursorOff;
  repeat
    FillCol(0);
    FillCol(8);
    FillCol(7);
    FillCol(15);
    FillCol(7);
    FillCol(8);
  until keypressed;
  CursorOn;
  ReadKey;
end.