program Siren;

uses Crt;

const MaxVal = 1200;
      MinVal = 800;

var i: integer;
    tmp: integer;

function GetSoundVal(t: real): integer;
begin
  GetSoundVal := Trunc(Sin(t)*(MaxVal-MinVal)+MinVal);
end;

begin
  i:=0;
  repeat
    Inc(i);
    tmp := GetSoundVal(i/100);
    Sound(tmp);
    GotoXY(1,1); Write(tmp,' Hz  ');
    Delay(10);
  until keypressed;
  NoSound;
  WriteLn('* Press any key *');
  ReadKey;
end.