program AddArray;

uses Crt;

var Ergb: integer;
    List: array[1..100] of integer;
    ASize: integer;

procedure AddValue(index: integer; var ender: integer);
begin
  ender := ender + List[index];
end;

procedure GetArray;
var i: integer;
label InpNext;
begin
  i := 1;
  WriteLn('Werte eingeben! Ende mit 0.');
  repeat
    Write('Wert ',i,' = ');
    ReadLn(List[i]);
    ASize := i;
    Inc(i);
  until List[i-1]=0;
end;

procedure CalcArray;
var i: integer;
begin
  Ergb := 0;
  for i:=1 to ASize do begin
    Ergb := Ergb + List[i];
  end;
end;



begin
  ClrScr;
  WriteLn('-=ðþ MBUIAZ þð=-'); { Markus Birth's Ultimativer Intellektueller Array Zusammenfasser }
  WriteLn;
  GetArray;
  WriteLn;
  CalcArray;
  WriteLn('Ergebnis: ',Ergb);
  WriteLn;
  WriteLn('=== BITTE TASTE DRšCKEN ===');
  ReadKey;
end.