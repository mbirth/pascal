program GraphView;

uses Crt, Numbers;

const blocksize=2048;

var fn: file;
    tmp: array[0..blocksize] of char;
    ec: word;
    i,j: byte;
    k: word;
    x: char;
    offs: byte;

begin
  TextMode(co80+font8x8);
  ClrScr;
  Write('Reading file ',ParamStr(1),'....');
  Assign(fn,ParamStr(1));
  Reset(fn,1);
  BlockRead(fn,tmp,blocksize,ec);
  WriteLn(ec,' Bytes read');
  Close(fn);
  Write('Looking for offset....');
  offs:=0;
  repeat
    Inc(offs);
  until tmp[offs]=#72;
  Inc(offs,9);
  WriteLn('Offset is ',offs);
  GotoXY( 1,10); Write('É');
  GotoXY(74,10); Write('»');
  GotoXY( 1,25); Write('È');
  GotoXY(74,25); Write('¼');
  for i:=1 to 14 do begin
    GotoXY(1,i+10); Write('º');
    GotoXY(74,i+10); Write('º');
    for j:=1 to 72 do begin
      GotoXY(j+1,10); Write('Í');
      GotoXY(j+1,25); Write('Í');
      GotoXY(j+1,i+10);
      x:=tmp[(i-1)*72+j+offs];
      if x='1' then Write('Û') else if x='0' then Write(' ') else Write(x);
    end;
  end;
  GotoXY(1,26); Write('Header: ');
  for k:=0 to offs do begin
    Write(Dec2Hex(Ord(tmp[k])),' ');
  end;
  WriteLn; WriteLn; Write('Filetype-string: ');
  for k:=offs+72*14+1 to ec do begin
    Write(tmp[k]);
  end;
  WriteLn; WriteLn;
  WriteLn('Press any key');
  ReadKey;
  TextMode(co80);
end.