program Datenbank;
uses Crt,Dos;

const Defaultfile:string ='DataBank.DAT';
      Cfgfile='DataBank.INI';
      CName=0;
      CVorname=1;
      CStrasse=2;
      CNummer=3;
      COrt=4;
      CPLZ=5;
      CTel=6;
      CFax=7;

type Daten=record
       Namen: string[30];
       Vorname: string[15];
       Strasse: string[30];
       Nummer: string[6];
       Ort: string[20];
       PLZ: string[10];
       Tel: string[30];
       Fax: string[30];
     end;

type ActiveCheck=record
       Add: boolean;
       Edit: boolean;
       Del: boolean;
       View: boolean;
       Load: boolean;
       Save: boolean;
       Change: boolean;
       Init: boolean;
     end;

var Adresse: array[0..99] of Daten;
    Act: ActiveCheck;
    CenterPos, RetValue: integer;

procedure StartInit;
  begin
    Act.Load:=true;
    Act.Change:=true;
    Act.Init:=true;
  end;

procedure ReadyBeep;
  begin
    Sound(800);
    Delay(50);
    NoSound;
    Delay(50);
    Sound(1000);
    Delay(50);
    NoSound;
    Delay(50);
    Sound(1200);
    Delay(50);
    NoSound;
  end;

procedure ErrorBeep;
  begin
    Sound(100);
    Delay(200);
    NoSound;
  end;

procedure AckBeep;
  begin
    Sound(1200);
    Delay(25);
    NoSound;
  end;

procedure DrawBorder(MaxX,MaxY: integer; TCol, BCol: integer; BType: integer);
  var i,j: integer;
      lx,rx,oy,uy,mx,my: integer;
      DrwDelay, FilDelay: integer;
      Border: string[8];
  begin
    window(1,1,80,25);
    if (MaxX=0) AND (MaxY=0) AND (TCol=0) AND (BCol=0) then Exit;
    if BType=1 then Border := 'Ú¿ÀÙ³³ÄÄ';
    if BType=2 then Border := 'É»È¼ººÍÍ';
    if BType=3 then Border := 'Õ¸Ô¾³³ÍÍ';
    if BType=4 then Border := 'Ö·Ó½ººÄÄ';
    if BType=5 then Border := 'ÛÛÛÛÛÛßÜ';
    if BType=6 then Border := 'Ú·Ô¼³ºÄÍ';
    lx := 41-MaxX; oy := 13-MaxY; rx := 40+MaxX;  uy := 12+MaxY;
    mx := 40;      my := 12;      DrwDelay := 1000 div (2*MaxX); FilDelay := 1;
    TextColor(TCol); TextBackground(BCol);
    for i:=mx downto lx+1 do begin
      GotoXY(i,oy); Write(Border[7]);
      GotoXY((rx+1)-i+lx-1,oy); Write(Border[7]);
      Delay(DrwDelay);
    end;
    GotoXY(lx,oy); Write(Border[1]);
    GotoXY(rx,oy); Write(Border[2]);
    Delay(DrwDelay);
    for i:=oy+1 to uy-1 do begin
      GotoXY(lx,i); Write(Border[5]);
      GotoXY(rx,i); Write(Border[6]);
      Delay(DrwDelay);
    end;
    GotoXY(lx,uy); Write(Border[3]);
    GotoXY(rx,uy); Write(Border[4]);
    Delay(DrwDelay);
    for i:=lx+1 to mx do begin
      GotoXY(i,uy); Write(Border[8]);
      GotoXY((rx+1)-i+lx-1,uy); Write(Border[8]);
      Delay(DrwDelay);
    end;
    for i:=lx+1 to rx-1 do begin
      for j:=oy+1 to uy-1 do begin
        GotoXY(i,j); Write(' ');
        Delay(FilDelay);
      end;
    end;
    CenterPos := (rx-lx) div 2; window(lx+2,oy+1,rx-2,uy-1);
  end;

procedure WriteC(text: string);
  var x,y: integer;
  begin
    x := CenterPos-(Length(text) div 2);
    y := WhereY;
    GotoXY(x,y);
    Write(text);
  end;

procedure WriteCLn(text: string);
  var x,y: integer;
  begin
    x := CenterPos-(Length(text) div 2);
    y := WhereY;
    GotoXY(x,y);
    WriteLn(text);
  end;

