program BorderTest;

uses Crt;

var i: integer;

procedure DrawBorder(MaxX,MaxY: integer; TCol, BCol: integer; BType: integer);
  var i,j: integer;
      lx,rx,oy,uy,mx,my: integer;
      DrwDelay, FilDelay: integer;
      Border: string[8];
      CenterPos: integer;
  begin
    window(1,1,80,25);
    if (MaxX=0) AND (MaxY=0) AND (TCol=0) AND (BCol=0) then Exit;
    if BType=1 then Border := 'Ú¿ÀÙ³³ÄÄ';
    if BType=2 then Border := 'É»È¼ººÍÍ';
    if BType=3 then Border := 'Õ¸Ô¾³³ÍÍ';
    if BType=4 then Border := 'Ö·Ó½ººÄÄ';
    if BType=5 then Border := 'ÛÛÛÛÛÛßÜ';
    if BType=6 then Border := 'Ú·Ô¼³ºÄÍ';
    lx := 41-MaxX; oy := 13-MaxY; rx := 40+MaxX;  uy := 12+MaxY;
    mx := 40;      my := 12;      DrwDelay := 1000 div (2*MaxX); FilDelay := 1;
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
  end;

procedure NameBorder(num: integer);
begin
  GotoXY(1,1);
  WriteLn('B');
  WriteLn('O');
  WriteLn('R');
  WriteLn('D');
  WriteLn('E');
  WriteLn('R');
  WriteLn('#');
  WriteLn(num);
end;

begin
  ClrScr;
  DrawBorder(40,12,15,0,1);
  NameBorder(1);
  DrawBorder(35,11,14,1,2);
  NameBorder(2);
  DrawBorder(30,10,13,2,3);
  NameBorder(3);
  DrawBorder(25,9,12,3,4);
  NameBorder(4);
  DrawBorder(20,8,11,4,5);
  NameBorder(5);
  DrawBorder(15,7,10,5,6);
  NameBorder(6);
  Write('Jedes Fenster ist durch ein window-Befehl begrenzt. Dadurch wird ein Zerst”ren des Fensters durch einen Umbruch');
  WriteLn(' verhindert.');
end.