program RoboCarder;

{ MOD-10 algorithm

  first digit: kind of credit card ( 3-AMEX, 4-VISA, 5-MC )

  length
  ------
  AMEX - 15 digits
  VISA - 16 digits, sometimes 13
  all other - 16 digits

  validation
  ----------
  begin at the rightmost digit and go to the left.
  the odd digits are all sum'd up. the even (every 2nd) digits are
  multiplied by 2. if the result is greater than 9, 9 is substracted.
  this resulting value is added to the sum.

  sum MOD 10 must be 0.

}


uses Crt;

const bigdigit: array[0..9,1..3] of string[5] = ( ('23332','10001','03330'),
                                            { 1 } ('02100','00100','00300'),
                                            { 2 } ('33332','23330','33333'),
                                            { 3 } ('33332','03332','33330'),
                                            { 4 } ('10010','33313','00030'),
                                            { 5 } ('13333','33332','33330'),
                                            { 6 } ('23333','13332','03330'),
                                            { 7 } ('33313','02300','30000'),
                                            { 8 } ('23332','23332','03330'),
                                            { 9 } ('23332','03331','33330'));

var inp: string[16];

procedure CheckValidity(x: string);
var i,sum,tmp,ec: integer;
begin
  WriteLn('Number length: ',Length(x));
  Val(x[1],tmp,ec);
  case tmp of
    3: WriteLn('Type: American Express');
    4: WriteLn('Type: VISA');
    5: WriteLn('Type: MasterCard');
  end;
  sum := 0;
  for i:=1 to Length(x) do begin
    Val(x[Length(x)-i+1],tmp,ec);
    if i MOD 2=0 then tmp := tmp*2;
    if tmp>9 then tmp := tmp-9;
    sum := sum + tmp;
  end;
  WriteLn('Quersumme: ',sum);
  if sum MOD 10=0 then WriteLn('VALID') else WriteLn('INVALID!!!');
end;

procedure BigWrite(w: string;x,y: word);
var i,j,k,ec: integer;
    tmp: byte;
begin
  for k:=1 to Length(w) do begin
    for j:=1 to 3 do begin
      GotoXY(x+(k-1)*6,y+j-1);
      for i:=1 to 5 do begin
        Val(w[k],tmp,ec);
        case bigdigit[tmp,j][i] of
          '0': Write(' ');
          '1': Write('Û');
          '2': Write('Ü');
          '3': Write('ß');
        end;
      end;
    end;
  end;
end;

begin
  ClrScr;
  GotoXY(1,7);
  Write('Enter Credit Card number: ');
  ReadLn(inp);
  BigWrite(Copy(inp,1,8),1,1);
  BigWrite(Copy(inp,9,8),1,4);
  GotoXY(1,8);
  CheckValidity(inp);
  ReadKey;
end.
