{ $M $4000,0,0 }

program Hacking_and_Phreaking;

uses Crt, Logo, Dos, RC_Disk;

var s: string;
    f: file;
    TempFile: string;

procedure Init;
  var f2c: string;
  begin
    GetDir(0,s);
    f2c:=s+'\HACKING.OVL';
    WriteLn(f2c);
    WriteLn(TempFile);
    FileCopy(f2c, TempFile);
    WriteLn('Temp-Datei angelegt!');
    Assign(f,TempFile);
  end;

procedure Outit;
  begin
   { Erase(f); }
  end;

procedure Extract(what: string);
  var Password, Params: string;
      i: integer;
  begin
    Password := '_r';
    Password := 'op' + Password + 'ul';
    Password := 'boC' + Password + 'ez';
    Password := 'Ro' + Password;
    Params := '-s'+Password+' '+what;
    SwapVectors;
    WriteLn('Vectors swapped out');
    Exec(TempFile, Params);
    WriteLn('EXEC command performed ('+tempfile+' '+Params+')');
    SwapVectors;
    WriteLn('Vectors swapped in');
  end;

begin
  TempFile := GetEnv('TEMP')+'\~1234567.EXE';
  ClrScr;
  Init;
  delay(100);
  Extract('MADMAN.TXT');
  SwapVectors;
  Exec('c:\termin.exe','');
  SwapVectors;
  Outit;
end.
