program Rekursivitaet;
uses Crt;

procedure Zeichen;
var ch: char;
begin
  ch := ReadKey;
  Write(ch);
  if ch<>'-' then Zeichen;
  Write(ch);
end;

begin
  ClrScr;
  Zeichen;
end.