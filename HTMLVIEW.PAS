 program HTML_Viewer; { geschrieben von RoboCop of nOOb a.k.a. Markus Birth }

uses Crt, Logo, BasicStrings, HTML, Statusbar, CursorOnOff, HTMLV_Unit;

var ViewTags: boolean;              { Tags anzeigen - BOOLEAN }
    ShowCols: boolean;              { Farben zeigen - BOOLEAN }
    WordWrap: boolean;              { Wortumbruch   - BOOLEAN }
    ConvEntit: boolean;             { Entity-Konv.  - BOOLEAN }
    IK: char;                       { gedrÅckte Taste }
    skipped: longint;               { Zeilen, die vom Dokument Åbersprungen wurden (alle, die schon weggescrollt wurden) }
    SwitchToNormal: boolean;        { Soll ich nach dem nÑchsten '>' in die Normalfarbe wechseln? }

procedure SetPrefs; { Voreinstellungen festlegen }
begin
  ViewTags := false;
  ShowCols := true;
  WordWrap := false;
  ConvEntit:= true;
  Color_Normal     := 11;
  Color_Comments   :=  7;
  Color_Bold       := 14;
  Color_Italic     := 15;
  Color_Underlined := 13;
  Color_Anchor     := 12;
  Color_Font       := 10;
end;

procedure About; { Der Kommentar, der bei fehlendem Parameter ausgegeben wird }
begin
  WriteLogo;
  TextColor(15);
  WriteLn('-=˛ HTML Viewer ˛=-');
  WriteLn;
  TextColor(7);
  WriteLn('Entfernt HTML-Tags aus Dateien und zeigt sie an.');
  WriteLn('Geschrieben von RoboCop of nOOb');
  WriteLn;
  WriteLn('Dies ist noch die ''dumme'' Version. Sie entfernt alles, was zwischen');
  WriteLn('< und > steht. Eine intelligente Version wird auch noch folgen!');
  WriteLn;
  WriteLn('Syntax: '+ParamStr(0)+' <HTML-Datei>');
  Halt
end;

procedure UpdateStatus; { Schreibt Statusleiste }
begin
  WriteStatusItem( 1,'Hilfe');
  if ViewTags then  WriteStatusItem(2,'k.Tags') else WriteStatusItem(2,'Tags');
  if ShowCols then  WriteStatusItem(3,'k.Farb') else WriteStatusItem(3,'Farben');
  if WordWrap then  WriteStatusItem(4,'k.Wrap') else WriteStatusItem(4,'Wrap');
  if ConvEntit then WriteStatusItem(5,'Entity') else WriteStatusItem(5,'Umlaut');
  WriteStatusItem( 6,'');
  WriteStatusItem( 7,'');
  WriteStatusItem( 8,'');
  WriteStatusItem( 9,'');
  WriteStatusItem(10,'Ende');  { Hier nur 5 Zeichen verwutzen, da sonst die Statusleiste eins hîher rutscht }
end;

function IsCloseTag(T: string): boolean; { PrÅft, ob T ein Schlie·-Tag ist und gibt je nachdem TRUE oder FALSE zurÅck }
var C3: string[3];
    C4: string[4];
    C5: string[5];
begin
  C3 := Left(T,3);
  C4 := Left(T,4);
  C5 := Left(T,5);
  if ( (C3='-->')
    or (C4='</B>')
    or (C4='</I>')
    or (C4='</A>')
    or (C4='</U>')
    or (C5='</FON')) then IsCloseTag := true else IsCloseTag := false;
end;

function MakeColor(Temp: string; i: integer): integer; { Setzt je nach Tag neue Textfarbe }
var PART: string[5];
    C3: string[3];
    C4: string[4];
begin
  if i>4 then PART := Mid(Temp,i,5);
  C3 := Mid(Temp,i,3);
  C4 := Mid(Temp,i,4);
  if IsCloseTag(PART) then SwitchToNormal:=true;
  if C3='<B>' then MakeColor:=Color_Bold
  else if C3='<I>' then MakeColor:=Color_Italic
  else if C3='<U>' then MakeColor:=Color_Underlined
  else if C3='<A ' then MakeColor:=Color_Anchor
  else if C4='<FON' then MakeColor:=Color_Font
  else if C4='<!--' then MakeColor:=Color_Comments
  else MakeColor:=Color_Normal;
end;

procedure WriteLine(var Temp: string); { Schreibt eine Zeile auf den Bildschirm }
var si: string[1];
    i,j: integer;
    lc: integer;
    t: boolean;
    nc: integer;
