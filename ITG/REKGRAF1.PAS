Uses CRT,Graph;
var globalwinkel:integer;
    graphdriver,graphmode:integer;

Procedure GrafikAn;
begin
    graphdriver:=detect;
    initgraph(graphdriver,graphmode,'F:\SPRACHEN\BP\BGI');
    setgraphmode(graphmode);
end;
Procedure GrafikAus;
begin
    clearviewport;
    restorecrtmode;
    closegraph;
end;
Procedure Init;
begin
        clearviewport;
        setcolor(14);
        moveto (230,400);
    	globalwinkel:=0;
end;

Procedure turnleft (var winkel:integer);
begin
	globalwinkel:=(globalwinkel-winkel) mod 360
end;
Procedure turnright (var winkel:integer);
begin
	globalwinkel:=(globalwinkel+winkel) mod 360
end;
Procedure forwd (strecke:integer);
var hilf:real;
begin
     hilf:=globalwinkel*pi/180;
     linerel(round(strecke*cos(hilf)),
     round(strecke*sin(hilf)))
end;

Procedure Haken(Laenge,Winkel : integer);
begin
     if Laenge > 1 then
        begin
             Haken(Laenge - 1, Winkel);
             Forwd(Laenge);
             TurnLeft(Winkel);
        end;
end;

Procedure Quadrat(Laenge,Winkel:integer);
Var seite:integer;
begin
     if laenge >1 then
        begin
             for Seite := 1 to 4 do
                 begin
                      forwd(laenge);
                      Turnleft(winkel);
                 end;
             quadrat((Laenge*3) div 4,Winkel);
        end;
end;

procedure spirale(laenge,winkel:integer);
begin
     Forwd(Laenge div 2);
     Turnright(Winkel);
     if laenge < 80 then Spirale(laenge+1,winkel);
end;

procedure skier(laenge,ecke:integer);
var n : byte;
    w : integer;
begin
     w := 360 div ecke;
     if laenge > 30 then
        for n := 1 to ecke do
            begin
                 forwd(laenge);
                 turnleft(w );
                 skier(laenge div 2,ecke);
            end;
end;

begin
     GrafikAn;
     init;   skier(120,10); readkey;
     init;   Haken(150,45);   readkey;
     init;   Quadrat(150,90); readkey;
     init;   Spirale(10,25); readkey;
     GrafikAus;
end.