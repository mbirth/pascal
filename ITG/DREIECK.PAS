program Dreiecke;

uses Crt;

var a,b,c: real;

procedure GetData;
begin
  Write('Geben Sie die LÑnge der Seite a ein: '); ReadLn(a);
  Write('Und nun Seite b: '); ReadLn(b);
  Write('Und jetzt noch c: '); ReadLn(c);
  WriteLn('Danke!');
end;

function ProoveANG(x,y,z: real): boolean;
var j,k: real;
begin
  j := Sqr(x);
  k := Sqr(y);
  if j+k>Sqr(z) then ProoveANG:=true else ProoveANG:=false;
end;

function ProovePYT(x,y,z: real): boolean;
var j,k: real;
begin
  j := Sqr(x);
  k := Sqr(y);
  if j+k=Sqr(z) then ProovePYT:=true else ProovePYT:=false;
end;

function Gleichseitig: boolean;
begin
  if ((a=b) AND (b=c)) then Gleichseitig:=true else Gleichseitig:=false;
end;

function Gleichschenklig: boolean;
begin
  if ((a=b) OR (b=c) OR (a=c)) then Gleichschenklig:=true else Gleichschenklig:=false;
end;

function Rechtwinklig: boolean;
begin
  if ((ProovePYT(a,b,c)) OR (ProovePYT(b,c,a)) OR (ProovePYT(a,c,b))) then Rechtwinklig:=true
    else Rechtwinklig:=false;
end;

function Spitzwinklig: boolean;
begin
  if ((ProoveANG(a,b,c)) AND (ProoveANG(b,c,a)) AND (ProoveANG(a,c,b))) then Spitzwinklig:=true
    else Spitzwinklig:=false;
end;

begin
  ClrScr;
  GetData;
  WriteLn;
  if Gleichseitig then WriteLn('Das Teil ist gleichseitig!');
  if Gleichschenklig then WriteLn('Das Ding ist gleichschenklich!!');
  if Rechtwinklig then WriteLn('Und rechtwinklig ist es auch noch!');
  if Spitzwinklig then WriteLn('Spitzwinklig ist es! Ja, Spitzwinklig!');
  WriteLn;
  WriteLn('Ich habe dem nix hinzuzufÅgen!');
  WriteLn('Fertich, Meister!');
end.