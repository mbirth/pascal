program Distances;             { Autor: Markus Birth <mbirth@webwriters.de> }

uses Crt, Graph, GUI;

type ttabelle = array[1..10,1..10] of word;
     cityrec = record
       x: integer;
       y: integer;
       n: string[20];
     end;
     xyrec = record
       x: integer;
       y: integer;
     end;

const tabelle: ttabelle=((  0,530,555,289,378,370,569,584,616,596),
   		  		         (530,  0,249,385,207,478, 68,638,700,513),
                         (555,249,  0,495,193,588,189,395,457,294),
                         (289,385,495,  0,307, 93,422,782,844,777),
                         (378,207,193,307,  0,400,249,482,544,475),
                         (370,478,588, 93,400,  0,515,875,937,870),
                         (569, 68,189,422,249,515,  0,578,640,453),
                         (584,638,395,782,482,875,578,  0,179,139),
                         (616,700,457,844,544,937,640,179,  0,310),
                         (596,513,294,777,475,870,453,139,310,  0));

      map: array[1..52] of xyrec=((x:33;y: 4),(x:36;y: 5),(x:37;y: 5),
                                  (x:38;y: 7),(x:40;y: 7),(x:41;y: 8),
                                  (x:37;y:13),(x:41;y:14),(x:41;y:22),
                                  (x:42;y:23),(x:41;y:24),(x:40;y:24),
                                  (x:30;y:29),(x:33;y:33),(x:38;y:37),
                                  (x:38;y:40),(x:35;y:42),(x:37;y:46),
                                  (x:32;y:45),(x:27;y:46),(x:22;y:46),
                                  (x:21;y:47),(x:16;y:45),(x:10;y:47),
                                  (x: 8;y:46),(x: 9;y:40),(x:12;y:38),
                                  (x: 3;y:33),(x: 2;y:30),(x: 4;y:28),
                                  (x: 1;y:25),(x: 3;y:21),(x: 2;y:19),
                                  (x: 4;y:18),(x: 7;y:15),(x: 5;y:14),
                                  (x: 7;y:11),(x: 6;y: 9),(x: 8;y: 8),
                                  (x: 9;y: 7),(x:12;y: 7),(x:14;y: 8),
                                  (x:15;y: 6),(x:17;y: 6),(x:18;y: 1),
                                  (x:22;y: 2),(x:23;y: 7),(x:28;y: 6),
                                  (x:27;y: 8),(x:28;y:10),(x:31;y: 6),
                                  (x:33;y: 4));
      mapfact: xyrec = (x:7;y:7);
      citycount: byte=10;
      city: array[1..10] of cityrec=((x:36;y:16;n:'Berlin'),
                                     (x: 7;y:23;n:'Essen'),
                                     (x:15;y:31;n:'Frankfurt am Main'),
                                     (x:23;y:12;n:'Hamburg'),
                                     (x:18;y:22;n:'Kassel'),
                                     (x:24;y: 9;n:'Kiel'),
                                     (x: 8;y:27;n:'Kîln'),
                                     (x:27;y:43;n:'MÅnchen'),
                                     (x:36;y:40;n:'Passau'),
                                     (x:20;y:41;n:'Ulm'));
      desktopcolor=3;

var xmax, ymax, xmed, ymed: word;
    cityrp: array[1..10] of xyrec;
    WP: array[1..50] of byte;
    WPuptodate: boolean;
    buttondown: boolean;

{ V2S(x) - Liefert angegebenen Word-Wert als String mit 3 Stellen
  Input:  word
  Output: string }
function V2S(x: word): string;
var tmp: string;
begin
  Str(x:3,tmp);
  V2S := tmp;
end;

{ Dist(c1,c2) - Liefert Entfernung zwischen StÑdteindizes c1 und c2
  Input:  byte, byte
  Output: integer }
function Dist(wp1,wp2: byte): integer;
begin
  Dist := tabelle[wp1,wp2];
