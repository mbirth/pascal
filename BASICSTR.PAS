unit BasicStrings;

interface
  function Mid(Txt: string; Index: integer; Count: integer): string;
  function Left(Txt: string; Count: integer): string;
  function Right(Txt: string; Count: integer): string;

implementation
  function Mid(Txt: string; Index: integer; Count: integer): string;
    begin
      Mid := Copy(Txt, Index, Count);
    end;

  function Left(Txt: string; Count: integer): string;
    begin
      Left := Copy(Txt, 1, Count);
    end;

  function Right(Txt: string; Count: integer): string;
    begin
      Right := Copy(Txt, Length(Txt)-Count+1, Length(Txt)-(Length(Txt)-Count));
    end;

begin
  WriteLn('þ Loading Unit: BasicStrings - geschrieben von RoboCop IND.');
end.
