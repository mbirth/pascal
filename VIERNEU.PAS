uses crt,graph,dos,BGIP;

const xdelta=62;
      xdist=45;
      playercolor: array[1..2] of integer = (12,14);
      playernames: array[1..2] of string[20] = ('Spieler 1','Spieler 2');

var         graphmode:integer;
            globalwinkel:integer;
            graphdriver,agm:integer; {agm:ausgemalt}
            l:word;
            befehl:char;
            fc,i,t,x,y,spieler:integer; {fc:fillColor}
            circ: integer;
            wc: string;
            spielfeld,altfeld,leerfeld: array[1..7,1..6] of shortint;
            pl: integer; { Spieler }
            WON: boolean;


Function MausReset: Boolean;
Var regs: registers;
Begin
      MausReset:=false;
      regs.ax:=0; regs.bx:=0;
      Intr($33,regs);
      If regs.ax=$FFFF Then MausReset:=true;
End;

Procedure MausAnzeige(mode: Byte);
Var regs: registers;
Begin
     Case Mode Of
          0: regs.ax:=2;  {aus}
          1: regs.ax:=1;  {an}
     End;
     Intr($33,regs);
End;

Procedure MausZustand(Var taste, X_Pos, Y_Pos : Integer);
Var regs: registers;
Begin
     regs.ax:=3;
     Intr($33,regs);
     with regs do
         Begin
              X_Pos:=cx;
              Y_Pos:=dx;
              taste:=bx;   {1 = links 2 = rechts}
         End;
End;

procedure graphinit;
var       graphdriver:integer;
begin
     graphdriver:=detect;
     initgraph(graphdriver,graphmode,BGIPath);
     settextstyle(0,0,1);
     settextjustify(0,2);
     setcolor(4);
     setpalette(4,0);
     setbkcolor(8);
end;
Procedure rahmen(a,b,c,d: Integer; o,i,u: Shortint);
(* o obere Randfarbe
   i innere Farbe
   u untere Randfarbe *)
Begin
     Setcolor(0);
     Rectangle(a,b,c,d);
     SetFillStyle(1, i);
     Bar(a+2, b+2, c-2, d-2);
     If (i=8) and not (o=0) Then SetColor(7)
        Else SetColor(o);
     MoveTo(a+1,b+1);
     LineTo(a+1,d-2); LineTo(a+2,d-3);
     LineTo(a+2,b+1); LineTo(c-1,b+1);
     LineTo(c-2,b+2); LineTo(a+1,b+2);
     If (i=8) and not (u=0) Then SetColor(7)
        Else SetColor(o);
     SetColor(u);
     MoveTo(c-1,d-1);
     LineTo(c-1,b+2); LineTo(c-2,b+3);
     LineTo(c-2,d-1); LineTo(a+1,d-1);
     LineTo(a+2,d-2); LineTo(c-1,d-2);
     SetColor(0); moveto(150,30);
end;
procedure fenster3d(x1,y1,x2,y2:word;text:string);
var xtext:word;
begin
     if (x2-x1>40) and (y2-y1>40) then
        begin
             rahmen(x1,y1,x2,y2,10,8,9);
             rahmen(x1,y1,x1+20,y1+20,15,4,8);
             rahmen(x2-20,y1,x2,y1+20,15,4,8);
             rahmen(x1+20,y1,x2-20,y1+20,15,4,8);

             outtextxy(x1+6,y1+7,'þ');
             outtextxy(x2-20+6,y1+4,'');
             outtextxy(x2-20+6,y1+10,'');
             xtext:=((x2-x1) div 2) +x1 -(length(text)*4);
             if xtext>x1+23 then
                begin
                     moveto(xtext,y1+7);
                     outtext(text);
                end;
        end;
end;

Procedure Ausblendung;
Var i : Byte;
Begin
     For i := 42 DownTo 0 Do
         Begin
              SetRgbPalette(1,14,20,i);
              Delay(20);
         End;
End;


procedure DrawField;
VAR a,b,c,d,e:integer;
begin
  fenster3d(35,80,450,410,'VIER GEWINNT');
  SetColor(7);
  b:=130;
  c:=85;
  FOR e:=1 TO 6 DO Begin
    c:=85;
    FOR D:=1 to 7 DO Begin
      circle(c,b,20);
      c:=c+45;
    end;
    b:=b+50;
  end;
end;

procedure UpdateField;
var i,j: integer;
begin
  MausAnzeige(0);
  for i:=1 to 7 do
    for j:=1 to 6 do
      if spielfeld[i,j]<>altfeld[i,j] then
        if spielfeld[i,j] <> 0 then begin
          if spielfeld[i,j]<>0 then SetFillStyle(SolidFill,spielfeld[i,j]) else SetFillStyle(SolidFill,8);
          FloodFill(40+45*i,80+50*(7-j),7);
        end;
  altfeld := spielfeld;
  Mausanzeige(1);
end;

function AddStone(where,which: integer): boolean;
var done: boolean;
begin
  done := false;
  for i:=1 to 6 do begin
    if spielfeld[where,i]=0 then begin
      spielfeld[where,i]:=which;
      done := true;
      Break;
    end;
  end;
  if NOT done then begin
    Sound(1200);
    Delay(50);
    NoSound;
  end;
  AddStone:=done;
end;

