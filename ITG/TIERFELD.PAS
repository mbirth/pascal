program Tiersuche_im_Feld;
uses Crt, CursorOnOff;
type TBuchQuadrat = array[1..20,1..20] of char;
const DesktopCol=2;
      Quadrat: TBuchQuadrat =
(('A','M','S','E','L','L','E','R','O','F','M','R','U','W','D','N','A','B','O','A'),
 ('L','E','G','I','U','H','E','G','N','A','L','H','C','S','N','A','N','D','U','L'),
 ('B','O','C','K','B','U','E','N','A','Y','H','O','R','N','I','S','S','E','H','L'),
 ('N','H','A','H','E','H','S','U','A','L','U','C','H','S','T','S','R','L','U','I'),
 ('R','P','N','E','Z','N','A','W','R','E','H','D','R','A','P','O','E','L','R','G'),
 ('E','A','I','E','R','E','W','I','E','S','E','L','R','E','C','H','L','I','U','A'),
 ('P','V','U','C','E','T','R','A','D','N','A','P','C','H','C','E','S','R','G','T'),
 ('I','I','G','H','T','S','O','B','N','A','L','H','S','S','O','C','T','G','N','O'),
 ('V','A','N','W','T','U','D','A','A','P','T','E','U','Z','Y','H','E','B','A','R'),
 ('M','N','I','A','A','G','N','R','R','M','I','M','S','I','O','T','R','L','K','H'),
 ('M','I','P','N','N','N','O','S','A','I','L','E','L','E','T','T','A','R','C','S'),
 ('E','U','L','R','S','A','K','C','W','H','T','T','N','G','E','M','A','S','U','H'),
 ('R','B','W','B','E','L','L','H','H','C','I','A','N','E','A','N','I','A','K','C'),
 ('E','B','B','E','E','I','E','E','E','S','S','U','T','O','I','F','R','N','C','V'),
 ('I','E','L','O','F','T','E','W','D','H','E','N','B','C','I','B','E','T','U','F'),
 ('H','V','M','L','R','F','O','G','O','V','E','R','H','A','O','P','D','I','K','A'),
 ('E','L','E','E','L','L','A','R','A','U','P','E','I','R','K','F','R','L','R','H'),
 ('R','E','G','E','L','E','N','M','K','N','W','E','S','P','E','A','A','O','A','C'),
 ('E','I','N','D','E','B','U','A','T','E','S','I','E','M','A','U','M','P','C','S'),
 ('T','F','L','O','W','P','A','N','T','H','E','R','N','R','E','T','S','E','E','S'));

var whats: string;
    times: byte;

procedure DrawBorder(x1,y1,x2,y2,FG,BG: byte);
const frame='€';
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
  CursorOn;
end;

procedure WriteMash;
var x,y: byte;
begin
  TextColor(15);
  TextBackground(1);
  for y:=1 to 20 do begin
    for x:=1 to 20 do begin
      GotoXY(4+x,4+y);
      Write(Quadrat[y,x]);
    end;
  end;
end;

procedure Init;
begin
  TextMode(CO80+Font8x8);
  ClrScr;
  DrawBorder(1,1,79,49,14,DesktopCol);
  DrawBorder(53,13,71,21,0,3);
  TextColor(0);
  TextBackground(3);
  GotoXY(55,15);
  Write('Richtungsschema');
  GotoXY(60,17);
  Write('8 1 2');
  GotoXY(60,18);
  Write('7 ');
  TextColor(15);
  WritE('X');
  TextColor(0);
  Write(' 3');
  GotoXY(60,19);
  Write('6 5 4');
  DrawBorder(3,3,26,26,15,1);
  WriteMash;
  CursorOff;
end;

procedure Outit;
begin
  DrawBorder(1,1,79,49,0,0);
  TextMode(CO80);
end;

function Get(x,y,dir,len: byte): string;
var i: byte;
    ax,ay: byte;
    tmp: string;