procedure MainWindow;
  begin
    DrawBorder(40,12,15,0,4);
    GotoXY(1,1);
    TextColor(9); WriteC('-                  -'); Delay(100);
    TextColor(3);  WriteC('=                =');  Delay(100);
    TextColor(11);  WriteC('ð              ð');   Delay(100);
    TextColor(15);   WriteC('þ            þ');    Delay(100);
    TextColor(15);    WriteC('D        K');       Delay(150);
    TextColor(7);     WriteC('D        K');
    TextColor(15);     WriteC('A      N');        Delay(150);
    TextColor(8);     WriteC('D        K');
    TextColor(7);      WriteC('A      N');
    TextColor(15);      WriteC('T    A');         Delay(150);
    TextColor(0);     WriteC('D        K');
    TextColor(8);      WriteC('A      N');
    TextColor(7);       WriteC('T    A');
    TextColor(15);       WriteC('E  B');          Delay(150);
    TextColor(0);      WriteC('A      N');
    TextColor(8);       WriteC('T    A');
    TextColor(7);        WriteC('E  B');
    TextColor(15);        WriteC('N-');           Delay(150);
    TextColor(0);       WriteC('T    A');
    TextColor(8);        WriteC('E  B');
    TextColor(7);         WriteC('N-');           Delay(150);
    TextColor(0);        WriteC('E  B');
    TextColor(8);         WriteC('N-');           Delay(150);
    TextColor(0);         WriteC('N-');           Delay(150);
    TextColor(8);     WriteC('DATEN-BANK');       Delay(200);
    TextColor(6);     WriteC('DATEN-BANK');       Delay(200);
    TextColor(14);    WriteC('DATEN-BANK');
  end;

procedure FXWrite(text: string; finc: integer);
  var x,y,i: integer;
      finc2: integer;
      Del1: integer;
  begin
    x := WhereX;
    y := WhereY;
    Del1 := 750 div Length(text);
    if Del1>75 then Del1 := 75;
    for i:=1 to Length(text) do begin
      GotoXY(x+i-1,y); TextColor(15); Write(text[i]);
      if i>1 then begin
        GotoXY(x+i-2,y);
        TextColor(7);
        Write(text[i-1]);
      end;
      if i>2 then begin
        GotoXY(x+i-3,y);
        TextColor(8);
        Write(text[i-2]);
      end;
      Delay(Del1);
    end;
    GotoXY(x+Length(text)-1,y); TextColor(7); Write(text[Length(text)]);
    if Length(text)>1 then begin
      GotoXY(x+Length(text)-2,y);
      TextColor(8);
      Write(text[Length(text)-1]);
    end;
    Delay(Del1);
    GotoXY(x+Length(text)-1,y); TextColor(8); Write(text[Length(text)]);
    Delay(Del1*3);
    if finc<=blink then begin
      if finc<8 then finc2 := finc+8 else finc2 := finc-8;
    end else begin
      if finc<8+blink then finc2 := finc+8 else finc2 := finc-8;
    end;
    if finc=8 then finc2 := 15;
    if finc=15 then begin
      GotoXY(x,y); TextColor(8); Write(text); Delay(100);
    end;
    GotoXY(x,y); TextColor(finc2); Write(text);
    Delay(100);
    if finc=8 then begin
      GotoXY(x,y); TextColor(7); Write(text); Delay(100);
    end;
    GotoXY(x,y); TextColor(finc); Write(text);
  end;

procedure Copyright;
  begin
    DrawBorder(20,4,14,2,6); TextColor(DarkGray);
    WriteCLn('Copyright (C)1997 by Markus Birth');
    GotoXY(13,1); FXWrite('(C)1997',8);
    GotoXY(1,3);  TextColor(White);
    WriteCLn('Jeglicher Verstoá gegen dieses');
    WriteCLn('Copyright wird strafrechtlich');
    WriteCLn('verfolgt.');
    TextColor(LightRed); WriteC('Danke fr die Beachtung!');
  end;

procedure ProgDesc;
  begin
    DrawBorder(15,2,11,1,5);
    TextColor(DarkGray);
    GotoXY(4,1); Write('-=ðþ DATEN-BANK þð=-');
    GotoXY(4,1); FXWrite('-=ðþ DATEN-BANK þð=-',15); WriteLn;
    TextColor(DarkGray); WriteC('by RoboCop');
    ReadyBeep;
  end;

