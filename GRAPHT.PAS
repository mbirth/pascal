program Grafiktest;

uses Crt;

procedure InitGraph;
begin
  asm
    mov ah,0
    mov al,13h
    int 10h
  end;
end;

procedure PutPixel(x,y: integer; c: byte);
begin
  asm
    mov ah,0Ch
    mov al,c
    mov cx,x
    mov dx,y
    int 10h
  end;
  (* Sound(c);
  NoSound; *)
end;

procedure CloseGraph;
begin
  asm
    mov ah,0
    mov al,3h
    int 10h
  end;
end;

procedure Line(x1,y1,x2,y2: integer; c: byte);
var i,y: integer;
begin
  if x2>x1 then begin
    for i:=x1 to x2 do begin
      y := Trunc(((y2-y1)/(x2-x1))*(i-x1)+y1);
      PutPixel(i,y,c);
    end;
  end else if x1>x2 then begin
    for i:=x1 downto x2 do begin
      y := trunc(((y2-y1)/(x2-x1))*(i-x1)+y1);
      PutPixel(i,y,c);
    end;
  end else if y2>y1 then begin
    for i:=y1 to y2 do PutPixel(x1,i,c);
  end else if y1>y2 then begin
    for i:=y1 downto y2 do PutPixel(x1,i,c);
  end;
end;

procedure Square(x1,y1,x2,y2: integer; c:byte);
begin
  Line(x1,y1,x2,y1,c);
  Line(x1,y1,x1,y2,c);
  Line(x1,y2,x2,y2,c);
  Line(x2,y1,x2,y2,c);
end;

procedure Lines;
begin
  InitGraph;
  repeat
    Line(0,0,320,200,Random(256));
    Line(320,0,0,200,Random(256));
    Line(160,0,160,200,Random(256));
    Line(0,100,320,100,Random(256));
  until keypressed;
  ReadKey;
  CloseGraph;
end;

procedure RandPix;
begin
  InitGraph;
  repeat
    PutPixel(Random(320),Random(200),Random(256));
  until keypressed;
  ReadKey;
  CloseGraph;
end;

procedure FillScreen(c: byte);
var i,j: integer;
begin
  InitGraph;
  for i:=0 to 200 do begin
    for j:=0 to 320 do begin
      PutPixel(j,i,c);
      if keypressed then begin
        ReadKey;
        CloseGraph;
        Exit;
      end;
    end;
  end;
  ReadKey;
  CloseGraph;
end;

procedure WhitePix;
const MarkCol=8;
begin
  InitGraph;
  Line(160,98,160,80,MarkCol);
  PutPixel(159,97,MarkCol);
  PutPixel(161,97,MarkCol);
  Line(160,102,160,120,MarkCol);
  PutPixel(159,103,MarkCol);
  PutPixel(161,103,MarkCol);
  Line(158,100,140,100,MarkCol);
  PutPixel(157,99,MarkCol);
  PutPixel(157,101,MarkCol);
  Line(162,100,180,100,MarkCol);
  PutPixel(163,99,MarkCol);
  PutPixel(163,101,MarkCol);
  Square(150,90,170,110,MarkCol);
  repeat
    PutPixel(160,100,12);
    PutPixel(160,100,10);
    PutPixel(160,100,11);
  until keypressed;
  ReadKey;
  CloseGraph;
end;

procedure RandSquare;
var x1,y1,x2,y2,c: integer;
begin
  InitGraph;
  repeat
    x1 := Random(320);
    y1 := Random(200);
    x2 := Random(320);
    y2 := Random(200);
    c  := Random(256);
    Square(x1,y1,x2,y2,c);
  until keypressed;
  ReadKey;
  CloseGraph;
end;

procedure ColorTable;
var i,j: integer;
    tm: byte;
begin
  InitGraph;
    for i:=0 to 199 do begin
      for j:=0 to 319 do begin
        { PutPixel(j,i,Trunc(((j/20)+1)*((i/12.5)+1))); }
        tm := Trunc((j/20)*(i/12.5));
        PutPixel(j,i,tm);
        if keypressed then begin
          ReadKey;
          CloseGraph;
          Exit;
        end;
      end;
    end;
  ReadKey;
  CloseGraph;
  ClrScr;
end;


{ Ellipsengleichung

  xý   yý
  -- + -- = 1
  a    b      }

procedure Ellipsoid(x1,y1,x2,y2: integer; c:byte);
begin

end;

begin
  Randomize;

  Lines;
  RandPix;
  FillScreen(Random(256));
  WhitePix;
  RandSquare;
  ColorTable;
end.