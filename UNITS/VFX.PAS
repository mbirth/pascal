unit VFx; { Visual Effects - by RoboCop of nOOb <Robo.Cop@gmx.net>}

interface
  uses Crt;
  type pathstr=string[79];
  const drwdmax: integer=1000;
        fxwd: integer=750;
        crlf: string=Chr(10)+Chr(13);
  var CenterPos, CWS: byte;
  procedure SetBackLight(on: boolean);
  procedure DWrite(x,y,fg,bg: byte; c: char);
  procedure ReadyBeep;
  procedure WaitBeep;
  procedure ErrorBeep;
  procedure AckBeep;
  procedure WinBeep;
  procedure DrawBorder(MaxX,MaxY: integer; TCol,BCol: integer; BType: integer);
  procedure DrawBorder2(x1,y1,x2,y2,FG,BG: byte);
  procedure Alert(text: string);
  procedure FXWrite(text: string; finc: integer);
  procedure FXChar(ch: string; finc: integer);
  procedure FXWriteC(text: string; finc: integer);
  procedure WriteFlt(txt: string);
  procedure CWrite(st: string);
  procedure CWriteLn(st: string);
  procedure WriteC(st: string);
  procedure WriteCLn(st: string);
  procedure CursorOff;
  procedure CursorOn;
  procedure WStat(opt: string);
  procedure Wcheck(stat: string);
  function Space(len: integer): string;
  function Num2Str(x: longint): string;
  function MultiChar(ch: string; len: integer): string;
  procedure TWriteLn(tx: string);
  procedure WriteLR(st: string; col: integer);
  procedure WriteImp(txt: string);
  procedure WriteExp(txt: string);
  procedure SaveScreen;
  procedure RestoreScreen;
  procedure WriteScreen(FName: pathstr);
  procedure ReadScreen(FName: pathstr);

implementation

uses Dos;

var screen: array[1..50, 1..80, 1..2] of byte absolute $b800:0000;
    ScrSeg: word;
    ScrBuff: Pointer;
    x1,y1,x2,y2: integer;

procedure InitWindow;
begin
  x1 := Lo(WindMin);
  y1 := Hi(WindMin);
  x2 := Lo(WindMax);
  y2 := Hi(WindMax);
  CenterPos := (x2-x1+1) DIV 2;
end;

procedure Alert(text: string);
var msg: string;
    ta: byte;
    cx,cy: word;
begin
  ta := TextAttr;
  cx := WhereX;
  cy := WhereY;
  InitWindow;
  WriteScreen('1046rtl.buf');
  window(1,1,80,25);
  drwdmax := 0;
  DrawBorder2(20,5,60,20,15,4);
  GotoXY(22,6); Write(x1+1,',',y1+1,'/',x2+1,',',y2+1);
  msg := '--==+ ALERT +==--';
  GotoXY(40-(Length(msg) DIV 2),7); Write(msg);
  window(22,9,58,18);
  Write(text);
  ReadKey;
  window(x1+1,y1+1,x2+1,y2+1);
  ReadScreen('1046rtl.buf');
  drwdmax := 1000;
  TextAttr := ta;
  GotoXY(cx,cy);
end;

function WindowWidth: integer;
begin
  InitWindow;
  WindowWidth := x2-x1+1;
end;

procedure SetBackLight(on: boolean); { true=helle BG-Farben, false=Blinken }
var regs: registers;
begin
  regs.ax := $1003;
  regs.bl := byte(NOT on);
  intr($10,regs);
end;

procedure DWrite(x,y,fg,bg: byte; c: char);
begin
  screen[y,x,1] := Ord(c);
  screen[y,x,2] := bg * 16 + fg;
end;

procedure WinBeep;
  begin
    Sound(1000);
    Delay(100);
    NoSound;
    Delay(200);
    Sound(1000);
    Delay(50);
    NoSound;
    Delay(100);
    Sound(1000);
    Delay(50);
    NoSound;
    Delay(100);
    Sound(1400);
    Delay(750);
    NoSound;
  end;

procedure ReadyBeep; { inspired by Norton Speed Disk for DOS }
  begin
    Sound(800);
    Delay(50);
    NoSound;
    Delay(50);
    Sound(1000);
    Delay(50);
    NoSound;
    Delay(50);
    Sound(1200);
    Delay(50);
    NoSound;
  end;

procedure WaitBeep; { inspired by the GameBoy-Game "Tetris" }
  var i: integer;
  begin
    for i:=1 to 2 do begin
      Sound(720);
      Delay(70);
      NoSound;
      Delay(70);
      Sound(1500);
      Delay(70);
      NoSound;
      Delay(70);
    end;
  end;

