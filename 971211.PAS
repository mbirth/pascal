program Zeitvertreib111297;

uses Crt;

var Warschon: array[1..80, 1..50] of boolean;
    Randx: integer;
    Randy: integer;
    loc: integer;

label Hier;

const Chars: string = '€‹ﬂ '; {±≤∞';}
      xmax = 80;
      ymax = 49;
      del  = 0;

procedure Init;
var i,j: integer;
begin
  TextBackground(black);
  Randomize;
  for i:=1 to xmax do begin
    for j:=1 to ymax do begin
      Warschon[i,j] := False;
    end;
  end;
  loc := Length(Chars);
end;

procedure GetRandomNumbers;
label Hier2;
begin
Hier2:
  Randx := Random(xmax) + 1;
  Randy := Random(ymax) + 1;
  if Warschon[randx,randy] then goto Hier2;
end;

function GetRandomChar: string;
var rand: integer;
begin
  rand := Random(loc) + 1;
  GetRandomChar := Chars[rand];
end;

function Check: boolean;
var i,j: integer;
begin
  Check := False;
  for i:=1 to xmax do begin
    for j:=1 to ymax do begin
      if Warschon[i,j]=False then begin
        Check:=True;
        Exit;
      end;
    end;
  end;
end;

procedure WritePix(x,y: integer);
begin
  GotoXY(x,y);
  TextColor(Random(16));
  TextBackground(Random(16));
  Write(GetRandomChar);
  Warschon[x,y] := true;
end;

begin
  TextMode(CO80 + Font8x8);
  ClrScr;
  Init;
Hier:
  GetRandomNumbers;
  WritePix(randx,randy);
  Delay(del);
  if keypressed then exit;
  if Check then goto Hier;
  Init;
  goto Hier;
  GotoXY(1,1);
  ReadKey;
end.