program Morse;                { invented and programmed by Markus Birth }
uses Crt, Logo;               { those units are within our game }

type MorseData=record         { I'm trying to make it easier }
       Symbol:String;
       Code:String;
     end;

var Char2Morse: string;       { Where do all the Datas live? }
    MorseCode: string;
    f: text;
    Mors:array[0..100] of MorseData;
    i, j: integer;
    SingleC: string;
    Codes: integer;


const SDelay = 50;           { How fast R U ? }
      LDelay = 200;
      MTone  = 1200;
      Pause  = 50;
      CDelay = 200;
      WDelay = 3*CDelay;

procedure ReadData;           { What the hell is a 'Morsecode'?? }
  begin
    Assign(f, 'morse.dat');
    Reset(f);
    for i:=1 to 3 do ReadLn(f);
    ReadLn(f, Codes);
    Codes := Codes-1;
    for i:=0 to Codes do begin
      ReadLn(f, Mors[i].Symbol);
      ReadLn(f, Mors[i].Code);
      if Eof(f) then break;
    end;
    close(f);
  end;

function MorseSeek(Buch: string): string;
  begin
    for i:=0 to Codes do
      if Mors[i].Symbol=Buch then MorseSeek := Mors[i].Code;
    if Buch='' then MorseSeek := ''
  end;

procedure MorseIt(MC: string);
  var MTemp: string;
  begin
    if MC='' then exit;
    for i:=1 to length(MC) do begin
      MTemp := Copy(MC, i, 1);
      if MTemp = '.' then begin
        Sound(MTone);
        Delay(SDelay);
        NoSound;
      end;
      if MTemp = '-' then begin
        Sound(MTone);
        Delay(LDelay);
        NoSound;
      end;
      Write(MTemp);
      Delay(Pause);
    end;
    Delay(CDelay);
    WriteLn;
  end;

procedure ConvUpCase;
  begin
    for i:=1 to Length(Char2Morse) do
      Char2Morse[i] := UpCase(Char2Morse[i]);
  end;

begin                         { Come get some! Let's rock. }
  ClrScr;
  WriteLogo;
  TextColor(15);
  WriteLn('wrote another nice little program');
  TextColor(14);
  WriteLn('-=ðþ Morse þð=-');
  ReadData;
  WriteLn;
  TextColor(7);
  WriteLn('Press any key to continue ...');
  ReadKey;
  ClrScr;
  TextColor(15);
  WriteLn('Enter any text! To Exit just press return.');
  ReadLn(Char2Morse);
  ConvUpCase;
  for j:=1 to Length(Char2Morse) do begin
    SingleC := Copy(Char2Morse, j, 1);
    MorseCode := MorseSeek(SingleC);
    if SingleC = ' ' then begin
      Delay(WDelay);
      WriteLn;
    end
    else MorseIt(MorseCode);
  end;
  WriteLn;
  WriteLn('Exiting...');
end.