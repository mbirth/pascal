program Towers_of_Hanoi;

uses Crt, Graph, INIFile, BGIP;

const { Hmax=5; }
      Gray50: FillPatternType=($AA, $55, $AA, $55, $AA, $55, $AA, $55);
      Sound_ON=false;

var xmax, ymax, xmed, ymed: word;
    Code: integer;
    Hanoi: array[1..3,1..100] of byte;
    Item_X: array[1..100] of word;
    Board_Up, Board_Down: word;
    Tower_Y: word;
    Input: char;
    Mv_From, Mv_To: byte;
    Step: longint;
    tmp1,tmp2: string;
    T_Center: array[1..3] of word;
    Hmax: byte;
    Board_X,Board_Middle,Board_Y: word;
    Board_Color: byte;
    Tower_X: word;
    Tower_Color: byte;
    Item_MaxX, Item_MinX, Item_Y: word;
    Item_Color, Text_Color: byte;

function V2S(x: longint): string;
var tmp: string;
begin
  Str(x:0,tmp);
  V2S := tmp;
end;

function S2V(x: string): integer;
var tmp,code: integer;
begin
  Val(x,tmp,code);
  if (code<>0) then begin
    WriteLn('Error while VAL ''',x,''': ',code);
    Halt;
  end else S2V:=tmp;
end;

procedure Init;
var grDriver, grMode: integer;
    i,j: byte;
begin
  INIFileDebug := false;
  OpenINI('D:\LANG\src\bp\itg\hanoi.ini');
  Hmax := S2V(INIGet('Hanoi_Main','Items'));
  Board_X := S2V(INIGet('Hanoi_Board','Board_X'));
  Board_Middle := S2V(INIGet('Hanoi_Board','Board_Middle'));
  Board_Y := S2V(INIGet('Hanoi_Board','Board_Y'));
  Board_Color := S2V(INIGet('Hanoi_Board','Board_Color'));
  Tower_X := S2V(INIGet('Hanoi_Poles','Tower_X'));
  Tower_Color := S2V(INIGet('Hanoi_Poles','Tower_Color'));
  Item_MaxX := S2V(INIGet('Hanoi_Coins','Item_MaxX'));
  Item_MinX := S2V(INIGet('Hanoi_Coins','Item_MinX'));
  Item_Y := S2V(INIGet('Hanoi_Coins','Item_Y'));
  Item_Color := S2V(INIGet('Hanoi_Coins','Item_Color'));
  Text_Color := S2V(INIGet('Hanoi_Texts','Text_Color'));
  CloseINI;
  grDriver := VGA;
  grMode   := VGAHi;
  InitGraph(grDriver, grMode, BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
  xmed := xmax DIV 2;
  ymed := ymax DIV 2;
  T_Center[1] := xmed-(Board_X DIV 4);
  T_Center[2] := xmed;
  T_Center[3] := xmed+(Board_X DIV 4);
  Board_Up   := Board_Middle-(Board_Y DIV 2);
  Board_Down := Board_Middle+(Board_Y DIV 2);
  Tower_Y := (Hmax+1)*Item_Y;
  Step := 0;
  for i:=1 to 3 do begin
    for j:=1 to Hmax do begin
      Hanoi[i,j] := 0;
      Hanoi[1,j] := Hmax-j+1;
      Item_X[Hmax-j+1] := Trunc(((Hmax-j)/(Hmax-1))*(Item_MaxX-Item_MinX))+Item_MinX;
    end;
  end;
end;

procedure DrawBoard;
var i,j: byte;
begin
  ClearDevice;
  for i:=1 to 3 do begin
    SetColor(Tower_Color);
    SetFillPattern(Gray50,Tower_Color);
    Rectangle(T_Center[i]-(Tower_X DIV 2),Board_Up-Tower_Y,T_Center[i]+(Tower_X DIV 2),Board_Up);
    FloodFill(T_Center[i],Board_Middle-(Board_Y DIV 2)-(Tower_Y DIV 2),Tower_Color);
    SetColor(Text_Color);
    SetTextJustify(CenterText, CenterText);
    OutTextXY(T_Center[i],Board_Down+10,V2S(i));
    SetTextJustify(LeftText, TopText);
  end;
  SetColor(Board_Color);
  Rectangle(xmed-(Board_X DIV 2),Board_Up,xmed+(Board_X DIV 2),Board_Down);
  SetFillPattern(Gray50,Board_Color);
  FloodFill(xmed,Board_Middle,Board_Color);

  for i:=1 to 3 do begin
    for j:=1 to Hmax do begin
      if Hanoi[i,j]<>0 then begin
        SetColor(Item_Color);
        SetFillPattern(Gray50,Item_Color);
        Rectangle(T_Center[i]-(Item_X[Hanoi[i,j]] DIV 2),Board_Up-(Item_Y*(j-1)),T_Center[i]+(Item_X[Hanoi[i,j]] DIV 2),
                  Board_Up-(Item_Y*j));
        FloodFill(T_Center[i],Board_Up-(Item_Y*j)+(Item_Y DIV 2),Item_Color);
      end;
    end;
  end;
end;


function WhatsLast(Tower: byte): byte;
var i: integer;
    tmp: byte;
begin
  tmp := 0;
  for i:=Hmax downto 1 do begin
    if Hanoi[Tower,i]<>0 then begin
      tmp := Hanoi[Tower,i];
      Break;
    end;
  end;
  if (tmp=0) then tmp:=255;
  SetTextJustify(CenterText, CenterText);
  OutTextXY(T_Center[Tower],Board_Down+20,V2S(tmp));
  SetTextJustify(LeftText, TopText);
  WhatsLast := tmp;
end;

function TakeLast(Tower: byte): byte;
var i: integer;
    tmp: byte;
begin
  for i:=Hmax downto 1 do begin
    if Hanoi[Tower,i]<>0 then begin
      tmp := Hanoi[Tower,i];
      Hanoi[Tower,i] := 0;
      Break;
    end;
  end;
  TakeLast := tmp;
end;

procedure PutOnto(Which,Tower: byte);
var i: integer;
begin
  for i:=1 to Hmax do begin
    if Hanoi[Tower,i]=0 then begin
      Hanoi[Tower,i]:=which;
      Break;
    end;
  end;
end;

procedure MoveFromTo(Mv_From, Mv_To: byte);
var temp: byte;
begin
  if (WhatsLast(Mv_To)>WhatsLast(Mv_From)) then begin
    PutOnto(TakeLast(Mv_From),Mv_To);
    Inc(Step);
    if (Sound_ON) then begin
      Sound(1200);
      Delay(75);
      NoSound;
    end;
  end else begin
    if (Sound_ON) then begin
      Sound(800);
      Delay(150);
      NoSound;
    end;
    SetTextJustify(CenterText,CenterText);
    SetColor(LightRed);
    OutTextXY(xmed,40,'Can''t move Item on Tower '+V2S(Mv_From)+' to Tower '+V2S(Mv_To)+'.');
    Delay(1000);
  end;
end;

function All(what: byte): word;
var tmp: word;
begin
  if what=1 then All:=1 else All:=what+All(what-1);
end;

function CheckWon: boolean;
var i,j: byte;
    sum: word;
    tmp: boolean;
begin
  for i:=2 to 3 do begin
    if (WhatsLast(i)=1) then begin
      sum := 0;
      for j:=1 to Hmax do begin
        sum := sum + Hanoi[i,j];
      end;
      if (sum=All(Hmax)) then begin
        tmp:=true;
        Break;
      end;
    end else tmp:=false;
  end;
  CheckWon := tmp;
end;

procedure Outit;
var i: byte;
begin
  TextMode(CO80);
  WriteLn('VMode : ',xmax,'x',ymax);
  WriteLn('Center: ',xmed,'x',ymed);
  for i:=1 to Hmax do begin
    WriteLn('Tower_X ',i,': ',Item_X[i]);
  end;
  WriteLn('Steps needed: ',Step:0);
  WriteLn;
  if (CheckWon) then WriteLn('Programm siegreich beendet.') else WriteLn('Programm grundlos beendet.');
end;

begin
  Init;
  repeat
    DrawBoard;
    if (CheckWon) then begin
      if (Sound_ON) then begin
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
      Break;
    end;
    SetColor(LightGreen);
    SetTextJustify(CenterText,BottomText);
    OutTextXY(xmed,ymax,'Press X to exit');
    SetTextJustify(LeftText,TopText);
    SetColor(Text_Color);
    Str(Step:3,tmp1);
    OutTextXY(550,10,'Step: '+tmp1);
    tmp1 := 'Move Item from Tower ';
    OutTextXY(10,10,'Press 1, 2 or 3 to select a tower.');
    OutTextXY(10,20,tmp1);
    Input := ReadKey;
    if (Input='1') OR (Input='2') OR (Input='3') then begin
      Val(Input,Mv_From,Code);
      Str(Mv_From:0,tmp2);
      tmp1 := tmp1 + tmp2 + ' to Tower ';
      OutTextXY(10,20,tmp1);
      Input := ReadKey;
      if (Input='1') OR (Input='2') OR (Input='3') then begin
        Val(Input,Mv_To,Code);
        Str(Mv_To:0,tmp2);
        tmp1 := tmp1 + tmp2 + ' ...';
        OutTextXY(10,20,tmp1);
        MoveFromTo(Mv_From,Mv_To);
      end else if (Input<>'x') AND (Input<>'X') then begin
        if (Sound_ON) then begin
          Sound(800);
          Delay(150);
          NoSound;
        end;
      end else Break;
    end else if (Input<>'x') AND (Input<>'X') then begin
      if (Sound_ON) then begin
        Sound(800);
        Delay(150);
        NoSound;
      end;
    end;
  until (Input='x') OR (Input='X');
  Outit;
end.