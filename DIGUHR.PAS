program DIGUHR;

uses Crt;

const sstd1=2; { Std1 }
      sstd2=1; { Std2 }
      smin1=4; { Min1 }
      smin2=5; { Min2 }
      ssek1=5; { Sek1 }
      ssek2=3; { Sek2 }
      sset: boolean=true;

var std1,std2,ende,min1,min2,sek1,sek2: byte;

begin
  ClrScr;
  repeat
    for std1:=0 to 2 do begin
      if std1=2 then ende:=3 else ende:=9;
      for std2:=0 to ende do
        for min1:=0 to 5 do
          for min2:=0 to 9 do
            for sek1:=0 to 5 do
              for sek2:=0 to 9 do begin
                GotoXY(1,1);
                Write(std1,std2,':',min1,min2,'.',sek1,sek2);
                if sset then begin
                  if (std1=sstd1) AND (std2=sstd2) AND
                     (min1=smin1) AND (min2=smin2) AND
                     (sek1=ssek1) AND (sek2=ssek2) then sset:=false;
                end else Delay(1000);
                if keypressed then begin
                  ReadKey;
                  Exit;
                end;
              end;
    end;
  until 0=1;
end.
