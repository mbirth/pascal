{$M $F000,0,65536}

program GraphEdit;

uses Crt, Dos, Graph, GUI, BGIP;

const desktopcolor=3;
      blocksize=2048;
      zd: byte=8;
      xd=10;
      yd=25;
      bigact=0; biginact=15; bigline=8;
      smaact=0; smainact=10; smaline=15;
      savefmt: string[3]='NGG';

var xmax, ymax, xmed, ymed: word;
    graphic: array[1..72,1..14] of boolean;
    buttondown: boolean;
    somethinginmem: boolean;
    odfs,dfs: string;
    df: file;


function V2S(x: word): string;
var tmp: string;
begin
  Str(x,tmp);
  V2S := tmp;
end;

function LowCase(txt: string): string;
var tmp: string;
    i: word;
begin
  tmp := txt;
  for i:=1 to Length(txt) do begin
    if (txt[i] IN [#65..#90]) then tmp[i]:=Chr(Ord(txt[i])+32);
  end;
  LowCase := tmp;
end;

procedure Init;
var grDriver, grMode: integer;
begin
  grDriver := VGA;
  grMode   := VGAHi;
  initp_del := 30;
  InitGraph(grDriver, grMode, BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
  xmed := xmax DIV 2;
  ymed := ymax DIV 2;
  somethinginmem := false;
  buttondown := false;
  SetTextStyle(DefaultFont,HorizDir,1);
  SetTextJustify(LeftText,TopText);
  SetFillStyle(SolidFill,desktopcolor);
  Bar(0,0,xmax-1,ymax-1);
  ClearStatus;
end;

procedure Outit;
begin
  TextMode(CO80);
  WriteLn('VMode : ',xmax,'x',ymax);
  WriteLn('Center: ',xmed,'x',ymed);
  WriteLn;
  WriteLn('Last file: ',dfs);
  WriteLn;
  WriteLn('Program terminated.');
end;

procedure StartScreen;
begin
  MakeWindow(120,140,520,340,'NOKIA Graphic Editor');
  SetViewPort(123,161,517,337,ClipOn);
  SetColor(9);
  SetTextStyle(TripleXFont,HorizDir,10);
  SetTextJustify(CenterText,CenterText);
  OutTextXY(200,24,'GUI');
  OutTextXY(200,26,'GUI');
  OutTextXY(199,25,'GUI');
  OutTextXY(201,25,'GUI');
  SetTextStyle(SansSerifFont,HorizDir,2);
  OutTextXY(200,100,'GRAPHICAL USER INTERFACE');
  SetColor(0);
  SetTextStyle(SmallFont,HorizDir,5);
  OutTextXY(200,165,'written by Markus Birth <mbirth@webwriters.de>');
  SetTextStyle(SmallFont,VertDir,4);
  SetTextJustify(CenterText,TopText);
  SetColor(8);
  OutTextXY(385,2,'(c)1999 Web - Writers');
  SetColor(0);
  SetTextStyle(DefaultFont,HorizDir,1);
  OutTextXY(200,140,'Initializing color palette ...');
  Delay(1000);
  InitPalette;
  SetFillStyle(SolidFill,7);
  Bar(0,130,400,150);
  SetTextStyle(DefaultFont,HorizDir,1);
  SetViewPort(0,0,639,479,ClipOff);
  Status('Please press any key (mouse or keyboard)');
  ShowMouse(true);
  repeat
    MouseStat(mx,my,mb);
    StatusTime(false);
  until (keypressed) OR (mb<>0);
  if keypressed then ReadKey;
  ShowMouse(false);
  SetFillStyle(SolidFill,desktopcolor);
  Bar(120,140,520,340);
  ClearStatus;
  SetTextStyle(SmallFont,HorizDir,4);
  SetColor(15);
end;

procedure NoLoad;
begin
  ShowMouse(false);
  SetFillStyle(SolidFill,7);
  Bar(462,430,535,445);
  ShowMouse(true);
end;

procedure CantLoad;
begin
  ShowMouse(false);
  SetColor(0);
  Rectangle(462,430,535,445);
  SetColor(12);
  Line(463,431,534,444);
  Line(463,444,534,430);
  ShowMouse(true);
end;

procedure TryPreview(what: string);
var pf: file;
    offs: word;
    tmp: array[0..blocksize] of char;
    ec: word;
    i,j: byte;
begin
  SetFillStyle(SolidFill,7);
  Bar(462,430,535,445);
  Assign(pf,what);
  {$I-}
  Reset(pf,1);
  if IOResult<>0 then begin
    CantLoad;
    Exit;
  end;
  {$I+}
  BlockRead(pf,tmp,blocksize,ec);
  Close(pf);
  if (ec=0) then begin
    CantLoad;
    Exit;
  end;
  offs:=0;
  repeat
    Inc(offs);
  until ((tmp[offs-1]=#00) AND (tmp[offs]=#72) AND (tmp[offs+1]=#00) AND (tmp[offs+2]=#14)) OR (offs=ec-2);
  if (offs=ec-2) then begin
    CantLoad;
    Exit;
  end;
  Inc(offs,9);
  ShowMouse(false);
  SetColor(0);
  SetFillStyle(SolidFill,10);
  Bar(462,430,535,445);
  Rectangle(462,430,535,445);
  for j:=1 to 14 do begin
    for i:=1 to 72 do begin
      if (tmp[(j-1)*72+i+offs]='1') then begin
        PutPixel(462+i,430+j,0);
      { end else begin
        PutPixel(462+i,430+j,7); }
      end;
    end;
  end;
  ShowMouse(true);
end;

procedure SelectFile;
const entr=43;
var df: text;
    fils: array[1..215] of string[12];
    maxf: byte;
    tmp: string;
    i,j: byte;
    xp,yp: word;
    ofi: byte;
    wassomewhere,oversomewhere: boolean;
begin
  Status('Reading directory structure....');
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C DIR /A>'+GetEnv('TEMP')+'dirlist.$$$');
  SwapVectors;
  Assign(df,GetEnv('TEMP')+'dirlist.$$$');
  {$I-}
  Reset(df);
  if IOResult<>0 then begin
    TextMode(co80);
    WriteLn('ERROR while trying to read directory.');
    Halt;
  end;
  {$I+}
  i:=1;
  repeat
    ReadLn(df,tmp);
    if (tmp[1] IN [#65..#95]) OR (tmp[1] IN [#48..#58]) OR (tmp[1]='-') then begin
      j:=1;
      repeat
        Inc(j);
      until (tmp[j]=' ');
      if (Copy(tmp,14,5)<>'<DIR>') then begin
        fils[i]:=Copy(tmp,1,j-1)+'.'+Copy(tmp,10,3);
        fils[i]:=LowCase(fils[i]);
        Inc(i);
      end else begin
     (*   fils[i]:=Copy(tmp,1,j-1);
        if (Copy(tmp,10,3)<>'   ') then fils[i]:=fils[i]+'.'+Copy(tmp,10,3);
        Inc(i); *)
      end;
    end;
    if (i>215) then Exit;
  until Eof(df);
  Close(df);
  Erase(df);
  maxf := i-1;
  Status('Reading directory structure....done.');
  ShowMouse(false);
  MakeWindow(100,5,540,450,'Open file');
  MakeButton(105,420,170,445,'New');
  MakeButton(175,420,240,445,'Quit');
  if (somethinginmem) then MakeButton(245,420,310,445,'Cancel');
  SetTextStyle(SmallFont,HorizDir,4);
  SetTextJustify(LeftText,TopText);
  SetColor(0);
  OutTextXY(110,25,'..');
  for i:=1 to maxf do begin
    j:=i DIV entr;
    xp:=110+j*85;
    yp:=25+(i-j*entr)*9;
    OutTextXY(xp,yp,fils[i]);
  end;
  ofi := 0;
  repeat
    ShowMouse(true);
    MouseStat(mx,my,mb);
    StatusTime(false);
    wassomewhere:=false;
    oversomewhere:=false;
    if MouseOver(110,25,185,35) then begin  { Parent directory }
      { oversomewhere:=true; }
    end;
    for i:=1 to maxf do begin
      j:=i DIV entr;
      xp:=110+j*85;
      yp:=25+(i-j*entr)*9;
      if MouseOver(xp,yp+2,xp+75,yp+10) then begin
        oversomewhere:=true;
        if (i<>ofi) then begin
          SetTextJustify(LeftText,TopText);
          ShowMouse(false);
          SetColor(9);
          OutTextXY(xp,yp,fils[i]);
          TryPreview(fils[i]);
          dfs := fils[i];
          SetColor(0);
          if ofi<>0 then OutTextXY(110+(ofi DIV entr)*85,25+(ofi-(ofi DIV entr)*entr)*9,fils[ofi]);
          ShowMouse(true);
          ofi := i;
        end;
        wassomewhere:=true;
      end;
    end;
    if (NOT wassomewhere) AND (ofi<>0) then begin
      ShowMouse(false);
      SetColor(0);
      OutTextXY(110+(ofi DIV entr)*85,25+(ofi-(ofi DIV entr)*entr)*9,fils[ofi]);
      ShowMouse(true);
      NoLoad;
      ofi := 0;
    end;
    if MouseOver(105,420,170,445) then begin
      oversomewhere:=true;
      Status('Click to start a new graphic');
      if (mb=1) then begin
        MakeBeveledButton(105,420,170,445,'New');
        repeat MouseStat(mx,my,mb); until (mb=0);
        dfs:='untitled';
        exit;
      end;
    end;
    if MouseOver(175,420,240,445) then begin
      oversomewhere:=true;
      Status('Click to terminate this program');
      if (mb=1) then begin
        MakeBeveledButton(175,420,240,445,'Quit');
        repeat MouseStat(mx,my,mb); until (mb=0);
        Outit;
        Halt;
      end;
    end;
    if (somethinginmem) AND (MouseOver(245,420,310,445)) then begin
      oversomewhere:=true;
      Status('Click to go back without changing something');
      if (mb=1) then begin
        MakeButton(245,420,310,445,'Cancel');
        repeat MouseStat(mx,my,mb); until (mb=0);
        dfs:='noload';
        exit;
      end;
    end;
    if (NOT oversomewhere) AND (oldstat<>'') then ClearStatus;
  until ((mb<>0) AND (oversomewhere)) or keypressed;
  if keypressed then begin
    ReadKey;
    Halt;
  end;
  SetFillStyle(SolidFill,desktopcolor);
  ShowMouse(false);
  Bar(100,5,540,450);
  ShowMouse(true);
end;

procedure LoadFile;
var sts: string;
    offs: word;
    tmp: array[0..blocksize] of char;
    ec: word;
    i,j: byte;
begin
  sts := 'Loading file '+dfs+'....';
  Status(sts);
  odfs := dfs;
  Assign(df,dfs);
  {$I-}
  Reset(df,1);
  if IOResult<>0 then begin
    TextMode(co80);
    WriteLn('ERROR while trying to open file '+dfs+'.');
    Halt;
  end;
  {$I+}
  BlockRead(df,tmp,blocksize,ec);
  Close(df);
  if (ec=0) then begin
    TextMode(co80);
    WriteLn('ERROR while reading file '+dfs+'.');
    Halt;
  end;
  sts := sts + V2S(ec) + ' Bytes read.';
  Status(sts);
  offs:=0;
  repeat
    Inc(offs);
  until ((tmp[offs-1]=#00) AND (tmp[offs]=#72) AND (tmp[offs+1]=#00) AND (tmp[offs+2]=#14)) OR (offs=ec-2);
  if (offs=ec-2) then begin
    TextMode(co80);
    WriteLn('ERROR while searching graphic offset. (Wrong file?)');
    Halt;
  end;
  Inc(offs,9);
  sts := sts + ' Offset is '+V2S(offs)+'.';
  Status(sts);
  for j:=1 to 14 do begin
    for i:=1 to 72 do begin
      if (tmp[(j-1)*72+i+offs]='1') then graphic[i,j]:=true else graphic[i,j]:=false;
    end;
  end;
  sts := sts + ' File is now in buffer.';
  Status(sts);
  if (Copy(dfs,Length(dfs)-2,3)='ngg') then savefmt := 'NGG'
    else if (Copy(dfs,Length(dfs)-2,3)='nol') then savefmt := 'NOL';
end;

procedure ClearBuf;
var i,j: byte;
begin
  for j:=1 to 14 do begin
    for i:=1 to 72 do begin
      graphic[i,j]:=false;
    end;
  end;
  Status('Graphics buffer cleared.');
end;

procedure PaintMash;
var i,j: byte;
begin
  ShowMouse(false);
  SetFillStyle(SolidFill,7);
  Bar(xd,yd,xd+576,yd+135);
  SetFillStyle(SolidFill,biginact);
  Bar(xd,yd,xd+72*zd,yd+14*zd);
  SetFillStyle(SolidFill,smainact);
  Bar(xd,yd+120,xd+73,yd+135);
  SetColor(smaline); Rectangle(xd,yd+120,xd+73,yd+135);
  if (zd>3) then begin
    SetColor(bigline); Rectangle(xd,yd,xd+72*zd,yd+14*zd);
    for i:=1 to 71 do Line(xd+i*zd,yd+1,xd+i*zd,yd+14*zd-1);
    for i:=1 to 13 do Line(xd+1,yd+i*zd,xd+72*zd-1,yd+i*zd);
    for j:=1 to 14 do begin
      for i:=1 to 72 do begin
        if (graphic[i,j]) then begin
          SetFillStyle(SolidFill,bigact);
          FloodFill(xd+i*zd-zd DIV 2,yd+j*zd-zd DIV 2,bigline);
          PutPixel(xd+i,yd+120+j,smaact);
        end;
      end;
    end;
  end else begin
    SetColor(bigline); Rectangle(xd,yd,xd+72*zd+1,yd+14*zd+1);
    for j:=1 to 14 do begin
      for i:=1 to 72 do begin
        if (graphic[i,j]) then begin
          SetFillStyle(SolidFill,bigact);
          PutPixel(xd+i,yd+120+j,smaact);
          Bar(xd+(i-1)*zd+1,yd+(j-1)*zd+1,xd+i*zd,yd+j*zd);
        end else begin
          SetFillStyle(SolidFill,biginact);
          PutPixel(xd+i,yd+120+j,smainact);
          Bar(xd+(i-1)*zd+1,yd+(j-1)*zd+1,xd+i*zd,yd+j*zd);
        end;
      end;
    end;
  end;
  ShowMouse(true);
end;

procedure PrintZFact;
var tmp: string;
begin
  SetFillStyle(SolidFill,7);
  Bar(590,75,633,86);
  SetTextJustify(CenterText,CenterText);
  SetTextStyle(SmallFont,HorizDir,4);
  Str(zd,tmp);
  tmp := tmp+'x';
  SetColor(0);
  ShowMouse(false);
  OutTextXY(611,80,tmp);
  OutTextXY(612,80,tmp);
  ShowMouse(true);
end;

procedure UpdatePix(x,y: word);
begin
  ShowMouse(false);
  if (zd>3) then begin
    if (graphic[x,y]) then begin
      SetFillStyle(SolidFill,bigact);
      FloodFill(xd+x*zd-zd DIV 2,yd+y*zd-zd DIV 2,bigline);
      PutPixel(xd+x,yd+120+y,smaact);
    end else begin
      SetFillStyle(SolidFill,biginact);
      FloodFill(xd+x*zd-zd DIV 2,yd+y*zd-zd DIV 2,bigline);
      PutPixel(xd+x,yd+120+y,smainact);
    end;
  end else begin
    if (graphic[x,y]) then begin
      SetFillStyle(SolidFill,bigact);
      PutPixel(xd+x,yd+120+y,smaact);
      Bar(xd+(x-1)*zd+1,yd+(y-1)*zd+1,xd+x*zd,yd+y*zd);
    end else begin
      SetFillStyle(SolidFill,biginact);
      PutPixel(xd+x,yd+120+y,smainact);
      Bar(xd+(x-1)*zd+1,yd+(y-1)*zd+1,xd+x*zd,yd+y*zd);
    end;
  end;
  ShowMouse(true);
end;

procedure MakeEditorWindow;
begin
  ShowMouse(false);
  MakeWindow(0,0,639,467,'Graphics editor ['+dfs+']');
  MakeButton(590,24,633,74,'ZOOM+');
  MakeButton(590,87,633,137,'ZOOM-');
  MakeButton(5,442,70,462,'New');
  MakeButton(75,442,140,462,'Load');
  MakeButton(145,442,210,462,'Save');
  MakeButton(215,442,280,462,'Quit');
  PrintZFact;
  PaintMash;
  ShowMouse(true);
end;

function CheckName(fn: string): boolean;
var i: word;
    checkok: boolean;
begin
  checkok := true;
  if (Length(fn)>12) then checkok:=false;
  for i:=1 to Length(fn) do begin
    if (fn[i])='.' then begin
      if (i>9) OR (i<2) then checkok:=false;
      if (Length(fn)-i>3) OR (Length(fn)-i<1) then checkok:=false;
    end;
  end;
  CheckName := checkok;
end;

function CheckExist(fn: string): boolean;
var testf: file;
begin
  Assign(testf,fn);
  {$I-}
  Reset(testf,1);
  if (IOResult=0) then begin
    Close(testf);
    {$I+}
    CheckExist := true;
    Exit;
  end;
  CheckExist := false;
end;

function StripExt(fn: string): string;
var i: word;
begin
  for i:=1 to Length(fn) do begin
    if fn[i]='.' then begin
      StripExt := Copy(fn,1,i-1);
      Exit;
    end;
  end;
  StripExt := fn;
end;

procedure MapExt(var fn: string;ext: string);
var i: word;
begin
  fn := StripExt(fn);
  if Length(fn)>8 then fn:=Copy(fn,1,8);
  fn := fn + '.' + LowCase(ext);
end;

procedure PaintRadios;
begin
  MakeBeveledButton(140,320,275,360,'');
  if (savefmt='NGG') then begin
    MakeBevRadiobutton(150,330,'NOKIA Group-Graphic');
  end else MakeRadiobutton(150,330,'NOKIA Group-Graphic');
  if (savefmt='NOL') then begin
    MakeBevRadiobutton(150,340,'NOKIA Operator-Logo');
  end else MakeRadiobutton(150,340,'NOKIA Operator-Logo');
  gui_dis := true;
  if (savefmt='B1N') then begin
    MakeBevRadiobutton(150,350,'Binary format');
  end else MakeRadiobutton(150,350,'Binary format');
  gui_dis := false;
  MapExt(dfs,savefmt);
end;

procedure CheckFile(fn: string);
var line1,line2: string;
    colr1,colr2: byte;
    testf: file;
    testimg: array[1..72,1..14] of boolean;
    tmp: array[0..blocksize] of char;
    ec: word;
    offs: word;
    i,j: byte;
begin
  line1:='';
  line2:='';
  colr1:=0;
  colr2:=0;
  SetFillStyle(SolidFill,7);
  Bar(300,300,505,350);
  if (NOT CheckName(fn)) then begin
    colr1 := 12;
    line1 := 'Invalid filename';
    colr2 := 6;
    line2 := 'Enter a valid filename';
  end;
  if (line1='') then begin
    Assign(testf,fn);
    {$I-}
    Reset(testf,1);
    if (IOResult=0) then begin
      colr1 := 12;
      line1 := 'File exists!';
      colr2 := 2;
      line2 := 'Enter another filename';
      Blockread(testf,tmp,blocksize,ec);
      Close(testf);
      if (ec=0) then begin
        { NOT READABLE }
        Exit;
      end;
      offs:=0;
      repeat
        Inc(offs);
      until ((tmp[offs-1]=#00) AND (tmp[offs]=#72) AND (tmp[offs+1]=#00) AND (tmp[offs+2]=#14)) OR (offs=ec-2);
      if (offs=ec-2) then begin
        { NO OFFSET }
        Exit;
      end;
      Inc(offs,9);
      SetColor(0);
      Rectangle(427,324,500,339);
      for j:=1 to 14 do begin
        for i:=1 to 72 do begin
          if (tmp[(j-1)*72+i+offs]='1') then PutPixel(427+i,324+j,0) else PutPixel(427+i,324+j,10);
        end;
      end;
    end;
    {$I+}
  end;
  SetTextJustify(RightText, CenterText);
  SetTextStyle(SmallFont,HorizDir,4);
  SetColor(colr1);
  OutTextXY(500,303,line1);
  OutTextXY(499,303,line1);
  SetColor(colr2);
  OutTextXY(500,313,line2);
  OutTextXY(499,313,line2);
end;

procedure SaveFile;
const NGGhead: array[0..15] of char=(#78,#71,#71,#00,#01,#00,#72,#00,#14,#00,
                                     #01,#00,#01,#00,#76,#00);
      NGGhl=15;
      NOLhead: array[0..19] of char=(#78,#79,#76,#00,#01,#00,#249,#01,#01,#00,
                                     #72,#00,#14,#00,#01,#00,#01,#00,#87,#00);
      NOLhl=19;
      Foot: string='File saved by Markus Birth''s Graphic Editor. Go to http://www.webwriters.de';
var oldfs: string;
    Key: char;
    Cont, alrchg, over: boolean;
    savf: file;
    savbuf: array[0..blocksize] of char;
    sbo,sbc,ec: word;
    i,j: word;
begin
  Cont := false;
  alrchg := false;
  ShowMouse(false);
  MakeWindow(120,170,520,420,'Save file');
  MakeButton(125,395,323,415,'SAVE NOW!');
  MakeButton(327,395,515,415,'Cancel');
  SetTextStyle(SmallFont,HorizDir,4);
  SetTextJustify(LeftText,BottomText);
  OutTextXY(141,247,'Filename:');
  OutTextXY(141,317,'Format:');
  MakeBeveledButton(140,250,500,295,'');
  PaintRadios;

  ShowMouse(true);

  SetColor(8);
  SetTextStyle(TripleXFont,HorizDir,5);
  SetTextJustify(LeftText,CenterText);
  OutTextXY(145,266,dfs);
  CheckFile(dfs);
  oldfs := dfs;

  repeat
    repeat
      over := false;
      MouseStat(mx,my,mb);
      if (dfs<>oldfs) then begin
        ShowMouse(false);
        MakeBeveledButton(140,250,500,295,'');
        SetColor(0);
        SetTextStyle(TripleXFont,HorizDir,5);
        SetTextJustify(LeftText,CenterText);
        OutTextXY(145,266,dfs);
        CheckFile(dfs);
        oldfs := dfs;
        ShowMouse(true);
      end;
      if MouseOver(125,395,323,415) then begin
        over := true;
        Status('Click to save the graphic as '+dfs);
        if (mb=1) then MakeBeveledButton(125,395,323,415,'SAVE NOW!');
      end;
      if MouseOver(327,395,515,415) then begin
        over := true;
        Status('Cancel this operation');
        if (mb=1) then begin
          MakeBeveledButton(327,395,515,415,'Cancel');
          Key := #27;
          dfs := odfs;
        end;
      end;
      if MouseOver(145,325,270,334) then begin
        over := true;
        Status('Change format to NOKIA Group-Graphic');
        if (mb=1) then begin
          savefmt := 'NGG';
          PaintRadios;
          MapExt(dfs,savefmt);
          repeat MouseStat(mx,my,mb); until (mb=0);
        end;
      end;
      if MouseOver(145,335,270,344) then begin
        over := true;
        Status('Change format to NOKIA Operator-Logo');
        if (mb=1) then begin
          savefmt := 'NOL';
          PaintRadios;
          MapExt(dfs,savefmt);
          repeat MouseStat(mx,my,mb); until (mb=0);
        end;
      end;
      if MouseOver(145,345,270,354) then begin
        over := true;
        Status('Change format to binary [not yet implemented]');
      end;
      if ((NOT over) AND (oldstat<>'')) then ClearStatus;
      StatusTime(false);
    until (keypressed) OR (((MouseOver(125,395,323,415)) OR (MouseOver(327,395,515,415))) AND (mb=1));
    ClearStatus;
    if (keypressed) then Key := ReadKey;
    if (MouseOver(125,395,323,415)) AND (mb=1) then Key := #13;
    repeat MouseStat(mx,my,mb); until (mb=0);
    case Key of
      #08: begin
             if (Length(StripExt(dfs))>0) then begin
               dfs := Copy(StripExt(dfs),1,Length(StripExt(dfs))-1);
               MapExt(dfs,savefmt);
             end else begin
               Sound(1200);
               Delay(50);
               NoSound;
             end;
           end;
      #27: begin
             ShowMouse(false);
             SetFillStyle(SolidFill,7);
             Bar(120,170,520,420);
             ShowMouse(true);
             Exit;
           end;
      #13: begin
             if (NOT CheckName(dfs)) OR (CheckExist(dfs)) then begin
               Sound(800);
               Delay(50);
               NoSound;
               Key := #00;
               if (NOT CheckName(dfs)) then Alert('Invalid filename.');
               if (CheckExist(dfs)) then Alert('File exists on disk.');
               MakeButton(125,395,323,415,'SAVE NOW!');
             end;
           end;
    else
      if (Key IN [#65..#90]) OR (Key IN [#48..#58]) OR (Key IN [#97..#122]) OR (Key='-') OR (Key='_') then begin
        if (Length(StripExt(dfs))<8) then begin
          if (dfs=odfs) AND (NOT alrchg) then begin
            dfs := LowCase(key);
            alrchg := true;
          end else begin
            dfs := StripExt(dfs)+LowCase(Key);
            alrchg := true;
          end;
          MapExt(dfs,savefmt);
        end else begin
          Sound(1200);
          Delay(50);
          NoSound;
        end;
      end else begin
        Sound(1200);
        Delay(50);
        NoSound;
      end;
    end;
  until (Key=#13) OR (Key=#27);
  if (Key=#27) then Exit;
  Assign(savf,dfs);
  {$I-}
  Rewrite(savf,1);
  if (IOResult<>0) then begin
    TextMode(co80);
    WriteLn('ERROR while opening output file.');
    Halt;
  end;
  {$I+}
  if (savefmt='NGG') then begin
    for i:=0 to NGGhl do begin
      savbuf[i] := NGGhead[i];
    end;
    sbo := NGGhl+1;
  end else if (savefmt='NOL') then begin
    for i:=0 to NOLhl do begin
      savbuf[i] := NOLhead[i];
    end;
    sbo := NOLhl+1;
  end;
  for j:=1 to 14 do begin
    for i:=1 to 72 do begin
      if (graphic[i,j]) then savbuf[sbo+(i-1)+(j-1)*72] := '1' else savbuf[sbo+(i-1)+(j-1)*72] := '0';
    end;
  end;
  for i:=1 to Length(foot) do begin
    savbuf[sbo+1007+i] := foot[i];
  end;
  savbuf[sbo+1008+Length(foot)] := #13;
  sbc := sbo+1008+Length(foot)+1;
  BlockWrite(savf,savbuf,sbc,ec);
  Close(savf);
  Alert('File saved.');
  ShowMouse(false);
  SetFillStyle(SolidFill,7);
  Bar(120,170,520,420);
  ShowMouse(true);
end;

procedure Editor;
const ExitNow: boolean=false;
var i: byte;
    ovso: boolean;
    wx,wy,owx,owy: word;
    xmx,xmy: word;
    Key: char;
begin
  MakeEditorWindow;
  ShowMouse(true);
  repeat
    ovso:=false;
    MouseStat(mx,my,mb);
    wx := (mx-xd) DIV zd+1;
    wy := (my-yd) DIV zd+1;
    if (wx<>owx) OR (wy<>owy) then begin
      if (wx>0) AND (wx<73) AND (wy>0) AND (wy<15) then begin
        ShowMouse(false);
        SetFillStyle(SolidFill,7);
        Bar(xd+80,yd+115,xd+200,yd+135);
        SetTextJustify(CenterText,CenterText);
        SetTextStyle(SmallFont,HorizDir,5);
        SetColor(0);
        OutTextXY(xd+140,yd+125,V2S(wx)+'/'+V2S(wy));
        OutTextXY(xd+141,yd+125,V2S(wx)+'/'+V2S(wy));
        owx:=wx;
        owy:=wy;
        ShowMouse(true);
      end else if (owx<>0) AND (owy<>0) then begin
        ShowMouse(false);
        SetFillStyle(SolidFill,7);
        Bar(xd+80,yd+115,xd+200,yd+135);
        SetTextJustify(CenterText,CenterText);
        SetTextStyle(SmallFont,HorizDir,5);
        SetColor(8);
        OutTextXY(xd+140,yd+125,'--/--');
        OutTextXY(xd+141,yd+125,'--/--');
        owx := 0;
        owy := 0;
        ShowMouse(true);
      end;
    end;
    if (wx>0) AND (wx<73) AND (wy>0) AND (wy<15) then begin
      if (mb=1) then begin
        xmx:=mx; xmy:=my; repeat MouseStat(mx,my,mb); until (mb=0) OR (mx<>xmx) OR (my<>xmy);
        graphic[wx,wy]:=true;
        UpdatePix(wx,wy);
      end else if (mb=2) then begin
        xmx:=mx; xmy:=my; repeat MouseStat(mx,my,mb); until (mb=0) OR (mx<>xmx) OR (my<>xmy);
        graphic[wx,wy]:=false;
        UpdatePix(wx,wy);
      end;
    end;
    if MouseOver(590,24,633,74) then begin
      ovso:=true;
      Status('Click to zoom in');
      if (mb=1) then begin
        MakeBeveledButton(590,24,633,74,'ZOOM+');
        repeat MouseStat(mx,my,mb); until (mb=0);
        if (zd<8) then begin
          Inc(zd);
          PaintMash;
          PrintZFact;
        end;
        MakeButton(590,24,633,74,'ZOOM+');
      end;
    end;
    if MouseOver(590,75,633,86) then begin
      ovso:=true;
      Status('Click to repaint graphic');
      if (mb=1) then begin
        repeat MouseStat(mx,my,mb); until (mb=0);
        PaintMash;
        PrintZFact;
        owx := 255; owy := 255;
      end;
    end;
    if MouseOver(590,87,633,137) then begin
      ovso:=true;
      Status('Click to zoom out');
      if (mb=1) then begin
        MakeBeveledButton(590,87,633,137,'ZOOM-');
        repeat MouseStat(mx,my,mb); until (mb=0);
        if (zd>2) then begin
          Dec(zd);
          PaintMash;
          PrintZFact;
          owx := 255; owy := 255;
        end;
        MakeButton(590,87,633,137,'ZOOM-');
      end;
    end;
    if MouseOver(5,442,70,462) then begin
      ovso:=true;
      Status('Click to clear the graphic completely. WARNING!');
      if (mb=1) then begin
        MakeBeveledButton(5,442,70,462,'New');
        repeat MouseStat(mx,my,mb); until (mb=0);
        ClearBuf;
        dfs := 'untitled';
        MakeEditorWindow;
        owx := 255; owy := 255;
      end;
    end;
    if MouseOver(75,442,140,465) then begin
      ovso:=true;
      Status('Click to load another graphic');
      if (mb=1) then begin
        MakeBeveledButton(75,442,140,462,'Load');
        repeat MouseStat(mx,my,mb); until (mb=0);
        SelectFile;
        if (dfs='untitled') then ClearBuf else if (dfs='noload') then dfs:=odfs else LoadFile;
        MakeEditorWindow;
        owx := 255; owy := 255;
      end;
    end;
    if MouseOver(145,442,210,462) then begin
      ovso:=true;
      Status('Click here to save your file');
      if (mb=1) then begin
        MakeBeveledButton(145,442,210,462,'Save');
        repeat MouseStat(mx,my,mb); until (mb=0);
        ClearStatus;
        SaveFile;
        MakeButton(145,442,210,462,'Save');
      end;
    end;
    if MouseOver(215,442,280,462) then begin
      ovso:=true;
      Status('Click to quit this nice proggy. WARNING: SAVE YOUR FILE FIRST!');
      if (mb=1) then begin
        MakeBeveledButton(215,442,280,462,'Quit');
        repeat MouseStat(mx,my,mb); until (mb=0);
        Outit;
        Halt;
      end;
    end;
    if (NOT ovso) AND (oldstat<>'') then ClearStatus;
    StatusTime(false);
    if (keypressed) then Key:=ReadKey;
  until (mb=3) OR (Key=#27) OR (ExitNow);
end;

begin
  Init;
  MouseReset;
  if (ParamCount<>1) then begin
    StartScreen;
    SelectFile;
    if (dfs='untitled') then ClearBuf else if (dfs='noload') then dfs:=odfs else LoadFile;
  end else begin
    dfs:=ParamStr(1);
    LoadFile;
    InitPalette;
  end;
  somethinginmem := true;
  Editor;
  Outit;
end.