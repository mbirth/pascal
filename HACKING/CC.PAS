program CCMast;

uses Crt, DOS;

var c: record
         len: integer;
         str: string;
         dig: array[1..16] of byte;
         chk: integer;
         typ: string;
         val: string;
       end;

procedure InputCC;
begin
  Write('Enter CC#: ');
  ReadLn(c.str);
end;

procedure CheckType(nam,pres,lens: string);
var clen: string;
    i,oldidx: integer;
    prechk, lenchk: boolean;
begin
  oldidx := 1;
  prechk := false;
  for i:=1 to Length(pres) do begin
    if pres[i]=',' then begin
      if Copy(pres,oldidx,i-oldidx)=Copy(c.str,1,i-oldidx) then prechk := true;
      oldidx := i+1;
    end;
  end;
  oldidx := 1;
  lenchk := false;
  Str(c.len,clen);
  for i:=1 to Length(lens) do begin
    if lens[i]=',' then begin
      if Copy(lens,oldidx,i-oldidx)=Copy(clen,1,i-oldidx) then lenchk := true;
      oldidx := i+1;
    end;
  end;
  { WriteLn(nam:16,' -prechk: ',prechk:5,' -lenchk: ',lenchk:5); }
  if prechk AND lenchk then c.typ := nam;
end;

procedure CheckCC;
var i,a,co: integer;
begin
  c.len := Length(c.str);
  for i:=1 to c.len do begin
    Val(c.str[i],c.dig[i],co);
  end;
  c.chk := 0;
  for i:=c.len downto 1 do begin
    if (c.len-i) MOD 2=0 then a:=c.dig[i] else a:=c.dig[i]*2;
    if a>9 then a := a-9;
    { WriteLn(i:2,': [',c[i],']: ',a:2); }
    c.chk := c.chk + a;
  end;

  c.typ := 'unknown';
  CheckType('MasterCard', '51,52,53,54,55,', '16,');
  CheckType('VISA', '4,', '13,16,');
  CheckType('American Express', '34,37,', '15,');
  CheckType('Diner''s Club', '30,36,38,', '14,');
  CheckType('Discover', '6011,', '16,');
  CheckType('enRoute', '2014,2149,', '15,');
  CheckType('JCB','3088,3096,3112,3158,3337,3528,','16,');

  WriteLn('Type: ', c.typ);
  Write('Checksum: ', c.chk);
  if (c.chk MOD 10=0) AND (c.len>12) AND (c.len<17) then c.val:='VALID' else c.val:='INVALID';
  WriteLn(' ',c.val);
end;

function Checksum(x: string): integer;
var ch, i, co, j: integer;
begin
  ch := 0;
  for i:=1 to Length(x) do begin
    val(x[i],j,co);
    if (Length(x)-i) MOD 2<>0 then j:=j*2;
    if j>9 then j := j - 9;
    ch := ch + j;
  end;
  Checksum := ch;
end;

function Valid(x: string): boolean;
begin
  if Checksum(x) MOD 10=0 then Valid := true else Valid := false;
end;

procedure Interpolate;
var f: text;
    i: integer;
    n,o: string;
begin
  Assign(f,'CC.out');
  {$I-}
  Append(f);
  if IOResult<>0 then Rewrite(f);
  {$I+}
  WriteLn(f,'---- ---- ---- ----');
  Write(f,'New Interpolation from ',c.typ,' card ');
  for i:=1 to c.len do begin
    Write(f,c.dig[i]:1);
    if (i MOD 4 = 0) AND (i<>16) then Write(f,' ');
  end;
  WriteLn(f,' (Checksum: ',c.chk,' [',c.val,'])');
  WriteLn(f,'');
  for i:=0 to 9999 do begin
    n := Copy(c.str,1,c.len-4);
    if i<1000 then n := n + '0';
    if i<100 then n := n + '0';
    if i<10 then n := n + '0';
    Str(i:0,o);
    n := n + o;
    if (Valid(n)) AND (n<>c.str) then
      WriteLn(f, Copy(n,1,4),' ',Copy(n,5,4),' ',Copy(n,9,4),' ',Copy(n,13,Length(n)-12),' [',Checksum(n),']');
  end;
  Close(f);
end;


begin
  InputCC;
  CheckCC;
  Interpolate;
end.
