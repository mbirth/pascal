program Schedule;

{ Datendatei
  ----------

  Dateiname: [wie EXE-Datei].DAT
  Format:
    dd.mm. [Termin]    // fr j„hrliche Termine
    dd.mm.yy [Termin]  // fr einmalige Termine
  }


uses Crt, Dos, VFx;

const Days: array[0..6] of string[10] =
            ('Sonntag','Montag','Dienstag',
             'Mittwoch','Donnerstag',
             'Freitag','Sonnabend');
      Months: array[1..12] of string[9] =
              ('Januar','Februar','M„rz','April',
               'Mai','Juni','Juli','August','September',
               'Oktober','November','Dezember');

var SD,SM,SY,SDOW: word;
    datf: text;
    datfn: string;
    increaser: byte;
    waitafter: boolean;
    origmode: integer;

procedure Init; forward;
procedure Outit; forward;
procedure GetDDate(dat: string;var d,m,y: byte); forward;
function GetDDesc(dat: string): string; forward;
procedure Raise(var d,m,y: word); forward;
procedure Check4App; forward;
procedure Appointment(ter: string); forward;


procedure Init;
var i,lm: integer;
begin
  CursorOff;
  origmode := 0;
  lm := LastMode;
  if (lm<>3) then begin
    origmode := lm;
    TextMode(co80);
  end;
  increaser := 0;
  waitafter := false;
  GotoXY(1,WhereY-1);
  ClrEol;
  GetDate(SY,SM,SD,SDOW);
  SY := SY - (SY DIV 100) * 100;
  CWriteLn('   %%15#ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
  CWrite('%%8#Ä%%7#Ä%%15#Ä´ %%14#Schedule/DOS%%15# ÃÄÄÄ´ ');
  TextColor(7);
  Write('Es ist heute ',Days[SDOW],', der ',SD,'. ',Months[SM],' ',SY,'. ');
  TextColor(15);
  Write('Ã');
  Write(MultiChar('Ä',77-WhereX));
  CWrite('%%7#ÄÄ%%8#ÄÄ');
  CWrite('   %%15#ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ%%7#     ');
  WriteLn;
  TextColor(7);
  for i:=Length(ParamStr(0)) downto 1 do begin
    if Copy(ParamStr(0),i,1)='.' then datfn := Copy(ParamStr(0),1,i-1)+'.dat';
  end;
  Assign(datf,datfn);
  {$I-}
  Reset(datf);
  if IOResult<>0 then begin
    TextColor(12+blink);
    Write('ş ');
    TextColor(12);
    WriteLn('Fehler ',IOResult,' beim ™ffnen von ',datfn,'.');
    WriteLn;
    Outit;
    Halt;
  end;
  if Eof(datf) then begin
    TextColor(12+blink);
    Write('ş ');
    TextColor(12);
    WriteLn('Datendatei ',datfn,' ist leer.');
    WriteLn;
    Outit;
    Halt;
  end;
  {$I+}
end;

procedure Outit;
var i: integer;
    h,m,s,hu,os: word;
    li,c: byte;
begin
  c := 9;
  CWrite('%%8#ÄÄ%%7#ÄÄ%%15#');
  if waitafter then begin
    Write(MultiChar('Ä',12),'´ ');
    CWrite('%%8#Bitte eine Taste drcken, oder # Sek. warten%%15#');
    Write(' Ã',MultiChar('Ä',12));
  end else Write(MultiChar('Ä',77-WhereX));
  CWrite('%%7#ÄÄ%%8#ÄÄ');
  li := WhereY-1;
  if waitafter then begin
    GetTime(h,m,os,hu);
    while c<>0 do begin
      GotoXY(50,li);
      Write(c:1);
      GetTime(h,m,s,hu);
      if s<>os then begin
        Dec(c);
        Sound(1500);
        Delay(50);
        NoSound;
      end;
      os := s;
      if keypressed then begin
        ReadKey;
        GotoXY(1,li);
        CWrite('%%8#ÄÄ%%7#ÄÄ%%15#');
        Write(MultiChar('Ä',72));
        CWrite('%%7#ÄÄ%%8#ÄÄ');
        CursorOn;
        NormVideo;
        if origmode<>0 then TextMode(origmode);
        Halt;
      end;
    end;
  end;
  GotoXY(1,li);
  CWrite('%%8#ÄÄ%%7#ÄÄ%%15#');
  Write(MultiChar('Ä',72));
  CWrite('%%7#ÄÄ%%8#ÄÄ');
  CursorOn;
  ReadyBeep;
  NormVideo;
  if origmode<>0 then TextMode(origmode);
  Halt;
end;

procedure GetDDate(dat: string;var d,m,y: byte);
var i,co: integer;
    date: string;
    oldp: integer;
begin
  d := 0;
  m := 0;
  y := 0;
  oldp := 1;
  for i:=1 to Length(dat) do begin
    if dat[i]=' ' then begin
      date := Copy(dat,1,i-1);
      Break;
    end;
  end;
  Val(Copy(date,1,2),d,co);
  Val(Copy(date,4,2),m,co);
  if Length(date)>6 then Val(Copy(date,7,2),y,co) else y:=0;
end;

function GetDDesc(dat: string): string;
var i: integer;
begin
  for i:=1 to Length(dat) do begin
    if dat[i]=' ' then begin
      GetDDesc := Copy(dat,i+1,Length(dat)-i);
      Break;
    end;
  end;
end;

procedure Raise(var d,m,y: word);
begin
  Inc(d);
  Inc(increaser);
  case m of
    1,3,5,7,8,10,12: if d>31 then begin
                       Inc(m);
                       d := 1;
                     end;
    4,6,9,11: if d>30 then begin
                Inc(m);
                d := 1;
              end;
    2: if ((y/4=y div 4) AND (d>29)) then begin
         Inc(m);
         d := 1;
       end else if ((y/4<>y div 4) AND (d>28)) then begin
         Inc(m);
         d := 1;
       end;
  end;
  if m>12 then begin
    Inc(y);
    m := 1;
  end;
end;

procedure Check4App;
var tmp: string;
    d,m,y: byte;
    i: integer;
begin
  for i:=1 to 5 do begin
    Reset(datf);
    while NOT Eof(datf) do begin
      ReadLn(datf, tmp);
      case tmp[1] of
        '0'..'9': begin
          GetDDate(tmp,d,m,y);
          { Write('Date: ',TD,'.',TM,'.',TY,' --- ');
          WriteLn('Seek for: ',d,'.',m,'.',y); }
          if ((d=SD) AND (m=SM) AND ((y=SY) OR (y=0))) then Appointment(tmp);
        end;
      end;
    end;
    Raise(SD,SM,SY);
  end;
end;

procedure Appointment(ter: string);
var d,m,y: byte;
begin
  GetDDate(ter,d,m,y);
  case increaser of
    0: TextColor(12+blink);
    1: TextColor(12);
    2,3: TextColor(14);
    4,5: TextColor(10);
  end;
  Write('ş ');
  case increaser of
    0: begin Write('-HEUTE-  '); waitafter := true; end;
    1: begin Write('-MORGEN- '); waitafter := true; end;
  else begin
      Write(d:2,'.',m:2,'.');
      if y<>0 then Write(y:2,' ') else Write('   ');
    end;
  end;
  Write('ş');
  if ((increaser=0) OR (increaser=0)) then TextColor(15) else TextColor(7);

  WriteLn('  ',GetDDesc(ter));
end;

begin
  Init;
  Check4App;
  Outit;
end.