program DelTemp;

uses Crt, DOS;

type Tpb = record
             x: word;
             y: word;
           end;

const level: byte = 0;
      border: record
                frame: string[6];
                width, height: word;
              end = (frame:'É»È¼ºÍ';width:80;height:4);
      ac: byte = 1;
      dircount: integer = 1;
      filcount: integer = 1;

var TempDir: string[40];
    screen: array[1..50, 1..80, 1..2] of byte absolute $b800:0000;
    pb: Tpb;

procedure Abort_NoTempFound;
begin
  TextColor(12);
  WriteLn('Temporary Directory not found. Check your Envvars TEMP and/or TMP!');
  TextColor(7);
  Halt(1);
end;

procedure Abort_FileLocked(f: string);
begin
  WriteLn('Oooops with ',f,'. Exiting...');
  Halt(2);
end;

procedure DrawBorder;
var i: integer;
begin
  screen[WhereY,1,1] := Ord(border.frame[1]);
  for i:=2 to border.width-1 do screen[WhereY,i,1] := Ord(border.frame[6]);
  screen[WhereY,border.width,1] := Ord(border.frame[2]);
  WriteLn;
  for i:=2 to border.height-1 do begin
    screen[WhereY,1,1] := Ord(border.frame[5]);
    screen[WhereY,border.width,1] := Ord(border.frame[5]);
    WriteLn;
  end;
  screen[WhereY,1,1] := Ord(border.frame[3]);
  for i:=2 to border.width-1 do screen[WhereY,i,1] := Ord(border.frame[6]);
  screen[WhereY,border.width,1] := Ord(border.frame[4]);
  WriteLn;
  pb.x := 1;
  pb.y := WhereY-border.height;
end;

procedure UpdatePb;
const e=0;
      d=7;
var i: integer;
    c: byte;
begin
  c := ac;
  Inc(ac);
  if ac>3 then ac:=1;
  for i:=1 to border.width do begin
    if (c=3) then screen[pb.y,i,2] := d else screen[pb.y,i,2] := e;
    Dec(c);
    if c<1 then c:=3;
  end;
  for i:=1 to border.height-2 do begin
    if (c=3) then screen[pb.y+i,border.width,2] := d else screen[pb.y+i,border.width,2] := e;
    Dec(c);
    if c<1 then c:=3;
  end;
  for i:=border.width downto 1 do begin
    if (c=3) then screen[pb.y+border.height-1,i,2] := d else screen[pb.y+border.height-1,i,2] := e;
    Dec(c);
    if c<1 then c:=3;
  end;
  for i:=border.height-2 downto 1 do begin
    if (c=3) then screen[pb.y+i,1,2] := d else screen[pb.y+i,1,2] := e;
    Dec(c);
    if c<1 then c:=3;
  end;
end;

procedure RestorePb;
var i: word;
begin
  for i:=1 to border.width do begin
    screen[pb.y,i,2] := 7;
    screen[pb.y+border.height-1,i,2] := 7;
  end;
  for i:=1 to border.height-2 do begin
    screen[pb.y+i,1,2] := 7;
    screen[pb.y+i,border.width,2] := 7;
  end;
end;

function IS(f: SearchRec; a: byte): boolean;
var tmp: byte;
begin
  tmp := f.Attr AND a;
  if (tmp=a) then IS := true else IS := false;
end;

procedure WritePathInfo(x: string;l: integer);
var out: string[69];
    i: integer;
begin
  GotoXY(pb.x+9,pb.y+1);
  Str(level:0,out);
  out := '['+out+'] '+x+'\';
  for i:=Length(out) to 69 do out := out + ' ';
  Write(out);
end;

function LZ(x: integer): string;
var tmp: string;
begin
  Str(x:0,tmp);
  if Length(tmp)<2 then tmp := '0'+tmp;
  LZ := tmp;
end;

procedure WriteFileInfo(f: SearchRec);
var i,j: integer;
    tm: DateTime;
begin
  GotoXY(pb.x+9,pb.y+2);
  for i:=Length(f.Name) downto 1 do begin
    if f.Name[i]='.' then begin
      Write(Copy(f.Name,1,i-1));
      for j:=i to 9 do Write(' ');
      Write(Copy(f.Name,i+1,Length(f.Name)-i));
    end;
  end;
  GotoXY(22,WhereY);
  Write(f.Size:9,' ');
  if IS(f,Directory) then Write('D')
    else if IS(f,VolumeID) then Write('V')
    else Write('-');
  if IS(f,Archive) then Write('A') else Write('-');
  if IS(f,Hidden) then Write('H') else Write('-');
  if IS(f,ReadOnly) then Write('R') else Write('-');
  if IS(f,SysFile) then Write('S') else Write('-');
  Write(' ');
  UnpackTime(f.Time,tm);
  Write(LZ(tm.Day)+'.'+LZ(tm.Month)+'.',tm.Year,' '+LZ(tm.Hour)+':'+LZ(tm.Min)+'.'+LZ(tm.Sec));
end;

procedure ParseDirRec(x: string);
var DC: SearchRec;
    f: file;
begin
  Inc(level);
  Inc(dircount);
  WritePathInfo(x,level);
  FindFirst(x+'\*.*',AnyFile,DC);
  while DosError=0 do begin
    UpdatePb;
    Delay(50);
    if (DC.Name<>'.') AND (DC.Name<>'..') then begin
      WriteFileInfo(DC);
      if IS(DC,Directory) then begin
        ParseDirRec(x+'\'+DC.Name);
        WritePathInfo(x,level);
        { RmDir(x+'\'+DC.Name); }
      end else begin
        Assign(f,x+'\'+DC.Name);
        if (IS(DC,ReadOnly)) OR (IS(DC,Hidden)) OR (IS(DC,SysFile)) then SetFAttr(f,Archive);
        if DosError=5 then begin
          Abort_FileLocked(x+'\'+DC.Name);
        end;
        Inc(filcount);
        { Erase(f); }
      end;
    end;
    FindNext(DC);
  end;
  Dec(level);
end;

procedure WriteFinalStats;
var i: integer;
begin
  for i:=2 to 79 do begin
    screen[pb.y+1,i,1] := 32;
    screen[pb.y+2,i,1] := 32;
  end;
  GotoXY(pb.x+2,pb.y+1); Write('Directories parsed: ',dircount);
  GotoXY(pb.x+2,pb.y+2); Write('Files deleted: ',filcount);
end;

begin
  WriteLn('-=+ TempClear +=-                 (c)2000 by Markus Birth <mbirth@webwriters.de>');
  TempDir := GetEnv('TEMP');
  if TempDir='' then TempDir := GetEnv('TMP');
  if TempDir='' then Abort_NoTempFound;
  GotoXY(1,WhereY-1);
  DrawBorder;
  GotoXY(pb.x+2,pb.y+1); Write(' Path:');
  GotoXY(pb.x+2,pb.y+2); Write('Entry:');
  ParseDirRec(TempDir);
  RestorePb;
  WriteFinalStats;
  GotoXY(1,pb.y+border.height);
end.
