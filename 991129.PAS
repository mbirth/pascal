program BinaryWatch;

uses Crt, Graph, BGIP;

type TTri=record
       P: array[1..3] of PointType;
     end;
     TRow1=record
       Tri: array[1..3] of TTri;
     end;
     TRow23=record
       Tri: array[1..5] of TTri;
     end;

const Cu=4;
      Cd=3;
      Row1: TRow1 =(Tri:((P:((X:430;Y: 10),(X:510;Y:150),(X:349;Y:150))),(P:((X:320;Y:150),(X:239;Y: 10),(X:400;Y: 10))),
                         (P:((X:210;Y: 10),(X:290;Y:150),(X:129;Y:150)))));
      Row2: TRow23=(Tri:((P:((X:540;Y:170),(X:620;Y:310),(X:459;Y:310))),(P:((X:430;Y:310),(X:349;Y:170),(X:510;Y:170))),
                         (P:((X:320;Y:170),(X:400;Y:310),(X:239;Y:310))),(P:((X:210;Y:310),(X:129;Y:170),(X:290;Y:170))),
                         (P:((X:100;Y:170),(X:180;Y:310),(X: 19;Y:310)))));
      Row3: TRow23=(Tri:((P:((X:540;Y:470),(X:459;Y:330),(X:620;Y:330))),(P:((X:430;Y:330),(X:510;Y:470),(X:349;Y:470))),
                         (P:((X:320;Y:470),(X:239;Y:330),(X:400;Y:330))),(P:((X:210;Y:330),(X:290;Y:470),(X:129;Y:470))),
                         (P:((X:100;Y:470),(X: 19;Y:330),(X:180;Y:330)))));

var xmax,ymax: integer;

procedure GraphInit;
var grDriver, grMode : integer;
begin
  grDriver := VGA;
  { VGAlo     640x200x16
    VGAmed    640x350x16
    VGAhi     640x480x16 }
  grMode   := VGAhi;
  InitGraph(grDriver,grMode,BGIPath);
  xmax := GetMaxX+1;    { Bildschirmbreite in Pixeln }
  ymax := GetMaxY+1;    { Bildschirmh”he in Pixeln }
end;

procedure GraphOutit;
begin
  TextMode(co80 + Font8x8);
end;

procedure DrawTriangles;
var i,c: integer;
begin
{ Upper row }
  for i:=1 to 3 do begin
    if (i MOD 2)=0 then c:=3 else c:=4;
    SetColor(c);
    SetFillStyle(SolidFill,c);
    FillPoly(SizeOf(Row1.Tri[i]) DIV SizeOf(PointType), Row1.Tri[i]);
  end;
{ Middle row }
  for i:=1 to 5 do begin
    if (i MOD 2)=0 then c:=3 else c:=4;
    SetColor(c);
    SetFillStyle(SolidFill,c);
    FillPoly(SizeOf(Row2.Tri[i]) DIV SizeOf(PointType), Row2.Tri[i]);
  end;
{ Lower row }
  for i:=1 to 5 do begin
    if (i MOD 2)=0 then c:=4 else c:=3;
    SetColor(c);
    SetFillStyle(SolidFill,c);
    FillPoly(SizeOf(Row3.Tri[i]) DIV SizeOf(PointType), Row3.Tri[i]);
  end;
end;

begin
  GraphInit;
  SetFillStyle(SolidFill,15);
  SetColor(15);
  Bar(0,0,xmax,ymax);
  DrawTriangles;
  ReadKey;
  GraphOutit;
end.
