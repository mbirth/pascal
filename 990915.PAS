uses Graph, Crt, BGIP;

const input='face.bmp';   { Bitmap x*y*16 }
      firstblock=118;
      blocksize=4095;

var Orig: array[0..blocksize] of byte;
    pos: integer;
    first4: boolean;
    wi,he: longint;
    f: file;
    result: word;
    xmax,ymax: integer;

procedure OpenFile;
begin
  Assign(f,input);
  Reset(f,1);
  BlockRead(f,Orig,SizeOf(Orig),result);
  if (result<>SizeOf(Orig)) AND (result<>FileSize(f) MOD blocksize) then begin
    TextColor(12);
    WriteLn('FEHLER!!');
    TextColor(15);
    WriteLn('Es wurden nur ',result,' Bytes gelesen, statt ',SizeOf(Orig),'.');
    Halt;
  end;
  wi := Orig[19]*256 + Orig[18];
  he := Orig[23]*256 + Orig[22];
  WriteLn('Image size: ',wi,'x',he,' (',(wi*he) DIV 2,' Bytes image data)');
  WriteLn(FileSize(f),' Bytes filesize');
  ReadKey;
  pos := firstblock;
  first4 := true;
end;

procedure GraphInit;
var grDriver, grMode : integer;
begin
  grDriver := VGA;
  { VGAlo     640x200x16
    VGAmed    640x350x16
    VGAhi     640x480x16 }
  grMode   := VGAhi;
  InitGraph(grDriver,grMode,BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
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

function GetNextPixCol: byte;
begin
  if (first4) then begin
    GetNextPixCol := Orig[pos] DIV 16;
    first4 := false;
  end else begin
    GetNextPixCol := Orig[pos] MOD 16;
    first4 := true;
    Inc(pos);
  end;
  if (pos>blocksize) then begin
    BlockRead(f,Orig,SizeOf(Orig),result);
    if (result<>SizeOf(Orig)) AND (result<>FileSize(f) MOD (blocksize+1)) AND (result<>0) then begin
      CloseGraph;
      TextMode(co80);
      TextColor(12);
      WriteLn('FEHLER!!');
      TextColor(15);
      WriteLn('Es wurden nur ',result,' Bytes gelesen, statt ',SizeOf(Orig),'.');
      Halt;
    end;
    pos := 0;
  end;
end;

procedure ShowGraph;
var i,j: integer;
begin
  for j:=he downto 1 do
    for i:=1 to wi+6 do begin
{      WriteLn(i,'x',j,'- ',GetNextPixCol); }
      PutPixel(i,j,BMP2CRT(GetNextPixCol));
    end;
end;

begin
  OpenFile;
  Graphinit;
  ShowGraph;
  ReadKey;

end.
