unit CursorOnOff;

interface
  procedure CursorOff;
  procedure CursorOn;
implementation

procedure CursorOff;assembler; { Schaltet den Cursor ab - schnell und zuverl„ssig }
asm
   xor  ax,ax
   mov  ah,01h
   mov  ch,20h
   mov  cl,20h
   int  10h
end;

procedure CursorOn;assembler; { Schaltet den Blinker wieder an }
asm
   mov  ah,01h
   mov  cx,0607h
   int  10h
end;

begin
  WriteLn('þ Loading Unit: CursorOnOff - geschrieben von RoboCop of nOOb');
end.