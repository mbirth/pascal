program WriteEffects;
uses Crt;
const Del=100;

var Txt: string;
    i,j: integer;
    y: integer;

label HereWeGoAgain;

procedure WriteFX(Txt: string);
  var Del2: integer;
  begin
    y := WhereY-1;
    for i := 1 to 80 do begin
      GotoXY(1, y);
      TextColor(3);
      Write(Txt);
      GotoXY(i, y);
      for j:=i to Length(Txt) do Write(' ');
      Del2 := 40;
      Delay(Del2);
      if i=Length(Txt) then break;
    end;
    GotoXY(1, y);
    TextColor(15);
    Write(Txt);
    Delay(Del);
    GotoXY(1, y);
    TextColor(7);
    Write(Txt);
    Delay(Del);
    GotoXY(1, y);
    TextColor(8);
    WriteLn(Txt);
    Delay(Del);
  end;

begin
  TextMode(CO40);
  ClrScr;
  TextColor(8);
HereWeGoAgain:
  ReadLn(Txt);
  WriteFX(Txt);
  goto HereWeGoAgain;
end.