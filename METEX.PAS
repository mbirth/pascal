program Metex;

uses Crt;

var P: string;
    Port: text;
    TempVar: string[14];

procedure SetDeviceRaw(var T: Text); assembler;        { DOS-Intr 21h - Fkt. 3 holen 4 senden }
asm
	LES	DI,T
	MOV	BX,WORD PTR ES:[DI]
	MOV	AX,4400H
	INT	21H
	TEST	DX,0080H
	JZ	@@1
	OR	DL,20H
	MOV	DH,DH
	MOV	AX,4401H
	INT	21H
@@1:
end;

procedure SendData(var T: char); assembler;
asm
  mov ax,4
  mov dx,T
  int 21
end;

function GetData: char; assembler;
asm
  mov ax,3
  int 21
  mov GetData,ax
end;

begin
  ClrScr;
  WriteLn('Setting Var ...');
  P := 'COM2';
  WriteLn('Assigning ...');
  Assign(Port,P);
  WriteLn('ReWrite');
  Rewrite(Port);
  WriteLn('SetDeviceRaw(Port)');
  SetDeviceRaw(Port);
  WriteLn('Trying to write something ...');
  Write(Port,'D');
  WriteLn('Close');
  Close(Port);
  WriteLn('Reset');
  Reset(Port);
  WriteLn('Trying to read ...');
  Read(Port,TempVar);
  WriteLn('Closing...');
  Close(Port);
  WriteLn('Output...');
  WriteLn(TempVar);
end.