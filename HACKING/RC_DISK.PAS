unit RC_Disk;     { BLEA01.PAS }

interface
  procedure FileCopy(src: string; tar: string);

implementation

procedure FileCopy(src: string; tar: string);
  const
    bytezahl=16384;

  var
    Quelle, Ziel:              file ;
    Puffer:                    array [1..bytezahl] of byte;
    Recordzahl, Rest:          integer;

  begin
    Assign(Quelle, src);
    Reset(Quelle,1);
    Assign(Ziel, tar);
    Rewrite(Ziel,1);
    Rest := FileSize(Quelle);
    while Rest>0 do begin
      if Bytezahl<=Rest then Recordzahl := Bytezahl else Recordzahl := Rest;
      BlockRead(Quelle, Puffer, Recordzahl);
      BlockWrite(Ziel, Puffer, Recordzahl);
      Rest := Rest-Recordzahl;
    end;
    Close(Quelle);
    Close(Ziel);
  end;
end.
