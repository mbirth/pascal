{$N+}
program Gravitation;

uses Crt,Dos;

var act,old,tim,last: extended;
    percges: extended;
    steps: extended;
    actstep,oldact: longint;
    proz,oldproz: real;
    lowt: extended;
    lowh: extended;
    perc: real;
    h,m,s,hu: word;
    d,mm,y,dof: word;
    ofile: text;


const Hoehe=1E+06;
      Gravk=6.67259E-11;
      Erdm=7.35E+22;    { Erde: 5.976E+24, Mond: 7.35E+22 }
      Erdrad=1738000;   { Erde: 6371025  , Mond: 1738000 }
      Schritt=20;
      IS:extended=1E-4;
      Start=0;
      Ende=1200;
      Arg=9;
      Va=11;
      AnU:integer=10000;
      OUT:boolean=TRUE;

function GetHeight(tim,old: extended):extended;
begin
  GetHeight:=Hoehe-((Gravk*Erdm)/(2*Sqr(Erdrad+old)))*Sqr(tim);
end;

procedure ArgOut(desc:string;val:extended;un:string;x:integer);
begin
  TextColor(Arg);
  Write(desc+': ');
  TextColor(Va);
  Write(val:0:x);
  TextColor(Arg);
  WriteLn(' '+un+'     ');
end;

function LTo14(num: extended): string;
var temp: string;
    i: integer;
begin
  Str(num:8:5,temp);
  for i:=1 to 14-Length(temp) do temp:=' '+temp;
  LTo14 := temp;
end;

procedure ShowMeThat;
var temp,temp2: string;
    i: integer;
begin
  GotoXY(1,6);
  ArgOut('Zeit',tim,'s',5);
  ArgOut('H”he',act,'m',5);
  if OUT then WriteLn(ofile,LTo14(tim),'s --- ',LTo14(act),'m');
end;

procedure IncStep;
begin
  actstep:=actstep+1;
  if (actstep>0) then proz:=(actstep/steps)*100 else proz:=0;
  if proz>=oldproz+0.1 then begin
    oldproz:=proz;
    GotoXY(40,3);
    ArgOut('Rechnung',actstep,'',0);
    GotoXY(40,4);
    ArgOut('Prozent',proz,'',1);
  end;
end;

procedure CheckOut;
begin
  if tim>=last+Schritt then begin
    last:=tim;
    ShowMeThat;
  end;
end;

procedure StartCalc;
label 1;
begin
1:act:=GetHeight(tim,old);
  old:=act;
  IncStep;
  if ((act<lowh) AND (act>0)) then begin
    lowh:=act;
    lowt:=tim;
  end;
  CheckOut;
  if tim<Ende+1 then begin
    tim:=tim+IS;
    goto 1
  end;
end;

procedure Init;
begin
  ClrScr;
  actstep:=0;
  steps:=(Ende-Start)/IS;
  GotoXY(1,1);
  TextColor(Yellow);
  WriteLn('-=ðþ RoboCop''s Gravitation þð=-');
  old:=Hoehe;
  lowh:=Hoehe;
  TextColor(White);
  GotoXY(1,3);
  ArgOut('Initialh”he',Hoehe,'m',0);
  ArgOut('Anzahl Rechnungen',steps,'',0);
  TextColor(Arg);
  Write('Genauigkeit: ');
  TextColor(Va);
  Write(IS:1);
  last:=Start;
  tim:=Start;
  if OUT then begin
    Assign(ofile,'GRAV.OUT');
    {$I-}
    Append(ofile);
    {$I+}
    if IOResult<>0 then Rewrite(ofile);
    WriteLn(ofile,'-=ðþ RoboCop''s Gravitation þð=-');
    WriteLn(ofile,'');
    GetDate(y,mm,d,dof);
    GetTime(h,m,s,hu);
    WriteLn(ofile,'Log vom: ',d,'.',mm,'.',y,' / ',h,':',m,'.',s,',',hu);
    WriteLn(ofile,'');
    WriteLn(ofile,'Initialh”he          : ',Hoehe:0:5,' m');
    WriteLn(ofile,'Gravitationskonstante: ',Gravk:1,' m^3*kg^-1*s^-2');
    WriteLn(ofile,'Masse K”rper 1       : 1 kg');
    WriteLn(ofile,'Masse K”rper 2       : ',Erdm:1,' kg');
    WriteLn(ofile,'Radius K”rper 2      : ',Erdrad,' m');
    WriteLn(ofile,'Schrittweite         : ',Schritt,' s');
    WriteLn(ofile,'Genauigkeit          : ',IS:0:5,' s');
    WriteLn(ofile,'Anfang               : ',Start,' s');
    WriteLn(ofile,'Ende                 : ',Ende,' s');
    WriteLn(ofile,'');
    WriteLn(ofile,'     Zeit       ---      H”he');
    WriteLn(ofile,'########.#####  --- ########.#####');
  end;
end;

procedure Outit;
begin
  GotoXY(1,9);
  ArgOut('Endzeit',tim,'s',5);
  ArgOut('Endh”he',act,'m',5);
  if OUT then begin
    WriteLn(ofile,'Endzeit: ',tim:0:5,' s');
    WriteLn(ofile,'Endh”he: ',act:0:5,' m');
    WriteLn(ofile,'');
    WriteLn(ofile,'Mindestwert bei ',lowt:0:5,' s mit ',lowh:0:5,' m.');
    GetDate(y,mm,d,dof);
    GetTime(h,m,s,hu);
    WriteLn(ofile,'');
    WriteLn(ofile,'### Beendet: ',d,'.',mm,'.',y,' / ',h,':',m,'.',s,',',hu);
    WriteLn(ofile,'');
    WriteLn(ofile,'');
    Close(ofile);
  end;
end;

begin
  Init;
  StartCalc;
  Outit;
end.