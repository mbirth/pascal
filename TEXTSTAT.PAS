program TextStat;

uses Crt;

var t: char;
    i: integer;
    s: array[1..26] of integer;
    sum: longint;
    f: file of char;
		p: single;
		op: single;

begin
	ClrScr;
	for i:=1 to 26 do s[i]:=0;
	assign(f,ParamStr(1));
	{$I-}
	Reset(f);
	if IOResult<>0 then Halt;
	{$I+}
	sum := 0;
	op := 0;
	while NOT Eof(f) do begin
		Read(f,t);
		if (Ord(Upcase(t))>64) AND (Ord(Upcase(t))<91) then Inc(s[Ord(Upcase(t))-64]);
		Inc(sum);
		p := (sum/FileSize(f))*100;
		if (p>op+1) OR (p=100) then begin
      GotoXY(1,1);
      for i:=1 to 26 do WriteLn(Chr(i+64),': ',s[i]:4,' (',(s[i]/sum)*100:9:5,'%)');
      WriteLn('Chars analyzed: ',sum:5);
			WriteLn('Percentage completed: ',p:9:3);
      op := p;
    end;
  end;
	Close(f);
	ReadKey;
end.
