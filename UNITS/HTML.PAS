unit HTML;

interface
  function GetIt(t,t1,t2: string; s: integer): string;
  procedure ConvEntities(var t: string);
  procedure Change(var t:string;told,tnew: string);
implementation


function GetIt(t,t1,t2: string; s: integer): string; { Liefert den Wert zwischen t1 und t2 in t ab Position s }
var i: integer;
    TargetReached: boolean;
    Cache: string;
begin
  Cache := '';
  TargetReached := false;
  for i:=s to Length(t) do begin
    if Copy(t,i,Length(t2))=t2 then TargetReached:=false;
    if TargetReached then Cache:=Cache+Copy(t,i,1);
    if Copy(t,i,Length(t1))=t1 then TargetReached:=true;
  end;
  GetIt := Cache;
end;

procedure Change(var t:string;told,tnew: string); { �ndert jegliche Vorkommen von told in t in tnew um }
var i,sk: integer;
    nto: string;
    Cache: string;
begin
  nto:='&'+told+';';
  Cache := '';
  sk := 0;
  for i:=1 to Length(t) do begin
    if Copy(t,i,Length(nto))=nto then begin
      Cache:=Cache+tnew;
      sk:=Length(nto);
    end else if sk=0 then Cache:=Cache+Copy(t,i,1);
    if sk>0 then Dec(sk);
  end;
  t := Cache;
end;

procedure ConvEntities(var t: string); { Konvertiert die Entities, sofern welche vorkommen }
var i,j: integer;
    e: string;
    a,b: integer;
    stat: boolean;
    Cache: string;
begin
  Cache := t;
  for i:=0 to Length(t) do begin
    if Copy(t,i,1)='&' then begin
      for j:=i to Length(t) do begin
        if Copy(t,j,1)=';' then begin
          e:=Copy(t,i+1,j-i-1);

          if e='aacute' then Change(Cache,e,'�');
          if e='Aacute' then Change(Cache,e,'�');
          if e='acirc' then Change(Cache,e,'�');
          if e='Acirc' then Change(Cache,e,'�');
          if e='agrave' then Change(Cache,e,'�');
          if e='Agrave' then Change(Cache,e,'�');
          if e='aring' then Change(Cache,e,'�');
          if e='Aring' then Change(Cache,e,'�');
          if e='atilde' then Change(Cache,e,'�');
          if e='Atilde' then Change(Cache,e,'�');
          if e='auml' then Change(Cache,e,'�');
          if e='Auml' then Change(Cache,e,'�');

          if e='aelig' then Change(Cache,e,'�');
          if e='AElig' then Change(Cache,e,'�');

          if e='ccedil' then Change(Cache,e,'�');
          if e='Ccedil' then Change(Cache,e,'�');

          if e='eacute' then Change(Cache,e,'�');
          if e='Eacute' then Change(Cache,e,'�');
          if e='ecirc' then Change(Cache,e,'�');
          if e='Ecirc' then Change(Cache,e,'�');
          if e='egrave' then Change(Cache,e,'�');
          if e='Egrave' then Change(Cache,e,'�');
          if e='euml' then Change(Cache,e,'�');
          if e='Euml' then Change(Cache,e,'�');

          if e='eth' then Change(Cache,e,'�');
          if e='ETH' then Change(Cache,e,'�');

          if e='iacute' then Change(Cache,e,'�');
          if e='Iacute' then Change(Cache,e,'�');
          if e='icirc' then Change(Cache,e,'�');
          if e='Icirc' then Change(Cache,e,'�');
          if e='igrave' then Change(Cache,e,'�');
          if e='Igrave' then Change(Cache,e,'�');
          if e='iuml' then Change(Cache,e,'�');
          if e='Iuml' then Change(Cache,e,'�');

          if e='ntilde' then Change(Cache,e,'�');
          if e='Ntilde' then Change(Cache,e,'�');

          if e='oacute' then Change(Cache,e,'�');
          if e='Oacute' then Change(Cache,e,'�');
          if e='ocirc' then Change(Cache,e,'�');
          if e='Ocirc' then Change(Cache,e,'�');
          if e='ograve' then Change(Cache,e,'�');
          if e='Ograve' then Change(Cache,e,'�');
          if e='oslash' then Change(Cache,e,'�');
          if e='Oslash' then Change(Cache,e,'�');
          if e='otilde' then Change(Cache,e,'�');
          if e='Otilde' then Change(Cache,e,'�');
          if e='ouml' then Change(Cache,e,'�');
          if e='Ouml' then Change(Cache,e,'�');

          if e='thorn' then Change(Cache,e,'�');
          if e='THORN' then Change(Cache,e,'�');

          if e='uacute' then Change(Cache,e,'�');
          if e='Uacute' then Change(Cache,e,'�');
          if e='ucirc' then Change(Cache,e,'�');
          if e='Ucirc' then Change(Cache,e,'�');
          if e='ugrave' then Change(Cache,e,'�');
          if e='Ugrave' then Change(Cache,e,'�');
          if e='uuml' then Change(Cache,e,'�');
          if e='Uuml' then Change(Cache,e,'�');

          if e='yacute' then Change(Cache,e,'�');
          if e='Yacute' then Change(Cache,e,'�');

          if e='copy' then Change(Cache,e,'(C)');
          if e='nbsp' then Change(Cache,e,' ');
          if e='amp' then Change(Cache,e,'&');
          if e='szlig' then Change(Cache,e,'�');
          if e='acute' then Change(Cache,e,'�');
          if e='cedil' then Change(Cache,e,'�');
          if e='grave' then Change(Cache,e,'`');
          if e='uml' then Change(Cache,e,'�');
          if e='ordf' then Change(Cache,e,'�');
          if e='ordm' then Change(Cache,e,'�');
          if e='shy' then Change(Cache,e,'�');
          if e='macr' then Change(Cache,e,'�');
          if e='not' then Change(Cache,e,'�');
          if e='times' then Change(Cache,e,'�');
          if e='divide' then Change(Cache,e,'�');
          if e='cent' then Change(Cache,e,'�');
          if e='pound' then Change(Cache,e,'�');
          if e='yen' then Change(Cache,e,'�');
          if e='brvbar' then Change(Cache,e,'|');
          if e='reg' then Change(Cache,e,'(R)');
          if e='deg' then Change(Cache,e,'�');
          if e='plusmn' then Change(Cache,e,'�');
          if e='micro' then Change(Cache,e,'�');
          if e='para' then Change(Cache,e,'�');
          if e='sect' then Change(Cache,e,'�');
          if e='middot' then Change(Cache,e,'�');
          if e='frac14' then Change(Cache,e,'�');
          if e='frac12' then Change(Cache,e,'�');
          if e='frac34' then Change(Cache,e,'�');
          if e='sup1' then Change(Cache,e,'�');
          if e='sup2' then Change(Cache,e,'�');
          if e='sup3' then Change(Cache,e,'�');
          if e='iquest' then Change(Cache,e,'�');
          if e='iexcl' then Change(Cache,e,'�');
          if e='laquo' then Change(Cache,e,'�');
          if e='raquo' then Change(Cache,e,'�');
          if e='curren' then Change(Cache,e,'�');

          stat:=true;
        end;
        if stat then begin
          stat:=false;
          break;
        end;
      end;
    end;
  end;
  t:=Cache;
end;

begin
  WriteLn('� Loading Unit: HTML - geschrieben von RoboCop of nOOb');
end.