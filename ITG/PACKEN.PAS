uses Crt;

const personen: array[1..10] of string=('Bert','','Ernie','Wilma','','Fred','Barney','','Ger”llheimer','Horst');

procedure Zaehle;
begin

end;

procedure Ausgabe;
var i: byte;
begin
  WriteLn('<==*==>');
  for i:=1 to 10 do WriteLn(personen[i]);
  ReadKey;
end;

procedure Packe;
var i,a: integer;
begin
  for i:=1 to 10 do begin
    if (personen[i]='') then begin
      for a:=i to 10 do begin
        personen[a]:=personen[a+1];
      end;
    end;
    Write(i,': '); Ausgabe;
  end;
end;


begin
  Zaehle;
  Packe;
  Ausgabe;
end.
