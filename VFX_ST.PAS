uses Crt,VFx;

var i: integer;

begin
  CursorOff;
  WinBeep;
  for i:=1 to 10 do begin
    if i<5 then begin
      TextColor(8);
      WriteC('Dies ist ein Testtext ---------------------fdsafasdfasdfasdffsdfsdf-');
    end;
    FXWriteC('Dies ist ein Testtext ---------------------fdsafasdfasdfasdffsdfsdf-',15);
    WriteLn;
  end;
  ReadKey;
  CursorOn;
end.
