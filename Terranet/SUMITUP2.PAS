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

uses Crt,VFx;

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
  WriteLn('  Copyright (c)1998 by Markus Birth <Robo.Cop@gmx.net>');
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
  WStat('Header erstellen');
  WriteLn(OutF,'<HTML>');
  WriteLn(OutF,'<HEAD>');
  WriteLn(OutF,'<!-- This HTML file was created with SumItUp, a PASCAL program for Chat');
  WriteLn(OutF,'     statistics Copyrighted by Markus Birth <Robo.Cop@gmx.net>');
  WriteLn(OutF,'  <TITLE>Auswertung von ',ParamStr(1),'</TITLE>');
  WriteLn(OutF,'</HEAD>');
  WriteLn(OutF,'<STYLE TYPE="text/css">');
  WriteLn(OutF,'  TH { background: #808080; color: white; }');
  WriteLn(OutF,'  TD { background: #c0c0c0; color: black; }');
  WriteLn(OutF,'</STYLE>');
  WriteLn(OutF,'<BODY TEXT=black BGCOLOR=white LINK=navy VLINK=navy ALINK=yellow>');
  WriteLn(OutF,'<CENTER>');
  WriteLn(OutF,'<FONT SIZE=+4 COLOR=red FACE="Impact,Haettenschweiler,Arial">Auswertung von ',ParamStr(1),'</FONT><BR>');
  WriteLn(OutF,'<FONT SIZE=-1 COLOR=#c0c0c0><A HREF="mailto:Robo.Cop@gmx.net">Mail the author</A></FONT>');
  WriteLn(OutF,'</CENTER>');
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
  WriteLn(OutF,'<TABLE CELLPADDING=1 CELLSPACING=1>');
  WriteLn(OutF,'<TR><TH COLSPAN=7><FONT COLOR=yellow><U>Chatter, die im Chat waren</U></FONT></TH></TR>');
  WriteLn(OutF,'<TR><TH>Nr.</TH><TH>Nickname</TH><TH>Statements</TH>',
    '<TH>gesagte W&ouml;rter</TH><TH>durchschn. W&ouml;rter-<BR>zahl / Statement</TH><TH>benutzte Smileys</TH>',
    '<TH>"actions"</TH></TR>');
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
    if stm<>0 then wps := wds/stm else wps := 0;
    WriteLn(OutF,'<TR><TD ALIGN=right>',i,'</TD><TD>',tmp,'</TD><TD ALIGN=center>',stm,'</TD>',
      '<TD ALIGN=center>',wds,'</TD><TD ALIGN=center>',wps:0:2,'</TD><TD ALIGN=center>',smi,'</TD>',
      '<TD ALIGN=center>',acti,'</TD></TR>');
    Stat(1);
  end;
  WriteLn(OutF,'<TR><TD ALIGN=right COLSPAN=2>Gesamt</TD><TD ALIGN=center>',stmaa,'</TD>',
    '<TD ALIGN=center>',wdsaa,'</TD><TD ALIGN=center>',wdsaa/stmaa:0:2,'</TD><TD ALIGN=center>',smiaa,'</TD>',
    '<TD ALIGN=center>',actaa,'</TD></TR>');
  WriteLn(OutF,'</TABLE>');
  WriteLn(OutF,'<P>');
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
