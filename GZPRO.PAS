program GZ_PRO_Reader;           { GebÅhrenzÑhler-Auslese-Software }
uses Crt;
var P: string;
    Po: file;
    TempVar: string;

begin
  ClrScr;
  P := 'COM2';
  TextColor(Yellow);
  TextBackground(Blue);
  Write('GZ-PRO Lesesoftware');
  TextColor(White);
  WriteLn('                                      (C)1997 by RoboCop IND.');
  TextBackground(Black);
  TextColor(LightGray);
  WriteLn('Port: '+P);
  Assign(Po, P);
  Reset(Po);
  while not Eof(Po) do Read(P, TempVar);
  Close(Po);
  WriteLn(TempVar);
end.