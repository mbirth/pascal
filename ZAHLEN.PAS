program Zahlenraten;

uses Crt,Vfx;

const Maximum:longint=1000000;

var Ziel: longint;
    Tries,LowerTries,HigherTries: integer;
    ActTry: longint;
    Target: array[1..1000] of longint;
    CurPosOfZiel,oldcp: integer;
    Maxi: string[12];
    loser: boolean;

function GetNum:longint;
begin
  GetNum := Trunc(Int(Random*Maximum));
end;

procedure TitleScreen;

const l=2; o=2; r=79; u=4;
var i,j:integer;
    GameTitle: string[78];
begin
  Window(1,1,80,24);
  TextColor(15);
  TextBackground(0);
  for i:=l+1 to r-1 do begin
    for j:=o+1 to u-1 do begin
      GotoXY(i,j); Write(' ');
    end;
  end;
  for i:=l+1 to r-1 do begin
    GotoXY(i,o); Write('Ä');
    GotoXY(i,u); Write('Ä');
  end;
  for i:=o+1 to u-1 do begin
    GotoXY(l,i);  Write('º');
    GotoXY(r,i); Write('º');
  end;
  GotoXY(l,o);  Write('Ö');
  GotoXY(r,o); Write('·');
  GotoXY(l,u);  Write('Ó');
  GotoXY(r,u); Write('½');
  TextColor(8);
  GotoXY(r+1,o); Write('Ü');
  for i:=o+1 to u do begin
    GotoXY(r+1,i); Write('Û');
  end;
  for i:=l+1 to r+1 do begin
    GotoXY(i,u+1);  Write('ß');
  end;
  GameTitle:='+++ RoboCop''s Zahlenraten +++';
  GotoXY(Trunc((l+r)/2-Length(GameTitle)/2),Trunc((o+u)/2));
  FXWrite(GameTitle,14);
  GotoXY(7,u+3);
  FXWrite('Ziel des Spiels ist es, eine Zahl zwischen 0 und '+Maxi+' zu finden.',15);
  DrawBorder(20,2,15,1,5);
  TextBackground(0);
  WaitBeep;
end;

procedure DrawGraph;
var i:integer;
begin
  Window(1,21,80,25);
  for i:=1 to 80 do begin
    GotoXY(i,2); Write('Ä');
    GotoXY(i,4); Write('Ä');
  end;
  GotoXY(1,1); Write('0');
  GotoXY(81-Length(Maxi),1); Write(Maxi);
end;

procedure SetGraph(value: longint);
var curpos:integer;
    typ: integer;
begin
  Window(1,22,80,25);
  curpos := Round((80/Maximum)*value);
  typ:=0;
  if curpos=0 then curpos:=1;
  if curpos<0 then begin
    curpos:=1;
    typ:=1;
  end;
  if curpos>80 then begin
    curpos:=80;
    typ:=2;
  end;
  if curpos<>CurPosOfZiel then begin
    TextColor(9);
    GotoXY(oldcp,2);
    if oldcp<>CurPosOfZiel then Write('º');
    if value=Ziel then TextColor(14+blink) else TextColor(11);
    { GotoXY(curpos,1); Write('Ò'); }
    GotoXY(curpos,2);
    if typ=0 then Write('º');
    if typ=1 then Write('<');
    if typ=2 then Write('>');
    { GotoXY(curpos,3); Write('Ð'); }
  end;
  if value=Ziel then CurPosOfZiel:=curpos;
  oldcp := curpos;
end;

procedure Init;
begin
  Str(Maximum,Maxi);
  Randomize;
  loser:= true;
  Ziel := GetNum;
  TextBackground(0);
  ClrScr;
  TextColor(9);
  DrawGraph;
  TitleScreen;
  SetGraph(Ziel);
end;

procedure Ask(QueryString: string);
var spcfr,i: integer;
begin
  spcfr:=35-Length(QueryString);
  for i:=1 to Trunc(spcfr/2) do QueryString:=' '+QueryString+' ';
  Window(23,12,58,14);
  GotoXY(1,1);
  TextColor(15);
  TextBackground(1);
  GotoXY(1,1);
  WriteLn(QueryString);
  GotoXY(15,2); Write('                 ');
  GotoXY(15,2);
  Read(ActTry);
  TextBackground(0);
end;

procedure Check;
var AT,T:string;
    i: integer;
begin
  Window(1,9,19,18);
  Str(ActTry,AT);
  Str(Tries:2,T);
  if ActTry<Ziel then AT:=AT+' <';
  if ActTry>Ziel then AT:=AT+' >';
  if ActTry=Ziel then AT:=AT+'><';
  AT:=AT+' '+T;
  for i:=Length(AT) to 18 do begin
    AT:=' '+AT;
  end;
  GotoXY(1,9);
  TextColor(7);
  WriteLn(AT);
  if ActTry=12345 then loser:=false;
  Window(1,1,80,25);
  GotoXY(36,16);
  TextColor(10);
  if ActTry<Ziel then Write('Zu klein!');
  if ActTry>Ziel then Write('Zu groá! ');
  if ActTry=Ziel then begin
    TextColor(15+blink);
    Write('TREFFER! ');
    loser:=false;
  end;
end;

begin
  Init;
  while loser do begin
    Inc(Tries);
    Ask('Gib Deinen Versuch ein:');
    Target[Tries]:=ActTry;
    SetGraph(ActTry);
    Check;
  end;
  ReadKey;
end.