program Wave;

uses Crt;

const AC=9;
      IC=1;
      AS='±';
      IS=' ';
      del=0;

procedure MakeScreen;
var i,j: byte;
begin
  TextMode(co80 + Font8x8);
  TextColor(IC);
  for i:=1 to 49 do begin
    for j:=1 to 80 do begin
      GotoXY(j,i);
      Write(IS);
    end;
  end;
end;

procedure WaveL2R;
var i,j: byte;
begin
  for i:=0 to 82 do begin
    TextColor(IC);
    if ((i-1>0) AND (i-1<81)) then begin
      for j:=1 to 49 do begin
        GotoXY(i-1,j);
        Write(IS);
      end;
    end;
    TextColor(AC);
    if ((i>0) AND (i<81)) then begin
      for j:=1 to 49 do begin
        GotoXY(i,j);
        Write(AS);
      end;
    end;
    Delay(del);
  end;
end;

procedure WaveT2B;
var i,j: byte;
begin
  for i:=0 to 51 do begin
    TextColor(IC);
    if ((i-1>0) AND (i-1<50)) then begin
      for j:=1 to 80 do begin
        GotoXY(j,i-1);
        Write(IS);
      end;
    end;
    TextColor(AC);
    if ((i>0) AND (i<50)) then begin
      for j:=1 to 80 do begin
        GotoXY(j,i);
        Write(AS);
      end;
    end;
    Delay(del);
  end;
end;

begin
  MakeScreen;
  repeat
    WaveL2R;
    WaveT2B;
  until keypressed;
  ReadKey;
end.