program RekGUI;

uses Crt, Graph, DOS, GUI, RekGraph;

const desktopcolor=3;
      skier_len: integer=120;
      skier_edge: integer=10;
      skier_globangle: integer=0;
      skier_fixedinit: boolean=true;
      haken_len: integer=150;
      haken_angle: integer=45;
      haken_globangle: integer=0;
      haken_fixedinit: boolean=true;
      quadrat_len: integer=150;
      quadrat_angle: integer=90;
      quadrat_globangle: integer=0;
      quadrat_fixedinit: boolean=true;
      spirale_len: integer=10;
      spirale_angle: integer=25;
      spirale_globangle: integer=0;
      spirale_fixedinit: boolean=true;

var xmax, ymax, xmed, ymed: word;
    ExitAll, ExitSetupAll: boolean;

procedure Init;
var grDriver, grMode: integer;
    BGIPath: string;
begin
  grDriver := VGA;
  grMode   := VGAHi;
  initp_del := 30;
  BGIPath  := '..\..\BGI\';
  InitGraph(grDriver, grMode, BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmhîhe in Pixeln }
  xmed := xmax DIV 2;
  ymed := ymax DIV 2;
  om := 0;
  ExitAll := false;
  ExitSetupAll := false;
  SetTextStyle(DefaultFont,HorizDir,1);
  SetTextJustify(LeftText,TopText);
  SetFillStyle(SolidFill,desktopcolor);
  Bar(0,0,xmax-1,ymax-1);
  ClearStatus;
end;

procedure InitGraphs;
begin
  skier_del := 50;
  haken_del := 50;
  quadrat_del := 100;
  spirale_del := 50;
end;

procedure Outit;
begin
  TextMode(CO80);
  WriteLn('VMode : ',xmax,'x',ymax);
  WriteLn('Center: ',xmed,'x',ymed);
  WriteLn;
  WriteLn('Programm beendet.');
end;

function V2S(x: byte): string;
var tmp: string;
begin
  Str(x:3,tmp);
  V2S := tmp;
end;

procedure ShowSkier;
begin
  globangle := skier_globangle;
  SetViewPort(13,31,497,397,ClipOn);
  MoveTo(180,370);
  Skier(skier_len,skier_edge);
  SetViewPort(0,0,639,479,ClipOff);
end;

procedure ShowHaken;
begin
  globangle := haken_globangle;
  SetViewPort(13,31,497,397,ClipOn);
  MoveTo(240,180);
  Haken(haken_len,haken_angle);
  SetViewPort(0,0,639,479,ClipOff);
end;

procedure ShowQuadrat;
begin
  globangle := haken_globangle;
  SetViewPort(13,31,497,397,ClipOn);
  MoveTo(240,180);
  Quadrat(quadrat_len,quadrat_angle);
  SetViewPort(0,0,639,479,ClipOff);
end;


procedure ShowSpirale;
begin
  globangle := spirale_globangle;
  SetViewPort(13,31,497,397,ClipOn);
  MoveTo(240,180);
  Spirale(spirale_len,spirale_angle);
  SetViewPort(0,0,639,479,ClipOff);
end;

procedure Palette;
const tx=50;
      ty=31;
var i,j: integer;
begin
  for j:=1 to 16 do begin
    SetTextJustify(RightText,CenterText);
    SetColor(0);
    OutTextXY(tx,ty+(j-1)*10+5,V2S((j-1)*16));
    for i:=0 to 15 do begin
      SetFillStyle(SolidFill,(j-1)*16+i);
      SetColor((j-1)*15+i);
      Bar(tx+i*10,ty+(j-1)*10,tx+i*10+10,ty+(j-1)*10+10);
    end;
    SetTextJustify(LeftText,CenterText);
    SetColor(0);
    OutTextXY(tx+162,ty+(j-1)*10+5,V2S((j-1)*16+15));
  end;
end;

procedure CheckSetupStat;
begin
  if (mb<>0) then ShowMouse(false);
  if MouseOver(15,405,525,425) then begin
    Status('Hiermit wird die Konfiguration so gespeichert');
    case mb of
      1: begin
           ExitSetupAll := true;
         end;
    end;
  end else if MouseOver(527,405,625,425) then begin
    Status('Hier geht''s nach Hause!');
    case mb of
      1: begin
           MakeBeveledButton(527,405,625,425,'EXIT');
           ExitSetupAll:=true;
           ExitAll:=true;
           Delay(buttondelay);
           MakeButton(527,405,625,425,'EXIT');
           Exit;
         end;
    end;
  end else if (oldstat<>'') then begin
      ClearStatus;
      oldstat:='';
  end;
  if (mb<>0) then ShowMouse(true);
