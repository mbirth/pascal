program YinYanG;

uses Crt, Graph, BGIP;

const rad=30;
      ang=90;

type co=record
       x,y: integer;
     end;

var xmax,ymax: word;
    xmed,ymed: word;
    i: integer;

procedure Init;
var grDriver, grMode : integer;
begin
  grDriver := VGA;
  grMode   := VGAHi;
  InitGraph(grDriver,grMode,BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
  xmed := xmax DIV 2;
  ymed := ymax DIV 2;
end;

procedure YinYan(x,y,r,a,lc,fc: integer);
var center, upper, lower, fill: co;
begin
  center.x := x; center.y := y;
  upper.x  := Round(x+(r DIV 2)*sin((a/360)*2*Pi)); upper.y  := Round(y-(r DIV 2)*cos((a/360)*2*Pi));
  lower.x  := Round(x-(r DIV 2)*sin((a/360)*2*Pi)); lower.y  := Round(y+(r DIV 2)*cos((a/360)*2*Pi));
  fill.x := Round(x-(r DIV 2)*sin(((a+90)/360)*2*Pi)); fill.y := Round(y+(r DIV 2)*cos(((a+90)/360)*2*Pi));
  SetColor(lc);
  SetFillStyle(SolidFill,fc);
  Circle(center.x,center.y,r);
  Circle(upper.x, upper.y, r DIV 15);
  Circle(lower.x, lower.y, r DIV 15+1);
  Arc(upper.x, upper.y, 90-a, 270-a, r DIV 2);
  Arc(lower.x, lower.y, 270-a, 450-a, r DIV 2);
  PutPixel(center.x, center.y, lc);
  PutPixel(Round(center.x+sin(((a+90)/360)*2*Pi)), Round(center.y-cos(((a+90)/360)*2*Pi)),lc);
  PutPixel(Round(center.x-sin(((a+90)/360)*2*Pi)), Round(center.y+cos(((a+90)/360)*2*Pi)),lc);
{  SetRGBPalette(fc,0,0,0);}
  FloodFill(upper.x, upper.y, lc);
  FloodFill(fill.x, fill.y, lc);
{  SetRGBPalette(fc,63,63,63);}
end;

begin
  Init;
{  Delay(2000);}
  SetRGBPalette(1,63,63,63);
  SetRGBPalette(2,32,32,32);

(* Lines *)
  Line(xmed-rad-1,ymed-rad,xmed-rad-1,ymed+rad);
  Line(xmed+90+rad+1,ymed-rad,xmed+90+rad+1,ymed+rad);
  Line(xmed-rad-1,ymed+rad+1,xmed+90+rad+1,ymed+rad+1);
{  YinYan(xmed,ymed,rad,ang,1,2);}
  repeat

(* Flashing *)
{    for i:=0 to 63 do begin
      SetRGBPalette(1,i,i,i);
      SetRGBPalette(2,i,i,i);
    end;
    for i:=63 downto 0 do begin
      SetRGBPalette(1,i,i,i);
      SetRGBPalette(2,i,i,i);
    end; }

(* LeftRight *)
    for i:=90 downto 0 do begin
      YinYan(xmed+i,ymed,rad,i*4,1,2);
      Delay(10);
      SetFillStyle(SolidFill,0);
      Bar(xmed-rad+i,ymed-rad,xmed+rad+i,ymed+rad);
    end;
    for i:=0 to 90 do begin
      YinYan(xmed+i,ymed,rad,i*4,1,2);
      Delay(10);
      SetFillStyle(SolidFill,0);
      Bar(xmed-rad+i,ymed-rad,xmed+rad+i,ymed+rad);
    end;
  until keypressed;
  ReadKey;
end.
