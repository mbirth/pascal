unit ColWrite;

interface
  procedure CWrite(st: string);
  procedure CWriteLn(st: string);

implementation

uses Crt;

procedure CWrite(st: string);
var i,j,k: integer;
    FG,BG,err: integer;
    last: integer;
    cod: string;
begin
  last := 1;
  for i:=1 to Length(st) do begin
    if Copy(st,i,2)='%%' then begin
      Write(Copy(st,last,i-last));     { all before the CC }
      for j:=i to Length(st) do begin
        if Copy(st,j,1)='#' then begin
          last := j+1;
          cod := Copy(st,i+2,j-i-2);
          for k:=1 to Length(cod) do begin
            if Copy(cod,k,1)=',' then begin
              Val(Copy(cod,1,k-1),FG,err);
              if err=0 then TextColor(FG);
              Val(Copy(cod,k+1,Length(cod)-k),BG,err);
              if err=0 then TextBackground(BG);
            end else begin
              Val(cod,FG,err);
              if err=0 then TextColor(FG);
            end;
          end;
          break;
        end;
      end;
    end;
  end;
  Write(Copy(st,last,Length(st)-last+1));
end;

procedure CWriteLn(st: string);
begin
  CWrite(st);
  WriteLn;
end;

begin
  TextColor(8);
  WriteLn('þ Loading Unit: ColWrite - by Markus Birth <Robo.Cop@gmx.net>');
end.