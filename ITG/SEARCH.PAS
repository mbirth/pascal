program Searches;

const max=30000;

var  F: array[1..max] of word;
    S4: word;
    sp: integer;
    comp: integer;

procedure Init;
var x: word;
    i: word;
begin
  comp := 0;
  x := 0;
  for i:=1 to max do begin
    x := x + Random(3) + 1;
    F[i] := x;
  end;
end;

procedure SearchFor;
var x: integer;
begin
  WriteLn('Geben Sie die Arrayposition des zu suchenden Elements ein!');
  Write('(Zahl zwischen 1 und ',max:0,'): ');
  ReadLn(x);
  S4 := F[x];
  Write('Suche jetzt nach ',S4,' ');
end;

function bin_searchrekursiv(left, right, key: word): word;
var x,n: word;
begin
  Inc(comp);
  Write('.');
  if left>right then bin_searchrekursiv:=0
    else begin
      x := (left+right) DIV 2;
      if key < F[x] then bin_searchrekursiv:=bin_searchrekursiv(left, x-1, key)
        else if key > F[x] then bin_searchrekursiv:=bin_searchrekursiv(x+1,right, key) else bin_searchrekursiv := x;
    end;
end;

function bin_searchiterativ(key: word): word;
var left, right, x: word;
begin
  left := 1;
  right := max;
  repeat
    x := (left + right) DIV 2;
    if key<F[x] then right := x-1 else left := x+1;
    Inc(comp);
    Write('.');
  until (key=F[x]) OR (left>right);
  if key=F[x] then bin_searchiterativ := x
    else bin_searchiterativ := 0;
end;

procedure Stats;
begin
  WriteLn(' gefunden an Stelle ',sp:0);
  Write(comp:0,' Vergleichsoperation');
    if (comp>1) then WriteLn('en') else WriteLn;
end;

begin
  Randomize;
  Init;
  SearchFor;
  { sp := bin_searchiterativ(S4); }
  sp := bin_searchrekursiv(1,max,S4);
  Stats;
  WriteLn('<=======****=======>');
end.
