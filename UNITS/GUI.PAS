unit GUI;


interface
  uses Crt, Graph, DOS;
  const cc: array[0..15,0..2] of byte =
    (($00,$00,$00),($00,$00,$80),($00,$80,$00),($00,$80,$80),($80,$00,$00),
     ($80,$00,$80),($FF,$80,$00),($C0,$C0,$C0),($80,$80,$80),($00,$00,$FF),
     ($00,$FF,$00),($00,$FF,$FF),($FF,$00,$00),($FF,$00,$FF),($FF,$FF,$00),
     ($FF,$FF,$FF));
        buttondelay:integer=200;
        initp_del:integer=0;
        fo_del:integer=3;
        gui_dis:boolean=false;
  var ch,cm,cs,css: word;
      mb, mx, my: integer;
      oldstat: string;
      om: word;
  procedure InitPalette;
  procedure FadeOut;
  function MouseReset: boolean;
  procedure ShowMouse(mode: boolean);
  procedure MouseStat(var x,y,b: integer);
  function MouseOver(x1,y1,x2,y2: integer): boolean;
  procedure Frame(x1,y1,x2,y2: integer; b,p,s,t: shortint; bo: boolean);
  procedure MakeWindow(x1,y1,x2,y2: integer; title: string);
  procedure MakeButton(x1,y1,x2,y2: integer; msg: string);
  procedure MakeBeveledButton(x1,y1,x2,y2: integer; msg: string);
  procedure MakeRadiobutton(x,y: integer; msg: string);
  procedure MakeBevRadiobutton(x,y: integer; msg: string);
  procedure Alert(msg: string);
  procedure StatusTime(jow: boolean);
  procedure ClearStatus;
  procedure Status(txt: string);


implementation

procedure InitPalette;
var i,k: byte;
begin
  for i:=0 to 15 do begin
    case i of
       6: k := 20;
       8: k := 56;
       9: k := 57;
      10: k := 58;
      11: k := 59;
      12: k := 60;
      13: k := 61;
      14: k := 62;
      15: k := 63;
    else
      k := i;
    end;
    SetRGBPalette(k,cc[i,0] DIV 4,cc[i,1] DIV 4,cc[i,2] DIV 4);
    Delay(initp_del);
  end;
end;

procedure FadeOut;
const step=10;
var i,j,k: byte;
    r,g,b: integer;
    dead: array[0..15] of boolean;
begin
  for i:=0 to 15 do dead[i]:=false;
  for i:=0 to (256 DIV step) do begin
    for j:=0 to 15 do begin
        r := cc[j,0]-i*step; if r<0 then r:=0;
        g := cc[j,1]-i*step; if g<0 then g:=0;
        b := cc[j,2]-i*step; if b<0 then b:=0;
        r := (r DIV 4);
        g := (g DIV 4);
        b := (b DIV 4);
        case j of
           6: k := 20;
           8: k := 56;
           9: k := 57;
          10: k := 58;
          11: k := 59;
          12: k := 60;
          13: k := 61;
          14: k := 62;
          15: k := 63;
        else
          k := j;
        end;
        if NOT dead[j] then SetRGBPalette(k,r,g,b);
        if (r=0) AND (g=0) AND (b=0) then dead[j]:=true;
    end;
    Delay(fo_del);
  end;
end;

