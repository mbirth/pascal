unit Coder;

interface
  const code=true;
        decode=false;

  var RSInit: integer;

  procedure OrdCode(var x: string; co: boolean);
  procedure SortCode(var x: string; co: boolean);
  procedure Hebrew(var x: string);
  procedure MVCode(var x: string; n: shortint);
  procedure Enigma(var x: string; p: string; code: boolean);

implementation

function AddOrd(var x: char; wert: byte): char;  { Addiert wert zu der Ordinalzahl von x }
var y: integer;                                  { und liefert das neue Zeichen }
begin
  y := Ord(x);
  y := y + wert;
  if y>255 then y:=y-256;
  AddOrd := Chr(y);
end;

function SubOrd(var x: char; wert: byte): char;  { Subtrahiert wert von der Ordinalzahl von x }
var y: integer;                                  { und liefert das neue Zeichen }
begin
  y := Ord(x);
  y := y - wert;
  if y<0 then y:=y+256;
  SubOrd := Chr(y);
end;

procedure Hebrew(var x: string);
var matrix: array[1..16,1..16] of char;
    i,j,xd: integer;
begin
  for i:=1 to 16 do begin
    for j:=1 to 16 do begin
      matrix[i,j] := ' ';
    end;
  end;
  if (Trunc(Sqrt(Length(x)))<>Sqrt(Length(x))) then xd := Trunc(Sqrt(Length(x)))+1 else xd := Trunc(Sqrt(Length(x)));
  for i:=Length(x) to Sqr(xd) do x := x + ' ';
  for i:=1 to xd do begin
    for j:=1 to xd do begin
      matrix[j,i] := x[(i-1)*xd+j];
    end;
  end;
  x := '';
  for i:=1 to Sqr(xd) do x := x + ' ';
  for i:=1 to xd do begin
    for j:=1 to xd do begin
      x[(i-1)*xd+j] := matrix[i,j];
    end;
  end;
end;

function Space(len: integer): string;   { Liefert einen String mit len Leerzeichen }
var i: integer;
    tmp: string;
begin
  tmp := '';
  for i:=1 to len do tmp:=tmp+' ';
  Space := tmp;
end;

procedure OrdCode(var x: string; co: boolean);    { Codiert einen Text durch Addition (co=true) oder }
var i: integer;                                   { Subtraktion (co=false) von Zufallszahlen zu/von der }
    fin: string;                                  { Ordinalzahl der einzelnen Zeichen }
begin
  RandSeed:=RSInit;
  fin := '';
  for i:=1 to Length(x) do begin
    if co then fin := fin + AddOrd(x[i],Random(256)) else fin := fin + SubOrd(x[i],Random(256));
  end;
  x := fin;
end;

procedure SortCode(var x: string; co: boolean);   { Codiert durch Vertauschen der Reihenfolge der Buchstaben }
var i: integer;
    pos: integer;
    fin: string;
    belegt: array[0..255] of boolean;
begin
  for i:=1 to 255 do belegt[i]:=false;
  RandSeed:=RSInit;
  if co then fin := Space(Length(x)) else fin := '';
  for i:=1 to Length(x) do begin
    if co then begin
      repeat
        pos := Random(Length(x))+1;
      until NOT belegt[pos];
      fin[pos] := x[i];
      belegt[pos]:=true;
    end else begin
      repeat
        pos := Random(Length(x))+1;
      until NOT belegt[pos];
      fin := fin + x[pos];
      belegt[pos]:=true;
    end;
  end;
  x := fin;
end;

procedure MVCode(var x: string; n: shortint); { Codiert durch verschieben des Alphabets }
const alpho: string[26]='abcdefghijklmnopqrstuvwxyz';
var alph: string[26];
    fin: string;
    i,j,id: integer;
begin
  if n>=0 then alph := Copy(alpho,27-n,n) + Copy(alpho,1,26-n)
    else alph := Copy(alpho,-n+1,27+n) + Copy(alpho,1,-n);
  fin := '';
  for i:=1 to Length(x) do begin
    for j:=1 to 26 do begin
      if alpho[j]=x[i] then fin := fin + alph[j];
      if UpCase(alpho[j])=x[i] then fin := fin + UpCase(alph[j]);
    end;
    if (Length(fin)<i) then fin := fin + x[i];
  end;
  x := fin;
end;

procedure Enigma(var x: string; p: string; code: boolean); { Enigma! }
var fin: string;
    i,no,pd: byte;
begin
  fin := '';
  pd := 1;
  for i:=1 to Length(x) do begin
    if code then no := Ord(x[i])+Ord(p[pd]) else no := Ord(x[i])-Ord(p[pd]);
    Inc(pd);
    if (pd>Length(p)) then pd := 1;
    fin := fin + Chr(no);
  end;
  x := fin;
end;

begin
  RSInit := 0;
  WriteLn('þ Loading Unit: Coder - RoboCop of nOOb <Robo.Cop@gmx.net>');
end.
