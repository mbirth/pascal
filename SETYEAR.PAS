program SetYear;

uses Dos;

var y,m,d,dow: word;
    ec,ny: integer;

begin
  GetDate(y,m,d,dow);
  WriteLn('Datum im Computer: ',d,'.',m,'.',y);
  Val(ParamStr(1),ny,ec);
  SetDate(ny,m,d);
  GetDate(y,m,d,dow);
  WriteLn('Neues Datum      : ',d,'.',m,'.',y);
end.
