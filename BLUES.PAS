program BlueS;

uses Crt;

const FILEZ:array[0..27] of string=('atapi.sys','Disk.sys','Ntfs.sys','Cdrom.SYS','Null.SYS','Beep.SYS',
             'i8042prt.sys','kbdclass.sys','s3mini.sys','Msfs.SYS','NDIS.SYS',
             's3trio3d.dll','FSFILTER.SYS','FSAVP.SYS','nbf.sys','Floppy.SYS',
             'CLASS2.SYS','SCSIPORT.SYS','win32k.sys','Cdfs.SYS','Fastfat.SYS',
             'hcioPort.SYS','ParVdm.SYS','Parport.SYS','afd.sys','netbt.sys',
             'nwlnkb.sys','###');

var FILEZc: integer;
    exitnow: boolean;
    oldhex: string;

procedure Init;
var i: integer;
begin
  exitnow := false;
  i := 0;
  repeat
    Inc(i);
  until (FILEZ[i]='###');
  FILEZc := i;
  Randomize;
  TextMode(co80 + Font8x8);
  TextColor(7);
  TextBackground(1);
  ClrScr;
end;

procedure Outit;
begin
  GotoXY(1,1);
  if NOT (exitnow) then ReadKey;
end;

procedure RandHex(x,y: integer; pre, cap, lowonly, old: boolean);
const HexSet:string='0123456789abcdef';
var i,mx: integer;
begin
  GotoXY(x,y);
  if (pre) then Write('0x');
  if (lowonly) then begin
    Write('0000');
    mx := 4;
  end else mx := 8;
  if (NOT old) then begin
    oldhex := '';
    for i:=1 to mx do oldhex := oldhex + HexSet[Random(16)+1];
  end;
  if (cap) then for i:=1 to Length(oldhex) do Write(UpCase(oldhex[i])) else Write(oldhex);
end;

procedure RandFile(x,y: integer);
begin
  GotoXY(x,y);
  Write(FILEZ[Random(FILEZc)]);
end;

procedure Mask;
var i: integer;
begin
  GotoXY(1,6);
  Write('CPUID:');
  i := Random(3)+1;
  case i of
    1: Write('AuthenticAMD');
    2: Write('IntelInside');
    3: Write('CyrixInstead');
  end;
  Write(' 5.8.c irql:1f ');
  i := Random(2);
  if (i=1) then Write('DPC ');
  Write('SYSVER 0xoooooooo');
  RandHex(WhereX-10,6,true,false,false,false);
  GotoXY(1,8);
  Write('Dll Base DateStmp - Name               Dll Base DateStmp - Name');
  GotoXY(1,35);
  Write('Address  dword dump   Build [1381]                           - Name');
end;

procedure FillOutError;
begin
  begin
    GotoXY(1,2);
    WriteLn('*** STOP: 0xoooooooo (0xoooooooo, 0xoooooooo, 0xoooooooo, 0xoooooooo)');
    WriteLn('IRQL_NOT_LESS_OR_EQUAL*** Address oooooooo has base at oooooooo - ');
    RandHex(11,2,true,true,true,false);
    RandHex(23,2,true,true,false,false);
    RandHex(35,2,true,true,true,false);
    RandHex(47,2,true,true,true,false);
    RandHex(59,2,true,true,false,false);
    RandHex(35,3,false,false,false,true);
    RandHex(56,3,false,false,false,false);
    RandFile(67,3);
  end;
end;

procedure FillOutDlls;
var c,x: integer;
    done: boolean;
begin
  GotoXY(1,9);
  for c:=1 to 25 do begin
    done := false;
    repeat
      if (done) then x:=40 else x:=1;
      GotoXY(x,WhereY);
      RandHex(WhereX,WhereY,false,false,false,false);
      Write(' ');
      RandHex(WhereX,WhereY,false,false,false,false);  { DATUM }
      Write(' - ');
      RandFile(WhereX,WhereY);
      done := true;
    until ((done) AND (x=40));
    WriteLn;
  end;
end;

procedure FillOutDump;
var c,i: integer;
begin
  GotoXY(1,36);
  for c:=1 to 10 do begin
    for i:=1 to 7 do begin
      RandHex(WhereX,WhereY,false,false,false,false);
      Write(' ');
    end;
    Write('- ');
    if (c=1) then Write('ntoskrnl.exe') else RandFile(WhereX,WhereY);
    WriteLn;
  end;
end;

procedure MemDump;
var i: integer;
begin
  i := 0;
  GotoXY(1,47);
  WriteLn('Beginnen des Speicherabbildes');
  Write('Speicher wird auf Datentr„ger abgebildet: ');
  for i:=1 to 100 do begin
    GotoXY(43,48);
    Write(i:3);
    GotoXY(1,1);
    Delay(Random(300)+250);
    if (keypressed) then begin
      ReadKey;
      exitnow := true;
      Exit;
    end;
  end;
  GotoXY(1,48);
  WriteLn('Speicherabbild abgeschlossen. Wenden Sie sich an den Systemadministrator');
  Write('oder einen Techniker.');
end;

begin
  Init;
  Mask;
  FillOutError;
  FillOutDlls;
  FillOutDump;
  MemDump;
  Outit;
end.
