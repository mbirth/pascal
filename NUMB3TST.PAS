uses numbers;

var tmp: string;
    tmp2: real;

begin

  Write('Enter Floating Point Bin number: ');
  ReadLn(tmp);
  WriteLn('It''s: ',FPBin2Dec(tmp):0:10);
{
  Write('Enter FP decimal: ');
  ReadLn(tmp2);
  WriteLn('It''s: ',Dec2FPBin(tmp2));
}
end.
