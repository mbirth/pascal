program Visualization2;

uses Crt, Graph, VFx, BGIP;

const cnt: byte=0;
      abo: boolean=false;
      firstrun: boolean=true;
      Simple_quick:boolean=false;
      DataFile='visual2.ini';
      Arraytypes: array[0..2] of string[20]=('zufall','aufsteigend','absteigend');

var xmax, ymax, xmed, ymed: word;
    xarr,oarr: array[0..639] of integer;
    pretime, opretime: integer;
    slow_, fact_, oslow_, ofact_: array[1..11] of integer;
    slow,fact: integer;
    sel: byte;
    DotCol, TrailCol, oDotCol, oTrailCol: byte;
    {BGIPath,} oBGIPath: string;
    Arraytype, oArraytype, OAT: byte;

function GetIniString(line: byte): string;
var f: text;
    i: integer;
    tmp: string;
begin
  Assign(f,DataFile);
  {$I-}
  Reset(f);
  if IOResult<>0 then begin
    TextMode(co80);
    WriteLn('Fehler beim Lesen der ',Datafile,' ... existiert die auch?');
    WriteLn('... und sind wir auch im richtigen Verzeichnis????');
    WriteLn;
    WriteLn('Egal ... ich leg'' mir selbst eine an ... ');
    Rewrite(f);
    if IOResult<>0 then begin
      WriteLn('Schei·e ... nicht mal das geht auf diesem Sau-Rechner ...');
      WriteLn('Mu·t wohl doch DU das Problem lîsen .... sieh'' mal zu, da·');
      WriteLn('Du mehr Rechte auf dieses Verzeichnis bekommst!');
      WriteLn;
      Halt;
    end;
    WriteLn(f,'D:\BP\BGI');
    WriteLn(f,'2000');
    WriteLn(f,'15');
    WriteLn(f,'8');
    WriteLn(f,'5');
    WriteLn(f,'0');
    WriteLn(f,'1');
    WriteLn(f,'50');
    WriteLn(f,'1');
    WriteLn(f,'10');
    WriteLn(f,'30');
    WriteLn(f,'0');
    WriteLn(f,'1');
    WriteLn(f,'10');
    WriteLn(f,'0');
    WriteLn(f,'');
    WriteLn(f,'INI-Datei fÅr VISUAL2.EXE (bzw. VISUAL2.PAS)');
    WriteLn(f,'');
    WriteLn(f,'   Copyright (c)1999 by Markus Birth <mbirth@webwriters.de>');
    WriteLn(f,'');
    WriteLn(f,' 1. Zeile: BGI-Path');
    WriteLn(f,' 2. Zeile: Pre-Delay vor Grafikanzeige');
    WriteLn(f,' 3. Zeile: Punktfarbe');
    WriteLn(f,' 4. Zeile: Spurfarbe');
    WriteLn(f,' 5. Zeile: einfachstes Sort (normal): -Faktor');
    WriteLn(f,' 6.                                   -Delay');
    WriteLn(f,' 7. Zeile: einfachstes Sort (quick): -Faktor');
    WriteLn(f,' 8.                                  -Delay');
    WriteLn(f,' 9. Zeile: Selectionsort: -Faktor');
    WriteLn(f,'10.                       -Delay');
    WriteLn(f,'11. Zeile: Bubblesort: -Faktor');
    WriteLn(f,'12.                    -Delay');
    WriteLn(f,'13. Zeile: Quicksort: -Faktor');
    WriteLn(f,'14.                   -Delay');
    WriteLn(f,'15. Zeile: Arraytype (0-Random, 1-aufsteigend, 2-absteigend)');
    Close(f);
    WriteLn('Sooo, das wÑre geschafft! Wenn Du jetzt das Programm nocheinmal');
    WriteLn('aufrufst, mÅ·te alles funktionieren!');
    Halt;
  end;
  {$I+}
  for i:=1 to line do ReadLn(f,tmp);
  Close(f);
  GetIniString := tmp;
end;

