unit Numbers;

interface
  procedure Negativate(var bin: string);
  function Dec2Hex(dec: longint): string;
  function Hex2Dec(hex: string): longint;
  function Bin2Dec(bin: string): longint;
  function FPBin2Dec(bin: string): extended;
  function Dec2Bin(dec: longint): string;
  function Dec2FPBin(dec: real): string;

  procedure Shorten(z,n: integer; var nz,nn,fac: integer);
  procedure AddFrac(z1,n1,z2,n2: integer; var nz,nn: integer; sh: boolean);
  procedure SubFrac(z1,n1,z2,n2: integer; var nz,nn: integer; sh: boolean);

implementation

  const HexSet:string='0123456789abcdef';

  function Sqrr(base,raise: integer): longint;
  var i: integer;
      tmp: longint;
  begin
    if (raise>0) then begin
      tmp := 1;
      for i:=1 to raise do
        tmp := tmp * base;
    end else tmp := 1;
    Sqrr := tmp;
  end;

  function Dec2Hex(dec: longint): string;
  var tmp: string;
  begin
    tmp := '';
    repeat
      tmp := HexSet[(dec MOD 16)+1] + tmp;
      dec := dec DIV 16;
    until (dec<=15);
    tmp := HexSet[(dec MOD 16)+1] + tmp;
    if (Length(tmp)/2 <> Length(tmp) DIV 2) then tmp := '0'+tmp;
    Dec2Hex := tmp;
  end;

  function Hex2Dec(hex: string): longint;
  var x: longint;
      i,j: integer;
  begin
    x := 0;
    for i:=1 to Length(hex) do
      for j:=1 to Length(HexSet) do
        if (UpCase(hex[i])=UpCase(HexSet[j])) then
          x := x + (j-1)*Sqrr(16,Length(hex)-i);
    Hex2Dec := x;
  end;

  function Bin2Dec(bin: string): longint;
  var i: integer;
      cm: longint;
      tmp: longint;
  begin
    cm := 1;
    tmp := 0;
    if Length(bin)>30 then begin
      Bin2Dec := 0;
      WriteLn('OVERFLOW! Only up to 30 bits are allowed.');
      Exit;
    end;
    for i:=Length(bin) downto 1 do begin
      if bin[i]='1' then tmp := tmp + cm;
      cm := cm * 2;
    end;
    Bin2Dec := tmp;
  end;

  function FPBin2Dec(bin: string): extended;
  var i,di: integer;
      cm: extended;
      tmp: extended;
      dot: boolean;
  begin
    cm := 0.5;
    tmp := 0;
    dot := false;
    for i:=1 to Length(bin) do begin
      if (bin[i]='.') OR (bin[i]=',') then begin
        if i>31 then begin
          FPBin2Dec := 0;
          WriteLn('OVERFLOW! Only up to 30 bits before the separator are allowed.');
          Exit;
        end;
        tmp := tmp + Bin2Dec(Copy(bin,1,i-1));
        di := i;
        dot := true;
      end;
    end;
    if NOT dot then tmp := Bin2Dec(bin);
    for i:=di+1 to Length(bin) do begin
      if bin[i]='1' then tmp := tmp + cm;
      cm := cm * 0.5;
    end;
    FPBin2Dec := tmp;
  end;

  procedure Negativate(var bin: string);
  var i: integer;
     tmp: string;
     as: boolean;
  begin
    tmp := '';
    WriteLn('Neg: positive Value: ',bin);
    as := false;
    for i:=1 to Length(bin) do
      if (bin[i]='1') then tmp := tmp + '0' else tmp := tmp + '1';
    WriteLn('Neg: switched Value: ',tmp);
    for i:=Length(tmp) downto 1 do
      if (tmp[i]='0') then begin
        tmp[i]:='1';
        as := true;
        Break;
      end else tmp[i]:='0';
    WriteLn('Neg: one added     : ',tmp);
    if (NOT as) OR (tmp[1]<>'1') then tmp := '1' + tmp;
    bin := tmp;
  end;

  function Dec2Bin(dec: longint): string;
  var i: integer;
     cm: longint;
     cn: longint;
    tmp: string;
  begin
    cm := 1;
    cn := Abs(dec);
    tmp := '';
    for i:=1 to 30 do cm := cm * 2;
    while cm>=1 do begin
      if (cn div cm=0) AND (Length(tmp)>0) then tmp:=tmp+'0';
      if (cn div cm<>0) then tmp:=tmp+'1';
      cn := cn mod cm;
      cm := cm div 2;
    end;
    if Length(tmp)=0 then tmp:='0';
    if (dec)<0 then Negativate(tmp);
    Dec2Bin := tmp;
  end;

  function Dec2FPBin(dec: real): string;
  var i: integer;
     cm: real;
     cn: real;
    tmp: string;
  begin
    tmp := Dec2Bin(Trunc(dec));
    tmp := tmp + ',';
    cm  := Abs(dec - Trunc(dec));
    cn := 0.5;
    repeat
      if (cm-cn)>=0 then begin
        tmp := tmp + '1';
        cm := cm-cn;
      end else tmp := tmp + '0';
      cn := cn * 0.5;
    until cm=0;
    Dec2FPBin := tmp;
  end;

  procedure Shorten(z,n: integer; var nz,nn,fac: integer);
  var curt: integer;
      min: integer;
  begin
    if z<n then min:=z else min:=n;
    for curt:=min downto 1 do begin
      { WriteLn('curt: ',curt,' -- z/curt: ',z/curt:0:2,'  n/curt: ',n/curt:0:2);
      Delay(100); }
      if ((Int(z/curt)=z/curt) AND (Int(n/curt)=n/curt)) then begin
        nz := z div curt;
        nn := n div curt;
        fac := curt;
        Exit;
      end;
    end;
  end;

  procedure AddFrac(z1,n1,z2,n2: integer; var nz,nn: integer; sh: boolean);
  var fac: integer;
  begin
    nz := z1*n2+z2*n1;
    nn := n1*n2;
    if sh then Shorten(nz,nn,nz,nn,fac);
  end;

  procedure SubFrac(z1,n1,z2,n2: integer; var nz,nn: integer; sh: boolean);
  var fac: integer;
  begin
    nz := z1*n2-z2*n1;
    nn := n1*n2;
    if sh then Shorten(nz,nn,nz,nn,fac);
  end;

begin
  WriteLn('þ Loading Unit: Numbers - Markus Birth <mbirth@webwriters.de>');
end.