begin
  lc := 1;
  if ConvEntit then ConvEntities(Temp);
  for i:=1 to length(Temp) do begin { FÅr den ganzen String }
    si:=Mid(Temp,i,1); { si ist das momentane Zeichen bei i }
    if ((si='<') or (Mid(Temp,i,3)='-->')) then begin { Wenn Zeichen == '<' oder die nÑchsten 3 == '-->' }
      t:=true; { Ja, es ist ein Tag }
      if ShowCols then nc:=MakeColor(Temp,i) else nc:=0; { Wenn Farben AN, dann Tag-Farbe --> nc }
    end;
    if ((not t) and ((lc<=80) or (WordWrap))) then begin { Wenn kein Tag und Ausgegebene Zeichen noch nicht 80 }
      Write(si); { mom. Zeichen ausgeben }
      Inc(lc); { Ausgegebene Zeichen += 1 }
    end else if ((ViewTags) and ((lc<=80) or (WordWrap))) then begin { sonst, wenn Tags AN und Ausg. Z. noch nicht 80 }
      if ((not SwitchToNormal) and (nc<>0)) then TextColor(nc); { Wenn nicht SwitchToNormal und new color != 0, dann TC=nc }
      Write(si); { mom. Zeichen ausgeben }
      Inc(lc); { Ausgegebene Zeichen += 1 }
    end;
    if ((si='>') or (Mid(Temp,i-3,3)='!--')) then begin { Wenn Zeichen == '>' oder die letzten 3 == '!--' }
      t := false; { Nein, es ist kein Tag mehr }
      if nc<>0 then TextColor(nc); { Wenn new color != 0, dann TC=nc }
      if SwitchToNormal then begin { Wenn SwitchToNormal }
        SwitchToNormal := false; { Nee, kein SwitchToNormal mehr, einmal reicht }
        TextColor(Color_Normal); { Textfarbe auf Normal }
      end;
    end;
  end;
  if WhereX<>1 then for i:=WhereX to 80 do Write(' '); { Rest der Zeile mit Leerzeichen auffÅllen }
end;

procedure RebuildScreen; { Schreibt den Bildschirm neu - OHNE CLRSCR }
var i,j: integer;
begin
  window(1,2,80,25);
  TextBackground(1);
  TextColor(11);
  GotoXY(1,1);
  for i:=1 to 23 do begin
    if Screen[i]<>'' then WriteLine(Screen[i]);
  end;
  for i:=WhereY to 23 do for j:=1 to 80 do Write(' ');
  window(1,1,80,25);
end;

procedure ShowData; { Liest Datei ein }
var Temp: string;
    i: integer;
begin
  window(1,2,80,24);
  TextColor(11);
  TextBackground(1);
  while not Eof(HTMLFile) do begin
    ReadLn(HTMLFile,Temp);
    Inc(i);
    if i>23 then begin
      ShiftScreen;
      Screen[23]:=Temp;
    end;
    WriteLine(Temp);
  end;
  window(1,1,80,25);
end;

procedure WaitForInput; { Wartet auf Eingabe und fÅhrt je nach Taste verschiedene Operationen aus }
label ExitWFI, Again;
begin
Again:
  IK := ReadKey;
  case IK of
    #000: begin  { Funktionstaste oder Sondertaste erwischt! }
            IK := ReadKey;
            case IK of
              #059: ShowAbout;                                                   { F1  }
              #060: if ViewTags then ViewTags := false else ViewTags := true;    { F2  }
              #061: if ShowCols then ShowCols := false else ShowCols := true;    { F3  }
              #062: if WordWrap then WordWrap := false else WordWrap := true;    { F4  }
              #063: if ConvEntit then ConvEntit := false else ConvEntit := true; { F5  }
              #068: goto ExitWFI;                                                { F10 }
            end;
          end;
    #027: goto ExitWFI;                          { ESC }
  else Sound(1200); Delay(100); NoSound;         { andere Taste }
  end;
  UpdateStatus;
  RebuildScreen;
  goto Again;
ExitWFI:
end;

begin
  if ParamCount=0 then About;
  OpenHTML; { Datei îffnen }
  SetPrefs; { Voreinstellungen setzen }
  MakeScreen; { Bildschirm aufbauen }
  UpdateStatus; { Statuszeile aufbauen }
  CursorOff; { Weg mit dem Blinker }
  ShowData; { Daten anzeigen }
  WaitForInput; { Auf Taste warten }
  Close(HTMLFile); { Datei schlie·en }
  window(1,1,80,25); { WINDOW wieder setzen }
  TextColor(7);            { Alte DOS-Farben  }
  TextBackground(0);       { wiederherstellen }
  ClrScr; { Bildschirm nochmal lîschen - LETZTE ôLUNG }
  CursorOn; { Und Cursor wieder rumblinken lassen - Elektro Schocks}
end.