function Str2Val(st: string): integer;
var tmp, ec: integer;
begin
  Val(st,tmp,ec);
  if (ec<>0) then begin
    TextMode(co80);
    WriteLn('Fehler beim Umwandeln eines Strings in einen numerischen Wert.');
    WriteLn('Stimmen die EintrÑge in der INI-Datei??');
    Halt;
  end;
  Str2Val := tmp;
end;

procedure ReadIni;
var tmp: string;
begin
  BGIPath   := GetIniString(1);
  pretime   := Str2Val(GetIniString(2));
  DotCol    := Str2Val(GetIniString(3));
  TrailCol  := Str2Val(GetIniString(4));
  fact_[1]  := Str2Val(GetIniString(5));
  slow_[1]  := Str2Val(GetIniString(6));
  fact_[11] := Str2Val(GetIniString(7));
  slow_[11] := Str2Val(GetIniString(8));
  fact_[2]  := Str2Val(GetIniString(9));
  slow_[2]  := Str2Val(GetIniString(10));
  fact_[3]  := Str2Val(GetIniString(11));
  slow_[3]  := Str2Val(GetIniString(12));
  fact_[4]  := Str2Val(GetIniString(13));
  slow_[4]  := Str2Val(GetIniString(14));
  Arraytype := Str2Val(GetIniString(15));
end;

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
  TextBackground(0);
  ClrScr;
  WriteLn('Dieses Programm wurde Ihnen prÑsentiert von ..... nein, nicht Krombacher!');
  WriteLn('Aber dafÅr von Markus Birth, SchÅler der 12. Klasse im Jahrgang 1998/99');
  WriteLn;
  WriteLn;
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

function InArray(what: integer): boolean;
var i: word;
   tmp: boolean;
begin
  tmp := false;
  for i:=0 to 639 do begin
    if xarr[i]=what then begin
      tmp := true;
      Exit;
    end;
  end;
  InArray := tmp;
end;

procedure InitArray;
var i: word;
   tmp: integer;
begin
  Randomize;
  for i:=0 to 639 do begin
    case Arraytype of
      0: xarr[i] := Random(480);
      1: if (i<480) then xarr[i] := i else xarr[i] := 479;
      2: if (i<480) then xarr[i] := 479-i else xarr[i] := 0;
    end;
    oarr[i] := xarr[i];
  end;
end;

procedure OutArray;
var i: word;
begin
  if (keypressed) then begin
    abo := true;
    Exit;
  end;
  Inc(cnt);
  if (cnt>=fact) then begin
    cnt := 0;
    for i:=0 to 639 do begin
      PutPixel(i,479-oarr[i],TrailCol);
      PutPixel(i,479-xarr[i],DotCol);
      oarr[i]:=xarr[i];
    end;
    Delay(slow);
  end;
end;

procedure PutBigPixel(x,y: word;c: byte);
begin
  PutPixel(x-1,y-1,c);
  PutPixel(x-1,y,c);
  PutPixel(x-1,y+1,c);
  PutPixel(x,y-1,c);
  PutPixel(x,y,c);
  PutPixel(x,y+1,c);
  PutPixel(x+1,y-1,c);
  PutPixel(x+1,y,c);
  PutPixel(x+1,y+1,c);
end;


