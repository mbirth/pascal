unit Misc;

interface
  const prtLPT1 = $00;
        prtLPT2 = $01;
        prtLPT3 = $02;

        prtNotBusy    = $80;
        prtAck        = $40;
        prtOutOfPaper = $20;
        prtSelected   = $10;
        prtIOError    = $08;
        prtTimeout    = $01;

  procedure Boot(cold: boolean);
  function PrtStat(prtPort: byte): byte;

implementation

uses Dos;

procedure Boot(cold: boolean);
var p: procedure;
    BootFlag: Word ABSOLUTE $0040:$0072;
begin
  if cold then BootFlag:=0 else BootFlag:=$1234;
  @p:=Ptr($f000,$fff0);
  inline($fa);
  p;
end;

function prtStat(prtPort: byte): byte;
var regs: registers;
begin
  regs.ax := $0200;
  regs.dx := prtPort;
  intr($17, regs);
  prtStat := regs.ah;
end;

begin
  Write('þ Loading Unit: Miscellaneous - RoboCop of nOOb <Robo.Cop@gmx.net> ... ');
  WriteLn('OK');
end.