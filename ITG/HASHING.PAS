program Hashing;

uses Crt;

const max=25;

var mem: array[0..max] of integer;
    x,pos: integer;

procedure Init;
var i: integer;
begin
  for i:=0 to max do mem[i] := 255;
end;

procedure OutArray;
var i: integer;
begin
  for i:=0 to max do begin
    if (i/2)=(I DIV 2) then TextColor(10) else TextColor(12);
    GotoXY(i*3+1,3); Write(i:3);
    GotoXY(i*3+1,4); if (mem[i]<>255) then Write(mem[i]:3);
  end;
end;

function Hash(v: integer): integer;
begin
  Hash := v MOD 13;
end;

procedure MakeFree(var v: integer);
begin
  if (mem[v]<>255) then begin
    repeat
      Inc(v);
    until (mem[v]=255) OR (v>max);
  end;
  if (v>max) then begin
    ClrScr;
    TextColor(12);
    WriteLn('Array Åberschritten! Das Feld ist VOLL!');
    Halt;
  end;
end;

procedure ReadAndSort;
var i: integer;
begin
  for i:=1 to 15 do begin
    GotoXY(5,5);
    ReadLn(x);
    pos := Hash(x);
    MakeFree(pos);
    mem[pos] := x;
    OutArray;
  end;
end;

begin
  TextBackground(0);
  TextColor(15);
  ClrScr;
  Init;
  OutArray;
  ReadAndSort;
end.
