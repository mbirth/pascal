program JumpDot;

uses Crt, Graph, BGIP, DOS;

const grav=9.80665;
      fac=15;

var xmax,ymax: word;
    xmed,ymed: word;
    dx, dy: word;
    i: integer;
    down: boolean;
    di: word;
    h,m,s,ss: word;
    sts, sss: longint;

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

begin
  Init;
  dx := 0; dy := 10;
  down := true;
  { GetTime(h,m,s,ss);
  sts := h*60*60*100 + m*60*100 + s*100 + ss; }
  di := 0;
  for i:=0 to xmax do begin
    { GetTime(h,m,s,ss);
    sss := (h*60*60*100 + m*60*100 + s*100 + ss)-(sts); }
    dx := i;
    { dy := Round((9.80665)*Sqr(sss/100)); }
    if (down) then dy := Round((grav/2)*Sqr((i-di)/fac)) else dy := Round((grav/2)*Sqr((di-(i-di))/fac));
    if (dy>ymax) then begin
      down:=false;
      dy:=ymax-1;
      di:=i-di;
    end;
    if (dy<=0) AND (di<i-10) then begin
      down:=true;
      dy:=0;
      di:=i;
    end;
    PutPixel(dx,dy,15);
    if (down) then PutPixel(0,0,10) else PutPixel(0,0,12);
    Delay(10);



  end;


end.