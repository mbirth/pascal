program TimeCalc;   { Unterrichtsstoff der 12. Klasse - L”sung von Markus Birth }

uses Crt,Strings;

var tstr: string[40];
    h1,m1,s1,hs1: integer;
    h2,m2,s2,hs2: integer;
    hf,mf,sf,hsf: integer;

procedure GetData(which: string;var h,m,s,hs: integer);
var i,ec,tmp,oldi: integer;
begin
  Write('Geben Sie die ',which,' Zeit ein [hh:mm.ss,tt]: ');
  ReadLn(tstr);
  oldi := 1;
  for i:=1 to Length(tstr) do begin
    if ((tstr[i]=':') OR (tstr[i]='.') OR (tstr[i]=',')) then begin
      Val(Copy(tstr,oldi,i-oldi),tmp,ec);
      oldi := i+1;
      case tstr[i] of
        ':': h:=tmp;
        '.': m:=tmp;
        ',': s:=tmp;
      end;
    end;
  end;
  Val(Copy(tstr,oldi,Length(tstr)-oldi+1),tmp,ec);
  hs:=tmp;
end;

procedure AddData(h1,m1,s1,hs1,h2,m2,s2,hs2: integer; var hf,mf,sf,hsf: integer; Add: boolean);
begin
  if Add then begin
    hsf := hs1 + hs2;
    sf  := s1  + s2;
    mf  := m1  + m2;
    hf  := h1  + h2;

    sf  := sf  + hsf DIV 100;
    hsf := hsf MOD 100;

    mf  := mf  + sf DIV 60;
    sf  := sf MOD 60;

    hf  := hf  + mf DIV 60;
    mf  := mf MOD 60;
  end else begin
    hsf := hs1 - hs2;
    sf  := s1  - s2;
    mf  := m1  - m2;
    hf  := h1  - h2;

    while hsf<0 do begin
      hsf := hsf + 100;
      sf  := sf  - 1;
    end;

    while sf<0 do begin
      sf  := sf + 60;
      mf  := mf - 1;
    end;

    while mf<0 do begin
      mf  := mf + 60;
      hf  := hf - 1;
    end;
  end;
end;

procedure TimeOut(h,m,s,t: integer);
begin
  WriteLn(h:2,':',m:2,'.',s:2,'''',t:2,'''''');
end;

procedure DataOut(Add: boolean);
begin
  Write(' ');
  TimeOut(h1,m1,s1,hs1);
  if Add then Write('+') else Write('-');
  TimeOut(h2,m2,s2,hs2);
  WriteLn('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
  AddData(h1,m1,s1,hs1,h2,m2,s2,hs2,hf,mf,sf,hsf,Add);
  Write(' ');
  TimeOut(hf,mf,sf,hsf);
  WriteLn('ÄÍÍÍÍÍÍÍÍÍÍÍÍÍÄ');
end;

procedure SwapVals(var h1,m1,s1,t1,h2,m2,s2,t2: integer);
var tmp: integer;
begin
  tmp := h1;
  h1  := h2;
  h2  := tmp;

  tmp := m1;
  m1  := m2;
  m2  := tmp;

  tmp := s1;
  s1  := s2;
  s2  := tmp;

  tmp := t1;
  t1  := t2;
  t2  := tmp;
end;

procedure Time2Secs(h,m,s: integer; var sec: longint);
begin
  sec := h*3600 + m*60 + s;
end;

procedure Secs2Time(sec: longint; var h,m,s: integer);
begin
  h   := sec div 3600;
  sec := sec mod 3600;
  m   := sec div 60;
  s   := sec mod 60;
end;

begin
  ClrScr;
  GetData(' erste',h1,m1,s1,hs1);
  GetData('zweite',h2,m2,s2,hs2);
  Window(1,4,26,10);
  DataOut(true);
  Window(26,4,52,10);
  DataOut(false);
  Window(52,4,78,10);
  SwapVals(h1,m1,s1,hs1,h2,m2,s2,hs2);
  DataOut(false);
  Window(1,1,80,25);
  GotoXY(1,11);
  WriteLn;
  WriteLn('*** Bitte drcken Sie eine Taste ***');
  ReadKey;
end.
