program PushPopDir;

{$M 8192,0,0}

uses Dos;

const TmpFile='dirmem.$$$';

var where: string;
    what: string;
    debug: boolean;

function UC(str: string): string;
var i: integer;
    tmp: string;
begin
  tmp := '';
  for i:=1 to Length(str) do begin
    tmp := tmp + UpCase(str[i]);
  end;
  UC := tmp;
end;

function Contains(str, what: string): boolean;
var i,sl: integer;
begin
  sl := Length(what);
  what := UC(what);
  for i:=Length(str) downto 1 do begin
    if UC(Copy(str,i,sl))=what then begin
      if debug then WriteLn('þ Contains result: ''',what,''' in ParamStr(0): true');
      Contains := true;
      Exit;
    end;
  end;
  if debug then WriteLn('þ Contains result: ''',what,''' in ParamStr(0): false');
  Contains := false;
end;

function GetTempFile: string;
var td: string;
begin
  td := GetEnv('TEMP');
  if td='' then td := GetEnv('TMP');
  if td='' then td := 'C:\';
  if Copy(td,Length(td)-1,1)='\' then td := td+TmpFile else td := td+'\'+TmpFile;
  if debug then WriteLn('þ GetTempFile result: ',td);
  GetTempFile := td;
end;

procedure PopDir;
var tmp: text;
    dir: string;
begin
  dir := '';
  if debug then WriteLn('þ Assigning GetTempFile to tmp');
  Assign(tmp,GetTempFile);
  {$I-}
  if debug then WriteLn('þ Resetting tmp');
  Reset(tmp);
  if debug then WriteLn('þ IOResult check');
  if IOResult<>0 then begin
    WriteLn('No directory in memory!');
    Halt;
  end;
  {$I+}
  if debug then WriteLn('þ Read pushed dir, if NOT Eof(tmp)');
  if NOT Eof(tmp) then ReadLn(tmp,dir);
  if debug then WriteLn('þ Closing tmp');
  Close(tmp);
  if debug then WriteLn('þ Erasing tmp');
  Erase(tmp);
  if debug then WriteLn('þ Result check');
  if dir='' then begin
    WriteLn('No directory in memory! [2]');
    Halt;
  end;
  if debug then WriteLn('þ Changing to directory ''',dir,'');
  ChDir(dir);
  WriteLn('Changed directory to ',dir,'.');
  Halt;
end;

