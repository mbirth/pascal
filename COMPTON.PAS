program Physik;

uses Crt;

const W:real=3.204E-14;  { Wkin = 200 keV }
      C:real=2.99792458E8; { c }
      M:real=9.1093897E-31; { Elektronenmasse }
      comp=13;

var mx, vx: real;
    omx,ovx: real;
    mc, omc, vc, ovc: string;
    ct: longint;

begin
  ClrScr;
  mx := M;
  vx := 0;
  ct := 0;
  WriteLn('GewÅnschte Genauigkeit: ',comp-2,' Stellen nach dem Kommata.');
  repeat
    omx := mx;
    ovx := vx;
    vx := Sqrt((2*W)/(mx));
    mx := M/Sqrt(1-Sqr(vx/C));
    Inc(ct);
    Str(mx,mc);
    Str(omx,omc);
    Str(vx,vc);
    Str(ovx,ovc);
    mc := Copy(mc,1,comp);
    omc := Copy(omc,1,comp);
    vc := Copy(vc,1,comp);
    ovc := Copy(ovc,1,comp);
    GotoXY(1,3);
    WriteLn('[',ct:5,'] Elektronenmasse m: ',mx,'         ');
    WriteLn('[',ct:5,'] Geschwindigkeit v: ',vx,'         ');
    Delay(200);
  until (mc=omc) AND (vc=ovc);
end.