uses Graph;

var
  Gd, Gm: Integer;
  Y0, Y1, Y2, X1, X2: Integer;
begin
  Gd := Detect;
  InitGraph(Gd, Gm, 'F:\SPRACHEN\BP\BGI\');
  if GraphResult <> grOk then
    Halt(1);
  Y0 := 10;
  Y1 := 60;
  Y2 := 110;
  X1 := 10;
  X2 := 50;
  Bar3D(X1, Y0, X2, Y1, 10, TopOn);
  Bar3D(X1, Y1, X2, Y2, 10, TopOff);
  Readln;
  CloseGraph;
end.