end;

{ WPmax - Liefert Index des letzten Wegpunktes im WP-Array
  Input:  none
  Output: byte }
function WPmax: byte;
var i: byte;
begin
  for i:=1 to 50 do if (WP[i]=255) then WPmax := i-1;
end;

{ UpdateDist - Refreshed die Entfernungsanzeige
  Input:  none
  Output: none }
procedure UpdateDist;
var i: byte;
    dst: integer;
    dis: string;
begin
  dst := 0;
  if (WPmax>1) then for i:=1 to WPmax-1 do begin
                      dst := dst + Dist(WP[i],WP[i+1]);
                    end;
  SetFillStyle(SolidFill,7);
  SetColor(0);
  Bar(53,398,247,457);
  SetViewPort(53,398,247,457,ClipOn);
  SetTextStyle(TripleXFont,HorizDir,4);
  SetTextJustify(RightText,CenterText);
  Str(dst:4,dis);
  dis := dis + ' km';
  OutTextXY(187,17,dis);
  SetViewPort(0,0,639,479,ClipOff);
end;

{ ShowGermany - Zeichnet/refreshed die Deutschlandkarte
  Input:  none
  Output: none }
procedure ShowGermany;
const xd=7;
      yd=22;
var k,x,y: integer;
begin
  Frame(8,26,312,362,0,0,7,1,false);
  SetColor(15);
  for k:=1 to 51 do line((map[k].x*mapfact.x)+xd,(map[k].y*mapfact.y)+yd,(map[k+1].x*mapfact.x)+xd,(map[k+1].y*mapfact.y)+yd);
  SetTextJustify(CenterText,TopText);
  SetTextStyle(SmallFont,HorizDir,4);
  for k:=1 to 10 do begin
    x:=city[k].x*mapfact.x+xd;
    y:=city[k].y*mapfact.y+yd;
    cityrp[k].x:=x;
    cityrp[k].y:=y;
    PutPixel(x,y,15);
    PutPixel(x+1,y,7);
    PutPixel(x-1,y,7);
    PutPixel(x,y-1,7);
    PutPixel(x,y+1,7);
    PutPixel(x-1,y-1,8);
    PutPixel(x-1,y+1,8);
    PutPixel(x+1,y-1,8);
    PutPixel(x+1,y+1,8);
    if (WP[1]=k) then SetColor(10)
      else if (WP[WPmax]=k) then SetColor(12)
      else SetColor(11);
    OutTextXY(x+2,y+2,city[k].n);
    if (WP[WPmax]=k) OR (WP[1]=k) then OutTextXY(x+3,y+2,city[k].n);
  end;
end;

{ UpdatePath - Refreshed die Weglinien
  Input:  none
  Output: none }
procedure UpdatePath;
var i: byte;
begin
  ShowGermany;
  MoveTo(cityrp[WP[1]].x,cityrp[WP[1]].y);
  SetColor(9);
  for i:=2 to WPmax do begin
    if (i=WPmax) then SetColor(12);
    LineTo(cityrp[WP[i]].x,cityrp[WP[i]].y);
  end;
end;

{ UpdateWP - Refreshed die Wegpunkte-Liste
  Input:  none
  Output: none }
procedure UpdateWP;
var i: byte;
begin
  if (NOT WPuptodate) then begin
    SetFillStyle(SolidFill,7);
    Bar(328,30,527,397);
    SetViewPort(328,30,527,397,ClipOn);
    SetColor(0);
    for i:=1 to WPmax do begin
      SetTextJustify(RightText,CenterText);
      SetTextStyle(SmallFont,HorizDir,4);
      OutTextXY(19,i*9-5,V2S(i)+'.');
      SetTextJustify(LeftText,CenterText);
      OutTextXY(20,i*9-5,city[WP[i]].n);
      OutTextXY(21,i*9-5,city[WP[i]].n);
      SetTextJustify(RightText,CenterText);
      SetTextStyle(SmallFont,HorizDir,4);
      if i>1 then begin
        OutTextXY(160,i*9-5,V2S(Dist(WP[i],WP[i-1])));
      end else begin
        OutTextXY(160,i*9-5,'---');
      end;
      Rectangle(167,i*9-8,192,i*9);
      SetTextStyle(SmallFont,HorizDir,2);
      SetTextJustify(CenterText,CenterText);
      OutTextXY(179,i*9-5,'CLEAR');
    end;
    SetViewPort(0,0,639,479,ClipOff);
    UpdateDist;
    UpdatePath;
    WPuptodate := true;
  end;
