program Sorts;

uses Crt, VFx;

const max = 200;

type elementtype = integer;
     Arraytype = array[0..max] of elementtype;

var count: integer;
    xarr: arraytype;
    oarr: arraytype;

procedure Banner(what: string);
begin
  drwdmax:=0;
  DrawBorder(Length(what) DIV 2+5,3,15,1,6);
  Write('  ',what);
  ReadKey;
  Window(1,1,80,50);
  TextBackground(0);
  ClrScr;
end;

procedure Check(var f:arraytype);
var i,cnt: integer;
begin
  i:=0;
  cnt:=0;
  repeat
    Inc(i);
    Inc(cnt);
  until (F[i]=0) AND (F[i-1]=0);
  F[0] := cnt;
end;

procedure Init;
begin
  TextMode(co80 + Font8x8);
  Randomize;
end;

(***************************************************************************
 ************ Array-Initialisierungen **************************************
 ***************************************************************************)

procedure Init_clear(var f:arraytype);
var i: integer;
begin
  for i:=1 to max do F[i]:=0;
end;

procedure Init_Random(var f:arraytype);
var i: integer;
begin
  { for i:=1 to max do f[i]:=(Random(65535)-32767); }
  for i:=1 to max do f[i]:=Random(32768);
  F[0]:=max;
end;

procedure Init_Inc(var f:arraytype);
var i: integer;
begin
  for i:=1 to max do F[i]:=i;
  F[0]:=max;
end;

procedure Init_Dec(var f:arraytype);
var i: integer;
begin
  for i:=1 to max do F[i]:=max-i+1;
  F[0]:=max;
end;



procedure OutArray(f: arraytype; var fo: arraytype);
const maxlines=50;
var i: integer;
begin
  for i:=1 to F[0] do begin
    if i<=maxlines then GotoXY(1,i)
      else if i<=maxlines*2 then GotoXY(20,i-maxlines)
      else if i<=maxlines*3 then GotoXY(40,i-maxlines*2)
      else if i<=maxlines*4 then GotoXY(60,i-maxlines*3);
    TextColor(7);
    Write(i:3,': ');
    if (F[i]<>Fo[i]) then TextColor(14) else TextColor(7);
    Write(F[i]:10);
    { Delay(5); }
  end;
  fo := f;
{  ReadKey; }
  Delay(100);
end;

procedure Swap(var x1,x2: elementtype);
var tmp: elementtype;
begin
  tmp := x1;
  x1 := x2;
  x2 := tmp;
end;


procedure Sort_Bubblesort(var f:arraytype);
var i: integer;
    canswap: boolean;
    tmp: elementtype;
begin
  repeat
    canswap:=false;
    for i:=1 to F[0]-1 do begin
      if F[i]>F[i+1] then begin
        Swap(F[i],F[i+1]);
        canswap := true;
      end;
    end;
  until (NOT canswap);
end;

procedure Sort_Simple(var f:arraytype);
var i,j: integer;
    tmp: elementtype;
begin
  for i:=1 to F[0]-1 do
    for j:=i+1 to F[0] do
      if F[j]<F[i] then begin
        Swap(F[i],F[j]);
      end;
end;

procedure Sort_Selectionsort(var f:arraytype);
var i,j,minpos: integer;
    tmp: elementtype;
begin
  for i:=1 to F[0]-1 do begin
    minpos := i;
    for j:=i+1 to F[0] do if F[j]<F[minpos] then minpos:=j;
    Swap(F[i],F[minpos]);
  end;
end;

procedure Sort_Insertionsort(n: integer; var f:arraytype);
var h,i,j: integer;
begin
  for i:=2 to n do begin
    h    := f[i];
    f[1] := h;
    j    := i-1;
    while h<f[j] do begin
      f[j+1] := f[j];
      if (i>2) then Dec(j) else exit;
    end;
    f[j+1] := h;
    OutArray(xarr,oarr);
  end;
end;

procedure Sort_Shellsort(n: integer; var f:arraytype);
var i,j,k,m: integer;
    goon: boolean;
    hilf: elementtype;
begin
  m := n DIV 2;
  repeat
    for i:=1 to n-m do begin
      while f[i+m] < f[i] do begin
        hilf := f[i+m];
        j := i;
        goon := true;
        while (j>0) AND goon do begin
          if hilf<f[j] then begin
            f[j+m] := f[j];
            j := j-m;
          end else goon := false;
        end;
        f[j+m] := hilf;
      end;
    end;
    m := m DIV 2;
    OutArray(xarr,oarr);
  until m=0;
end;

begin
  Init;
  Banner('Init_Random');
  Init_Random(xarr);
{  Banner('Init_Inc');
  Init_Inc(xarr); }
{  Banner('Init_Dec');
  Init_Dec(xarr); }
  oarr := xarr;
  OutArray(xarr,oarr);
{  Sort_Bubblesort(xarr); }
{  Sort_Selectionsort(xarr); }
{  Sort_Simple(xarr); }
{  Sort_Insertionsort(xarr[0], xarr); }
  Sort_Shellsort(xarr[0], xarr);
{  OutArray(xarr,oarr); }
end.
