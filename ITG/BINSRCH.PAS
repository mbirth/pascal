function bin_searchrekursiv(left, right, key: word): word;
var x: word;
begin
  if left>right then bin_searchrekursiv:=0
    else begin
      x := (left+right) DIV 2;
      if key < F[x] then bin_searchrekursiv(left, x-1, key)
        else if key > F[x] then bin_searchrekursiv(x+1,right, key)
          else bin_searchrekursiv := x;
    end;
end;

function bin_searchiterativ(key: word): word;
var left, right, x: word;
begin
  left := 1;
  right := max;
  repeat
    x := (left + right) DIV 2;
    if key<F[x] then right := x-1 else left := x+1;
  until (key=F[x]) OR (left>right);
  if key=F[x] then bin_searchiterativ := x;
    else bin_searchiterativ := 0;
end;
