unit RCString;

interface
  procedure WriteCLn(t: string);
  procedure WriteC(t: string);
  procedure WriteCY(l: integer; t: string);
implementation

uses Crt;

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

procedure WriteCY(l: integer; t: string);
var cx,cy: integer;
begin
  cx := WhereX;
  cy := WhereY;
  GotoXY(40-Length(t) div 2,l);
  Write(t);
  GotoXY(cx,cy);
end;

begin
  WriteLn('þ Loading Unit: Strings - geschrieben von RoboCop of nOOb');
end.