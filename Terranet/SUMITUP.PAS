program SumItUp;

{ This program will do the following:
  ( Uses Terranet-Chat-files in HTML or Plain Text)

  1. Count the chatter, who speak and shows her names.
  2. Count the chatter at all.
  3. Count the statements per chatter
  4. Average length of statements (in words)
  5. Count used "Smileys"
  6. Count used "actions" (everything between 2 *s)

  }

  (* Program copyright by Markus Birth <Robo.Cop@gmx.net> *)

uses Crt,ColWrite,LinStat;

var InF: text;
    OutF: text;
    OutFM: integer;
    choice: char;
    SpChC, ChC, SmC, AcC: integer;
    SpCh: array[1..500] of string[20];

procedure Abort(errmsg: string);
begin
  Wcheck('%%140#fail');
  WriteLn;
  if errmsg<>'HELP' then begin
    TextColor(12+blink);
    Write('FEHLER: ');
    TextColor(12);
    WriteLn(errmsg);
  end;
  TextColor(15);
  WriteLn;
  WriteLn('Syntax: ',ParamStr(0),' <Chat-Logfile> <Statistik-Datei>');
  TextColor(7);
  WriteLn;
  WriteLn('<Chat-Logfile> ist die Datei, die das Chat-Log enthÑlt. Vorzugsweise sollte');
  WriteLn('diese Datei im "Plain Text"-Format sein.');
  WriteLn;
  WriteLn('<Statistik-Datei> ist die Ausgangs-Datei, in der schlie·lich die Statistik-');
  WriteLn('Informationen enthalten sein sollen. Das Ausgabeformat fÅr die Statistik ist');
  WriteLn('HTML und kann somit mit jedem Browser betrachtet werden.');
  WriteLn;
  Halt;
end;

procedure FileIError(EC: integer);
begin
  Wcheck('%%140#fail');
  WriteLn;
  TextColor(12);
  WriteLn('Der Fehler ',EC,' trat wÑhrend des Versuches, die Datei ''',ParamStr(1),''' zu');
  WriteLn('îffnen, auf.');
  WriteLn;
  CWriteLn('%%7#Mîgliche Fehlerursachen: ˘Dateiname/Pfadangabe falsch geschrieben');
  WriteLn('                         ˘Datei wird gerade von anderer Anwendung benutzt');
  WriteLn('                         ˘kurzer Dateiname entspricht nicht den Anfangs-');
  WriteLn('                          buchstaben des LFNs');
  WriteLn('                         ˘Datei befindet sich nicht im aktuellen Verzeichnis');
  WriteLn;
  CWriteLn('%%14#-=+ Bitte drÅcken Sie eine Taste +=-');
  TextColor(8);
  ReadKey;
  Halt;
end;

procedure Init;
begin
  OutFM:=0;
  TextBackground(0);
  ClrScr;
  TextColor(11);
  TextBackground(1);
  Write('-=+ Chat - Auswertung +=-');
  TextBackground(0);
  TextColor(8);
  Write('   Copyright (c)1998 by Markus Birth <Robo.Cop@gmx.net>');
  TextColor(7);
  WriteLn;
  WStat('Parameter testen');
  if ParamCount=0 then Abort('HELP');
  if ((ParamStr(1)='/?') OR (ParamStr(1)='-?')) then Abort('HELP');
  if ParamCount<2 then Abort('Zu wenig Parameter angegeben!');
  Wcheck('%%10# OK ');
  WStat('Dateivariablen zuweisen');
  Assign(InF,ParamStr(1));
  Assign(OutF,ParamStr(2));
  Wcheck('%%10# OK ');
  WStat('Eingabedatei prÅfen');
  {$I-} Reset(InF); {$I+}
  if IOResult<>0 then FileIError(IOResult);
  Close(InF);
  Wcheck('%%10# OK ');
  WStat('Ausgabedatei prÅfen');
  {$I-} Reset(OutF); {$I+}
  if IOResult=0 then begin
    Wcheck('%%14#WARN');
    Close(OutF);
    WriteLn;
    CWriteLn('%%12#Die Ausgabedatei existiert schon!%%7#');
    WriteLn('Mîchten Sie die Ausgabedatei [U]eberschreiben, die neuen Daten');
    Write('an sie [A]nhÑngen oder a[b]brechen (U/A/b) ? ');
    choice := ReadKey;
    Window(1,7,80,10);
    ClrScr;
    Window(1,1,80,25);
    GotoXY(1,7);
    case choice of
      'a','A': OutFM := 1;
      'u','U': OutFM := 2;
      'b','B': begin
                 WriteLn;
                 WriteLn('Bitte geben Sie eine andere Ausgabedatei an, oder bennen die momentane um.');
                 Halt;
               end;
    end;
  end else begin
    Wcheck('%%10# OK ');
  end;
end;

procedure Parse(tmp: string);
var i,j:integer;
    stat: boolean;
begin
  for i:=1 to Length(tmp) do begin
    if Copy(tmp,i,2)='>>' then begin
      stat:=false;
      for j:=1 to SpChC do begin
        if SpCh[j]=Copy(tmp,1,i-2) then stat:=true;
      end;
      if NOT stat then begin
        Inc(SpChC);
        SpCh[SpChC]:=Copy(tmp,1,i-2);
        WriteLn(OutF,'Chatter ',SpChC,': ',SpCh[SpChC]);
      end;
    end;
  end;
end;

procedure WorkIO;
var tmp: string;
begin
  while NOT Eof(InF) do begin
    ReadLn(InF,tmp);
    Parse(tmp);
  end;
end;

procedure OpenIO;
begin
  WStat('Eingabedatei îffnen');
  Reset(InF);
  Wcheck('%%10# OK ');
  WStat('Ausgabedatei îffnen');
  case OutFM of
    1: begin
         Append(OutF);
         Wcheck('%%14#APPD');
       end;
    2: begin
         Rewrite(OutF);
         Wcheck('%%12#CLRD');
       end;
    0: begin
         Rewrite(OutF);
         Wcheck('%%10# OK ');
       end;
  end;
  WStat('Header erstellen');
  WriteLn(OutF,'<HTML>');
  WriteLn(OutF,'<HEAD>');
  WriteLn(OutF,'<!-- This HTML file was created with SumItUp, a PASCAL program for Chat');
  WriteLn(OutF,'     statistics Copyrighted by Markus Birth <Robo.Cop@gmx.net>');
  WriteLn(OutF,'  <TITLE>Auswertung von ',ParamStr(1),'</TITLE>');
  WriteLn(OutF,'</HEAD>');
  WriteLn(OutF,'<BODY TEXT=black BGCOLOR=white LINK=navy VLINK=navy ALINK=yellow>');
  WriteLn(OutF,'<FONT SIZE=+4 COLOR=red FACE="Impact,Haettenschweiler,Arial">Auswertung</FONT><BR>');
  WriteLn(OutF,'<FONT SIZE=-1 COLOR=#c0c0c0><A HREF="mailto:Robo.Cop@gmx.net">Mail the author</A></FONT>');
  WriteLn(OutF,'<P>');
  Wcheck('%%10# OK ');
end;

procedure CloseIO;
begin
  WStat('Eingabedatei schlie·en');
  Close(InF);
  Wcheck('%%10# OK ');
  WStat('Footer erstellen');
  WriteLn(OutF,'</BODY>');
  WriteLn(OutF,'</HTML>');
  Wcheck('%%10# OK ');
  WStat('Ausgabedatei schlie·en');
  Close(OutF);
  Wcheck('%%10# OK ');
end;

begin
  Init;
  OpenIO;
  WorkIO;
  CloseIO;
end.
