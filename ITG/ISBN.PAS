program ISBNGrab;

uses Crt;

var UrISBN: string;
    i,j,co: integer;

function BNS(ISBN: string;which: integer): string;
var NR: array[1..10] of string;
    x,lastx,i: integer;
    j: string;
begin
  i := 1;
  lastx := 0;
  for x:=0 to Length(ISBN) do begin
    if ISBN[x]='-' then begin
      NR[i] := Copy(ISBN,lastx+1,x-lastx-1);
      Inc(i);
      lastx := x;
    end;
  end;
  NR[i] := Copy(ISBN,lastx+1,Length(ISBN));
  if which<>0 then BNS := NR[which] else begin
    Str(i:0,j);
    BNS := j;
  end;
end;


begin
  Write('ISBN eintippen: ');
  ReadLn(UrISBN);
  Write('ISBN: ',BNS(UrISBN,1));
  Val(BNS(UrISBN,0),j,co);
  for i:=2 to j do Write('-',BNS(UrISBN,i));
  WriteLn(' (',BNS(UrISBN,0),' Gruppen)');
  WriteLn('Buchnr.: ',BNS(UrISBN,3));
  ReadKey;
end.
