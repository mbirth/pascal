program Sentencizer;

uses Crt, VFx;

type TZeichenMenge = Set of Char;

var Ziffern, Buchstaben, Sonstige,
    Vokale, Konsonanten, Urmenge, Umlaute: TZeichenMenge;
    Zi, Bu, So, Vo, Um, Leer, i : byte;
    Satz : String[80];


procedure Input;
begin
  Write('Bitte den Satz eingeben: ');
  ReadLn(Satz);
  WriteLn(' ==> Dankeschîn!');
  Zi := 0;
  Bu := 0;
  So := 0;
  Vo := 0;
  Um := 0;
  Leer := 0;
  Ziffern := ['0'..'9'];
  Buchstaben := ['a'..'z','A'..'Z'];
  Sonstige := ['!'..'}']-(Ziffern + Buchstaben);
  Vokale := ['a','e','i','o','u','A','E','I','O','U'];
  Umlaute := ['Ñ','î','Å','é','ô','ö'];
  Konsonanten := Buchstaben - Vokale;
  Urmenge := [];
end;

procedure Analyze;
begin
  Write(MultiChar('-',80));
  Write('Analyse lÑuft: DurchzÑhlen ... ');
  for i:=1 to Length(Satz) do begin
    if Satz[i] IN Buchstaben then Inc(Bu)
      else if Satz[i] IN Ziffern then Inc(Zi)
      else if Satz[i] IN Umlaute then Inc(Um)
      else if Satz[i]=' ' then Inc(Leer)
      else Inc(So);
    if Satz[i] IN Vokale then Inc(Vo);
    Urmenge := Urmenge + [Satz[i]];
  end;
  Write('Ausstreichen ... ');
  Vokale := Vokale * Urmenge;
  Konsonanten := Konsonanten * Urmenge;
  Ziffern := Ziffern * Urmenge;
  Umlaute := Umlaute * Urmenge;
  Sonstige := Sonstige * Urmenge;
  WriteLn('fertig!');
end;

procedure OutputSet(which: TZeichenMenge);
var Ch: char;
begin
  for Ch:=' ' to 'ˇ' do
    if Ch IN which then Write(Ch);
  WriteLn;
end;

procedure Output;
begin
  Write(MultiChar('-',80));
  WriteLn('Originalsatz: ',Satz);
  WriteLn('Anzahl Buchstaben: ',Bu);
  WriteLn('Anzahl Vokale    : ',Vo,' -- Konsonanten: ',Bu-Vo);
  WriteLn('Anzahl Umlaute   : ',Um);
  WriteLn('Anzahl Ziffern   : ',Zi);
  WriteLn('Anzahl Leerzeichn: ',Leer);
  WriteLn('Anzahl sonstiges : ',So);
  WriteLn;
  Write('Vokale     : '); OutputSet(Vokale);
  Write('Konsonanten: '); OutputSet(Konsonanten);
  Write('Umlaute    : '); OutputSet(Umlaute);
  Write('Ziffern    : '); OutputSet(Ziffern);
  Write('sonstiges  : '); OutputSet(Sonstige);
end;


begin
  ClrScr;
  Input;
  Analyze;
  Output;
end.