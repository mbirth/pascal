program Sounds_Test;

uses Crt,Sounds;

var i,j: integer;
    Killsound: boolean;

begin
  Debug := true;
  Killsound := false;
  if Killsound then begin
    WriteLn('Killing sound NOW!');
    WriteLn('Time to die!');
    NoSound;
    WriteLn('Sound is no more! Exiting...');
    Write('* Press any - and that means ANY - key *');
    ReadKey;
    ClrScr;
    Exit;
  end;
  Delay(1000);
  Tone(1000,500); { Syntax: Tone(Hertz,Delay) }
  Delay(100);
  Siren(600,1200,5000,7); { Syntax: Siren(LoTone,HiTone,Delay,Divisor [for speed]) }
  DualTone(1750,2000,1000,1); { Syntax: DualTone(Tone1,Tone2,Delay,ToneDelay) }
  Write('* Press any key *');
  ReadKey;
  ClrScr;
  for i:=4 downto 1 do begin
    for j:=16 downto 1 do begin
      DualTone(i*800,j*200,500,1);

    end;
  end;
  Write('* Press this key again *');
  ReadKey;
  ClrScr;
end.