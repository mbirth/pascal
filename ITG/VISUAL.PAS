program Visualization;

uses Crt, Graph, BGIP;

const CompareColor = 14;
      HaveToSwapC  = 12;
      MarkDelay    = 500;
      Bool_Active  = 11;
      Bool_AText   = 0;
      Bool_Disabl  = 9;
      Bool_DText   = 15;

var xmax, ymax, xmed, ymed: word;
    xarr: array[1..10] of byte;

procedure InitGraphics;
var grDriver, grMode: integer;
begin
  grDriver := VGA;
  grMode   := VGAHi;
  InitGraph(grDriver, grMode, BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmhîhe in Pixeln }
  xmed := xmax DIV 2;
  ymed := ymax DIV 2;
end;

procedure Outit;
begin
  TextMode(CO80);
  WriteLn('VMode : ',xmax,'x',ymax);
  WriteLn('Center: ',xmed,'x',ymed);
  WriteLn;
  WriteLn('Programm beendet.');
end;

function V2S(x: byte): string;
var tmp: string;
begin
  Str(x,tmp);
  V2S := tmp;
end;

procedure SwapVal(var x1,x2: integer);
var tmp: integer;
begin
  tmp := x1;
  x1 := x2;
  x2 := tmp;
end;

procedure SwapValB(var x1,x2: byte);
var tmp: byte;
begin
  tmp := x1;
  x1 := x2;
  x2 := tmp;
end;

procedure InitArray;
var i: byte;
begin
  Randomize;
  for i:=1 to 10 do xarr[i] := Random(256);
end;

procedure MakeBox(el: byte;x,y: integer);
var tw: word;
begin
  SetTextJustify(CenterText,CenterText);
  tw := TextWidth(V2S(xarr[el]));
  SetFillStyle(SolidFill,1);
  Bar(x-tw DIV 2-2,y-5,x+tw DIV 2+2,y+5);
  SetColor(11);
  SetLineStyle(SolidLn,0,NormWidth);
  Rectangle(x-tw DIV 2-2,y-5,x+tw DIV 2+2,y+5);
  SetColor(15);
  OutTextXY(x,y+1,V2S(xarr[el]));
end;

procedure ClearBox(el: byte;x,y: integer);
var tw: word;
begin
  SetFillStyle(SolidFill,0);
  tw := TextWidth(V2S(xarr[el]));
  Bar(x-tw DIV 2-2,y-5,x+tw DIV 2+2,y+5);
end;

procedure OutArrayPlain(title: string);
var i: byte;
begin
  ClearViewPort;
  for i:=1 to 10 do begin
    MakeBox(i,64*i-32,40);
    SetColor(7);
    OutTextXY(64*i-32,30,V2S(i));
  end;
  SetColor(14);
  OutTextXY(320,15,title);
end;

procedure Mark(el,col: byte);
var tw: word;
    x : integer;
begin
  tw := TextWidth(V2S(xarr[el]));
  x := 64*el-32;
  SetColor(col);
  SetLineStyle(SolidLn,0,ThickWidth);
  Line(x-tw DIV 2-2,48,x+tw DIV 2+2,48);
end;

procedure Connect(el1,el2,col,depth: byte);
var x: integer;
begin
  SetColor(col);
  Mark(el1,col);
  Mark(el2,col);
  x := 64*el1-32;
  MoveTo(x,49);
  SetLineStyle(SolidLn,0,NormWidth);
  LineTo(x,49+depth*20);
  x := 64*el2-32;
  LineTo(x,49+depth*20);
  LineTo(x,49);
end;

procedure ClearConns;
begin
  SetFillStyle(SolidFill,0);
  Bar(5,47,635,149);
end;

procedure Swap(el1,el2: byte);
var i: integer;
    x1,x2: integer;
    lo,hi: integer;
    m1,m2: integer;
    SwapDelay: integer;
begin
  if (el1=el2) then Exit;
  x1 := 64*el1-32;
  x2 := 64*el2-32;
  if (x2<x1) then begin
    SwapVal(x1,x2);
    SwapValB(el1,el2);
  end;
  SwapDelay := 1000 DIV (x2-x1);
  for i:=40 to 80 do begin
    ClearBox(el1,x1,i);
    MakeBox(el1,x1,i+1);
    ClearBox(el2,x2,i);
    MakeBox(el2,x2,i+1);
    Delay(SwapDelay);
  end;

  for i:=x1 to x2-1 do begin
    m1 := i;
    m2 := x1+x2-i;
    ClearBox(el1,m1,81);
    MakeBox(el1,m1+1,81);
    ClearBox(el1,m2,81);
    MakeBox(el2,m2-1,81);
    Delay(SwapDelay);
  end;

  for i:=80 downto 40 do begin
    ClearBox(el2,x1,i+1);
    MakeBox(el2,x1,i);
    ClearBox(el1,x2,i+1);
    MakeBox(el1,x2,i);
    Delay(SwapDelay);
  end;
  SwapValB(xarr[el1],xarr[el2]);
