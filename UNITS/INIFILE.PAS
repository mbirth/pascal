unit INIFile;           { geschrieben von Markus Birth }

interface
  var INIFName: text;
      INIFN: string;
      INIFileDebug: Boolean;
  procedure OpenINI(f2o: string);
  procedure CloseINI;
  function INIGet(head: string;key: string):string;
  procedure INIPut(head: string;key: string;value: string);
  function ExtractHead(line: string):string;
  function ExtractKey(line: string):string;
  function ExtractValue(line: string):string;
implementation

uses Crt;

procedure OpenINI(f2o: string);
  begin
    if INIFileDebug then WriteLn('þ OpenINI: Opening '+f2o+'...');
    Assign(INIFName, f2o);
    if INIFileDebug then WriteLn('þ OpenINI: Resetting file...');
    {$I-}
    Reset(INIFName);
    {$I+}
    if INIFileDebug then WriteLn('þ OpenINI: Checking for error code...');
    if IOResult<>0 then begin
      if INIFileDebug then WriteLn('  ð OpenINI: File does not exist, creating new...');
      Rewrite(INIFName);
    end
    else if INIFileDebug then WriteLn('  ð OpenINI: OK, file existing...');
    INIFN := f2o;
  end;

procedure CloseINI;
  begin
    if INIFN='' then begin
      TextColor(LightRed+blink);
      WriteLn('ERROR!! No INI open. Please open one first.');
      Sound(220);
      Delay(200);
      NoSound;
    end;
    if INIFileDebug then WriteLn('þ CloseINI: Closing file...');
    Close(INIFName);
    INIFN := '';
  end;

function INIGet(head: string;key: string):string;
  var CurLin: string;
      tmp: string;
      c: integer;
  begin
    tmp := '';
    for c:=1 to Length(head) do begin
      tmp := tmp + UpCase(head[c]);
    end;
    head := tmp;
    tmp := '';
    for c:=1 to Length(key) do begin
      tmp := tmp + UpCase(key[c]);
    end;
    key := tmp;
    tmp := '';
    if INIFN='' then begin
      TextColor(LightRed+blink);
      WriteLn('ERROR!! No INI open. Please open one first.');
      Sound(220);
      Delay(200);
      NoSound;
    end;
    if INIFileDebug then WriteLn('þ INIGet: Resetting file...');
    Reset(INIFName);
    ReadLn(INIFName, CurLin);
    while not Eof(INIFName) do begin
      if ExtractHead(CurLin)=head then begin
        if INIFileDebug then WriteLn('  þ INIGet: Head found: '+head);
        ReadLn(INIFName, CurLin);
        if INIFileDebug then WriteLn('    ð INIGet: Key of next line: '+ExtractKey(CurLin));
        while ExtractHead(CurLin)='' do begin
          if ExtractKey(CurLin)=key then begin
            if INIFileDebug then begin
              WriteLn('    þ INIGet: Key found: '+key);
              WriteLn('    ð INIGet: Key value: '+ExtractValue(CurLin));
            end;
            INIGet := ExtractValue(CurLin);
            Exit;
          end;
          ReadLn(INIFName, CurLin);
        end;
        if INIFileDebug then WriteLn('    þ Key does not exist!');
        INIGet := '';
        Exit;
      end
      else begin
        ReadLn(INIFName, CurLin);
      end;
    end;
  end;

procedure INIPut(head: string;key: string;value: string);
  var CurLin: string;
      TempFile: text;
      Created: boolean;

  begin
    if INIFN='' then begin
      TextColor(LightRed+blink);
      WriteLn('ERROR!! No INI open. Please open one first.');
      Sound(220);
      Delay(200);
      NoSound;
    end;
    if INIFileDebug then WriteLn('þ INIPut: Resetting file...');
    Reset(INIFName);
    if INIFileDebug then WriteLn('þ INIPut: Opening temporary file...');
    Assign(TempFile, 'INIFILE$.$$$');
    if INIFileDebug then WriteLn('  þ INIPut: Rewriting tempfile...');
    Rewrite(TempFile);
    ReadLn(INIFName, CurLin);
    while not Eof(INIFName) do begin
      if ExtractHead(CurLin)=head then begin
        if INIFileDebug then WriteLn('  þ INIPut: Head found: '+head);
        if not Eof(INIFName) then begin
          WriteLn(TempFile, CurLin);
          ReadLn(INIFName, CurLin);
        end;
        while (not Eof(INIFName)) do begin
          if ExtractHead(CurLin)='' then begin
            if (ExtractKey(CurLin)<>key) AND (CurLin<>'') then begin
              WriteLn(TempFile, CurLin);
              ReadLn(INIFName, CurLin);
            end
            else begin
              if CurLin='' then begin
                if INIFileDebug then WriteLn('þ INIPut: No previous entry found, creating new...');
                WriteLn(TempFile, key+'='+value);
                WriteLn(TempFile, '');
                Created := True;
              end
              else begin
                if INIFileDebug then WriteLn('þ INIPut: Key found, changing...');
                WriteLn(TempFile, key+'='+value);
                Created := True;
              end;
            end;
          end;
        end;



      end;
    end;
  end;

function ExtractHead(line: string):string;
  var i: integer;
      Temp: string;
  begin
    Temp := '';
    if Copy(line,1,1)='[' then begin
      for i:=2 to Length(line) do begin
        if Copy(line,i,1)<>']' then Temp := Temp + UpCase(line[i])
        else Break;
      end;
    end;
    if Temp<>'' then ExtractHead := Temp else ExtractHead := '';
    if (Temp<>'') AND (INIFileDebug) then WriteLn('þ ExtractHead: TEMP-HEAD: "'+Temp+'"');
  end;

function ExtractKey(line: string):string;
  var i: integer;
      Temp: string;
  begin
    Temp := '';
    for i:=1 to Length(line) do begin
      if Copy(line,i,1)='=' then Break;
      Temp := Temp + UpCase(line[i]);
    end;
    if Temp<>'' then ExtractKey := Temp else ExtractKey := '';
    if (Temp<>'') AND (INIFileDebug) then WriteLn('þ ExtractKey: TEMP-KEY: "'+Temp+'"');
  end;

function ExtractValue(line: string):string;
  var i,j: integer;
      Temp: string;
  begin
    for i:=1 to Length(line) do begin
      if Copy(line,i,1)='=' then begin
        j:=i+1;
        Break;
      end;
    end;
    Temp := '';
    for i:=j to Length(line) do Temp := Temp + line[i];
    if Temp<>'' then ExtractValue := Temp else ExtractValue := '';
    if (Temp<>'') AND (INIFileDebug) then WriteLn('þ ExtractValue: TEMP-VALUE: "'+Temp+'"');
  end;

begin
  WriteLn('þ Loading Unit: INIFile - geschrieben von RoboCop of nOOb');
end.