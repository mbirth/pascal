program SMSArchiverDecode;

uses Crt, DOS;

const ifile='smsar.dat';

var data: array[1..10] of string;
    i,coe: integer;
    f: text;
    k: char;
    cx,cy: integer;

function Decode(x: string): string;
var i,y: integer;
    tmp: string;
begin
  tmp := '';
  for i:=1 to Length(x) do begin
    y := Ord(x[i]);
    tmp := tmp + Chr(y+coe);
  end;
  Decode := tmp;
end;

procedure Get10Lines;
var i: integer;
begin
  for i:=1 to 10 do ReadLn(f,data[i]);
end;


begin
  ClrScr;
  Write('Opening ',ifile,' ... ');
  Assign(f,ifile);
  Reset(f);
  WriteLn('OK.');
  Write('Getting 10 lines ... ');
  Get10Lines;
  WriteLn('OK.');
  cx := WhereX;
  cy := WhereY;
  repeat
    ClrScr;
    for i:=1 to 10 do WriteLn(Decode(data[i]));
    WriteLn('Coefficient: ',coe);
    k := ReadKey;
    if k='+' then coe:=coe+1;
    if k='-' then coe:=coe-1;
  until k=#27;
  Write('Closing file ... ');
  Close(f);
  WriteLn('OK.');
end.
