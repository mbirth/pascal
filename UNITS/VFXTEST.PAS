program VFXtest;

uses VFx, Crt;

var i,j: integer;

begin
  TextMode(co80);
  DrawBorder(20,10,11,1,5);
  WriteLn('Das hier ist der erste Bildschirm');
  Write('Der wird jetzt in einen Pointer geschrieben ...');
  SaveScreen;
  WriteLn(' Fertich! - TASTE DRöCKEN');
  ReadKey;
  DrawBorder(20,10,15,2,4);
  WriteLn('Jetzt wird das ganze wiederhergestellt ...');
  WriteLn('Aber vorher: TASTE DRöCKEN!!');
  ReadKey;
  RestoreScreen;
  ReadKey;
  TextBackground(0);
  Window(1,1,80,25);
  ClrScr;
  DrawBorder(20,10,11,1,5);
  Write('Und jetzt das ganze mit Dateien ... der Screen wird gleich ');
  Write('in eine Datei geschrieben (scrn.buf) ...');
  WriteScreen('.\scrn.buf');
  WriteLn('Fertich! - TASTE!');
  ReadKey;
  DrawBorder(20,10,14,4,1);
  Write('So, jetzt wieder laden ... NACH dem Tastendruck!');
  ReadKey;
  ReadScreen('.\scrn.buf');
  ReadKey;
  TextBackground(0);
  TextColor(15);
  Window(1,1,80,25);
  ClrScr;
  Write('Und jetzt spielen wir mit ');
  TextColor(15+blink);
  Write('BLINKEN');
  TextColor(15);
  Write(' und ');
  TextColor(15+blink);
  Write('hellen HintergrÅnden');
  TextColor(15);
  WriteLn(' herum ....');
  WriteLn;
  for i:=0 to 31 do begin
    TextColor(i);
    TextBackground(i MOD 8);
    Write('##');
  end;
  TextBackground(0);
  WriteLn;
  for i:=0 to 31 do begin
    TextColor(i);
    Write('##');
  end;
  TextColor(15);
  WriteLn;
  ReadKey;
  SetBackLight(true);
  ReadKey;
  SetBackLight(false);
  ReadKey;
  SetBackLight(true);
  ReadKey;
  SetBackLight(false);

  WriteLn('Programm beendet.');
end.