end;

procedure SetupData;
var sx,sy,sb: integer;
begin
  MakeWindow(10,10,630,430,'Konfiguration');
  MakeButton(15,405,525,425,'Einstellungen so Åbernehmen');
  MakeButton(527,405,625,425,'EXIT');
  ShowMouse(true);
  repeat
    MouseStat(mx,my,mb);
    CheckSetupStat;
    StatusTime(false);
  until (mb=3) OR (ExitSetupAll);
  if (mb=3) then ExitAll := true;
  ShowMouse(false);
end;

procedure BuildWindows;
begin
  MakeWindow(10,10,500,400,'Hauptfenster');
  MakeWindow(505,10,600,400,'Optionen');
  MakeButton(510,385,595,395,'EXIT');
  MakeButton(510,373,595,383,'CLEAR');
  MakeButton(510,34,595,54,'Skierp.');
  MakeButton(510,56,595,76,'Haken');
  MakeButton(510,78,595,98,'Quadrat');
  MakeButton(510,100,595,120,'Spirale');
  MakeButton(510,350,595,371,'SETUP');
end;

procedure CheckStat;
begin
  if (mb<>0) then ShowMouse(false);
  if MouseOver(510,385,595,395) then begin
    Status('Hier geht''s nach Hause!');
    case mb of
      1: begin
           MakeBeveledButton(510,385,595,395,'EXIT');
           ExitAll:=true;
           Delay(buttondelay);
           MakeButton(510,385,595,395,'EXIT');
           Exit;
         end;
    end;
  end else if MouseOver(510,373,595,383) then begin
    Status('Damit wird das Hauptfenster gelîscht!');
    case mb of
      1: begin
           MakeBeveledButton(510,373,595,383,'CLEAR');
           SetFillStyle(SolidFill,7);
           Bar(13,31,497,397);
           Delay(buttondelay);
           MakeButton(510,373,595,383,'CLEAR');
         end;
    end;
  end else if MouseOver(510,350,595,371) then begin
    Status('Hier kann man die Einstellungen Ñndern!');
    case mb of
      1: begin
           MakeBeveledButton(510,350,595,371,'SETUP');
           SetFillStyle(SolidFill,desktopcolor);
           Bar(10,10,500,400);
           Delay(buttondelay DIV 2);
           Bar(505,10,600,400);
           Delay(buttondelay DIV 2);
           ExitSetupAll := false;
           SetupData;
           if NOT ExitAll then begin
             SetFillStyle(SolidFill,desktopcolor);
             Bar(10,10,630,430);
             BuildWindows;
           end;
         end;
    end;
  end else if MouseOver(510,34,595,54) then begin
    Status('FÅr unsere Wintersportler!');
    case mb of
      1: begin
           MakeBeveledButton(510,34,595,54,'Skierp.');
           ShowSkier;
           Delay(buttondelay);
           MakeButton(510,34,595,54,'Skierp.');
         end;
    end;
  end else if MouseOver(510,56,595,76) then begin
    Status('Und das ist fÅr die Angler!');
    case mb of
      1: begin
           MakeBeveledButton(510,56,595,76,'Haken');
           ShowHaken;
           Delay(buttondelay);
           MakeButton(510,56,595,76,'Haken');
         end;
    end;
  end else if MouseOver(510,78,595,98) then begin
    Status('Sehen Sie schon viereckig?');
    case mb of
      1: begin
           MakeBeveledButton(510,78,595,98,'Quadrat');
           ShowQuadrat;
           Delay(buttondelay);
           MakeButton(510,78,595,98,'Quadrat');
         end;
    end;
  end else if MouseOver(510,100,595,120) then begin
    Status('Ist was verstopft?');
    case mb of
      1: begin
           MakeBeveledButton(510,100,595,120,'Spirale');
           ShowSpirale;
           Delay(buttondelay);
           MakeButton(510,100,595,120,'Spirale');
         end;
    end;
  end else if (oldstat<>'') then begin
      ClearStatus;
      oldstat:='';
  end;
  if (mb<>0) then ShowMouse(true);
end;

procedure StartScreen;
begin
  MakeWindow(120,140,520,340,'Rekursive Grafikfunktionen');
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
end;

begin
  Init;
  InitGraphs;
  StartScreen;
  BuildWindows;
  MouseReset;
  ShowMouse(true);
  repeat
    MouseStat(mx,my,mb);
    CheckStat;
    StatusTime(false);
  until (mb=3) OR (ExitAll);
  ShowMouse(false);
  FadeOut;
  Outit;
end.