end;

{ AddWP(x) - HÑngt Wegpunkt bei Stadt x an das WP-Array an
  Input:  byte
  Output: none }
procedure AddWP(what: byte);
var wpm: byte;
begin
  wpm := WPmax;
  if (wpm+1>1) then begin
    if (WP[wpm]<>what) then begin
      if (wpm<49) then begin
        WP[wpm+1] := what;
        WP[wpm+2] := 255;
        WPuptodate:=false;
      end else begin
        Sound(1200);
        Delay(50);
        NoSound;
      end;
    end;
  end else begin
    WP[1] := what;
    WP[2] := 255;
    WPuptodate:=false;
  end;
  UpdateWP;
end;

{ RemoveWP(x) - Entfernt den Wegpunkt mit Index x aus WP
  Input:  byte
  Output: none }
procedure RemoveWP(which: byte);
var i: byte;
begin
  for i:=which to 49 do WP[i] := WP[i+1];
  WPuptodate:=false;
  UpdateWP;
end;

{ Init - Alles, was initialisiert werden mu·, grundlegende Vardefs
  Input:  none
  Output: none }
procedure Init;
var grDriver, grMode: integer;
    BGIPath: string;
begin
  grDriver := VGA;
  grMode   := VGAHi;
  initp_del := 30;
  BGIPath  := 'D:\BP\BGI\';
  InitGraph(grDriver, grMode, BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmhîhe in Pixeln }
  xmed := xmax DIV 2;
  ymed := ymax DIV 2;
  WP[1] := 255;
  WPuptodate := false;
  buttondown := false;
  om := 0;
  SetTextStyle(DefaultFont,HorizDir,1);
  SetTextJustify(LeftText,TopText);
  SetFillStyle(SolidFill,desktopcolor);
  Bar(0,0,xmax-1,ymax-1);
  ClearStatus;
end;

{ Outit - Alles, um wieder auf Normalwerte zu kommen ...
  Input:  none
  Output: none }
procedure Outit;
var i,ad,wpm: integer;
begin
  wpm := WPmax;
  TextMode(CO80);
  WriteLn('VMode : ',xmax,'x',ymax);
  WriteLn('Center: ',xmed,'x',ymed);
  WriteLn;
  if wpm>1 then begin
    ad := 0;
    Write('Strecke: ');
    for i:=1 to wpm do begin
      if (i>1) then Write(', ',city[WP[i]].n) else Write(city[WP[i]].n);
      if (i<wpm) then ad := ad + Dist(WP[i],WP[i+1]);
    end;
    WriteLn;
    WriteLn('Entfernung: ',ad,' km');
    WriteLn;
  end;
  Write('Programm beendet.');
  if (wpm>1) then WriteLn(' Viel VergnÅgen in ',city[WP[wpm]].n,'!') else WriteLn;
end;

{ StartScreen - Zeichnet Anfangs-Logo und nach Tastendruck den Mainscreen
  Input:  none
  Output: none }
