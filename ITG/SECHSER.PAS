program Sechsen;


var take: longint;
    sixs: longint;
    thrw: longint;
    succ: boolean;

function Throw: byte;
begin
  Throw := Random(6)+1;
end;

procedure TripleThrowUntilSix;
var i,t: byte;
begin
  Write(take:5,'#',sixs:5,'#',thrw:8,' : ');
  succ := false;
  for i:=1 to 3 do begin
    t:=Throw;
    Write(t,' ');
    Inc(thrw);
    if t=6 then begin
      WriteLn;
      Inc(sixs);
      Inc(take);
      Exit;
    end;
  end;
  Inc(take);
  WriteLn;
end;

begin
  sixs := 0;
  thrw := 0;
  take := 0;
  Randomize;
  repeat
    TripleThrowUntilSix;
  until take=1000;
  WriteLn(' TAKE sixes   throws : # # #');
  WriteLn('<===========>');
  WriteLn('Takes: ',take);
  WriteLn('Sixes: ',sixs);
  WriteLn('Fails: ',thrw-sixs);
  WriteLn('Thrws: ',thrw);
  WriteLn('Quota of throws: ',(sixs/thrw)*100:3:2,' per cent');
  WriteLn('Quota of takes : ',(sixs/take)*100:3:2,' per cent');
end.
