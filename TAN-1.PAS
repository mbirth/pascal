program test;

var s,t,u,a,v: real;

begin
  a := Pi;
  t := sin(a);
  s := cos(a);
  u := t/s;
  v := t*360;

    WriteLn('Wert: ',a:8:5,'  sin: ',t:8:5,'  cos: ',s:8:5,'  tan: ',u:8:5,'  v: ',v:8:5);
end.