{$M $4000,0,0}
program ReverZ_CD_installer;

uses Crt,DOS;

var cddrv,tmpdir,tmpdirr,tmp: string;
    f: text;
    i: integer;

procedure Abort(msg: string);
begin
  WriteLn('Failed.');
  WriteLn;
  WriteLn(msg);
  WriteLn('Press any key to exit.');
  ReadKey;
  Halt;
end;

begin
  WriteLn('Welcome to the ReverZ-CD installer with the D-Info ''99 database');
  WriteLn;
  Write('Checking TEMP-directory....');
  tmpdir:=GetEnv('TEMP');
  if tmpdir='' then Abort('Set your TEMP-envvar!');
  WriteLn('done. TEMP-dir is ',tmpdir);
  Write('Checking write access to TEMP....');
  Assign(f,tmpdir+'\reverz.$$$');
  {$I-}
  Rewrite(f);
  if IOResult<>0 then Abort('Get write access to TEMP-dir or change envvar!');
  {$I+}
  WriteLn(f,'ReverZ write test');
  Close(f);
  {$I-}
  Reset(f);
  if IOResult<>0 then Abort('Write possible, read not - DO SOMETHING!');
  {$I+}
  ReadLn(f,tmp);
  Close(f);
  if tmp<>'ReverZ write test' then Abort('Read data not equal to written!');
  {$I-}
  Erase(f);
  if IOResult<>0 then begin
    WriteLn('Failed.');
    WriteLn;
    WriteLn(tmpdir,'\reverz.$$$ could not be deleted. Delete manually!');
    WriteLn('Press any key to continue.');
    ReadKey;
  end else WriteLn('done.');
  {$I+}
  Write('Searching install drive letter....');
  tmp := ParamStr(0);
  cddrv := tmp[1];
  WriteLn('done. Install drive is ',cddrv,':');
  Write('Creating Registry-entries....');
  Assign(f,tmpdir+'\reverz.reg');
  {$I-}
  Rewrite(f);
  if IOResult<>0 then Abort('Error while writing reverz.reg to '+tmpdir+'!');
  {$I+}
  tmpdirr := '';
  for i:=1 to Length(tmpdir) do
    if tmpdir[i]='\' then tmpdirr:=tmpdirr+'\\' else tmpdirr:=tmpdirr+tmpdir[i];
  WriteLn(f,'REGEDIT4');
  WriteLn(f,'');
  WriteLn(f,'[HKEY_CURRENT_USER\Software\Topware\D-Info ''99\ReverZ]');
  WriteLn(f,'"IndexLong"="',cddrv,':\\DATA\\rev_long.idx"');
  WriteLn(f,'"IndexShort"="',cddrv,':\\DATA\\rev_shor.idx"');
  WriteLn(f,'"CDPath"="',cddrv,':\\DATA"');
  WriteLn(f,'"HDPath"="',cddrv,':\\DATA"');
  WriteLn(f,'"TempPath"="',tmpdirr,'"');
  WriteLn(f,'"NotFound"=dword:00000002');
  WriteLn(f,'"Folge"=dword:00000001');
  WriteLn(f,'"F4Start"=dword:00000001');
  WriteLn(f,'"IgnoreCDWarnung"=dword:00000000');
  WriteLn(f,'"Index"=dword:00000002');
  WriteLn(f,'"ConfigOkay"=dword:00000001');
  WriteLn(f,'');
  Close(f);
  WriteLn('done.');
  Write('Importing Registry entries....');
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C START /w regedit /s '+tmpdir+'\reverz.reg');
  SwapVectors;
  WriteLn('hopefully done.');
  Write('Deleting reverz.reg....');
  {$I-}
  Erase(f);
  if IOResult<>0 then begin
    WriteLn('Failed.');
    WriteLn;
    WriteLn(tmpdir,'\reverz.reg could not be deleted. Delete manually!');
    WriteLn('Press any key to continue.');
    ReadKey;
  end else WriteLn('done.');
  {$I+}
  WriteLn;
  WriteLn('All done.');
end.
