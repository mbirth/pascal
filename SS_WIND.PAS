program ScreenSaver_Windows;

uses Crt;

const chars: string=' °±²ÛþÜÝÞß#';  { chars for use to fill windows }
      del=100;                            { delay between windows }

var x1, y1: integer;
    x2, y2: integer;
    rfc, rbc: integer;
    usech: integer;

procedure Initialize;
begin
  TextMode(3+256);  { Goes to 80x50 mode (for more windows ;-) }
end;

procedure Shutdown; { resets all changes }
begin
  TextMode(3);
  Window(1,1,80,25);
  TextColor(7);
  TextBackground(0);
end;

procedure GetRandomPos;
var tv: integer;
begin
  x1:=Random(81); { Get some coordinates from tha nice randomizer }
  x2:=Random(81);
  y1:=Random(51);
  y2:=Random(51);
  if x1>x2 then begin { did you hear that x1 is greater than x2? }
    tv := x2;
    x2 := x1;
    x1 := tv;
  end;
  if y1>y2 then begin { or even that y1 is greater than y2? }
    tv := y2;
    y2 := y1;
    y1 := tv;
  end;
end;

procedure GetRandomColors;
begin
  rfc:=Random(16); { which color do we want to use? }
  rbc:=Random(16); { and behind those little chars? }
end;

procedure GetRandomChar;
begin
  usech:=Random(Length(chars))+1; { What chars? }
end;

procedure DrawWindow;
var x: integer;
begin
  window(x1,y1,x2,y2); { This has nothing to do with MICROSHITs product }
  GotoXY(1,1); { go to the upper left corner }
  TextColor(rfc); { tell the bios which color to use.... }
  TextBackground(rbc);
  for x:=1 to (x2-x1+1)*(y2-y1+1)-(x2-x1+1) do Write(chars[usech]); { fill all with those nice little chars...hehe }
end;

begin
  Initialize;  { set videomode }
  repeat
    GetRandomPos; { get some coordinates }
    GetRandomColors; { get some colors }
    GetRandomChar; { get the pos of the right char }
    DrawWindow; { make such a nice window }
    Delay(del); { wait a sec.... }
    Randomize; { reinitialize randomizer }
  until keypressed; { heeeeree weee gooo agaaaiiinn ..... }
  Shutdown; { shut all down - restore vidmode }
end.