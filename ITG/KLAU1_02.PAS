var a,b,cs,max: integer;

begin
  Write('max: ');
  ReadLn(max);
  for a:=1 to max do begin
    for b:=a to max do begin
      cs := Sqr(a)+Sqr(b);
      if Sqrt(cs)=Int(Sqrt(cs)) then WriteLn(a,'�+',b,'�=',Sqrt(cs):0:0,'�');
    end;
  end;
end.
