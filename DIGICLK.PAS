program DigiClock;

uses Crt, Dos, Graph, BGIP;

const DigiData: array[0..9] of string[7]=('1110111','0010010','1011101','1011011',
                                          '0111010','1101011','1101111','1010010',
                                          '1111111','1111011');
      digacol: byte =14;
      digdcol: byte =0;

var xmax,ymax: word;
    h,m,s,hh: word;
    olds: word;


procedure InitVid;
var grDriver, grMode : integer;
begin
  grDriver := VGA;
  grMode   := VGAhi;
  InitGraph(grDriver,grMode,BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
end;

procedure WriteDig(pos,which,col: byte);
const sw=40;
      sh=40;
      sa=3;
      ya=20;
      xa=5;

var ab: word;

begin
  SetColor(col);
  ab := pos*Trunc(sw*1.9);
  SetLineStyle(UserBitLn,$AAAA,ThickWidth);
  case which of
    1: begin
         MoveTo(xa+ab+sa,ya);
         LineTo(xa+ab+sa+sw,ya);
       end;
    2: begin
         MoveTo(xa+ab,ya+sa);
         LineTo(xa+ab,ya+sa+sh);
       end;
    3: begin
         MoveTo(xa+ab+sa+sw+sa,ya+sa);
         LineTo(xa+ab+sa+sw+sa,ya+sa+sh);
       end;
    4: begin
         MoveTo(xa+ab+sa,ya+sa+sh+sa);
         LineTo(xa+ab+sa+sw,ya+sa+sh+sa);
       end;
    5: begin
         MoveTo(xa+ab,ya+sa+sh+sa+sa);
         LineTo(xa+ab,ya+sa+sh+sa+sa+sh);
       end;
    6: begin
         MoveTo(xa+ab+sa+sw+sa,ya+sa+sh+sa+sa);
         Lineto(xa+ab+sa+sw+sa,ya+sa+sh+sa+sa+sh);
       end;
    7: begin
         MoveTo(xa+ab+sa,ya+sa+sh+sa+sa+sh+sa);
         LineTo(xa+ab+sa+sw,ya+sa+sh+sa+sa+sh+sa);
       end;
  end;
end;

procedure OutDig(pos,which: byte);
var digcs: string[7];
    i: integer;
begin
  digcs := DigiData[which];
  for i:=1 to 7 do begin
    if digcs[i]='0' then WriteDig(pos,i,digdcol) else WriteDig(pos,i,digacol);
  end;
end;

procedure OutitVid;
begin
  TextMode(CO80);
  WriteLn('Programm beendet.');
end;

begin
  InitVid;
  Randomize;
  repeat
    while olds=s do begin
      GetTime(h,m,s,hh);
      if keypressed then begin
        ReadKey;
        Halt;
      end;
    end;
    { digacol := Random(8)+8; }
    olds := s;
    OutDig(0,h DIV 10);
    OutDig(1,h MOD 10);
    OutDig(3,m DIV 10);
    OutDig(4,m MOD 10);
    OutDig(6,s DIV 10);
    OutDig(7,s MOD 10);
  until keypressed;
  ReadKey;
  OutitVid;
end.
