program Mirroring;

uses Crt, Graph, GUI, BGIP;

var xmax,ymax: integer;
    omx, omy, omb: integer;
    lx,ly,rx,ry: integer;
    orx,ory: integer;
    ls,rs: boolean;

procedure GraphInit;
var grDriver, grMode : integer;
begin
  grDriver := VGA;
  { VGAlo     640x200x16
    VGAmed    640x350x16
    VGAhi     640x480x16 }
  grMode   := VGAhi;
  InitGraph(grDriver,grMode,BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
end;

procedure GraphOutit;
begin
  TextMode(co80 + Font8x8);
end;

function Num2Str(x: longint): string;
var tmp: string;
begin
  Str(x:3,tmp);
  Num2Str := tmp;
end;

procedure SetRect;
begin
  omx := 0;
  omy := 0;
  omb := 0;
  lx := 0; ly := 0;
  ls := false;
  rs := false;
  repeat
    repeat
      MouseStat(mx,my,mb);
    until (mx<>omx) OR (my<>omy) OR (mb<>omb);
    if (mb=1) AND NOT (ls) then begin
      repeat
        MouseStat(mx,my,mb);
      until (mb=0);
      lx := mx;
      ly := my;
      ls := true;
    end;
    rx := mx;
    ry := my;
    if (lx<>0) AND (ly<>0) AND ((rx<>orx) OR (ry<>ory)) AND NOT (rs) then begin
      ShowMouse(false);
      SetColor(0);
      Rectangle(lx,ly,orx,ory);
      SetColor(15);
      Rectangle(lx,ly,rx,ry);
      ShowMouse(true);
      orx := rx;
      ory := ry;
    end;
    if (lx<>0) AND (ly<>0) AND (rx<>0) AND (ry<>0) AND (mb=1) then begin
      rs := true;
      repeat
        MouseStat(mx,my,mb);
      until (mb=0);
    end;
    omx := mx;
    omy := my;
    omb := mb;
    Bar(1,1,150,30);
    OutTextXY(1,1,'X:'+Num2Str(mx)+' Y:'+Num2Str(my)+' Buttons:'+Num2Str(mb));
  until (ls) AND (rs);
end;

begin
  GraphInit;
  fo_del := 0;
  InitPalette;
  MouseReset;
  ShowMouse(true);
  SetFillStyle(SolidFill,0);
  SetTextStyle(SmallFont,HorizDir,4);
  SetColor(15);
  SetRect;
  Alert('Fertich!!');
  FadeOut;
  GraphOutit;
end.
