uses Crt;

var i: integer;


begin
  for i:=1 to 50 do begin
    Sound(800);
    Delay(1);
    Sound(1000);
    Delay(1);
    Sound(1200);
    Delay(1);
  end;
  NoSound;
end.