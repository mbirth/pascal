program INIFile_Test;

uses Crt, INIFile;

const Heading=15;
      Struct =9;
      Files  =11+blink;
      Descr  =10;
      Values =14;
      Quest  =10;

begin
  ClrScr;
  INIFileDebug := False;
  OpenINI('C:\WINNT\SYSTEM.INI');
  TextColor(Struct); Write('˛ ');
  TextColor(Heading);
  WriteLn('Einige Informationen Åber Ihre FENSTER ....');
  TextColor(Struct); WriteLn('≥'); Write('√ƒ˛ ');
  TextColor(Files);
  WriteLn('SYSTEM.INI');

{ Computer-Typ }
  TextColor(Struct); Write('≥ √ƒƒ ');
  TextColor(Descr); Write('Computer-Typ: ');
  TextColor(Values); WriteLn(INIGet('boot.description','system.drv'));

{ Maus }
  TextColor(Struct); Write('≥ √ƒƒ ');
  TextColor(Descr); Write('Maus        : ');
  TextColor(Values); WriteLn(INIGet('boot.description','mouse.drv'));

{ Grafikkarte }
  TextColor(Struct); Write('≥ √ƒƒ ');
  TextColor(Descr); Write('Grafikkarte : ');
  TextColor(Values); WriteLn(INIGet('boot.description','display.drv'));

{ Tastatur }
  TextColor(Struct); Write('≥ ¿ƒƒ ');
  TextColor(Descr); Write('Tastatur    : ');
  TextColor(Values); WriteLn(INIGet('boot.description','keyboard.typ'));

  CloseINI;
  OpenINI('C:\WINNT\WIN.INI');
  TextColor(Struct); Write('√ƒ˛ ');
  TextColor(Files);
  WriteLn('WIN.INI');

{ Land }
  TextColor(Struct); Write('≥ √ƒƒ ');
  TextColor(Descr); Write('Land        : ');
  TextColor(Values); WriteLn(INIGet('intl','sCountry'));

{ WÑhrung }
  TextColor(Struct); Write('≥ √ƒƒ ');
  TextColor(Descr); Write('WÑhrung     : ');
  TextColor(Values); WriteLn(INIGet('intl','sCurrency'));

{ Standard-Drucker }
  TextColor(Struct); Write('≥ √ƒƒ ');
  TextColor(Descr); Write('Std.-Drucker: ');
  TextColor(Values); WriteLn(INIGet('windows','device'));

{ Hintergrund-Bild }
  TextColor(Struct); Write('≥ ¿ƒƒ ');
  TextColor(Descr); Write('HG-Bild     : ');
  TextColor(Values); WriteLn(INIGet('Desktop','Wallpaper'));

  CloseINI;
  OpenINI('C:\WINDOWS\SYSTEM\OEMINFO.INI');
  TextColor(Struct); Write('¿ƒ˛ ');
  TextColor(Files);
  WriteLn('OEMINFO.INI');

{ Computer-Modell }
  TextColor(Struct); Write('  √ƒƒ ');
  TextColor(Descr); Write('Computer-Typ: ');
  TextColor(Values); WriteLn(INIGet('general','Model'));

{ Hersteller }
  TextColor(Struct); Write('  √ƒƒ ');
  TextColor(Descr); Write('Hersteller  : ');
  TextColor(Values); WriteLn(INIGet('general','Manufacturer'));

{ Support Informationen }
  TextColor(Struct); Write('  ¿ƒ˛ ');
  TextColor(Files); WriteLn('Support Informationen');

  TextColor(Struct); Write('    √ƒƒ ');
  TextColor(Descr); Write('Zeile1: ');
  TextColor(Values); WriteLn(Copy(INIGet('Support Information','Line1'),1,63));

  TextColor(Struct); Write('    √ƒƒ ');
  TextColor(Descr); Write('Zeile2: ');
  TextColor(Values); WriteLn(Copy(INIGet('Support Information','Line2'),1,63));

  TextColor(Struct); Write('    √ƒƒ ');
  TextColor(Descr); Write('Zeile3: ');
  TextColor(Values); WriteLn(Copy(INIGet('Support Information','Line3'),1,63));

  TextColor(Struct); Write('    √ƒƒ ');
  TextColor(Descr); Write('Zeile4: ');
  TextColor(Values); WriteLn(Copy(INIGet('Support Information','Line4'),1,63));

  TextColor(Struct); Write('    √ƒƒ ');
  TextColor(Descr); Write('Zeile5: ');
  TextColor(Values); WriteLn(Copy(INIGet('Support Information','Line5'),1,63));

  TextColor(Struct); Write('    ¿ƒƒ ');
  TextColor(Descr); Write('Zeile6: ');
  TextColor(Values); WriteLn(Copy(INIGet('Support Information','Line6'),1,63));

  CloseINI;
  WriteLn;
  TextColor(Quest);
  Write('Bitte Taste drÅcken .... ');
  ReadKey;
  WriteLn('danke!');
  TextColor(7);
end.