procedure PushDir;
var tmp: text;
begin
  if debug then WriteLn('þ Assigning GetTempFile to tmp');
  Assign(tmp,GetTempFile);
  {$I-}
  if debug then WriteLn('þ Rewriting tmp');
  Rewrite(tmp);
  if debug then WriteLn('þ Writing ''',where,''' to tmp');
  WriteLn(tmp,where);
  if debug then WriteLn('þ Closing tmp');
  Close(tmp);
  if debug then WriteLn('þ IOResult check');
  if IOResult<>0 then begin
    WriteLn('There was an error!');
    Halt;
  end;
  {$I+}
  WriteLn('Pushed current directory into memory.');
  Halt;
end;

procedure SwapDir;
var tmp: text;
    dir: string;
begin
  dir := '';
  if debug then WriteLn('þ Assigning GetTempFile to tmp');
  Assign(tmp,GetTempFile);
  {$I-}
  if debug then WriteLn('þ Resetting tmp');
  Reset(tmp);
  if debug then WriteLn('þ IOResult check');
  if IOResult<>0 then begin
    WriteLn('No directory in memory!');
    Halt;
  end;
  {$I+}
  if debug then WriteLn('þ Read pushed dir, if NOT Eof(tmp)');
  if NOT Eof(tmp) then ReadLn(tmp,dir);
  if debug then WriteLn('þ Closing tmp');
  Close(tmp);
  if debug then WriteLn('þ Erasing tmp');
  Erase(tmp);
  if debug then WriteLn('þ Result check');
  if dir='' then begin
    WriteLn('No directory in memory! [2]');
    Halt;
  end;
  if debug then WriteLn('þ Changing to directory ''',dir,'');
  ChDir(dir);
  {$I-}
  if debug then WriteLn('þ Rewriting tmp');
  Rewrite(tmp);
  if debug then WriteLn('þ Writing ''',where,''' to tmp');
  WriteLn(tmp,where);
  if debug then WriteLn('þ Closing tmp');
  Close(tmp);
  if debug then WriteLn('þ IOResult check');
  if IOResult<>0 then begin
    WriteLn('There was an error!');
    Halt;
  end;
  {$I+}
  WriteLn('Swapped directory with those in memory.');
end;

procedure ShowDir;
var tmp: text;
    dir: string;
begin
  dir := '';
  if debug then WriteLn('þ Assigning GetTempFile to tmp');
  Assign(tmp,GetTempFile);
  {$I-}
  if debug then WriteLn('þ Resetting tmp');
  Reset(tmp);
  if debug then WriteLn('þ IOResult check');
  if IOResult<>0 then begin
    WriteLn('No directory in memory!');
    Halt;
  end;
  if debug then WriteLn('þ Read pushed dir, if NOT Eof(tmp)');
  if NOT Eof(tmp) then ReadLn(tmp,dir);
  if debug then WriteLn('þ Closing tmp');
  Close(tmp);
  if dir='' then begin
    if debug then WriteLn('þ No valid dir in mem ==> Erasing tmp');
    Erase(tmp);
    WriteLn('No directory in memory! [2]');
    Halt;
  end;
  WriteLn('Pushed directory: ',dir);
  Halt;
end;

procedure CreatePackage;
var tmp: text;
begin
  if debug then WriteLn('þ Assigning $$_cp_$$.bat to tmp');
  Assign(tmp,'$$_cp_$$.bat');
  {$I-}
  if debug then WriteLn('þ Rewriting tmp');
  Rewrite(tmp);
  if debug then WriteLn('þ Writing commands to tmp');
  WriteLn(tmp,'@echo off');
  WriteLn(tmp,'ECHO Building package of %1 ...');
  WriteLn(tmp,'DEL popd.exe >NUL');
  WriteLn(tmp,'DEL pushd.exe >NUL');
  WriteLn(tmp,'DEL swapd.exe >NUL');
  WriteLn(tmp,'COPY %1 popd.exe >NUL');
  WriteLn(tmp,'COPY %1 pushd.exe >NUL');
  WriteLn(tmp,'COPY %1 swapd.exe >NUL');
  WriteLn(tmp,'DEL %1 >NUL');
  if debug then WriteLn('þ Closing tmp');
  Close(tmp);
  if debug then WriteLn('þ IOResult check');
  if IOResult<>0 then begin
    WriteLn('There was an error! Could not create package. Make sure, that there is no');
    WriteLn('file named $$_cp_$$.bat in this directory and try again.');
    Halt;
  end;
  {$I+}
  if debug then WriteLn('þ Swapping Vectors out');
  SwapVectors;
  if debug then WriteLn('þ Execing anti-packager');
  Exec(GetEnv('COMSPEC'),'/C $$_cp_$$.bat '+ParamStr(0));
  if debug then WriteLn('þ Swapping Vectors in');
  SwapVectors;
  if debug then WriteLn('þ Checking DOSError');
  if DOSError<>0 then begin
    WriteLn('There was an error during the building of the package. Make sure your environ-');
    WriteLn('ment variable COMSPEC points to your command-interpreter.');
    Halt;
  end;
  if debug then WriteLn('þ Erasing tmp');
  Erase(tmp);
  WriteLn;
  WriteLn('Now you''re ready to use PushPopDir. Read the PPDIR.TXT for further instructions.');
  Halt;
end;

begin
  debug := false;
  GetDir(0,where);
  what := ParamStr(0);
  if ((ParamStr(1)<>'') AND (ParamStr(1)='debug')) then debug:=true;
  if (((NOT debug) AND (ParamCount>0)) OR ((debug) AND (ParamCount>1))) then ShowDir;
  if Contains(what,'popd') then PopDir;
  if Contains(what,'pushd') then PushDir;
  if Contains(what,'swapd') then SwapDir;
  CreatePackage;
end.