PROGRAM Combsorttest;
USES crt,graph,dos;
TYPE feld_ = array[0..3000] of word;
VAR  x : feld_;

{Grafik initialisieren}
PROCEDURE graf;
VAR gd,gm : integer;
BEGIN
  gd:=detect;
  {evtl. Grafikpfad „ndern}
  initgraph(gd,gm,'c:\schuls~1\tp\bgi');
  if graphresult<>0 then halt(1);
END;

{Zufallszahlen erzeugen}
PROCEDURE zufall(n : integer;var a : feld_);
VAR i : integer;
 BEGIN
  randomize;
  for i:=1 to n do
   a[i]:=random(n)+1;
 END;


 { "Je nachdem, wie tief die Spalte geht!" (Zitat: Fr”bel) }
PROCEDURE combsortdar;
VAR x : feld_;
    s,s1,s2 : string;
    sorted : boolean;
    i,j,top,gap,h,n,z,z1,z2 : integer;

 BEGIN
  n:=25;z:=0;z1:=0;z2:=0;
  setfillstyle(1,0);setcolor(15);
  bar(0,0,getmaxx,getmaxy);
  zufall(n,x);
  for i:=1 to n do begin
   str(x[i],s);
   if x[i]<10 then s:='0'+s;
   outtextxy(50+i*20,100,s);
  end;
  outtextxy(70,320,'Vergleichsabstand : 25');
  outtextxy(70,300,'Durchgang         : 00');
  outtextxy(70,350,'Vertauschungen    : 00');
  outtextxy(70,360,'Vergleiche        : 00');
  gap:=n;
  repeat
   inc(z);
   gap:=trunc(gap/1.3); { Neue Schrittweite }
   if gap=0 then gap:=1
   else
   if (gap=9) or (gap=10) then gap:=11;
   setcolor(red);
   str(gap,s);if gap<10 then s:='0'+s;
   bar(230,320,250,330);outtextxy(230,320,s);
   setcolor(15);
   str(z,s);if z<10 then s:='0'+s;
   bar(230,300,250,310);outtextxy(230,300,s);
   sorted:=true;                 { Variable auf "sortiert" setzen }
   top:=n-gap;                   { Obergrenze fr Sortieren festlegen }
   for i:=1 to top do begin
    inc(z1);
    setcolor(15);
    str(z1,s);if z1<10 then s:='0'+s;
    bar(230,360,250,370);outtextxy(230,360,s);
    setcolor(blue);
    str(x[i],s1);if x[i]<10 then s1:='0'+s1;
    outtextxy(50+i*20,100,s1);
    str(x[i+gap],s2);if x[i+gap]<10 then s2:='0'+s2;
    outtextxy(50+(i+gap)*20,100,s2);
    setcolor(green);
    line(60+i*20,95,60+i*20,80);
    line(60+(i+gap)*20,95,60+(i+gap)*20,80);
    line(60+i*20,80,60+(i+gap)*20,80);
    bar(20,65,600,75);
    outtextxy(16+round((i+gap/2)*20),65,'VERGLEICHEN');
    delay(100);
    bar(20,65,600,75);
    if x[i]>x[i+gap] then begin  { Vergleich von Elementen im Abstand "gap" }
     inc(z2);
     setcolor(15);
     str(z2,s);if z2<10 then s:='0'+s;
     bar(230,350,250,358);outtextxy(230,350,s);
     setcolor(green);
     outtextxy(16+round((i+gap/2)*20),65,'VERTAUSCHEN');
     for j:=100 to 120 do begin
      setcolor(blue);
      outtextxy(50+i*20,j,s1);
      outtextxy(50+(i+gap)*20,50+j div 2,s2);
      delay(1);
      bar(50+i*20,j,70+i*20,j+10);bar(50+(i+gap)*20,50+j div 2,70+(i+gap)*20,60+j div 2);
     end;
     for j:=1 to (gap*20) do begin
      setcolor(blue);
      outtextxy(50+i*20+j,120,s1);
      outtextxy(50+(i+gap)*20-j,110,s2);
      delay(1);
      bar(50+i*20+j,120,70+i*20+j,130);bar(50+(i+gap)*20-j,110,70+(i+gap)*20-j,120);
     end;
     for j:=120 downto 100 do begin
      setcolor(blue);
      outtextxy(50+i*20,j,s1);
      outtextxy(50+(i+gap)*20,50+j div 2,s2);
      delay(1);
      bar(50+i*20,j,70+i*20,j+10);bar(50+(i+gap)*20,50+j div 2,70+(i+gap)*20,60+j div 2);
     end;
     bar(20,65,600,75);
     h:=x[i];x[i]:=x[i+gap];x[i+gap]:=h; { Vertauschung, wenn "falsch" }
     sorted:=false;              { Variable auf "nicht fertig sortiert" setzen }
    end;
    setcolor(0);
    line(60+i*20,95,60+i*20,80);
    line(60+(i+gap)*20,95,60+(i+gap)*20,80);
    line(60+i*20,80,60+(i+gap)*20,80);
    setcolor(15);
    str(x[i],s1);if x[i]<10 then s1:='0'+s1;
    outtextxy(50+i*20,100,s1);
    str(x[i+gap],s2);if x[i+gap]<10 then s2:='0'+s2;
    outtextxy(50+(i+gap)*20,100,s2);
   end;
  until sorted and (gap=1);
 END;

PROCEDURE auswahl;
VAR c : char;
 BEGIN
  repeat
   setfillstyle(1,0);
   bar(0,0,getmaxx,getmaxy);
   setcolor(15);
   outtextxy(260,100,'C O M B S O R T');
   outtextxy(260,120,'###############');
   outtextxy(220,200,'1...DEMONSTRATION');
   outtextxy(220,220,'2...ENDE');

   repeat
    c:=readkey;
   until c<>'';
   case c of
   '1': combsortdar;
   end;
  until c='2';
 END;
BEGIN
 graf;
 auswahl;
 closegraph;
END.
