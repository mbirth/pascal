program BGIGraph;

uses Crt, Graph, BGIP;

const xsize=600;  { Breite des Funktionsfensters }
      ysize=440;  { H”he des Funktionsfensters }
      xscaledelay=0;
      yscaledelay=0;
      graphdelay=6;
      WaitAfterInit=500;

var xmax, ymax: integer;
    xmed, ymed: integer;
    xsmed, ysmed: integer;


procedure InitGraphic;  { Initialisiert die Grafik und definiert alle wichtigen Variablen }
var BGIMode, BGIDriv: integer;
begin
  BGIDriv := 9;
  BGIMode := 2;
  InitGraph(BGIDriv,BGIMode,BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
  xmed := xsize div 2;  { Mitte-X des Funktionsfensters }
  ymed := ysize div 2;  { Mitte-Y des Funktionsfensters }
  xsmed := xmax div 2;  { Mitte-X des Bildschirmes }
  ysmed := ymax div 2;  { Mitte-Y des Bildschirmes }
  Delay(WaitAfterInit);
end;

procedure CloseGraphic;
begin
  CloseGraph;
end;

procedure MakeScale;
var i: integer;
begin
  SetTextStyle(DefaultFont, HorizDir, 1);
  SetColor(14);
  OutTextXY(150,10,'-=+ RoboCop''s ultimativer Funktionsplotter +=-');
  SetColor(8);
  Line(xsmed-xmed,ysmed,xsmed+xmed,ysmed);
  Line(xsmed,ysmed-ymed,xsmed,ysmed+ymed);
  for i:=xsmed-xmed to xsmed+xmed do begin
    if ((i-(xsmed-xmed))/10=Int((i-(xsmed-xmed))/10)) then begin
      if ((i-(xsmed-xmed))/50=Int((i-(xsmed-xmed))/50)) then begin
        SetColor(7);
        Line(i,ysmed-2,i,ysmed+2);
      end else begin
        SetColor(8);
        Line(i,ysmed-1,i,ysmed+1);
      end;
    end;
    Delay(xscaledelay);
  end;
  for i:=ysmed-ymed to ysmed+ymed do begin
    if ((i-(ysmed-ymed))/10=Int((i-(ysmed-ymed))/10)) then begin
      if ((i-(ysmed-ymed))/50=Int((i-(ysmed-ymed))/50)) then begin
        SetColor(7);
        Line(xsmed-2,i,xsmed+2,i);
      end else begin
        SetColor(8);
        Line(xsmed-1,i,xsmed+1,i);
      end;
    end;
    Delay(yscaledelay);
  end;
  SetColor(15);
  OutTextXY(xmed+xsmed,ysmed+10,'x');
  OutTextXY(xsmed+10,ysmed-ymed-5,'y');
end;

function y(x: real): real;
begin
  y := x*x*x-3*x*x+2;
end;

procedure MakeFunction;
var i: integer;
    ty: integer;
    fr,fpr,x: real;
begin
  SetColor(9);
  for i:=xsmed-xmed to xsmed+xmed do begin
    x := ((i-1)-xsmed)/(xmed/10);
    fpr := y(x);
    if fpr>32767 then fpr := 32767;
    if fpr<-32767 then fpr := -32767;
    fr := fpr*(ysize div 20);
    ty := ysmed-Trunc(fr);
    if ty>ysmed+ymed then begin
      SetColor(0);
      ty := ysmed+ymed;
    end else if ty<ysmed-ymed then begin
      SetColor(0);
      ty := ysmed-ymed;
    end else SetColor(9);
    MoveTo(i,ty);

    x := (i-xsmed)/(xmed/10);
    fpr := y(x);
    if fpr>32767 then fpr := 32767;
    if fpr<-32767 then fpr := -32767;
    fr := fpr*(ysize div 20);
    ty := ysmed-Trunc(fr);
    if ty>ysmed+ymed then begin
      SetColor(0);
      ty := ysmed+ymed;
    end else if ty<ysmed-ymed then begin
      SetColor(0);
      ty := ysmed-ymed;
    end else SetColor(9);
    PutPixel(i,ymax-19,7);
    PutPixel(i,5,7);
    LineTo(i,ty);
    Delay(graphdelay);
  end;
end;

procedure SystemReady;
begin
  SetColor(10);
  OutTextXY(160,470,'Graph fertig! Bitte drcken Sie eine Taste!');
end;


begin
  InitGraphic;
  MakeScale;
  MakeFunction;
  SystemReady;
  ReadKey;
  CloseGraph;
  WriteLn('Programm beendet.');
end.