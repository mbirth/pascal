program Froehliche_Weihnacht;

uses Crt, Graph, BGIP;

const pdel=10;
      bdel=100;
      bdis=20;

var xmax, ymax: word;
    oy: integer;


procedure InitGraphics;
var grDriver, grMode : integer;
begin
  grDriver := VGA;
  grMode   := VGAhi;
  InitGraph(grDriver,grMode,BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
end;

procedure OutitGraphics;
begin
  TextMode(CO80);
  WriteLn('Programm beendet.');
end;

procedure DrawStaffs;
begin
  SetLineStyle(SolidLn, 0, NormWidth);
  SetColor(8);
  Rectangle(10,100,15,400);
  SetColor(6);
  Rectangle(11,101,14,399);
  Rectangle(12,101,13,399);
  SetColor(8);
  Rectangle(625,100,630,400);
  SetColor(6);
  Rectangle(626,101,629,399);
  Rectangle(627,101,628,399);
end;

function y(x: integer): integer;
const fac=0.001;
      xcen=320;
      ypos=195;
var ot: string;
    t: integer;
begin
  t := Round(-fac*(x-xcen)*(x-xcen)+ypos);
  { if Abs(t-oy)>3 then begin
    Str(x,ot);
    OutText(ot+';');
    Str(t,ot);
    OutText(ot);
  end;
  oy := t; }
  y := t;

end;

procedure DrawLine;
var i: integer;
begin
  MoveTo(13,y(13));
  SetColor(8);
  for i:=13 to 627 do begin
    LineTo(i,y(i));
  end;
end;

procedure BlowTorch(i: word;col: byte);
const fcol=7;    { Farbe der Lampenfassung }
      pcol=15;   { Farbe des Kontakts }
      gcol=8;    { Farbe des Glas }
var j: integer;
begin
  { Just a 3x3 rectangle }
  { PutPixel(i-1,y(i)-1,col);
  PutPixel(i-1,y(i),col);
  PutPixel(i-1,y(i)+1,col);
  PutPixel(i,y(i)-1,col);
  PutPixel(i,y(i),col);
  PutPixel(i,y(i)+1,col);
  PutPixel(i+1,y(i)-1,col);
  PutPixel(i+1,y(i),col);
  PutPixel(i+1,y(i)+1,col); }

  { A nice lamp }
  PutPixel(i,y(i)-2,pcol);   { Kontakt }

  for j:=-1 to 1 do PutPixel(i-1,y(i)+j,fcol);   { Sockel }
  for j:=-1 to 1 do PutPixel(i,y(i)+j,fcol);
  for j:=-1 to 1 do PutPixel(i+1,y(i)+j,fcol);

  PutPixel(i-2,y(i)+2,gcol); { Lampe }
  PutPixel(i+2,y(i)+2,gcol);
  PutPixel(i-2,y(i)+6,gcol);
  PutPixel(i+2,y(i)+6,gcol);
  for j:=3 to 5 do PutPixel(i-3,y(i)+j,gcol);
  for j:=3 to 5 do PutPixel(i+3,y(i)+j,gcol);
  for j:=-1 to 1 do PutPixel(i+j,y(i)+7,gcol);

  for j:=3 to 5 do PutPixel(i-2,y(i)+j,col); { Licht }
  for j:=2 to 6 do PutPixel(i-1,y(i)+j,col);
  for j:=2 to 6 do PutPixel(i,y(i)+j,col);
  for j:=2 to 6 do PutPixel(i+1,y(i)+j,col);
  for j:=3 to 5 do PutPixel(i+2,y(i)+j,col);
end;

procedure AnimateTorches_LineBlink;
var i: integer;
begin
  Randomize;
  for i:=13 to 627 do begin
    if i/bdis=Int(i/bdis) then begin
      BlowTorch(i,0);
    end;
  end;
  repeat
    for i:=13 to 627 do begin
      if i/bdis=Int(i/bdis) then begin
        BlowTorch(i,Random(16));
        Delay(pdel);
      end;
    end;
    Delay(bdel);
  until keypressed;
  ReadKey;
end;

procedure AnimateTorches_RandomBlink;
var i: integer;
begin
  Randomize;
  for i:=13 to 627 do begin
    if i/bdis=Int(i/bdis) then begin
      BlowTorch(i,0);
    end;
  end;
  repeat
    i := (Random(630 DIV bdis))*bdis+20;
    BlowTorch(i,Random(16));
    Delay(pdel);
  until keypressed;
  ReadKey;
end;

procedure AnimateTorches_ShiftBlink;
const maxt=630 DIV bdis-1;
var i: integer;
    lc: array[0..maxt] of byte;
begin
  Randomize;
  for i:=13 to 627 do begin
    if i/bdis=Int(i/bdis) then begin
      BlowTorch(i,0);
    end;
  end;
  repeat
    for i:=maxt downto 1 do lc[i]:=lc[i-1];
    lc[0] := Random(16);
    for i:=0 to maxt do begin
      BlowTorch(i*bdis+20,lc[i]);
    end;
    Delay(bdel);
  until keypressed;
  ReadKey;
end;

begin
  InitGraphics;
  DrawStaffs;
  DrawLine;
  AnimateTorches_ShiftBlink;
  OutitGraphics;
end.
