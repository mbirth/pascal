program StripHTML;

uses ColWrite,LinStat,Crt;

const StripBegin='<';
      StripEnd='>';

var OutF, InF: text;
    OutFN, InFN: string;
    choice: char;
    OutFM: byte;
    tmp: string;


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
  WriteLn('Syntax: ',ParamStr(0),' <Dateiname>');
  TextColor(7);
  WriteLn;
  WriteLn('<Dateiname> ist der Dateiname OHNE ENDUNG. Die Eingabedatei mu· auf .HTM');
  WriteLn('enden und die Ausgabedatei wird auf .TXT enden.');
  WriteLn;
  CWrite('Beispiel: %%15#');
  Write(ParamStr(0));
  CWriteLn(' CHATLOG%%7#');
  WriteLn;
  WriteLn('          Entfernt alle HTML-Tags aus CHATLOG.HTM und speichert das Ergebnis');
  WriteLn('          in der Datei CHATLOG.TXT.');
  Halt;
end;

procedure FileIError(EC: integer);
begin
  Wcheck('%%140#fail');
  WriteLn;
  TextColor(12);
  WriteLn('Der Fehler ',EC,' trat wÑhrend des Versuches, die Datei ''',InFN,''' zu');
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
  ClrScr;
  CWriteLn('%%14,1# -=+ StripHTML +=- %%7,0#');
  WriteLn;
  WStat('Parameter testen');
  if ParamCount=0 then Abort('HELP');
  if ((ParamStr(1)='/?') OR (ParamStr(1)='-?')) then Abort('HELP');
  if ParamCount>1 then Abort('Zu viele Parameter angegeben - nur 1 benîtigt!');
  Wcheck('%%10# OK ');
  WStat('VervollstÑndige Dateinamen');
  OutFN := ParamStr(1)+'.txt';
  InFN  := ParamStr(1)+'.htm';
  Wcheck('%%10# OK ');
  WStat('Dateivariablen zuweisen');
  Assign(InF,InFN);
  Assign(OutF,OutFN);
  Wcheck('%%10# OK ');
  WStat('PrÅfe Eingabedatei');
  {$I-} Reset(InF); {$I+}
  if IOResult<>0 then FileIError(IOResult);
  Close(InF);
  Wcheck('%%10# OK ');
  WStat('PrÅfe Ausgabedatei');
  {$I-} Reset(OutF); {$I+}
  if IOResult=0 then begin
    Wcheck('%%14#WARN');
    Close(OutF);
    WriteLn;
    CWriteLn('%%12#Die Ausgabedatei existiert schon!%%7#');
    WriteLn('Mîchten Sie die Ausgabedatei [U]eberschreiben, die neuen Daten');
    Write('an sie [A]nhÑngen oder den Vorgang a[b]brechen (U/A/b) ? ');
    choice := ReadKey;
    Window(1,8,80,11);
    ClrScr;
    Window(1,1,80,25);
    GotoXY(1,8);
    case choice of
      'a','A': OutFM := 1;
      'u','U': OutFM := 2;
      'b','B': begin
                 WriteLn;
                 WriteLn('Bitte geben Sie eine andere Datei an, oder bennen die momentane um.');
                 Halt;
               end;
    end;
  end else begin
    Wcheck('%%10# OK ');
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
         Wcheck('%%12#DELE');
       end;
    0: begin
         Rewrite(OutF);
         Wcheck('%%10# OK ');
       end;
  end;
end;

procedure CloseIO;
begin
  WStat('Eingabedatei schlie·en');
  Close(InF);
  Wcheck('%%10# OK ');
  WStat('Ausgabedatei schlie·en');
  Close(OutF);
  Wcheck('%%10# OK ');
end;

procedure Strip(var tmp: string);
var i: integer;
    t: boolean;
    temp: string;
begin
  temp := '';
  t := false;
  for i:=1 to Length(tmp) do begin
    if (tmp[i]=StripBegin) then t:=true;
    if NOT t then temp := temp + tmp[i];
    if (tmp[i]=StripEnd) then t:=false;
  end;
  tmp := temp;
end;

begin
  Init;
  OpenIO;
  WStat('Entferne Daten zwischen '''+StripBegin+''' und '''+StripEnd+'''');
  while NOT Eof(InF) do begin
    ReadLn(InF,tmp);
    Strip(tmp);
    WriteLn(OutF,tmp);
  end;
  Wcheck('%%10# OK ');
  CloseIO;
end.