procedure UpdatePlayer;
begin
  SetFillStyle(SolidFill,4);
  Bar(463,83,617,105);
  SetColor(15);
  OutTextXY(470,90,playernames[pl]);
end;

procedure Hint(txt: string);
begin
  SetFillStyle(SolidFill,4);
  Bar(463,105,617,117);
  SetColor(10);
  OutTextXY(470,105,txt);
  Sound(1200);
  Delay(50);
  NoSound;
end;

procedure CheckWon;
var i,j,ai,aj,d,m: integer;
    x: array[1..4] of integer;
    W2: boolean;
begin
  Mausanzeige(0);
{  W2 := false;
  TextMode(co80+Font8x8); }
  for i:=1 to 7 do
    for j:=1 to 6 do begin
{      TextColor(15);
      Write(i,'|',j,' '); }
      for d:=1 to 8 do begin
        ai := i;
        aj := j;
        m := 1;
        repeat
          if (ai>0) AND (aj>0) AND (ai<8) AND (aj<7) then x[m] := spielfeld[ai,aj] else x[m] := 8;
          case d of
            1: Inc(aj);
            2: begin Inc(ai); Inc(aj); end;
            3: Inc(ai);
            4: begin Inc(ai); Dec(aj); end;
            5: Dec(aj);
            6: begin Dec(ai); Dec(aj); end;
            7: Dec(ai);
            8: begin Dec(ai); Inc(aj); end;
          end;
          Inc(m);
        until (m=5);
        if (x[1]=x[2]) AND (x[2]=x[3]) AND (x[3]=x[4]) AND (x[1]<>8) AND (x[1]<>0) AND NOT (WON) then begin
          WON := true;
{          W2 := true; }
          Sound(500);
          Delay(100);
          Sound(600);
          Delay(500);
          NoSound;
        end;
{        for m := 1 to 4 do begin
          if NOT W2 then begin
            TextColor(x[m]);
            if (x[m]=0) then TextColor(8);
            if (x[m]=8) then TextColor(0);
          end else begin
            TextColor(x[m]+blink);
            if (x[m]=0) then TextColor(8+blink);
            if (x[m]=8) then TextColor(0);
          end;
          Write('þ');
        end;
        W2 := false;
        Write(' '); }
      end;
{      WriteLn; }
    end;
{    for i:=1 to 6 do begin
      TextColor(15);
      GotoXY(70,11-i);
      Write(i:1);
    end;
    for i:=1 to 7 do begin
      GotoXY(70+i,11);
      Write(i:1);
    end;
    for i:=1 to 7 do
      for j:=1 to 6 do begin
        GotoXY(70+i,11-j);
        if (spielfeld[i,j]<>0) then TextColor(spielfeld[i,j]) else TextColor(8);
        Write('þ');
      end;
    ReadKey;
    Graphinit;
    DrawField;
    altfeld := leerfeld;
    UpdateField; }
    Mausanzeige(1);
end;

procedure fensterabfrage;
var xt,yt:string[3];position:string[7];
begin
    mausanzeige(1);
    repeat
      mauszustand(t,x,y);
      if (x>=65) AND (x<=420) AND (t<>0) then begin
        repeat
          mauszustand(t,x,y);
        until t=0;
        circ := ((x - xdelta) DIV xdist) + 1;
        SetFillStyle(SolidFill, 0);
        Bar(1,1,100,30);
        Str(circ,wc);
        SetColor(15);
        OutTextXY(1,1,wc);
        if AddStone(circ,playercolor[pl]) then begin
          UpdateField;
          if pl=1 then pl:=2 else pl:=1;
          UpdatePlayer;
          Hint('Bitte Stein setzen');
        end else begin
          Hint('Versuch''s nochmal!');
          { Gleicher Spieler nochmal! }
        end;
        CheckWon;
      end;
     until ((x>=585) AND (y>=450) AND (x<=630) AND (y<=470) AND (t=1)) OR (WON);
     rahmen(585,450,630,470,4,8,15);
     setcolor(10);
     outtextxy(594,458,'ENDE');
     repeat mauszustand(t,x,y) until t=0;
     rahmen(585,450,630,470,15,8,4);
     setcolor(10);
     outtextxy(593,457,'ENDE');


     ausblendung;
     mausanzeige(0);
end;


procedure MENU;
begin
     graphinit;
     mausreset;
     setbkcolor(1);
     rahmen(460,80,620,120,15,4,10);
     setcolor(1);
     outtextxy(470,90,'++++++++++++');


     rahmen(585,450,630,470,15,8,4);
     setcolor(10);
     outtextxy(593,457,'ENDE');

     UpdateField;
     end;

Procedure anfang;
     begin
          graphinit;
          for i:=1 to 8 do for t:=1 to 6 do spielfeld[i,t]:=0;
          altfeld := spielfeld;
          leerfeld := spielfeld;
          mausreset;
          setbkcolor(1);
          rahmen(30,30,610,430,15,8,4);
          setcolor(10);
          outtextxy(200,200,'VIER   GEWINNT');
          readln;
     end;


Begin
    { randomize;
     anfang;   }
     MENU;
     drawfield;
     pl := 1; { Spieler 1 zuerst }
     WON := false;
     UpdatePlayer;
     Hint('Bitte Stein setzen');
     Fensterabfrage;
     closegraph;
end.
{ausblendung;}