{###########################################################################
 #### Mouse procedures following                                        ####
 ###########################################################################}

function MouseReset: boolean;
var regs: registers;
begin
  MouseReset := false;
  regs.ax := 0; regs.bx := 0;
  Intr($33,regs);
  if regs.ax=$FFFF then MouseReset := true;
end;

procedure ShowMouse(mode: boolean);
var regs: registers;
begin
  if mode then regs.ax:=1 else regs.ax:=2;
  Intr($33,regs);
end;

procedure MouseStat(var x,y,b: integer);
var regs: registers;
begin
  regs.ax := 3;
  Intr($33,regs);
  with regs do begin
    x := cx;
    y := dx;
    b := bx;   { 1-left button; 2-right button; 4-middle button }
  end;
end;

function MouseOver(x1,y1,x2,y2: integer): boolean;
begin
  if (mx>=x1) AND (mx<=x2) AND (my>=y1) AND (my<=y2) then MouseOver:=true else MouseOver:=false;
end;

{###########################################################################
 #### Window make procedures following                                  ####
 ###########################################################################}

procedure Frame(x1,y1,x2,y2: integer; b,p,s,t: shortint; bo: boolean);
{ Parameters:
  x1 y1 x2 y2 - Coordinates of Frame
  b - blend color
  p - pattern color
  s - shadow color
  t - thickness }
var slice: byte;
begin
  if bo then begin
    SetColor(0);
    Rectangle(x1,y1,x2,y2);
    slice := 1;
  end else slice := 0;
  SetFillStyle(SolidFill,p);
  case t of
    2: begin
         SetColor(b);
         MoveTo(x1+slice,y1+slice);
         LineTo(x1+slice,y2-slice-1); LineTo(x1+slice+1,y2-slice-2); LineTo(x1+slice+1,y1+slice);
         LineTo(x2-slice,y1+slice); LineTo(x2-slice-1,y1+slice+1); LineTo(x1+slice,y1+slice+1);
         SetColor(s);
         MoveTo(x2-slice,y2-slice);
         LineTo(x2-slice,y1+slice+1); LineTo(x2-slice-1,y1+slice+2); LineTo(x2-slice-1,y2-slice);
         LineTo(x1+slice,y2-slice); LineTo(x1+slice+1,y2-slice-1); LineTo(x2-slice,y2-slice-1);
         Bar(x1+slice+2,y1+slice+2,x2-slice-2,y2-slice-2);
       end;
    1: begin
         SetColor(b);
         MoveTo(x2-slice,y1+slice);
         LineTo(x1+slice,y1+slice); LineTo(x1+slice,y2-slice);
         SetColor(s);
         MoveTo(x2-slice,y1+slice+1);
         LineTo(x2-slice,y2-slice); LineTo(x1+slice+1,y2-slice);
         Bar(x1+slice+1,y1+slice+1,x2-slice-1,y2-slice-1);
       end;
  end;
  SetColor(0); MoveTo(150,30);
end;

procedure MakeWindow(x1,y1,x2,y2: integer; title: string);
begin
  Frame(x1,y1,x2,y2,15,7,8,2,true);
  Frame(x1+3,y1+3,x2-3,y1+20,8,1,15,1,false);
  SetTextJustify(CenterText,CenterText);
  SetTextStyle(SmallFont,HorizDir,5);
  SetViewPort(x1+4,y1+3,x2-4,y1+19,ClipOn);
  SetColor(8);  OutTextXY(((x2-x1-8) DIV 2)+1,7+1,title);
  SetColor(15); OutTextXY(((x2-x1-8) DIV 2)-1,7-1,title);
  SetColor(7);  OutTextXY(((x2-x1-8) DIV 2),7,title);
  SetViewPort(0,0,639,479,ClipOff);
end;

procedure MakeButton(x1,y1,x2,y2: integer; msg: string);
begin
  ShowMouse(false);
  SetFillStyle(SolidFill,7);
  Bar(x1,y1,x2+1,y2+1);
  Frame(x1,y1,x2,y2,15,7,8,1,false);
  SetTextJustify(CenterText,CenterText);
  SetTextStyle(SmallFont,HorizDir,5);
  if (NOT gui_dis) then SetColor(0) else SetColor(8);
  SetViewPort(x1+1,y1+1,x2-1,y2-1,ClipOn);
  OutTextXY((x2-x1-2) DIV 2+1,(y2-y1-2) DIV 2-2,msg);
  OutTextXY((x2-x1-2) DIV 2,(y2-y1-2) DIV 2-2,msg);
  SetViewPort(0,0,639,479,ClipOff);
  ShowMouse(true);
end;


procedure MakeBeveledButton(x1,y1,x2,y2: integer; msg: string);
begin
  ShowMouse(false);
  SetFillStyle(SolidFill,7);
  Bar(x1,y1,x2+1,y2+1);
  Frame(x1+1,y1+1,x2+1,y2+1,8,7,15,1,false);
  SetTextJustify(CenterText,CenterText);
  SetTextStyle(SmallFont,HorizDir,4);
  if (NOT gui_dis) then SetColor(0) else SetColor(8);
  SetViewPort(x1+2,y1+2,x2,y2,ClipOn);
  OutTextXY((x2-x1-2) DIV 2+1,(y2-y1-2) DIV 2-1,msg);
  SetViewPort(0,0,639,479,ClipOff);
  ShowMouse(true);
end;

procedure MakeRadiobutton(x,y: integer; msg: string);
begin
  ShowMouse(false);
  MoveTo(x,y-4);
  SetColor(8); LineTo(x+4,y); LineTo(x,y+4); LineTo(x-4,y);
  if (NOT gui_dis) then SetColor(15); LineTo(x,y-4);
  MoveTo(x,y-3);
  SetColor(8); LineTo(x+3,y); LineTo(x,y+3); LineTo(x-3,y);
  if (NOT gui_dis) then SetColor(15); LineTo(x,y-3);
  SetTextStyle(SmallFont,HorizDir,4);
  SetTextJustify(LeftText,CenterText);
  if (NOT gui_dis) then SetColor(0) else SetColor(8);
  OutTextXY(x+8,y-1,msg);
  ShowMouse(true);
end;

procedure MakeBevRadiobutton(x,y: integer; msg: string);
begin
  ShowMouse(false);
  MoveTo(x,y-4);
  SetColor(15); LineTo(x+4,y); LineTo(x,y+4); LineTo(x-4,y);
  SetColor(8); LineTo(x,y-4);
  MoveTo(x,y-3);
  SetColor(15); LineTo(x+3,y); LineTo(x,y+3); LineTo(x-3,y);
  SetColor(8); LineTo(x,y-3);
  SetTextStyle(SmallFont,HorizDir,4);
  SetTextJustify(LeftText,CenterText);
  if (NOT gui_dis) then SetColor(0) else SetColor(8);
  OutTextXY(x+8,y-1,msg);
  ShowMouse(true);
end;

procedure Alert(msg: string);
var bg: array[150..489,200..280] of byte;
    xl,xr: word;
    bl,br: word;
    i, j: word;
    key: char;
begin
  ShowMouse(false);
  SetTextStyle(SmallFont,HorizDir,4);
  SetTextJustify(CenterText,CenterText);
  xl := Length(msg)*8 + 20;
  xr := xl;
  xl := 320 - xl DIV 2;
  xr := 320 + xr DIV 2;
  if xl<0 then xl := 0;
  if xr>639 then xr := 639;
  if xl>280 then xl := 280;
  if xr<360 then xr := 360;
  for j:=200 to 280 do begin
    for i:=xl to xr do begin
      bg[i,j] := GetPixel(i,j);
    end;
  end;
  MakeWindow(xl,200,xr,280,'Alert');
  if xl>260 then begin
    bl := xl+10;
    br := xr-10;
  end else begin
    bl := 300;
    br := 340;
  end;
  MakeButton(bl,255,br,270,'OK');
  SetViewPort(xl+3,225,xr-3,255,ClipOn);
  OutTextXY((xr-xl-6) DIV 2,14,msg);
  OutTextXY((xr-xl-6) DIV 2-1,14,msg);
  SetViewPort(0,0,639,479,ClipOff);
  Key := #00;
  if (mb<>0) then repeat MouseStat(mx,my,mb); until (mb=0);
  repeat
    ShowMouse(true);
    MouseStat(mx,my,mb);
    if (keypressed) then Key := ReadKey;
  until (MouseOver(bl,255,br,270) AND (mb<>0)) OR (key=#13) OR (key=#27);
  ShowMouse(false);
  MakeBeveledButton(bl,255,br,270,'OK');
  repeat MouseStat(mx,my,mb); until (mb=0);
  for j:=200 to 280 do begin
    for i:=xl to xr do begin
      PutPixel(i,j,bg[i,j]);
    end;
  end;
  ShowMouse(true);
end;

{###########################################################################
 #### Status bar procedures following                                   ####
 ###########################################################################}

procedure StatusTime(jow: boolean);
var hs,ms,ot: string;
begin
  GetTime(ch,cm,cs,css);
  if (cm<>om) OR jow then begin
    SetFillStyle(SolidFill,7);
    Bar(593,469,637,477);
    Str(ch:0,hs);
    Str(cm:0,ms);
    if (ch<10) then ot:='0' else ot:='';
    ot:=ot+hs+':';
    if (cm<10) then ot:=ot+'0';
    ot:=ot+ms;
    SetTextJustify(CenterText,CenterText);
    SetTextStyle(SmallFont,HorizDir,4);
    SetViewPort(592,468,638,478,ClipOn);
    SetColor(8);
    OutTextXY(24,4,ot);
    SetColor(0);
    OutTextXY(23,4,ot);
    SetViewPort(0,0,639,479,ClipOff);
    om := cm;
  end;
end;

procedure ClearStatus;
begin
  SetFillStyle(SolidFill,7);
  Bar(0,467,639,479);
  Frame(0,467,589,479,8,7,15,1,false);
  Frame(591,467,639,479,8,7,15,1,false);
  StatusTime(true);
  oldstat := '';
end;

procedure Status(txt: string);
begin
  if oldstat<>txt then begin
    ShowMouse(false);
    ClearStatus;
    SetTextJustify(LeftText,CenterText);
    SetTextStyle(SmallFont,HorizDir,4);
    SetViewPort(1,468,638,478,ClipOn);
    SetColor(0);
    OutTextXY(10,4,txt);
    SetViewPort(0,0,639,479,ClipOff);
    oldstat := txt;
    ShowMouse(true);
  end;
end;




begin
  WriteLn('þ Loading Unit: GUI - Markus Birth <mbirth@webwriters.de>');
end.