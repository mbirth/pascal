procedure quicksort(anfang,ende : integer; var f : feldtyp);
var links, rechts  : integer;
    h, vgl : elementtyp;
begin
     links := anfang; rechts := ende; vgl := f[(links+rechts) div 2];

     if links < rechts then
        begin
             repeat
                   while f[links]< vgl do inc(links);
                   while f[rechts]> vgl do dec(rechts);
                   if links <= rechts then
                      begin
                           h:=f[links];
                           f[links]:= f[rechts];
                           f[rechts]:=h;
                           inc(links); dec(rechts);
                      end;
             until links > rechts;
             quicksort(anfang,rechts,f);
             quicksort(links,ende,f);
        end;
end;
