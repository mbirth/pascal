program ConvUmlaut;

uses Crt;

var mystr: string;

procedure ChangeAll(var text: string; what, targ: string);
var x: byte;
begin
  while Pos(what,text) > 0 do begin
    x := Pos(what,text);
    Delete(text,x,1);
    Insert(targ,text,x);
  end;
end;

begin
  ClrScr;
  mystr := 'x';
  while mystr<>'' do begin
    Write('Dein Text mit Umlauten: ');
    ReadLn(mystr);
    ChangeAll(mystr,'Ñ','ae');
    ChangeAll(mystr,'î','oe');
    ChangeAll(mystr,'Å','ue');
    ChangeAll(mystr,'é','AE');
    ChangeAll(mystr,'ô','OE');
    ChangeAll(mystr,'ö','UE');
    ChangeAll(mystr,'·','ss');
    Write('Dein Text ohne Umlaute: ');
    WriteLn(mystr);
  end;
end.