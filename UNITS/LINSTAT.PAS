unit LinStat;

interface
  var CWS: byte;
  procedure WStat(opt: string);
  procedure Wcheck(stat: string);

implementation

uses ColWrite,Crt;

procedure WStat(opt: string);
var i: integer;
begin
  CWS := WhereY;
  GotoXY(1,CWS);
  Write(opt);
  Write(' ');
  for i:=Length(opt) to 70 do begin
    Write('.');
  end;
  CWriteLn(' %%7#[%%142#wait%%7#]');
end;

procedure Wcheck(stat: string);
begin
  GotoXY(75,CWS);
  CWriteLn(stat);
  TextColor(7);
end;


begin
  TextColor(8);
  WriteLn('þ Loading Unit: LinStat - by Markus Birth <Robo.Cop@gmx.net>');
end.