{###########################################################################
 ###########################################################################
 ##################### SORTIER ALGORITHMEN #################################
 ###########################################################################
 ###########################################################################}

procedure Sort_Simple;
var i,j: integer;
    yi,yj: integer;
begin
  for i:=0 to 638 do begin
    for j:=i+1 to 639 do begin
      yi := 479-xarr[i];
      yj := 479-xarr[j];
      { PutBigPixel(j,yj,12); }
      if xarr[j]<xarr[i] then begin
        SwapVal(xarr[i],xarr[j]);
        if NOT Simple_quick then OutArray;
      end;
      { Delay(5);
      PutBigPixel(j,yj,0);
      PutPixel(j,479-xarr[j],15); }
      if (abo) then Exit;
    end;
    if (abo) then Exit;
    if Simple_quick then OutArray;
  end;
end;

procedure Sort_Selectionsort;
var i,j,minpos: integer;
begin
  for i:=0 to 638 do begin
    minpos := i;
    for j:=i+1 to 639 do begin
      if xarr[j]<xarr[minpos] then begin
        minpos:=j;
      end;
    end;
    SwapVal(xarr[i],xarr[minpos]);
    OutArray;
    if (abo) then Exit;
  end;
end;

procedure Sort_Bubblesort;
var i: integer;
    canswap: boolean;
begin
  repeat
    canswap:=false;
    for i:=0 to 638 do begin
      if xarr[i]>xarr[i+1] then begin
        SwapVal(xarr[i],xarr[i+1]);
        OutArray;
        canswap := true;
      end;
      if (abo) then Exit;
    end;
  until (NOT canswap) OR (abo);
end;

{#################################}

procedure Sort_Insertionsort;
var h,i,j: integer;
begin
  for i:=2 to 638 do begin
    h       := xarr[i];
    xarr[0] := h;
    j       := i-1;
    while h<xarr[j] do begin
      xarr[j+1] := xarr[j];
      OutArray;
      if (i>2) then Dec(j) else exit;
    end;
    xarr[j+1] := h;
    if (abo) then Exit;
  end;
end;



procedure Sort_QuickSort(sta,sto: integer; var f: array of integer);
var li, re: integer;
    h, vgl: integer;
begin
     li:=sta; re:=sto; vgl:=f[(li+re) DIV 2];

     if li<re then begin
       repeat
         while f[li]<vgl do Inc(li);
         while f[re]>vgl do Dec(re);
         if li<=re then begin
           SwapVal(f[li],f[re]);
           inc(li); dec(re);
           OutArray;
         end;
       until (li>re) OR (abo);
       if (NOT abo) then begin
         Sort_QuickSort(sta,re,f);
         Sort_QuickSort(li,sto,f);
       end;
     end;
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

procedure DoIt(what: byte);
begin
  InitArray;
  InitGraphics;
  OutArray;
  Delay(pretime);
  slow := slow_[what];
  fact := fact_[what];
  case what of
    1: Sort_Simple;
   11: begin
         Simple_quick := true;
         Sort_Simple;
       end;
    2: Sort_Selectionsort;
    3: Sort_Bubblesort;
    4: Sort_Quicksort(0,639,xarr);
  end;
  cnt := fact;
  OutArray;
  ReadyBeep;
  ReadKey;
  TextMode(co80);
end;

function KeyValid(sel: char): boolean;
begin
  if (sel IN ['A'..'E','a'..'e','s','S','X','x']) then KeyValid := true
    else KeyValid := false;
end;

procedure UpdateAType;
var ofxwd: integer;
begin
  ofxwd := fxwd;
  fxwd := 650;
  if (OAT<>255) then begin
    GotoXY(46,20);
    WriteLR(Arraytypes[OAT],1);
  end;
  GotoXY(46,20);
  WriteLR(Arraytypes[ArrayType],15);
  OAT := ArrayType;
  fxwd := ofxwd;
end;

function Menu: byte;
var sel: char;
begin
  OAT := 255;
  TextBackground(0);
  TextMode(co80 + Font8x8);
  ClrScr;
  DrawBorder2(1,1,79,50,11,1);
  if firstrun then fxwd := 650 else fxwd := 10;
  GotoXY(1,3);
  TextColor(8);
  CursorOff;
  WriteC('--==+ Visualization 2 +==--');
  Delay(300);
  FXWriteC('--==+ Visualization 2 +==--',15);
  GotoXY(29,6); FXWrite('[ ] Simplesort (normal)',11);
  GotoXY(29,8); FXWrite('[ ] Simplesort (quick)',11);
  GotoXY(29,10); FXWrite('[ ] Selectionsort',11);
  GotoXY(29,12); FXWrite('[ ] Bubblesort',11);
  GotoXY(29,14); FXWrite('[ ] Quicksort',11);
  GotoXY(29,20); FXWrite('[ ] Zahlenfolge: ',11);
  GotoXY(29,24); FXWrite('[ ] Voreinstellungen Ñndern',11);
  GotoXY(29,26); FXWrite('[ ] Programm beenden',11);
  fxwd := 10;
  GotoXY(30,6); FXWrite('A',14);
  GotoXY(30,8); FXWrite('B',14);
  GotoXY(30,10); FXWrite('C',14);
  GotoXY(30,12); FXWrite('D',14);
  GotoXY(30,14); FXWrite('E',14);
  GotoXY(30,20); FXWrite('T',14);
  GotoXY(30,24); FXWrite('S',14);
  GotoXY(30,26); FXWrite('X',14);
  if firstrun then fxwd := 650;
  UpdateAType;
  firstrun := false;
  GotoXY(1,30);
  FXWriteC('DrÅcken Sie einen der gelben Buchstaben (auf der Tastatur).',7);
  Menu := 0;
  repeat
    sel := ReadKey;
    if (NOT KeyValid(sel)) AND NOT (sel IN ['t','T']) then begin
      Sound(400);
      Delay(100);
      NoSound;
    end else begin
      Sound(1200);
      Delay(50);
      NoSound;
    end;
    if (sel IN ['t','T']) then begin
      Inc(ArrayType);
      if (ArrayType>2) then ArrayType := 0;
      UpdateAType;
    end;
  until KeyValid(sel);
  case sel of
    'a','A': Menu := 1;
    'b','B': Menu := 2;
    'c','C': Menu := 3;
    'd','D': Menu := 4;
    'e','E': Menu := 5;
    'x','X': Menu := 0;
    's','S': Menu := 128;
  end;
end;

procedure WriteLet(b: char;text: string;c: byte);
begin
  TextColor(c);
  Write('[');
  TextColor(14);
  Write(UpCase(b));
  TextColor(c);
  Write('] ',text);
end;

procedure OutSetup;
begin
  GotoXY(5,10); WriteLet('A','BGI-Pfad: ',10);
    TextColor(15); Write(BGIPath);
  GotoXY(5,12); WriteLet('B','Pre-Delay: ',10);
    TextColor(15); Write(pretime:0);
  GotoXY(30,12); WriteLet('C','Punktfarbe: ',10);
    TextColor(15); Write(DotCol:3,' ');
    TextColor(DotCol); Write('€');
  GotoXY(55,12); WriteLet('D','Spurfarbe: ',10);
    TextColor(15); Write(TrailCol:3,' ');
    TextColor(TrailCol); Write('€');
  GotoXY(5,15); WriteLet('E','einfachstes Sort (normal)',11);
  GotoXY(45,15); WriteLet('F','einfachstes Sort (quick)',11);
  GotoXY(5,19);  WriteLet('G','Selectionsort',11);
  GotoXY(45,19); WriteLet('H','Bubblesort',11);
  GotoXY(5,23);  WriteLet('I','Quicksort',11);
  TextColor(8);
  GotoXY(45,25); Write('Zahlenfolge: ',ArrayTypes[ArrayType]);
  GotoXY(11,16); Write('Faktor: ',fact_[1]);
  GotoXY(11,17); Write('Delay : ',slow_[1]);
  GotoXY(51,16); Write('Faktor: ',fact_[11]);
  GotoXY(51,17); Write('Delay : ',slow_[11]);
  GotoXY(11,20); Write('Faktor: ',fact_[2]);
  GotoXY(11,21); Write('Delay : ',slow_[2]);
  GotoXY(51,20); Write('Faktor: ',fact_[3]);
  GotoXY(51,21); Write('Delay : ',slow_[3]);
  GotoXY(11,24); Write('Faktor: ',fact_[4]);
  GotoXY(11,25); Write('Delay : ',slow_[4]);
  GotoXY(7,47);
    WriteLet('O','Eingaben Åbernehmen',15); Write('      ');
    WriteLet('S','Eingaben sichern',15); Write('      ');
    WriteLet('X','Abbrechen',15);
end;

function Setup_KeyValid(what: char): boolean;
begin
  if (what IN ['A'..'I','a'..'i','o','O','s','S','x','X']) then Setup_KeyValid:=true
    else Setup_KeyValid := false;
end;

procedure DoHelp;
begin
  window(5,28,75,45);
  TextBackground(1);
  ClrScr;
  window(6,29,74,44);
  TextColor(14);
  WriteLn('--==+ HILFE +==--');
  WriteLn;
  TextColor(15);
end;

procedure HelpDone;
begin
  window(1,1,80,50);
  TextBackground(2);
end;

procedure ClearHelp;
begin
  window(5,28,75,45);
  TextBackground(2);
  ClrScr;
  window(1,1,80,50);
end;

procedure Setup_GetVal(var v: integer);
var tmp: string;
    tmp2, ec: integer;
    wx, wy: word;
begin
  wx := WhereX;
  wy := WhereY;
  repeat
    GotoXY(wx,wy);
    Write(Space(10));
    GotoXY(wx,wy);
    ReadLn(tmp);
    Val(tmp,tmp2,ec);
    if (ec<>0) then ErrorBeep;
  until (tmp='') OR (ec=0);
  if (tmp<>'') then v := tmp2;
  AckBeep;
end;

procedure Setup_GetByte(var v: byte);
var tmp: string;
    tmp2, ec: integer;
    wx, wy: word;
begin
  wx := WhereX;
  wy := WhereY;
  repeat
    GotoXY(wx,wy);
    Write(Space(5));
    GotoXY(wx,wy);
    ReadLn(tmp);
    Val(tmp,tmp2,ec);
    if (ec<>0) then ErrorBeep;
  until (tmp='') OR (ec=0);
  if (tmp<>'') then v := tmp2;
  AckBeep;
end;

procedure Setup_BGIpath;
var tmp: string;
begin
  GotoXY(5,10);
  TextColor(10+blink); Write('[ ]');
  GotoXY(6,10);
  TextColor(14+blink); Write('A');
  DoHelp;
  WriteLn('Geben Sie den Pfad zu den BGI-Dateien an.');
  WriteLn;
  WriteLn('Beispiel: C:\SCHULS~1\TP\BGI');
  WriteLn;
  WriteLn('Um den alten Wert zu behalten, einfach [ENTER] drÅcken.');
  HelpDone;
  GotoXY(19,10); Write(Space(50));
  GotoXY(19,10);
  TextColor(15);
  ReadLn(tmp);
  if (tmp<>'') then BGIpath := tmp;
  ClearHelp;
  GotoXY(5,10); TextColor(10); Write('[ ]');
  GotoXY(6,10); TextColor(14); Write('A');
  GotoXY(19,10);TextColor(15); Write(BGIpath);
end;

procedure Setup_PreDelay;
var tmp: string;
    tmp2, ec: integer;
begin
  GotoXY(5,12);
  TextColor(10+blink); Write('[ ]');
  GotoXY(6,12);
  TextColor(14+blink); Write('B');
  DoHelp;
  WriteLn('Geben Sie die Zeit an, die vor der Grafikanzeige gewartet werden');
  WriteLn('soll. Dies ist bei den neueren Monitoren nîtig, da sie einige');
  WriteLn('Zeit benîtigen, um in den Grafikmodus zu schalten.');
  WriteLn;
  WriteLn('Beispiel: 2000 - fÅr 2 Sekunden');
  WriteLn;
  WriteLn('Um den alten Wert zu behalten, einfach [ENTER] drÅcken.');
  HelpDone;
  GotoXY(20,12); TextColor(15);
  Setup_GetVal(pretime);
  ClearHelp;
  GotoXY(5,12); TextColor(10); Write('[ ]');
  GotoXY(6,12); TextColor(14); Write('B');
  GotoXY(20,12); Write(Space(10));
  GotoXY(20,12);TextColor(15); Write(pretime:0);
end;

procedure ColTab;
begin
  WriteLn('  0   1   2   3   4   5   6   7');
  CWriteLn('%%0#€€€€%%1#€€€€%%2#€€€€%%3#€€€€%%4#€€€€%%5#€€€€%%6#€€€€%%7#€€€€');
  CWriteLn('%%8#€€€€%%9#€€€€%%10#€€€€%%11#€€€€%%12#€€€€%%13#€€€€%%14#€€€€%%15#€€€€');
  WriteLn('  8   9  10  11  12  13  14  15');
end;

procedure Setup_DotCol;
var tmp: string;
    tmp2,ec: integer;
begin
  GotoXY(30,12);
  TextColor(10+blink); Write('[ ]');
  GotoXY(31,12);
  TextColor(14+blink); Write('C');
  DoHelp;
  WriteLn('Geben Sie die Farbe fÅr die aktiven Punkte an.');
  WriteLn;
  WriteLn('Die Zahl mu· zwischen 0 und 255 liegen.');
  WriteLn('Um den alten Wert zu behalten, einfach [ENTER] drÅcken.');
  WriteLn;
  WriteLn('Beispiele:');
  WriteLn;
  ColTab;
  HelpDone;
  GotoXY(46,12); TextColor(15);
  Setup_GetByte(DotCol);
  ClearHelp;
  GotoXY(30,12); TextColor(10); Write('[ ]');
  GotoXY(31,12); TextColor(14); Write('C');
  GotoXY(46,12); Write(Space(5));
  GotoXY(46,12);TextColor(15); Write(DotCol:3,' '); TextColor(DotCol); Write('€');
end;

procedure Setup_TrailCol;
var tmp: string;
    tmp2,ec: integer;
begin
  GotoXY(55,12);
  TextColor(10+blink); Write('[ ]');
  GotoXY(56,12);
  TextColor(14+blink); Write('D');
  DoHelp;
  WriteLn('Geben Sie die Farbe fÅr die ehemaligen Punkte an.');
  WriteLn;
  WriteLn('Die Zahl mu· zwischen 0 und 255 liegen. 0 deaktiviert die Funktion.');
  WriteLn('Um den alten Wert zu behalten, einfach [ENTER] drÅcken.');
  WriteLn;
  WriteLn('Beispiele:');
  WriteLn;
  ColTab;
  HelpDone;
  GotoXY(70,12); TextColor(15);
  Setup_GetByte(TrailCol);
  ClearHelp;
  GotoXY(55,12); TextColor(10); Write('[ ]');
  GotoXY(56,12); TextColor(14); Write('D');
  GotoXY(70,12); Write(Space(5));
  GotoXY(70,12);TextColor(15); Write(TrailCol:3,' '); TextColor(TrailCol); Write('€');
end;

procedure Setup_Algos(x,y: word;c: char;t: string;no: byte);
var key: char;
begin
  GotoXY(x,y); TextColor(11+blink); Write('[ ]');
  GotoXY(x+1,y); TextColor(14+blink); Write(c);
  GotoXY(x+4,y); TextColor(15); Write(t);
  GotoxY(x+2,y+1); WriteLet('1','Faktor:',11);
    TextColor(15); Write(' ',fact_[no]);
  GotoXY(x+2,y+2); WriteLet('2','Delay :',11);
    TextColor(15); Write(' ',slow_[no]);
  repeat
    DoHelp;
    WriteLn('DrÅcken Sie "1" oder "2" um den Faktor oder das Delay zu Ñndern.');
    WriteLn('"X", wenn Sie hier nichts Ñndern wollen.');
    WriteLn;
    WriteLn('Faktor - ist die Beschleunigung, d.h. es wird nur noch jeder Xte');
    WriteLn('         Zustand auf dem Bildschirm ausgegeben, was die');
    WriteLn('         Bearbeitung und Visualisierung ungemein beschleunigt.');
    WriteLn;
    WriteLn('Delay  - die Wartedauer zwischen zwei Ausgaben. Bei schnellen Algo-');
    WriteLn('         rithmen sollte man ein Delay setzen, damit die Visuali-');
    WriteLn('         sierung in einer vernÅnftigen Geschwindigkeit ablÑuft.');
    HelpDone;
    key := ReadKey;
    case key of
      '1': begin
             GotoXY(x+2,y+1); TextColor(11+blink); Write('[ ]');
             GotoXY(x+3,y+1); TextColor(14+blink); Write('1');
             GotoXY(x+6,y+1); TextColor(15); Write('Faktor:');
             GotoXY(x+14,y+1); TextColor(15);
             DoHelp;
             WriteLn('Der Faktor gibt an, wieviel ZustÑnde wÑhrend der Visualisierung');
             WriteLn('Åbersprungen werden sollen. Es wird nur jeder Xte Zustand');
             WriteLn('angezeigt. Die Zahl kann im Bereich von 1 bis 32767 liegen,');
             WriteLn('aber man sollte sie nicht grî·er als etwa 100 wÑhlen, da sonst');
             WriteLn('die Visualisierung etwas merkwÅrdig aussieht.');
             WriteLn;
             WriteLn('Um den Wert nicht zu Ñndern, einfach [ENTER] drÅcken.');
             HelpDone;
             Setup_GetVal(fact_[no]);
             if (fact_[no]<1) then fact_[no]:=1;
             GotoXY(x+2,y+1); WriteLet('1','Faktor:',11);
               TextColor(15);
               GotoXY(x+14,y+1); Write(Space(10));
               GotoXY(x+14,y+1); Write(fact_[no]);
           end;
      '2': begin
             GotoXY(x+2,y+2); TextColor(11+blink); Write('[ ]');
             GotoXY(x+3,y+2); TextColor(14+blink); Write('2');
             GotoXY(x+6,y+2); TextColor(15); Write('Delay :');
             GotoXY(x+14,y+2); TextColor(15);
             DoHelp;
             WriteLn('Das Delay gibt an, wieviel Millisekunden zwischen der Anzeige');
             WriteLn('der einzelnen ZustÑnde "gewartet" werden sollen. Die Zahl kann');
             WriteLn('im Bereich von 0 bis 32767 liegen, sollte aber nie grî·er als');
             WriteLn('ca. 500 (´ Sekunde) gewÑhlt werden, da man sonst Stunden vor');
             WriteLn('dem Rechner sitzen kann, ohne gro· was zu sehen.');
             WriteLn;
             WriteLn('Um den Wert nicht zu Ñndern, einfach [ENTER] drÅcken.');
             HelpDone;
             Setup_GetVal(slow_[no]);
             GotoXY(x+2,y+2); WriteLet('2','Delay :',11);
               TextColor(15);
               GotoXY(x+14,y+2); Write(Space(10));
               GotoXY(x+14,y+2); Write(slow_[no]);
           end;
    end;
  until (key IN ['x','X']);
  ClearHelp;
  GotoXY(x,y); WriteLet(c,t,11);
  TextColor(8);
  GotoXY(x+2,y+1); Write('    Faktor:');
  GotoXY(x+2,y+2); Write('    Delay :');
  GotoXY(x+14,y+1); Write(Space(10));
  GotoXY(x+14,y+1); Write(fact_[no]);
  GotoXY(x+14,y+2); Write(Space(10));
  GotoXY(x+14,y+2); Write(slow_[no]);
end;

procedure Setup_SimpleSN;
var key: char;
begin
  Setup_Algos(5,15,'E','einfachstes Sort (normal)',1);
end;

procedure Setup_SimpleSQ;
begin
  Setup_Algos(45,15,'F','einfachstes Sort (quick)',11);
end;

procedure Setup_SelectionS;
begin
  Setup_Algos(5,19,'G','Selectionsort',2);
end;

procedure Setup_BubbleS;
begin
  Setup_Algos(45,19,'H','Bubblesort',3);
end;

procedure Setup_QuickS;
begin
  Setup_Algos(5,23,'I','Quicksort',4);
end;

procedure Setup_SaveVals;
var f: text;
begin
  Assign(f,DataFile);
  {$I-}
  Rewrite(f);
  if IOResult<>0 then begin
    TextMode(co80);
    WriteLn('Fehler beim Schreiben der INI-Datei ... haben Sie genug Rechte?');
    WriteLn('Ist die Datei VISUAL2.INI nicht schreibgeschÅtzt? Ist genug Platz');
    WriteLn('vorhanden?');
    WriteLn;
    Halt;
  end;
  {$I+}
  WriteLn(f,BGIPath);
  WriteLn(f,pretime:0);
  WriteLn(f,DotCol:0);
  WriteLn(f,TrailCol:0);
  WriteLn(f,fact_[1]:0);
  WriteLn(f,slow_[1]:0);
  WriteLn(f,fact_[11]:0);
  WriteLn(f,slow_[11]:0);
  WriteLn(f,fact_[2]:0);
  WriteLn(f,slow_[2]:0);
  WriteLn(f,fact_[3]:0);
  WriteLn(f,slow_[3]:0);
  WriteLn(f,fact_[4]:0);
  WriteLn(f,slow_[4]:0);
  WriteLn(f,ArrayType:0);
  WriteLn(f,'');
  WriteLn(f,'INI-Datei fÅr VISUAL2.EXE (bzw. VISUAL2.PAS)');
  WriteLn(f,'');
  WriteLn(f,'   Copyright (c)1999 by Markus Birth <mbirth@webwriters.de>');
  WriteLn(f,'');
  WriteLn(f,' 1. Zeile: BGI-Path');
  WriteLn(f,' 2. Zeile: Pre-Delay vor Grafikanzeige');
  WriteLn(f,' 3. Zeile: Punktfarbe');
  WriteLn(f,' 4. Zeile: Spurfarbe');
  WriteLn(f,' 5. Zeile: einfachstes Sort (normal): -Faktor');
  WriteLn(f,' 6.                                   -Delay');
  WriteLn(f,' 7. Zeile: einfachstes Sort (quick): -Faktor');
  WriteLn(f,' 8.                                  -Delay');
  WriteLn(f,' 9. Zeile: Selectionsort: -Faktor');
  WriteLn(f,'10.                       -Delay');
  WriteLn(f,'11. Zeile: Bubblesort: -Faktor');
  WriteLn(f,'12.                    -Delay');
  WriteLn(f,'13. Zeile: Quicksort: -Faktor');
  WriteLn(f,'14.                   -Delay');
  WriteLn(f,'15. Zeile: Arraytype (0-Random, 1-aufsteigend, 2-absteigend)');
  Close(f);
  AckBeep;
end;

procedure Setup_Abort;
begin
  BGIPath  := oBGIPath;
  pretime  := opretime;
  slow_    := oslow_;
  fact_    := ofact_;
  DotCol   := oDotCol;
  TrailCol := oTrailCol;
  ArrayType:= oArrayType;
end;

procedure Setup_SavePre;
begin
  oBGIPath  := BGIPath;
  opretime  := pretime;
  oslow_    := slow_;
  ofact_    := fact_;
  oDotCol   := DotCol;
  oTrailCol := TrailCol;
  oArrayType:= ArrayType;
end;

procedure Setup;
var sel: char;
begin
  Setup_SavePre;
  DrawBorder2(2,5,78,49,15,2);
  GotoXY(1,7);
  FXWriteC('Voreinstellungen Ñndern',15);
  OutSetup;
  repeat
    sel := ReadKey;
    if NOT Setup_KeyValid(sel) then begin
      Sound(400);
      Delay(100);
      NoSound;
    end else begin
      Sound(1200);
      Delay(50);
      NoSound;
    end;
    case sel of
      'a','A': Setup_BGIpath;
      'b','B': Setup_PreDelay;
      'c','C': Setup_DotCol;
      'd','D': Setup_TrailCol;
      'e','E': Setup_SimpleSN;
      'f','F': Setup_SimpleSQ;
      'g','G': Setup_SelectionS;
      'h','H': Setup_BubbleS;
      'i','I': Setup_QuickS;
      's','S': Setup_SaveVals;
      'x','X': Setup_Abort;
    end;
  until (sel IN ['o','O','x','X','s','S']);
end;

begin
  ReadIni;
  repeat
    sel := Menu;
    abo := false;
    case sel of
      1: Doit(1);
      2: Doit(11);
      3: Doit(2);
      4: Doit(3);
      5: Doit(4);
    128: Setup;
    end;
  until (sel=0);
  Outit;
end.
