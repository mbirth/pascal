program Coder_Test;

uses Crt, Coder;

var org,x: string;

begin
  TextColor(15);
  TextBackground(0);
  ClrScr;
  Write('Zu verschlÅsselnder Text: ');
  ReadLn(org);
  RSInit := Length(org) * 11;
  WriteLn('RandSeed: ',RSInit);
  WriteLn;

  x := org;
  WriteLn('OrdCode (co=true)');
  OrdCode(x,code);
  WriteLn(x);
  OrdCode(x,decode);
  WriteLn(x);
  WriteLn;

  x := org;
  WriteLn('OrdCode (co=false)');
  OrdCode(x,decode);
  WriteLn(x);
  OrdCode(x,code);
  WriteLn(x);
  WriteLn;

  x := org;
  WriteLn('SortCode (co=true)');
  SortCode(x,code);
  WriteLn(x);
  SortCode(x,decode);
  WriteLn(x);
  WriteLn;

  x := org;
  WriteLn('SortCode (co=false)');
  SortCode(x,decode);
  WriteLn(x);
  SortCode(x,code);
  WriteLn(x);
  WriteLn;

  x := org;
  WriteLn('Hebrew');
  Hebrew(x);
  WriteLn(x);
  Hebrew(x);
  WriteLn(x);
  WriteLn;
end.
