program pZipCompressor;

uses Crt, Dos;

var infile, outfile: file;
    insize, outsize: longint;
    infname, outfname: string;

procedure Init;
begin
  infname := ParamStr(1);
  Assign(infile,infname);
  Reset(infile);
  insize := FileSize(infile);
  Close(infile);
end;

procedure ExecPacker;
begin
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C pack_.bat '+infname);
  SwapVectors;
end;

procedure After;
begin
  Assign(outfile,'!'+infname);
  Reset(outfile);
  outsize := FileSize(outfile);
  Close(outfile);
end;

procedure Out;
begin
  WriteLn('Statistics');
  WriteLn('Original size: ',insize,' Bytes');
  WriteLn('Packed size:   ',outsize,' Bytes');
end;

begin
  Init;
  ExecPacker;
  After;
  Out;
end.