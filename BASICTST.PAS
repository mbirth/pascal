program TestBasicStrings;

uses BasicStrings, Crt;

var Txt: string;

begin
  Txt := 'Dies ist ein Test-String';
  WriteLn('Urstring: '+Txt);
  WriteLn('8 Linke Zeichen: '+Left(Txt, 8));
  WriteLn('7 Zeichen ab 6. Position: '+Mid(Txt, 6, 7));
  WriteLn('6 Rechte Zeichen: '+Right(Txt , 6));
end.