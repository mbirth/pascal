unit RekGraph;

interface
  uses Crt,Graph;
  const skier_del:integer=0;
        haken_del:integer=0;
        quadrat_del:integer=0;
        spirale_del:integer=0;
  var globangle: integer;
  procedure TLeft(var angle: integer);
  procedure TRight(var angle: integer);
  procedure Forwd(len: integer);
  procedure Skier(len,edge:integer);
  procedure Haken(len,angle: integer);
  procedure Quadrat(len,angle: integer);
  procedure Spirale(len,angle: integer);


implementation
{###########################################################################
 #### Recursive functions following                                     ####
 ###########################################################################}

procedure TLeft(var angle: integer);
begin
  globangle := (globangle-angle) MOD 360;
end;

procedure TRight(var angle: integer);
begin
  globangle := (globangle+angle) MOD 360;
end;

procedure Forwd(len: integer);
var tmp: real;
begin
  tmp := globangle*pi/180;
  LineRel(round(len*cos(tmp)),round(len*sin(tmp)));
end;

procedure Skier(len,edge:integer);
var n : byte;
    w : integer;
begin
  w:=360 DIV edge;
  if len>30 then for n:=1 to edge do begin
    Forwd(len);
    TLeft(w);
    Delay(skier_del);
    Skier(len DIV 2,edge);
  end;
end;

procedure Haken(len,angle: integer);
begin
  if len>1 then begin
    Haken(len-1, angle);
    Forwd(len);
    TLeft(angle);
    Delay(haken_del);
  end;
end;

procedure Quadrat(len,angle: integer);
var side:integer;
begin
  if len>1 then begin
    for side:=1 to 4 do begin
      Forwd(len);
      TLeft(angle);
    end;
    Delay(quadrat_del);
    Quadrat((len*3) div 4,angle);
  end;
end;

procedure Spirale(len,angle: integer);
begin
     Forwd(len div 2);
     TRight(angle);
     Delay(spirale_del);
     if len<80 then Spirale(len+1,angle);
end;


begin
  WriteLn('þ Loading Unit: RekGraph - Markus Birth <mbirth@webwriters.de>');
end.