procedure ErrorBeep;
  begin
    Sound(100);
    Delay(200);
    NoSound;
  end;

procedure AckBeep;
  begin
    Sound(1200);
    Delay(25);
    NoSound;
  end;

procedure DrawBorder(MaxX,MaxY: integer; TCol, BCol: integer; BType: integer);
  var i,j: integer;
      lx,rx,oy,uy,mx,my: integer;
      DrwDelay, FilDelay: integer;
      Border: string[8];
  begin
    CursorOff;
    window(1,1,80,25);
    if (MaxX=0) AND (MaxY=0) AND (TCol=0) AND (BCol=0) then Exit;
    if BType=1 then Border := 'Ú¿ÀÙ³³ÄÄ';
    if BType=2 then Border := 'É»È¼ººÍÍ';
    if BType=3 then Border := 'Õ¸Ô¾³³ÍÍ';
    if BType=4 then Border := 'Ö·Ó½ººÄÄ';
    if BType=5 then Border := 'ÛÛÛÛÛÛßÜ';
    if BType=6 then Border := 'Ú·Ô¼³ºÄÍ';
    lx := 41-MaxX; oy := 13-MaxY; rx := 40+MaxX;  uy := 12+MaxY;
    mx := 40;      my := 12;      DrwDelay := drwdmax div (2*MaxX);
    if drwdmax > 0 then FilDelay := 1 else FilDelay := 0;
    TextColor(TCol); TextBackground(BCol);
    for i:=mx downto lx+1 do begin
      GotoXY(i,oy); Write(Border[7]);
      GotoXY((rx+1)-i+lx-1,oy); Write(Border[7]);
      Delay(DrwDelay);
    end;
    GotoXY(lx,oy); Write(Border[1]);
    GotoXY(rx,oy); Write(Border[2]);
    Delay(DrwDelay);
    for i:=oy+1 to uy-1 do begin
      GotoXY(lx,i); Write(Border[5]);
      GotoXY(rx,i); Write(Border[6]);
      Delay(DrwDelay);
    end;
    GotoXY(lx,uy); Write(Border[3]);
    GotoXY(rx,uy); Write(Border[4]);
    Delay(DrwDelay);
    for i:=lx+1 to mx do begin
      GotoXY(i,uy); Write(Border[8]);
      GotoXY((rx+1)-i+lx-1,uy); Write(Border[8]);
      Delay(DrwDelay);
    end;
    for i:=lx+1 to rx-1 do begin
      for j:=oy+1 to uy-1 do begin
        GotoXY(i,j); Write(' ');
        Delay(FilDelay);
      end;
    end;
    CenterPos := (rx-lx) div 2; window(lx+2,oy+1,rx-2,uy-1);
    CursorOn;
  end;

procedure DrawBorder2(x1,y1,x2,y2,FG,BG: byte);
const frame='Û';
var i,j,xlen,ylen: byte;
    tox,toy: byte;
    xc,yc: byte;
    max: byte;
    DDel: byte;
begin
  CursorOff;
  xlen := (x2-x1);
  ylen := (y2-y1);
  TextColor(FG);
  TextBackground(BG);
  if xlen>ylen then max:=xlen else max:=ylen;
  DDel:=400 DIV max;
  if DDel > drwdmax then DDel := drwdmax;
  for i:=0 to max do begin
    tox:=(xlen*i) DIV max;
    toy:=(ylen*i) DIV max;

    for j:=0 to 100 do begin
      xc := (x1+(tox*(100-j) DIV 100));
      yc := (y1+(toy*j DIV 100));
      if (xc>x1) AND (yc>y1) AND (xc<x2) AND (yc<y2) then begin
        GotoXY(xc,yc);
        Write(' ');
      end;
      xc := (x2-(tox*(100-j) DIV 100));
      yc := (y2-(toy*j DIV 100));
      if (xc>x1) AND (yc>y1) AND (xc<x2) AND (yc<y2) then begin
        GotoXY(xc,yc);
        Write(' ');
      end;
    end;

    GotoXY(x1+tox,y1);
    Write(frame);
    GotoXY(x1,y1+toy);
    Write(frame);
    GotoXY(x2-tox,y2);
    Write(frame);
    GotoXY(x2,y2-toy);
    Write(frame);
    Delay(DDel);
  end;
  for i:=x1+1 to x2-1 do begin
    for j:=y1+1 to y2-1 do begin
      GotoXY(i,j);
      Write(' ');
    end;
  end;
  GotoXY(x1+1,y1+1);
  CursorOn;
end;