begin
  i:=len;
  ax:=x;
  ay:=y;
  tmp:='';
  repeat
    tmp:=tmp+Quadrat[ay,ax];
    case dir of
      1: Dec(ay);
      2: begin Inc(ax); Dec(ay); end;
      3: Inc(ax);
      4: begin Inc(ax); Inc(ay); end;
      5: Inc(ay);
      6: begin Dec(ax); Inc(ay); end;
      7: Dec(ax);
      8: begin Dec(ax); Dec(ay); end;
    end;
    Dec(i);
  until i=0;
  Get:=tmp;
end;

procedure Input;
var i: byte;
   tmp: string;
begin
  DrawBorder(33,5,73,11,11,1);
  TextColor(11);
  TextBackground(1);
  GotoXY(43,7);
  WriteLn('Geben Sie ein Tier an');
  TextColor(15);
  GotoXY(38,9);
  CursorOn;
  ReadLn(tmp);
  CursorOff;
  whats:='';
  for i:=1 to Length(tmp) do whats:=whats+UpCase(tmp[i]);
  DrawBorder(33,5,73,11,DesktopCol,DesktopCol);
  TextColor(15);
end;

procedure Mark(x,y,dir,len,fg,bg: byte);
var ax,ay,i: byte;
begin
  TextColor(fg);
  TextBackground(bg);
  ax:=x; ay:=y;
  i:=len;
  repeat
    GotoXY(4+ax,4+ay);
    if (ay>=1) AND (ay<=20) AND (ax>=1) AND (ax<=20) then Write(Quadrat[ay,ax]);
    case dir of
      1: Dec(ay);
      2: begin Inc(ax); Dec(ay); end;
      3: Inc(ax);
      4: begin Inc(ax); Inc(ay); end;
      5: Inc(ay);
      6: begin Dec(ax); Inc(ay); end;
      7: Dec(ax);
      8: begin Dec(ax); Dec(ay); end;
    end;
    Dec(i);
  until i=0;
  Delay(30);
  TextBackground(0);
  TextColor(15);
end;

procedure Search(what: string);
var i,j,k: byte;
    ox,oy: byte;
    tmp: string;
begin
  TextBackground(0);
  ox:=1;
  oy:=1;
  for i:=1 to 20 do begin
    for j:=1 to 20 do begin
      (* Mark(j,i,1,1,9,1); *)
      if (Quadrat[i,j]=what[1]) then begin
        for k:=1 to 8 do begin
          tmp:=Get(j,i,k,Length(what));
          (* Mark(j,i,k,Length(what),0,1); *)
          if tmp=what then begin
            Window(5,30,75,46);
            GotoXY(ox,oy);
            Inc(times);
            WriteLn('Hab ''',what,''' bei (',j:2,'|',i:2,') gefunden. Richtung ',k,', LÑnge ',Length(what));
            ox:=WhereX; oy:=WhereY;
            Window(1,1,80,50);
            Mark(j,i,k,Length(what),0,7);
            Delay(50);
          end;
          (* Mark(j,i,k,Length(what),15,1); *)
        end;
      end;
      (* Mark(j,i,1,1,15,1); *)
    end;
  end;
  window(5,30,75,46);
  GotoXY(ox,oy);
  if (times=0) then begin
    WriteLn('Hab nix gefunden - versuch'' was anderes.');
  end;
end;

procedure ClearErg;
begin
  DrawBorder(3,28,77,47,DesktopCol,DesktopCol);
  DrawBorder(3,28,77,47,15,0);
end;

begin
  Init;
  repeat
    times:=0;
    { WriteMash; }
    ClearErg;
    Input;
    if (whats<>'') then begin
      Search(whats);
      WriteLn;
      WriteLn('[ Taste drÅcken, um fort zu fahren ]');
      window(1,1,80,50);
      ReadKey;
    end;
  until whats='';
  Outit;
end.