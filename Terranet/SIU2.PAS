program SumItUp;

{ This program will do the following:
  ( Uses Terranet-Chat-files in HTML or Plain Text)

  1. Count the chatter, who speak and shows her names.
  2. Count the chatter at all.
  3. Count the statements per chatter
  4. Average length of statements (in words)
  5. Count used "Smileys"
  6. Count used "actions" (everything between 2 *s)

  2nd version - now with CSV format

  }

  (* Program copyright by Markus Birth <Robo.Cop@gmx.net> *)

uses Crt,HTML,VFx;

var InF: text;
    OutF: text;
    NamF: text;
    OutFM: integer;
    choice: char;
    tmp: string;
    act,act2: byte;

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
  WriteLn('CSV und kann somit mit fast jeder Tabellenkalkulation eingelesen werden.');
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
label ret;
begin
  OutFM:=0;
  TextBackground(0);
  ClrScr;
  TextColor(11);
  TextBackground(1);
  Write('-=+ Chat - Auswertung Part ][ +=-');
  TextBackground(0);
  TextColor(8);
  WriteLn('  (c)1998 by Markus Birth <Robo.Cop@gmx.net>');
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
ret:
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
      else begin
        Sound(100);
        Delay(100);
        NoSound;
        GotoXY(1,7);
        goto ret;
      end;
    end;
  end else begin
    Wcheck('%%10# OK ');
  end;
  WStat('TemporÑrdateien erzeugen');
  Assign(NamF,'names.dat');
  Rewrite(NamF);
  Wcheck('%%10# OK ');
  CursorOff;
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

function Contains(all,srch: string): boolean;
var i: integer;
begin
  for i:=1 to Length(all)-Length(srch)+1 do begin
    if Copy(all,i,Length(srch))=srch then begin
      Contains := true;
      Exit;
    end;
  end;
  Contains := false;
end;

function Where(all,srch: string): integer;
var i: integer;
begin
  for i:=1 to Length(all)-Length(srch)+1 do begin
    if Copy(all,i,Length(srch))=srch then begin
      Where := i;
      Exit;
    end;
  end;
  Where := 0;
end;

procedure CountThings(tmp: string; var stm,wds,smi,acti: longint);
var i,j,w: integer;
    nam,lnam: string;
    temp: string;
    xw: integer;
    SmiF: text;
    smitmp: string;
    actid: boolean;
begin
  Reset(InF);
  wds := 0;
  smi := 0;
  stm := 0;
  acti := 0;
  actid := false;
  Assign(SmiF,'smileys.dat');
  while NOT Eof(InF) do begin
    ReadLn(InF,temp);
    if Contains(temp,'>>') then begin
      xw := Where(temp,'>>');
      nam := Copy(temp,1,xw-2);
      temp := Copy(temp,xw+3,Length(temp)-(xw+3));
    end else begin
      nam:='';
    end;
    if nam=tmp then Inc(stm);
    if ((nam=tmp) OR ((nam='') AND (lnam=tmp))) then begin
      for i:=1 to Length(temp) do begin
        if ((temp[i]=' ') AND (temp[i+1]<>' ')) then Inc(wds);
        if ((temp[i]='*') AND (temp[i+1]<>'*')) then begin
          if actid then begin
            actid := false;
            Inc(acti);
          end else begin
            actid := true;
          end;
        end;
        Reset(SmiF);
        while NOT Eof(SmiF) do begin
          ReadLn(SmiF,smitmp);
          if Copy(temp,i,Length(smitmp))=smitmp then Inc(smi);
        end;
        Close(SmiF);
      end;
      Inc(wds);
    end;
    lnam := nam;
  end;
end;

function NameExist(tmp: string): boolean;
var i: integer;
    temp: string;
begin
  Reset(NamF);
  while NOT Eof(NamF) do begin
    ReadLn(NamF,temp);
    if tmp=temp then begin
      NameExist := true;
      Exit;
    end;
  end;
  NameExist := false;
end;

procedure NameAdd(tmp: string);
begin
  Append(NamF);
  WriteLn(NamF,tmp);
end;

procedure Parse_Names(tmp: string);
var nam,txt: string;
    x: integer;
    ne: boolean;
begin
  nam := '';
  if Contains(tmp,'>>') then nam := Copy(tmp,1,Where(tmp,'>>')-2)
    else if ((Contains(tmp,'has left the group'))
      OR (Contains(tmp,'has joined the group'))
      OR (Contains(tmp,'hat die Gruppe verlassen'))
      OR (Contains(tmp,'ist der Gruppe beigetreten'))) then nam := Copy(tmp,1,Where(tmp,'has')-2);
  ne := NameExist(nam);
  if ((nam<>'') AND (NOT ne)) then NameAdd(nam);
end;

procedure Stat(fac: byte);
begin
  GotoXY(80,1);
  if act2/fac=Int(act2/fac) then begin
    if act=1 then Write('|') else
    if act=2 then Write('/') else
    if act=3 then Write('-') else
    if act=4 then begin Write('\'); act := 0; end;
    Inc(act);
  end;
  Inc(act2);
end;

procedure Write_Names;
var i: integer;
    tmp: string;
    wds,wdsaa: longint;
    smi,smiaa: longint;
    stm,stmaa: longint;
    acti,actaa: longint;
    wps: real;
begin
  WriteLn(OutF,'"Nr.","Nickname","Statements","gesagte Wîrter"',
    '"durchschn. Wîrterzahl / Statement","benutzte Smileys","actions"');
  Reset(NamF);
  i := 0;
  wdsaa := 0;
  smiaa := 0;
  stmaa := 0;
  actaa := 0;
  while NOT Eof(NamF) do begin
    Inc(i);
    ReadLn(NamF,tmp);
    CountThings(tmp,stm,wds,smi,acti);
    wdsaa := wdsaa + wds;
    smiaa := smiaa + smi;
    stmaa := stmaa + stm;
    actaa := actaa + acti;
    ConvEntities(tmp);
    if stm<>0 then wps := wds/stm else wps := 0;
    WriteLn(OutF,'"',i,'","',tmp,'","',stm,'","',wds,'","',wps:0:2,'","',smi,
      '","',acti,'"');
    Stat(1);
  end;
  WriteLn(OutF,'"","Gesamt:","',stmaa,'","',wdsaa,'","',wdsaa/stmaa:0:2,'","',smiaa,
    '","',actaa,'"');
end;

begin
  Init;
  OpenIO;
  act := 0;
  WStat('Analysiere Chatteilnehmer');
  while NOT Eof(InF) do begin
    ReadLn(InF,tmp);
    Parse_Names(tmp);
    Stat(50);
  end;
  Write_Names;
  Wcheck('%%10# OK ');
  CloseIO;
  CursorOn;
end.
