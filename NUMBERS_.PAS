program Unit_Numbers_Test;

uses Crt,Numbers;

var n,z,fac: integer;

begin
  ClrScr;
  WriteLn('-=+ Unit: Numbers - CheckOut +=-');
  WriteLn;

  WriteLn('Dec2Hex    254      Dec ==> Hex: ',Dec2Hex(254));

  WriteLn('Hex2Dec    F0       Hex ==> Dec: ',Hex2Dec('F0'));

  WriteLn('Bin2Dec    10101100 Bin ==> Dec: ',Bin2Dec('10101100'));

  Write('Shorten    525/365    Fraction : ');
  Shorten(525,365,n,z,fac);
  WriteLn(n,'/',z,' --- GGT:',fac);

  Write('AddFrac    6/8 + 4/7  Fraction : ');
  AddFrac(6,8,4,7,n,z,false);
  Write(n,'/',z,' ==> ');
  AddFrac(6,8,4,7,n,z,true);
  WriteLn(n,'/',z);

  Write('SubFrac    6/8 - 4/7  Fraction : ');
  SubFrac(6,8,4,7,n,z,false);
  Write(n,'/',z,' ==> ');
  SubFrac(6,8,4,7,n,z,true);
  WriteLn(n,'/',z);


end.