program Coding;

uses Crt;

const satz='ICH BIN HIER UND DU BIST DA! NUN BIN ICH DA UND DU BIST HIER. BLI BLA BLO BL™™  ';

var A: array[1..40,1..40] of char;


procedure Init;
var i,j: byte;
begin
  TextMode(co80+Font8x8);
  for i:=1 to 40 do begin
    for j:=1 to 40 do begin
      A[i,j] := ' ';
    end;
  end;
end;

procedure Ausgabe;
var i,j: byte;
begin
  for i:=1 to 40 do begin
    for j:=1 to 40 do begin
      GotoXY(j,i);
      Write(A[j,i]);
    end;
  end;
  ReadKey;
end;

procedure Code(x: string);
var i,j: byte;
begin
  Randomize;
  for j:=1 to 40 do begin
    A[j,j] := x[j];
    A[41-j,j] := x[40+j];
  end;
  for i:=1 to 40 do begin
    for j:=1 to 40 do begin
      if A[i,j]=' ' then A[i,j]:=Chr(65+Random(26));
    end;
  end;
end;

procedure Decode;
var i: byte;
begin
  ClrScr;
  for i:=1 to 40 do begin
    GotoXY(i,1);
    Write(A[i,i]);
    GotoXY(40+i,1);
    Write(A[41-i,i]);
  end;
end;

begin
  Init;
  Ausgabe;
  Code(satz);
  Ausgabe;
  Decode;
end.
