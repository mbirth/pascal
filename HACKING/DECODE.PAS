program DecodeSubraum;

uses Logo, Crt, VFx, Numbers;

var KeyF,DecF: text;


procedure Init;
begin
  ClrScr;
  CursorOff;
  TextColor(14);
  WriteCLn('-=˛ Subraum Decoder ˛=-');
  WriteLn;
  TextColor(8);
  WriteLn('Decodiert KEYFILES vom Programm HRECORD.EXE.');
  WriteLn;
  TextColor(7);
  window(1,5,80,25);
end;

procedure OpenInOut(InFile,OutFile: string);
begin
  WStat('ôffne '+InFile+' fÅr Eingabeoperationen');
  Assign(KeyF,InFile);
  {$I-}
  Reset(KeyF);
  if IOResult<>0 then begin
    Wcheck('%%140#FAIL');
    CWriteLn('%%12#FEHLER!! Datei "'+InFile+'" konnte nicht geîffnet werden.');
    Halt;
  end;
  {$I+}
  Wcheck('%%10# OK ');

  WStat('ôffne '+OutFile+' fÅr Ausgabeoperationen');
  Assign(DecF,OutFile);
  {$I-}
  Rewrite(DecF);
  if IOResult<>0 then begin
    Wcheck('%%140#FAIL');
    CWriteLn('%%10#FEHLER!! Datei "'+OutFile+'" konnte nicht geîffnet werden.');
    Halt;
  end;
  {$I+}
  Wcheck('%%10# OK ');
end;

procedure Decode;
var tmp: string;
    key: byte;
    dat: string;
begin
  WStat('Decodierung');
  dat := '';
  while NOT Eof(KeyF) do begin
    ReadLn(KeyF,tmp);
    if Copy(tmp,1,3)='KEY' then begin
      key := Hex2Dec(Copy(tmp,9,2));
      case key of
        008: dat := Copy(dat,1,Length(dat)-1);
        013: begin WriteLn(DecF,dat); dat := ''; end;
      else
        dat:=dat+Chr(key);
      end;
    end;
  end;

  Wcheck('%%10# OK ');
end;

procedure CloseInOut;
begin
  WStat('Schlie·e Eingabedatei');
  Close(KeyF);
  Wcheck('%%10# OK ');
  WStat('Schlie·e Ausgabedatei');
  Close(DecF);
  Wcheck('%%10# OK ');
end;

procedure OutIt;
begin
  WriteLn;
  window(1,1,80,25);
  GotoXY(1,24);
  WriteLn('Programm beendet.');
  CursorOn;
end;

begin
  Init;
  if ((ParamStr(1)='/?') OR (ParamStr(1)='-?') OR (ParamStr(1)='?') OR ((ParamStr(1)='') AND (ParamStr(2)=''))) then begin
    WriteLogo;
    TextColor(14);
    WriteCLn('+ + + Taste drÅcken + + +');
    ReadKey;
    GotoXY(1,WhereY-1);
    Write(Space(80));
    GotoXY(1,WhereY-1);
    TextColor(7);
    WriteLn('Die DAT-Dateien sind nach folgendem Schema aufgebaut:');
    WriteLn('Die erste Zeile ist eine Leerzeile, in der 2. Zeile steht die Gesamtzahl der');
    WriteLn('enthaltenen Zeichen. Danach folgen die einzelnen Zeichen in folgender Form:');
    WriteLn;
    WriteLn('KEY: xx yy zz aa');
    WriteLn('(xx,yy,zz und aa sind Hexadezimalwerte)');
    WriteLn;
    WriteLn('xx ist dabei der SCANCODE des eingelesenen Zeichens, yy der Ñquivalente');
    WriteLn('ASCII-Code und zz ein STATUS-Code. aa hat scheinbar keine Bedeutung.');
    WriteLn;
    WriteLn('Dieses Programm wandelt die ASCII-Codes wieder in ASCII-Zeichen um und');
    WriteLn('erstellt eine Datei mit dem "dechiffrierten" Text.');
    WriteLn;
    WriteLn('Syntax: ',ParamStr(0),' <Eingabedatei> <Ausgabedatei>');
    WriteLn;
    OutIt;
    Halt;
  end;
  OpenInOut(ParamStr(1),ParamStr(2));
  Decode;
  CloseInOut;
  OutIt;
end.