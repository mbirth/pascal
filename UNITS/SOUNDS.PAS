unit Sounds;

interface
  var Debug: boolean;
  procedure Tone(s1,l: integer);
  procedure DualTone(s1,s2,l,del: integer);
  procedure Siren(mn,mx,l,di: integer);
  procedure Play(ply: string);
implementation


uses Crt;

const StatBG=1; { Status Background }
      NormBG=0; { Normal Background (DOS=0) }
      NormTX=7; { Normal Textcolor (DOS=7) }
      StatHi=14;{ Highlighted Status text (descriptions) }
      StatNr=11;{ Normal Status text (values) }
      StatLo=7; { Minor / disabled status text (OFF-values / calculated values) }
      StatLoBG=0; { Minor / disabled background color }

procedure Tone(s1,l: integer); { Syntax: Tone(Hertz,Delay) }
var x,y: integer;
begin
  if Debug then begin
    Write('Single Tone with ',s1,' Hz for ',l,' ms.');
    y := WhereY;
    GotoXY(71,1);
    TextColor(StatHi);
    TextBackground(StatBG);
    Write('Freq: ');
    TextColor(StatNr);
    Write(s1:4);
  end;
  Sound(s1);
  Delay(l);
  NoSound;
  if Debug then begin
    GotoXY(71,1);
    TextColor(NormTX);
    TextBackground(NormBG);
    Write('          ');
    GotoXY(1,y);
    WriteLn;
  end;
end;


procedure DualTone(s1,s2,l,del: integer); { Syntax: DualTone(Tone1,Tone2,Delay,ToneDelay) }
var i: longint;
    x,y: integer;
begin
  if Debug then begin
    Write('DualTone with ',s1,' Hz and ',s2,' Hz for ',l,' ms.');
    y := WhereY;
    TextBackground(StatBG);
    TextColor(StatHI);
    GotoXY(71,1);
    Write('Frq1:     ');
    GotoXY(71,2);
    Write('Frq2:     ');
    GotoXY(71,3);
    Write('Dly:      ');
  end;
  for i:=0 to (l div (del*2)) do begin
    if Debug then begin
      TextBackground(StatLoBG);
      TextColor(StatLo);
      GotoXY(71,2);
      Write('Frq2: ',s2:4);
      TextBackground(StatBG);
      GotoXY(71,1);
      TextColor(StatHi);
      Write('Frq1: ');
      TextColor(StatNr);
      Write(s1:4);
      GotoXY(76,3);
      Write((i*del*2):5);
    end;
    Sound(s1);
    Delay(del);
    if Debug then begin
      TextBackground(StatLoBG);
      TextColor(StatLo);
      GotoXY(71,1);
      Write('Frq1: ',s1:4);
      TextBackground(StatBG);
      GotoXY(71,2);
      TextColor(StatHi);
      Write('Frq2: ');
      TextColor(StatNr);
      Write(s2:4);
      TextColor(StatLo);
      GotoXY(76,3);
      Write(((i+0.5)*del*2):5:0);
    end;
    Sound(s2);
    Delay(del);
  end;
  if Debug then begin
    TextColor(NormTX);
    TextBackground(NormBG);
    GotoXY(71,1);
    Write('          ');
    GotoXY(71,2);
    Write('          ');
    GotoXY(71,3);
    WriteLn('          ');
  end;
  NoSound;
end;

procedure Siren(mn,mx,l,di: integer); { Syntax: Siren(LoTone,HiTone,Delay,Divisor [for speed]) }
var i,t: longint;
    x,y: integer;
    lo,hi: integer;
begin
  if Debug then begin
    lo := mx;
    hi := mn;
    Write('Siren with tone from ',mn,' Hz to ',mx,' Hz for ',l,' ms (divisor=',di,').');
    y := WhereY;
    x := WhereX;
    TextColor(StatHi);
    TextBackground(StatBG);
    GotoXY(71,1);
    Write('Freq:     ');
    GotoXY(71,2);
    Write('Dly:      ');
    TextColor(StatNr);
  end;
  for i:=1 to l div 25 do begin
    t := Trunc(Sin(i/di)*((mx-mn) div 2)) + mn + ((mx-mn) div 2);
    if Debug then begin
      if t<lo then lo := t;
      if t>hi then hi := t;
      GotoXY(77,1);
      Write(t:4);
      GotoXY(76,2);
      Write((i*25):5);
    end;
    Sound(t);
    Delay(25);
  end;
  if Debug then begin
    TextColor(NormTX);
    TextBackground(NormBG);
    GotoXY(71,1);
    Write('          ');
    GotoXY(71,2);
    Write('          ');
    GotoXY(x+1,y);
    WriteLn('Hi:',hi,' Lo:',lo);
  end;
  NoSound;
end;

(*Basierend auf dem PLAY-Befehl von BASIC:

  Syntax: PLAY(string-ausdruck);

  string-ausdruck besteht aus den folgenden Kommandos, die auf diese Weise
  kombiniert werden: note [{#|+|-}]
  Dieser Ausdruck spielt note, wobei note ein Buchstabe von A bis G ist.
  Noten k”nnen um einen Halbton erh”ht oder erniedrigt werden, indem man
  ein # oder + (Halbton h”her) oder ein - (Halbton tiefer) als Be-
  zeichner an note anh„ngt. Andere Musikkommandos sind:

    Nn  Spielt Note n, wobei n im Bereich von 1 bis 84 sein kann
    On  Legt Oktave n fest, wobei n im Bereich von 0 bis 6 sein kann
    >n  Erh”ht die momentan gesetzte Oktave und spielt Note n
    <n  Erniedrigt die aktuelle Oktave und spielt Note n
    Ln  Bestimmt die L„nge folgender Noten (1 = ganze, 2 = halbe, 4 = viertel,
        8 = achtel, 16 = sechzehntel, 32 = 32.tel, 64 = 64.tel)
    Pn  Erzeugt eine Pause von n Notenl„ngen
    .   verl„ngert die Dauer einer Note auf das Eineinhalbfache ihres
        normalen Wertes
    Tn  Setzt das Tempo, wobei n die Anzahl der Viertelnoten in einer Minute
        ist (32 bis 255)
    MN  Spielt Musik im 7/8-Takt
    ML  Spielt Musik im normalen Takt (Legato)
    MS  Spielt Musik im 3/4-Takt (Staccato)
  *)

procedure Play(ply: string);
var i: integer;
    oct,len,ndel: integer;
begin
  oct := 3;
  len := 1;
  for i:=1 to Length(ply) do begin
    case ply[i] of
      'C': ;
      'D': ;
      'E': ;
      'F': ;
      'G': ;
      'A': ;
      'H': ;
      'B': ;
      '.': ndel := Trunc(ndel * 1.5);
      '>': if oct<6 then Inc(oct);
      '<': if oct>0 then Dec(oct);
    end;
  end;
end;


begin
  WriteLn('þ Loading Unit: Sounds - geschrieben von RoboCop of nOOb');
end.