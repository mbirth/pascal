uses Crt;const S:array[1..3,1..4] of word=((825,999,637,723),(436,638,345,451),(652,821,504,633));var B:array[1..3] of word;
P:array[1..4] of word;procedure A;var i,j:byte;begin for i:=1 to 3 do for j:=1 to 4 do begin P[j]:=P[j]+S[i,j];
B[i]:=B[i]+S[i,j];end;end;procedure C;var i,j:byte;begin WriteLn('<=========*=========>');Write('          ');
WriteLn('ROT BLAU GELB GRšN ====');for i:=1 to 3 do begin Write('Bezirk ',i,' ');for j:=1 to 4 do Write(S[i,j]:4,' ');
WriteLn(B[i]:4);end;Write('======== ');for i:=1 to 4 do Write(P[i]:4,' ');WriteLn;end;begin A;C;ReadKey;end.
