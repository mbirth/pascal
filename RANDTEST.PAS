program Randomize_TEST;

uses Crt;

const RSInit=255;

var i,j: integer;
    bla: string;

function AddOrd(var x: char; wert: byte): char;
var y: integer;
begin
  y := Ord(x);
  y := y + wert;
  if y>255 then y:=y-255;
  AddOrd := Chr(y);
end;

function SubOrd(var x: char; wert: byte): char;
var y: integer;
begin
  y := Ord(x);
  y := y - wert;
  if y<0 then y:=y+255;
  SubOrd := Chr(y);
end;


procedure Code(var x: string);
var i: integer;
    fin: string;
begin
  RandSeed:=RSInit;
  fin := '';
  for i:=1 to Length(x) do begin
    fin := fin + AddOrd(x[i],Random(256));
  end;
  x := fin;
end;

procedure DeCode(var x: string);
var i: integer;
    fin: string;
begin
  RandSeed:=RSInit;
  fin := '';
  for i:=1 to Length(x) do begin
    fin := fin + SubOrd(x[i],Random(256));
  end;
  x := fin;
end;


begin
  ClrScr;
  RandSeed := RSInit;
  for j:=0 to 7 do begin
    { RandSeed := 200;              { Randomize weist RandSeed einen Wert abh„ngig }
    for i:=1 to 15 do begin       { von der Systemzeit zu. Durch manuelle Zuweisung erh„lt }
      GotoXY(j*10+1,i);             { man IMMER die gleichen "Zufallszahlen". Dies ist gut }
      WriteLn(Random(256));       { fr z.B. Verschlsselungsverfahren. }
    end;
  end;
  Write('Gib Deine letzten Worte ein: ');
  ReadLn(bla);
  WriteLn;
  WriteLn('Original: ',bla);
  Code(bla);
  WriteLn('Codiert : ',bla);
  DeCode(bla);
  WriteLn('Decoded : ',bla);
end.
