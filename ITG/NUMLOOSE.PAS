program NumberLoose;

var input: string;

function Zahl(S: string): longint;
var i: integer;
    tmp: longint;
begin
  tmp := 0;
  for i:=1 to Length(s) do
    if Ord(s[i]) IN [48..57] then tmp:=tmp*10+Ord(s[i])-48;
  Zahl := tmp;
end;

begin
  Write('blabla eingeben: ');
  ReadLn(input);
  WriteLn('Ord vom blabla: ',Zahl(input));
end.
