program Fuck_ultaet;

var which: integer;

function Fak_Ite(m: integer): longint;
var i: integer;
    tmp: longint;
begin
  tmp := 1;
  for i:=1 to m do begin
    tmp := tmp * i;
  end;
  Fak_Ite := tmp;
end;

function Fak_Rek(m: integer): longint;
begin
  if m=1 then Fak_Rek := 1 else Fak_Rek := m * Fak_Rek(m-1);
end;


begin
  WriteLn('======================');
  Write('Enter n: '); ReadLn(which);
  WriteLn('Iterative: ',Fak_Ite(which));
  WriteLn('Recursive: ',Fak_Rek(which));
end.