program Fenster1;

uses crt;

procedure Ueberschrift(Text:string; VF,HF: byte);
begin
  window(1,1,80,1);
  TextColor(VF);
  TextBackground(HF);
  ClrScr;
  GotoXY(40-(length(Text) DIV 2),1);
  Write(Text);
end;

begin
  TextBackground(0);
  ClrScr;
  Ueberschrift('Mal sehen was passiert, wenn die šberschrift die Zeilenl„nge sprengt Test Test',10,1);
  ReadKey;
end.