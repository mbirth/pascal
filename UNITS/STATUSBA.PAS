unit Statusbar;

interface
  procedure WriteStatusItem(i: integer; t:string);
implementation

uses Crt,BasicStrings;

procedure WriteStatusItem(i: integer; t:string); { Schreibt Button in die Statusleiste (i=1..10) }
var j,k,l: integer;
begin
  if i=10 then l:=5 else l:=6;
  if Length(t)>l then t:=Left(t,l);
  if Length(t)<l then begin
    for j:=Length(t) to l-1 do t:=t+' ';
  end;
  window(1,25,80,25);
  TextBackground(0);
  TextColor(7);
  if i=1 then GotoXY(1,1) else GotoXY(8*(i-1),1);
  if i<>1 then Write(' ',i) else Write(i);
  TextBackground(3);
  TextColor(0);
  Write(t);
  window(1,2,80,24);
end;

begin
  WriteLn('þ Loading Unit: StatusBar - geschrieben von RoboCop of nOOb');
end.