unit Logo;

interface
         procedure WriteLogo;
implementation
uses crt;


  procedure WriteLogo;
    begin;
    TextColor(1);
    WriteLn('        ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
    Write('      /°°±±²²²ÛÛÛ');
    TextColor(9);
    Write('±±±²²±±±');
    TextColor(1);
    WriteLn('\');
    Write('     ³°°±±²²ÛÛÛ');
    TextColor(9);
    Write('±±±²²ÛÛ²²±±');
    TextColor(1);
    Write('³');
    TextColor(15);
    WriteLn('   ÜÜÜÜ   ÜÜÜ  ÜÜÜÜ   ÜÜÜ       ÜÜÜÜ  ÜÜÜ  ÜÜÜÜ');
    TextColor(1);
    Write('     ³°°°±±²²²ÛÛÛ');
    TextColor(9);
    Write('±±±²²±±±');
    TextColor(1);
    Write('Û³');
    TextColor(15);
    WriteLn('   Û   Û Û   Û  Û  Û Û   Û     Û     Û   Û Û   Û');
    TextColor(1);
    Write('     ÀÂÄÄÄÄÄÄÄÄÄÄ¿Û');
    TextColor(9);
    Write('±±±±');
    TextColor(1);
    Write('ÛÛÛ³');
    TextColor(15);
    WriteLn('   ÛßÛß  Û   Û  ÛßßÜ Û   Û     Û     Û   Û Ûßßß');
    TextColor(1);
    Write('      ³');
    TextColor(4);
    Write('²²²²²²²²²²');
    TextColor(1);
    Write('³ÛÛ');
    TextColor(9);
    Write('±±');
    TextColor(1);
    Write('ÛÛÛÛ³');
    TextColor(15);
    WriteLn('   Û  Û  Û   Û  Û  Û Û   Û     Û     Û   Û Û');
    TextColor(1);
    Write('     ÚÁÄÄÄÄÄÄÄÄÄÄÙÛÛÛÛÛÛ²²³');
    TextColor(15);
    WriteLn('   ß   ß  ßßß  ßßßß   ßßß       ßßßß  ßßß  ß');
    TextColor(1);
    Write('     ³°°°°°°°°°°°±±²²²²±±±³  ');
    TextColor(0);
    TextBackground(7);
    Write(' I    N    D    U    S    T    R    I    E   S ');
    TextBackground(0);
    TextColor(1);
    WriteLn;
    WriteLn('     ³°°°°°°°°°°°°°±±±±°°°³ ');
    Write('     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
    TextColor(0);
    WriteLn('              (C)1995-1996 by RoboCop INDUSTRIES');
    WriteLn('If you cannot decrypt ^THAT^ Symbol, install the ANSI.SYS Driver!');
  end;

begin
  WriteLn('ş Loading Unit: Logo - geschrieben von RoboCop IND.');
end.