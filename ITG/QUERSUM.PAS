program Quersumme;

var Zahl: longint;

function Quer(zahl: longint): integer;
var conv: string;
    i,q,tmp,ec: integer;

begin
  Str(zahl,conv);
  q := 0;
  for i:=1 to Length(conv) do begin
    Val(conv[i],tmp, ec);
    if ec=0 then q:=q + tmp;
  end;
  Quer := q;
end;

begin
  Write('Tipp ''ne Ganzzahl ein: ');
  ReadLn(Zahl);
  WriteLn('Quersumme von ',Zahl:0,' ist ',Quer(Zahl),'.');
end.