{ $M $4000,0,0 }

program ExecTest;

uses Dos;

begin
  SwapVectors;
  Exec('c:\command.com','');
  SwapVectors;
  if DosError<>0 then WriteLn('Dos-Error: ',DosError);
  WriteLn('Exitcode: ',DosExitCode);
end.