procedure FXWrite(text: string; finc: integer);
  var x,y,i: integer;
      finc2: integer;
      Del1: integer;
  begin
    CursorOff;
    x := WhereX;
    y := WhereY;
    Del1 := fxwd div Length(text);
    if (Del1>75) then Del1 := 75;
    for i:=1 to Length(text) do begin
      GotoXY(x+i-1,y); TextColor(15); Write(text[i]);
      if i>1 then begin
        GotoXY(x+i-2,y);
        TextColor(7);
        Write(text[i-1]);
      end;
      if i>2 then begin
        GotoXY(x+i-3,y);
        TextColor(8);
        Write(text[i-2]);
      end;
      Delay(Del1);
    end;
    GotoXY(x+Length(text)-1,y); TextColor(7); Write(text[Length(text)]);
    if Length(text)>1 then begin
      GotoXY(x+Length(text)-2,y);
      TextColor(8);
      Write(text[Length(text)-1]);
    end;
    Delay(Del1);
    GotoXY(x+Length(text)-1,y); TextColor(8); Write(text[Length(text)]);
    Delay(Del1*3);
    if finc<=blink then begin
      if finc<8 then finc2 := finc+8 else finc2 := finc-8;
    end else begin
      if finc<8+blink then finc2 := finc+8 else finc2 := finc-8;
    end;
    if finc=8 then finc2 := 15;
    if finc=15 then begin
      GotoXY(x,y); TextColor(8); Write(text); Delay(100);
    end;
    GotoXY(x,y); TextColor(finc2); Write(text);
    Delay(100);
    if finc=8 then begin
      GotoXY(x,y); TextColor(7); Write(text); Delay(100);
    end;
    GotoXY(x,y); TextColor(finc); Write(text);
    CursorOn;
  end;

procedure FXWriteC(text: string; finc: integer);
begin
  InitWindow;
  GotoXY(CenterPos-Length(text) div 2,WhereY);
  FXWrite(text,finc);
end;

procedure FXChar(ch: string; finc: integer);
  var x,y: integer;
      finc2: integer;
      Del1: integer;
  begin
    CursorOff;
    x := WhereX;
    y := WhereY;
    Del1 := fxwd div Length(ch);
    if (Del1>75) then Del1 := 75;
    if finc<=blink then begin
      if finc<8 then finc2 := finc+8 else finc2 := finc-8;
    end else begin
      if finc<8+blink then finc2 := finc+8 else finc2 := finc-8;
    end;
    if finc=8 then finc2 := 15;
    if finc=15 then begin
      GotoXY(x,y); TextColor(8); Write(ch); Delay(100);
    end;
    GotoXY(x,y); TextColor(finc2); Write(ch);
    Delay(100);
    if finc=8 then begin
      GotoXY(x,y); TextColor(7); Write(ch); Delay(100);
    end;
    GotoXY(x,y); TextColor(finc); Write(ch);
    CursorOn;
end;

procedure WriteFlt(txt: string);
var i,x,y: integer;
    ix: integer;
begin
  InitWindow;
  CursorOff;
  ix := WhereX;
  y := WhereY;
  for i:=1 to Length(txt) do begin
    if (txt[i]<>' ') then
      for x:=WindowWidth downto ix+i-1 do begin
        GotoXY(x,y);
        if x<WindowWidth then Write(txt[i],' ') else Write(txt[i]);
        Delay((2*WindowWidth) DIV (WindowWidth+1-i));
      end;
  end;
  WriteLn;
  CursorOn;
end;

procedure CWrite(st: string);
var i,j,k: integer;
    FG,BG,err: integer;
    last: integer;
    cod: string;
begin
  last := 1;
  for i:=1 to Length(st) do begin
    if Copy(st,i,2)='%%' then begin
      Write(Copy(st,last,i-last));     { all before the CC }
      for j:=i to Length(st) do begin
        if Copy(st,j,1)='#' then begin
          last := j+1;
          cod := Copy(st,i+2,j-i-2);
          for k:=1 to Length(cod) do begin
            if Copy(cod,k,1)=',' then begin
              Val(Copy(cod,1,k-1),FG,err);
              if err=0 then TextColor(FG);
              Val(Copy(cod,k+1,Length(cod)-k),BG,err);
              if err=0 then TextBackground(BG);
            end else begin
              Val(cod,FG,err);
              if err=0 then TextColor(FG);
            end;
          end;
          break;
        end;
      end;
    end;
  end;
  Write(Copy(st,last,Length(st)-last+1));
end;

procedure CWriteLn(st: string);
begin
  CWrite(st);
  WriteLn;
end;

procedure WriteC(st: string);
begin
  GotoXY(CenterPos-Length(st) div 2,WhereY);
  Write(st);
