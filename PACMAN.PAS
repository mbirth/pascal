program _PacMan_;

uses Crt, Graph, BGIP;

const rad=10;
      pcol:byte=14;

var xmax, ymax, xmed, ymed: word;
    k: char;
    angle,direct: word;


procedure GraphInit;
var grDriver, grMode: integer;
begin
  grDriver := VGA;
  grMode   := VGAHi;
  InitGraph(grDriver, grMode, BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
  xmed := xmax DIV 2;
  ymed := ymax DIV 2;
end;

procedure GraphOutit;
begin
  TextMode(CO80);
  WriteLn('VMode : ',xmax,'x',ymax);
  WriteLn('Center: ',xmed,'x',ymed);
  WriteLn;
  WriteLn('Programm beendet.');
end;

procedure PacMan(x,y,dir,a: word);
var tmp: string;
    sa,ea: real;
    x1,y1,x2,y2: word;
    xm,ym: word;
begin
  SetFillStyle(SolidFill,0);
  SetColor(0);
  Bar(xmed-rad,ymed-rad,xmed+rad,ymed+rad);
  SetColor(pcol);
  SetFillStyle(SolidFill,pcol);
  Circle(x,y,rad);
  FloodFill(x,y,pcol);

  SetColor(0);
  SetFillStyle(SolidFill,0);
  sa := (dir+a)/180*Pi;
  ea := (dir-a)/180*Pi;
  x1 := x+Trunc(Cos(sa)*(rad+1));
  y1 := y+Trunc(Sin(sa)*(rad+1));
  x2 := x+Trunc(Cos(ea)*(rad+1));
  y2 := y+Trunc(Sin(ea)*(rad+1));

  MoveTo(x,y);
  LineTo(x1,y1);
  MoveTo(x,y);
  LineTo(x2,y2);

  xm := (x1+x2+x) DIV 3;
  ym := (y1+y2+y) DIV 3;

  SetColor(0);
  SetFillStyle(SolidFill,0);
  FloodFill(xm,ym,0);

  (* { Statistics following }
  Bar(0,0,100,100);
  SetColor(15);
  Str(a:3, tmp);
  OutTextXY(5,5,'Angle: '+tmp);
  Str(dir:3, tmp);
  OutTextXY(5,15,'Direc: '+tmp); *)
end;

begin
  GraphInit;
  angle := 20;
  direct := 270;
  pcol := 15;
  SetTextJustify(CenterText, CenterText);
  OutTextXY(320,10,'Sieht aus wie eine ''Spalt N'', was?');
  repeat
    PacMan(xmed,ymed,direct,angle);
    k := ReadKey;
    pcol := 14;
    SetColor(15);
    OutTextXY(320,20,'Ist aber der allbeliebte PACMAN!!');
    case k of
      '+': if (angle<360) then Inc(angle,2) else angle:=0;
      '-': if (angle>0) then Dec(angle,2) else angle:=359;
      '*': if (direct<360) then Inc(direct,2) else direct:=0;
      '/': if (direct>0) then Dec(direct,2) else direct:=359;
    end;
  until k=#27;
  GraphOutit;
end.