program Mitarbeiter;

uses Crt;

{ 1..8 = Abteilung
  1..6 = Altersgruppe:
         1 - 16-19
         2 - 20-24
         3 - 25-35
         4 - 36-49
         5 - 50-60
         6 - >60
  1..2 = Geschlecht:
         1 - m„nnlich
         2 - weiblich }

var Arbeiter: array[1..8,1..6,1..2] of byte;

procedure InitArray;
var i,j: byte;
begin
  Randomize;
  for i:=1 to 8 do
    for j:=1 to 6 do begin
      Arbeiter[i,j,1] := Random(250);
      Arbeiter[i,j,2] := Random(250);
    end;
end;

function GetMalesFromAbt(abt: byte): integer;
var i: byte;
    m: integer;
begin
  m := 0;
  for i:=1 to 6 do begin
    m := m + Arbeiter[abt,i,1];
  end;
  GetMalesFromAbt := m;
end;

function GetFemsFromAbt(abt: byte): integer;
var i: byte;
    f: integer;
begin
  f := 0;
  for i:=1 to 6 do begin
    f := f + Arbeiter[abt,i,2];
  end;
  GetFemsFromAbt := f;
end;

function GetPeopleInAbt(abt: byte): integer;
var i: byte;
    a: integer;
begin
  a := 0;
  for i:=1 to 6 do a := a + Arbeiter[abt,i,1] + Arbeiter[abt,i,2];
  GetPeopleInAbt := a;
end;

procedure GetInfo;
var i,j: byte;
    m,w: integer;
begin
  m := 0;
  w := 0;
  for i:=1 to 8 do
    for j:=1 to 6 do begin
      m:=m+Arbeiter[i,j,1];
      w:=w+Arbeiter[i,j,2];
    end;
  WriteLn('Anzahl m„nnlicher Mitarbeiter firmenweit: ',m);
  WriteLn('Anzahl weiblicher Mitarbeiter firmenweit: ',w);
  for i:=1 to 8 do WriteLn('Mitarbeiter in Abteilung ',i:1,': ',GetPeopleInAbt(i):4,
                           ' (',GetMalesFromAbt(i):4,' M„nner/',GetFemsFromAbt(i):4,' Frauen)');
end;


begin
  InitArray;
  ClrScr;
  GetInfo;
  ReadKey;


end.