procedure StartScreen;
begin
  MakeWindow(120,140,520,340,'Entfernungstabelle');
  SetViewPort(123,161,517,337,ClipOn);
  SetColor(9);
  SetTextStyle(TripleXFont,HorizDir,10);
  SetTextJustify(CenterText,CenterText);
  OutTextXY(200,24,'GUI');
  OutTextXY(200,26,'GUI');
  OutTextXY(199,25,'GUI');
  OutTextXY(201,25,'GUI');
  SetTextStyle(SansSerifFont,HorizDir,2);
  OutTextXY(200,100,'GRAPHICAL USER INTERFACE');
  SetColor(0);
  SetTextStyle(SmallFont,HorizDir,5);
  OutTextXY(200,165,'geschrieben von Markus Birth <mbirth@webwriters.de>');
  SetTextStyle(SmallFont,VertDir,4);
  SetTextJustify(CenterText,TopText);
  SetColor(8);
  OutTextXY(385,2,'(c)1999 Web - Writers');
  SetColor(0);
  SetTextStyle(DefaultFont,HorizDir,1);
  OutTextXY(200,140,'Initialisiere Farbpalette ...');
  Delay(1000);
  InitPalette;
  SetFillStyle(SolidFill,7);
  Bar(0,130,400,150);
  SetTextStyle(DefaultFont,HorizDir,1);
  SetViewPort(0,0,639,479,ClipOff);
  Status('Bitte drÅcken Sie irgendeine Taste (Maus oder Tastatur)');
  ShowMouse(true);
  repeat
    MouseStat(mx,my,mb);
    StatusTime(false);
  until (keypressed) OR (mb<>0);
  if keypressed then ReadKey;
  ShowMouse(false);
  SetFillStyle(SolidFill,desktopcolor);
  Bar(120,140,520,340);
  ClearStatus;
  SetTextStyle(SmallFont,HorizDir,4);
  SetColor(15);
  OutTextXY(570,440,'Beenden durch DrÅcken');
  OutTextXY(570,448,'einer Taste oder beider');
  OutTextXY(570,456,'Maustasten gleichzeitig.');
  MakeWindow(325,5,530,400,'Wegpunkte');
  MakeWindow(50,370,250,460,'Entfernung');
  MakeWindow(5,5,315,365,'Deutschlandkarte');
end;

{ CheckMouse - öberprÅfung der Mausposition und evtl. Subroutinen-AusfÅhrung
  Input:  none
  Output: none }
procedure CheckMouse;
var i: byte;
    over: boolean;
    nst: string;
begin
  if (mb<>0) then begin
    if (NOT buttondown) then ShowMouse(false);
  end else buttondown:=false;
  over := false;
  (* if (mb=0) then Status('X:'+V2S(mx)+' Y:'+V2S(my)); *)
  for i:=1 to 10 do begin
    if MouseOver(cityrp[i].x-5,cityrp[i].y-5,cityrp[i].x+5,cityrp[i].y+5) then begin
      nst:=city[i].n+' (Klicken, um in Wegliste einzufÅgen)';
      if (oldstat<>nst) then Status(nst);
      over := true;
      if (mb=1) AND (NOT buttondown) then begin
        AddWP(i);
        buttondown:=true;
      end;
    end;
  end;
  for i:=1 to WPmax do begin
    if MouseOver(495,22+i*9,520,30+i*9) then begin
      nst:='Klicken, um '+city[WP[i]].n+' aus der Wegliste zu entfernen';
      if (oldstat<>nst) then Status(nst);
      over := true;
      if (mb=1) AND (NOT buttondown) then begin
        RemoveWP(i);
        buttondown:=true;
      end;
    end;
  end;
  if (NOT over) AND (oldstat<>'') then begin
    ClearStatus;
    oldstat:='';
  end;
  if (mb<>0) then ShowMouse(true);
end;

begin
  Mousereset;
  Init;
  StartScreen;
  ShowGermany;
  ShowMouse(true);
  repeat
    MouseStat(mx,my,mb);
    CheckMouse;
  until (keypressed) OR (mb=3);
  if (keypressed) then ReadKey;
  FadeOut;
  Outit;
end.