end;

procedure WriteCLn(st: string);
begin
  GotoXY(CenterPos-Length(st) div 2,WhereY);
  WriteLn(st);
end;

procedure CursorOff;assembler; { Schaltet den Cursor ab - schnell und zuverl„ssig }
asm
   xor  ax,ax
   mov  ah,01h
   mov  ch,20h
   mov  cl,20h
   int  10h
end;

procedure CursorOn;assembler; { Schaltet den Blinker wieder an }
asm
   mov  ah,01h
   mov  cx,0607h
   int  10h
end;

procedure WStat(opt: string);
var i: integer;
begin
  if CWS=0 then CWS := WhereY;
  GotoXY(1,CWS);
  Write(opt);
  Write(' ');
  for i:=Length(opt) to 70 do begin
    Write('.');
  end;
  CWriteLn(' %%7#[%%142#wait%%7#]');
end;

procedure Wcheck(stat: string);
begin
  GotoXY(75,CWS);
  CWriteLn(stat);
  TextColor(7);
  CWS := 0;
end;

function Space(len: integer): string;
var i: integer;
    tmp: string;
begin
  tmp := '';
  for i:=1 to len do tmp:=tmp+' ';
  Space := tmp;
end;

function Num2Str(x: longint): string;
var tmp: string;
begin
  Str(x:0,tmp);
  Num2Str := tmp;
end;


function MultiChar(ch: string; len: integer): string;
var i: integer;
    tmp: string;
begin
  tmp := '';
  for i:=1 to len do tmp:=tmp+ch;
  MultiChar := tmp;
end;

procedure TWriteLn(tx: string);
var wh: byte;
begin
  wh := WhereY;
  Write(tx);
  ClrEol;
  if wh<25 then begin
    WriteLn;
    ClrEol;
  end else begin
    GotoXY(1,1);
    ClrEol;
  end;
end;

procedure WriteLR(st: string; col: integer);
var i: integer;
begin
  TextColor(col);
  for i:=1 to Length(st) do begin
    Write(st[i]);
    Delay(20);
  end;
end;

procedure WriteImp(txt: string);
var i,j,x,y: integer;
    tmp: string;
begin
  InitWindow;
  CursorOff;
  y := WhereY;
  for x:=WindowWidth downto 0 do begin
    GotoXY(1,y);
    tmp := '';
    for i:=1 to Length(txt) do tmp := tmp + txt[i] + Space(x);
    tmp := Copy(tmp,1,WindowWidth);
    Write(tmp); ClrEol;
    Delay(300 DIV ((x+1)*2));
  end;
  CursorOn;
end;

procedure WriteExp(txt: string);
var i,j,x,y: integer;
    tmp: string[255];
begin
  InitWindow;
  CursorOff;
  y := WhereY;
  for x:=0 to WindowWidth do begin
    GotoXY(1,y);
    tmp := '';
    for i:=1 to Length(txt) do tmp := tmp + txt[i] + Space(x);
    tmp := Copy(tmp,1,WindowWidth);
    Write(tmp); ClrEol;
    Delay(300 DIV ((x+1)*2));
  end;
  GotoXY(1,y); ClrEol;
  CursorOn;
end;

procedure SaveScreen;
begin
  if ScrBuff<>NIL then Exit;             { schon belegt? }
  GetMem(ScrBuff,2000*2);                { 2000 Worte mal 2 Byte }
  Move(Mem[ScrSeg:0000],ScrBuff^,4000);  { in Speicher bewegen }
end;

procedure RestoreScreen;
begin
  if ScrBuff=NIL then Exit;              { noch leer? }
  Move(ScrBuff^,Mem[ScrSeg:0000],4000);  { aus Speicher holen }
  FreeMem(ScrBuff,2000*2);               { Speicher freilegen }
  ScrBuff:=NIL;
end;

procedure WriteScreen(FName: pathstr);
var f: file;
begin
  Assign(f,FName);
  Rewrite(f,1);
  Blockwrite(f,Mem[ScrSeg:0000],4000);
  Close(f);
end;

procedure ReadScreen(FName: pathstr);
var f: file;
begin
  Assign(f,FName);
  {$I-}
  Reset(f,1);
  {$I+}
  if IOResult<>0 then Exit;
  Blockread(f,Mem[ScrSeg:0000],4000);
  Close(f);
end;

begin
  Write('þ Loading Unit: Visual FX - RoboCop of nOOb <Robo.Cop@gmx.net> ... ');
  InitWindow;
  if LastMode=7 then ScrSeg := $B000 else ScrSeg := $B800;
  ScrBuff := NIL;
  WriteLn('OK');
end.