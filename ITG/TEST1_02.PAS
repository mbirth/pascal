program SortName;

uses Crt;

var Nam: array[1..3] of string;
    i: integer;

procedure Swap(var i1,i2: string);
var tmp: string;
begin
  tmp := i1;
  i1  := i2;
  i2  := tmp;
end;

begin
  for i:=1 to 3 do begin
    Write('Geben Sie den ',i,'. Namen ein: ');
    ReadLn(Nam[i]);
  end;
  if Nam[3]<Nam[1] then Swap(Nam[3],Nam[1]);
  if Nam[2]<Nam[1] then Swap(Nam[2],Nam[1]);
  if Nam[3]<Nam[2] then Swap(Nam[3],Nam[2]);
  for i:=1 to 3 do begin
    WriteLn('Name ',i,': ',Nam[i]);
  end;
  WriteLn('Bitte eine Taste drcken!');
  ReadKey;
end.
