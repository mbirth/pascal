program Exploder;

{
  #016 > filled
  #017 < filled

}

uses Crt, DOS, Numbers, VFx;

const StartPath='.\';

var cur: SearchRec;


procedure Init;
begin
  TextMode(co80 + Font8x8);
  TextBackground(0);
  TextColor(7);
end;

procedure SWindow(x1,y1,x2,y2: integer; fg, bg: byte; BType: byte);
var i,j: integer;
    Border: string[8];
begin
  if BType=1 then Border := 'Ú¿ÀÙ³³ÄÄ';
  if BType=2 then Border := 'É»È¼ººÍÍ';
  if BType=3 then Border := 'Õ¸Ô¾³³ÍÍ';
  if BType=4 then Border := 'Ö·Ó½ººÄÄ';
  if BType=5 then Border := 'ÛÛÛÛÛÛßÜ';
  if BType=6 then Border := 'Ú·Ô¼³ºÄÍ';
  DWrite(x1,y1,fg,bg,Border[1]);
  DWrite(x2,y1,fg,bg,Border[2]);
  DWrite(x1,y2,fg,bg,Border[3]);
  DWrite(x2,y2,fg,bg,Border[4]);
  for i:=y1+1 to y2-1 do begin
    DWrite(x1,i,fg,bg,Border[5]);
    DWrite(x2,i,fg,bg,Border[6]);
  end;
  for i:=x1+1 to x2-1 do begin
    DWrite(i,y1,fg,bg,Border[7]);
    DWrite(i,y2,fg,bg,Border[8]);
  end;
  for i:=x1+1 to x2-1 do
    for j:=y1+1 to y2-1 do begin
      DWrite(i,j,fg,bg,' ');
    end;
end;

procedure TurnAround(var x: string);
var i: integer;
    tmp: string;
begin
  tmp := '';
  for i:=Length(x) downto 1 do begin
    tmp := tmp + x[i];
  end;
  x := tmp;
end;

function GetName(x: string): string;
var i: byte;
    it: boolean;
begin
  it := false;
  if (x[1]='.') then begin
    GetName:=x;
    Exit;
  end;
  for i:=1 to Length(x) do
    if x[i]='.' then begin
      GetName := Copy(x,1,i-1);
      it := true;
    end;
  if NOT it then GetName := x;
end;

function GetExt(x: string): string;
var i: byte;
    it: boolean;
begin
  it := false;
  for i:=1 to Length(x) do
    if x[i]='.' then begin
      GetExt := Copy(x,i+1,Length(x)-i);
      it := true;
    end;
  if NOT it then GetExt := '';
end;


function Fill(x: string): string;
var i: byte;
    tmp: string;
begin
  tmp := '';
  for i:=Length(GetName(x))+1 to 8 do tmp := tmp + ' ';
  Fill := tmp;
end;

function Fill2(x: string): string;
var i: byte;
    tmp: string;
begin
  tmp := '';
  for i:=Length(GetExt(x))+1 to 3 do tmp := tmp + ' ';
  Fill2 := tmp;
end;


{ Attribute list in binary

  1st ReadOnly
  2nd Hidden
  3rd System
  4th VolumeID
  5th Directory
  6th Archive
  7th AnyFile }

procedure Add(var x: string; y: string);
begin
  x := x + y;
end;

procedure WriteFile(f: SearchRec); forward;

procedure List;
var binattr: string;
    strattr: string;
begin
{  ChDir(StartPath); }
  FindFirst('*.*',AnyFile,cur);
  while DosError<>18 do begin
    binattr := Dec2Bin(cur.attr);
    TurnAround(binattr);
    if (binattr[5]='1') then TextColor(15)
      else if (binattr[2]='1') then TextColor(8)
      else if (binattr[3]='1') then TextColor(12)
      else if (binattr[1]='1') then TextColor(10)
      else if (binattr[4]='1') then TextColor(11)
      else TextColor(7);
    WriteFile(cur);
    WriteLn;
    FindNext(cur);
  end;
end;

procedure WriteFile(f: SearchRec);
var binattr: string;
    strattr: string;
begin
  binattr := Dec2Bin(cur.attr);
  TurnAround(binattr);
  strattr := '';
  if (binattr[5]='1') then Add(strattr,'D') else
    if (binattr[4]='1') then Add(strattr,'V') else Add(strattr,'-');
  if (binattr[6]='1') then Add(strattr,'A') else Add(strattr,'-');
  if (binattr[1]='1') then Add(strattr,'R') else Add(strattr,'-');
  if (binattr[2]='1') then Add(strattr,'H') else Add(strattr,'-');
  if (binattr[3]='1') then Add(strattr,'S') else Add(strattr,'-');

  Write(GetName(cur.name),Fill(cur.name),' ',GetExt(cur.name),Fill2(cur.name),'³');
  if (binattr[5]='1') then Write(#017,' DIR ',#016) else
    if (binattr[4]='1') then Write(#017,' VOL ',#016) else Write(cur.size:7);
  Write('³',strattr);
end;

begin
  Init;
  SWindow(1,1,80,50,15,1,2);
  Window(3,2,78,49);
  List;
end.