end;

procedure ShowValue(desc: string;val: integer;el,col,depth: byte);
var OT: string;
begin
  SetFillStyle(SolidFill,0);
  Bar(0,320+depth*10-5,640,320+depth*10+5);
  SetColor(col);
  SetTextJustify(LeftText,CenterText);
  OT := desc+': '+V2S(val);
  OutTextXY(5,320+depth*10,OT);
  if (el<>0) then begin
    Mark(el,10);
    SetLineStyle(SolidLn,0,NormWidth);
    MoveTo(64*el-32,49);
    LineTo(64*el-32,320+depth*10);
    LineTo(TextWidth(OT)+10,320+depth*10);
    Delay(MarkDelay);
    SetColor(0);
    MoveTo(64*el-32,49);
    LineTo(64*el-32,320+depth*10);
    LineTo(TextWidth(OT)+10,320+depth*10);
    SetColor(CompareColor);
    MoveTo(64*el-32,49);
    LineTo(64*el-32,69);
    Mark(el,CompareColor);
  end;
end;

procedure Bool(text1,text2: string;what: boolean;depth: byte);
var OT: string;
begin
  SetTextJustify(CenterText,CenterText);
  if (what) then begin
    SetFillStyle(SolidFill,Bool_Active);
    SetColor(Bool_AText);
    OT := text1;
  end else begin
    SetFillStyle(SolidFill,Bool_Disabl);
    SetColor(Bool_DText);
    OT := text2;
  end;
  Bar(320,240+(depth-1)*20,639,240+(depth)*20);
  OutTextXY(480,240+(depth)*20-10,OT);
end;

{###########################################################################
 ###########################################################################
 ##################### SORTIER ALGORITHMEN #################################
 ###########################################################################
 ###########################################################################}

procedure Sort_Simple;
var i,j: integer;
begin
  for i:=1 to 9 do
    for j:=i+1 to 10 do begin
      Connect(i,j,CompareColor,1);
      Delay(MarkDelay);
      if xarr[j]<xarr[i] then begin
        Connect(i,j,HaveToSwapC,1);
        Delay(MarkDelay);
        ClearConns;
        Swap(i,j);
      end;
      ClearConns;
    end;
end;

procedure Sort_Selectionsort;
var i,j,minpos: integer;
begin
  for i:=1 to 9 do begin
    minpos := i;
    ShowValue('minpos',minpos,0,15,1);
    for j:=i+1 to 10 do begin
      Connect(i,j,CompareColor,1);
      Delay(MarkDelay);
      if xarr[j]<xarr[minpos] then begin
        minpos:=j;
        ShowValue('minpos',minpos,j,10,1);
        Delay(MarkDelay);
      end;
      ClearConns;
    end;
    if (i<>minpos) then begin
      Connect(i,minpos,HaveToSwapC,1);
      Delay(MarkDelay);
      ClearConns;
    end;
    Swap(i,minpos);
  end;
end;

procedure Sort_Bubblesort;
var i: integer;
    canswap: boolean;
begin
  repeat
    canswap:=false;
    Bool('Konnte was tauschen','Konnte (noch) nichts tauschen',canswap,1);
    for i:=1 to 9 do begin
      Connect(i,i+1,CompareColor,1);
      Delay(MarkDelay);
      if xarr[i]>xarr[i+1] then begin
        Connect(i,i+1,HaveToSwapC,1);
        Delay(MarkDelay);
        ClearConns;
        Bool('TAUSCHE','',true,1);
        Swap(i,i+1);
        canswap := true;
      end;
      Bool('Konnte was tauschen','Konnte (noch) nichts tauschen',canswap,1);
      ClearConns;
    end;
  until (NOT canswap);
end;






{###########################################################################
 ###########################################################################
 ######################### DER LETZTE REST #################################
 ###########################################################################
 ###########################################################################}

procedure WaitForKey;
var x: byte;
begin
  repeat
    x := Random(16);
    SetColor(x);
    SetTextJustify(CenterText,CenterText);
    OutTextXY(320,240,'SORTIERUNG ABGESCHLOSSEN - bitte eine Taste drÅcken');
    Delay(1);
  until keypressed;
  ReadKey;
end;

procedure Simplest_DEMO;
begin
  InitArray;
  OutArrayPlain('einfachste Sortierung');
  Sort_Simple;
  WaitForKey;
end;

procedure Selection_DEMO;
begin
  InitArray;
  OutArrayPlain('Selectionsort');
  Sort_Selectionsort;
  WaitForKey;
end;

procedure Bubble_DEMO;
begin
  InitArray;
  OutArrayPlain('Bubblesort');
  Sort_Bubblesort;
  WaitForKey;
end;

begin
  InitGraphics;
  { Simplest_DEMO; }
  Selection_DEMO;
  Bubble_DEMO;
  Outit;
end.
