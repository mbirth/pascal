uses Crt;

const input='test.bmp'; { 80x49x16 Bitmap }

var Data: array[1..80,1..98] of byte;
    Orig: array[0..4096] of byte;
    pos: integer;
    first4: boolean;

function GetNext: byte;
begin
  if (first4) then begin
    GetNext := Orig[pos] DIV 16;
    first4 := false;
  end else begin
    GetNext := Orig[pos] MOD 16;
    first4 := true;
    Inc(pos);
  end;
end;

procedure LoadFile;
const Datadelta=118;
var f: File;
    result: word;
    i,j: integer;
begin
  Assign(f, input);
  Reset(f);
  BlockRead(f, Orig, FileSize(f), result);
  if (result<>FileSize(f)) then begin
    TextColor(12);
    WriteLn('FEHLER!');
    TextColor(15);
    WriteLn('Es wurden nur ',result,' Bytes von ',FileSize(f),' gelesen.');
    ReadKey;
  end;
  if (Orig[18]<>80) OR (Orig[22]<>98) then begin
    TextColor(12);
    WriteLn('FEHLER!');
    TextColor(15);
    WriteLn('Die zu ladende BMP-Datei ist nicht im Format 80x98!');
    WriteLn(input,': ',Orig[18],'x',Orig[22]);
    Halt;
  end;
  first4 := true;
  pos := Datadelta;
  for i:=98 downto 1 do
    for j:=1 to 80 do
      Data[j,i] := GetNext;
end;

function BMP2CRT(x: byte): byte;
begin
  case x of
    0: BMP2CRT:=0;
    1: BMP2CRT:=4;
    2: BMP2CRT:=2;
    3: BMP2CRT:=6;
    4: BMP2CRT:=1;
    5: BMP2CRT:=5;
    6: BMP2CRT:=3;
    7: BMP2CRT:=8;
    8: BMP2CRT:=7;
    9: BMP2CRT:=12;
   10: BMP2CRT:=10;
   11: BMP2CRT:=14;
   12: BMP2CRT:=9;
   13: BMP2CRT:=13;
   14: BMP2CRT:=11;
   15: BMP2CRT:=15;
  else
    BMP2CRT:=x;
  end;
end;

procedure ShowFile;
var i,j: integer;
    c1,c2: byte;
begin
  for i:=1 to 49 do
    for j:=1 to 80 do begin
      GotoXY(j,i);
      c1 := Data[j,i*2-1];
      c2 := Data[j,i*2];
      { if (c1>7) then c1 := c1-8;
      if (c2>7) then c2 := c2-8; }
      TextColor(BMP2CRT(c1));
      TextBackground(BMP2CRT(c2));
      Write('ß');
    end;
end;

begin
  TextMode(co80 + Font8x8);
  TextColor(15);
  TextBackground(0);
  ClrScr;
  LoadFile;
  ShowFile;


end.