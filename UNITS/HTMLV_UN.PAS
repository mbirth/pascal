unit HTMLV_Unit;

interface
  var HTMLFile: text;
      Screen: array[1..23] of string;
      ConvEntit: boolean;
      ShowCols: boolean;
      Color_Normal,Color_Comments,Color_Bold,Color_Italic,Color_Underlined,Color_Anchor,Color_Font: integer;
  procedure WriteCLn(t: string);
  procedure WriteC(t: string);
  procedure FileIError(ErrorCode: integer);
  procedure OpenHTML;
  procedure MakeScreen;
  procedure ShiftScreen;
  procedure ShowAbout;

implementation

uses Crt,BasicStrings;

procedure WriteCLn(t: string); { Schreibt einen String zentriert in die Zeile MIT Zeilenvorschub }
begin
  GotoXY(40-Length(t) div 2,WhereY);
  WriteLn(t);
end;

procedure WriteC(t: string); { Schreibt einen String zentriert in die Zeile OHNE Zeilenvorschub }
begin
  GotoXY(40-Length(t) div 2,WhereY);
  Write(t);
end;

procedure FileIError(ErrorCode: integer); { Prozedur fÅr Dateien, die keine sind }
begin
  TextColor(12);
  WriteLn('WARNUNG! Ein Fehler trat wÑhrend des Lesevorgangs auf!');
  WriteLn('Fehlercode: ',ErrorCode);
  TextColor(8);
  ReadKey;
  Halt;
end;

procedure OpenHTML; { ôffnet HTML-Datei (oder auch jede x-beliebige andere) }
begin
  Assign(HTMLFile, ParamStr(1));
{+I}  Reset(HTMLFile);  {-I}
  if IOResult<>0 then FileIError(IOResult);
end;

procedure MakeScreen; { Baut den Initialbildschirm auf }
var TitleBar: string[80];
    i: integer;
begin
  TextBackground(3);
  TextMode(3);
  ClrScr;
  window(1,1,80,24);
  TextBackground(1);
  ClrScr;
  window(1,1,80,25);
  TextBackground(3);
  TextColor(0);
  TitleBar := 'HTML: '+Right(ParamStr(1),12);
  for i:=Length(TitleBar) to 80 do begin
    TitleBar := TitleBar + ' '
  end;
  GotoXY(1,1);
  Write(TitleBar);
  GotoXY(1,25);
end;

procedure ShiftScreen; { Shiftet das Screen-Array (Screen[1]:=Screen[2]; Screen[2]:=Screen[3]; etc.) }
var i: integer;
begin
  for i:=2 to 23 do begin
    Screen[i-1] := Screen[i];
  end;
end;

procedure ShowAbout; { Zeigt About-Fenster }
var i,j: integer;
    winx,winy: integer;
    left,right,up,down: integer;
begin
  winx := 40;  winy := 14;     { Variablen fÅr die Breite / Hîhe des About-Fensters }
  TextBackground(3);
  TextColor(0);
  left := 40-(winx div 2);  right := 40+(winx div 2);
  up   := 12-(winy div 2);  down  := 12+(winy div 2);
  for i:=left to right do begin
    for j:=up to down do begin
      GotoXY(i,j);
      if (((j=up) or (j=down)) and (i<>left) and (i<>right)) then Write('Õ')
      else if (((i=left) or (i=right)) and (j<>up) and (j<>down)) then Write('∫')
      else if ((i=left) and (j=up)) then Write('…')
      else if ((i=right) and (j=up)) then Write('ª')
      else if ((i=left) and (j=down)) then Write('»')
      else if ((i=right) and (j=down)) then Write('º')
      else Write(' ');
    end;
  end;
  GotoXY(40,up+2);
  WriteCLn('-=˛ HTML Viewer ˛=-');
  WriteLn;
  WriteCLn('geschrieben in PASCAL');
  WriteCLn('von RoboCop of nOOb');
  WriteLn;
  GotoXY(left+2,up+7);
  Write('Farben:  ');
  TextColor(Color_Bold);       Write('Bold     ');
  TextColor(Color_Italic);     Write('Italic   ');
  TextColor(Color_Underlined); Write('Underline');
  GotoXY(left+11,up+8);
  TextColor(Color_Normal);     Write('Normal   ');
  TextColor(Color_Comments);   Write('Comments ');
  TextColor(Color_Anchor);     Write('Anchor   ');
  GotoXY(left+11,up+9);
  TextColor(Color_Font);       Write('Font-Def.');
  TextColor(0);
  GotoXY(40,up+12);
  WriteCLn('Bitte drÅcken Sie eine Taste');
  ReadKey;
  TextColor(11);
  TextBackground(1);
end;


begin
  WriteLn('˛ Loading Unit: HTMLV_Unit - geschrieben von RoboCop of nOOb');
end.