procedure MainMenu;
  var ActCol: integer;
      ColAct, ColInA: integer;
  begin
    ColAct:=1514;  { Nur zur einfacheren Weiterverarbeitung: xxyy }
    ColInA:=0808;  { xx-Textfarbe        ---         yy-Buchstabe }
    GotoXY(1,3);
    TextColor(8);
    WriteC('  Datendatei: '+Defaultfile+'  ');
    GotoXY(10,5);
    FXWrite('W„hlen Sie eine Aktion durch drcken der jeweiligen Taste',10);
    if Act.Add then ActCol:=ColAct else ActCol:=ColInA;
    GotoXY(11,7);  FXWrite('  - Adresse hinzufgen',Trunc(ActCol/100));
    GotoXY(11,7);  FXWrite('A',ActCol-Trunc(ActCol/100)*100);
    if Act.Edit then ActCol:=ColAct else ActCol:=ColInA;
    GotoXY(41,7);  FXWrite('  - Adresse bearbeiten',Trunc(ActCol/100));
    GotoXY(41,7);  FXWrite('E',ActCol-Trunc(ActCol/100)*100);
    if Act.Del then ActCol:=ColAct else ActCol:=ColInA;
    GotoXY(11,9);  FXWrite('  - Adresse l”schen',Trunc(ActCol/100));
    GotoXY(11,9);  FXWrite('D',ActCol-Trunc(ActCol/100)*100);
    if Act.View then ActCol:=ColAct else ActCol:=ColInA;
    GotoXY(41,9);  FXWrite('  - Adressen durchsehen',Trunc(ActCol/100));
    GotoXY(41,9);  FXWrite('V',ActCol-Trunc(ActCol/100)*100);
    GotoXY(9,11); FXWrite('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',8);
    if Act.Load then ActCol:=ColAct else ActCol:=ColInA;
    GotoXY(11,13); FXWrite('  - Datendatei laden',Trunc(ActCol/100));
    GotoXY(11,13); FXWrite('L',ActCol-Trunc(ActCol/100)*100);
    if Act.Save then ActCol:=ColAct else ActCol:=ColInA;
    GotoXY(41,13); FXWrite('  - Datendatei schreiben',Trunc(ActCol/100));
    GotoXY(41,13); FXWrite('S',ActCol-Trunc(ActCol/100)*100);
    if Act.Change then ActCol:=ColAct else ActCol:=ColInA;
    GotoXY(11,15); FXWrite('  - andere Datendatei',Trunc(ActCol/100));
    GotoXY(11,15); FXWrite('C',ActCol-Trunc(ActCol/100)*100);
    if Act.Init then ActCol:=ColAct else ActCol:=ColInA;
    GotoXY(41,15); FXWrite('  - Datendatei initiieren',Trunc(ActCol/100));
    GotoXY(41,15); FXWrite('I',ActCol-Trunc(ActCol/100)*100);
    GotoXY(5,22); FXWrite('Dieses Programm wurde entwickelt von RoboCop IND. a.k.a. Markus Birth',8);
  end;

procedure InitNewDatabase;
  begin
    RetValue := 1;
    AckBeep;
  end;

procedure ChangeDatafile;
  begin
    RetValue := 1;
    AckBeep;
  end;

procedure ReadData(Datei: string);
  begin
    RetValue := 1;
    AckBeep;
  end;

procedure WriteData(Datei: string);
  begin
    RetValue := 1;
    AckBeep;
  end;

procedure AddressNew;
  begin
    RetValue := 1;
    AckBeep;
  end;

procedure AddressDelete;
  begin
    RetValue := 1;
    AckBeep;
  end;

procedure AddressEdit;
  begin
    RetValue := 1;
    AckBeep;
  end;

procedure AddressBrowse;
  begin
    RetValue := 1;
    AckBeep;
  end;

procedure AddressSearch;
  begin
    RetValue := 1;
    AckBeep;
  end;

procedure MainSelect;
  var KeyIn: char;
  begin
    KeyIn := ReadKey;
    if (UpCase(KeyIn)='A') AND (Act.Add) then AddressNew;
    if (UpCase(KeyIn)='E') AND (Act.Edit) then AddressEdit;
    if (UpCase(KeyIn)='D') AND (Act.Del) then AddressDelete;
    if (UpCase(KeyIn)='V') AND (Act.View) then AddressBrowse;
    if (UpCase(KeyIn)='L') AND (Act.Load) then ReadData(Defaultfile);
    if (UpCase(KeyIn)='W') AND (Act.Save) then WriteData(Defaultfile);
    if (UpCase(KeyIn)='C') AND (Act.Change) then ChangeDatafile;
    if (UpCase(KeyIn)='I') AND (Act.Init) then InitNewDatabase;
    if RetValue=0 then begin
      ErrorBeep;
      MainSelect;
    end;
    RetValue := 0;
  end;

begin
  Copyright;
  Delay(2000);
  ProgDesc;
  Delay(1000);
  MainWindow;
  StartInit;
  MainMenu;
  MainSelect;
end.