program Worms;

uses Crt, Graph, BGIP;

const  {col: array[1..20] of byte = (15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,8,8,8,8);}
        col: array[1..20] of byte = (15,15,15,15, 7, 7,7,7,7,7,7,8,8,8,8,8,8,8,8,8);
      r=200;
      wlen=20;
      wdel=5;

var xmax,ymax: word;
    xmed,ymed: word;
    opx: array[1..21] of word;
    opy: array[1..21] of word;
    cx,cy: word;
    angle: word;

procedure InitVid;
var grDriver, grMode : integer;
begin
  grDriver := VGA;
  grMode   := IBM8514Hi;
  InitGraph(grDriver,grMode,BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
  xmed := xmax DIV 2;
  ymed := ymax DIV 2;
end;

procedure OutitVid;
begin
  TextMode(CO80);
  WriteLn('Programm beendet.');
end;

procedure ColTab;
var i: integer;
begin
  for i:=1 to 256*2 do begin
    PutPixel(i,5,i DIV 2);
    PutPixel(i,6,i DIV 2);
    if i/10=Trunc(i/10) then PutPixel(i,4,15);
  end;
end;

{ Kreisgleichung

  xý+yý=rý   ( Radius r )

  <=> x = Sqrt(rý-yý)
  <=> y = Sqrt(rý-xý)

}

procedure MoveDotTo(x,y: word);
var i: integer;
begin
  for i:=wlen+1 downto 2 do begin
    opx[i]:=opx[i-1];
    opy[i]:=opy[i-1];
  end;
  opx[1] := x;
  opy[1] := y;
  PutPixel(opx[wlen+1],opy[wlen+1],0);
  for i:=wlen downto 1 do begin
    PutPixel(opx[i],opy[i],col[i]);
  end;
end;

procedure CircleDot;
var i,j: integer;
    x,y: integer;
begin
  repeat
    for i:=0 to r*2 do begin
      x := xmed-(i-r);
      y := ymed-r;
      MoveDotTo(x,y);
      Delay(wdel);
      if keypressed then begin
        ReadKey;
        Exit;
      end;
    end;
    for i:=r*2 downto 0 do begin
      y := ymed-(i-r);
      x := xmed-r;
      MoveDotTo(x,y);
      Delay(wdel);
      if keypressed then begin
        ReadKey;
        Exit;
      end;
    end;
    for i:=r*2 downto 0 do begin
      x := xmed-(i-r);
      y := ymed+r;
      MoveDotTo(x,y);
      Delay(wdel);
      if keypressed then begin
        ReadKey;
        Exit;
      end;
    end;
    for i:=0 to r*2 do begin
      y := ymed-(i-r);
      x := xmed+r;
      MoveDotTo(x,y);
      Delay(wdel);
      if keypressed then begin
        ReadKey;
        Exit;
      end;
    end;
  until 0=1;
end;

procedure RandomDot;
var xp,yp: shortint;
    tic,ticm: byte;
begin
  tic := 127;
  ticm := 0;
  TextColor(white);
    if tic>ticm then begin
      xp := (Trunc(Random(3))-1);
      yp := (Trunc(Random(3))-1);
      ticm := Trunc(Random(6));
      tic := 0;
      Randomize;
    end;
    Inc(tic);
    cx := cx + xp;
    if cx<1 then cx:=1;
    if cx>xmax then cx:=xmax-1;
    cy := cy + yp;
    if cy<1 then cy:=1;
    if cy>ymax then cy:=ymax-1;
end;

procedure AngleDot;
begin



end;

begin
  InitVid;
  Randomize;
  { ColTab; }
  { CircleDot; }
  cx := xmax DIV 2;
  cy := ymax DIV 2;
  angle := 0;
  MoveDotTo(cx,cy);
  repeat
    RandomDot;
    { AngleDot; }
    MoveDotTo(cx,cy);
    Delay(wdel*3);
  until keypressed;
  ReadKey;
  OutitVid;
  WriteLn('VMode: ',xmax,'x',ymax);
  WriteLn('Zentr x: ',xmed,' -- y: ',ymed);
end.
