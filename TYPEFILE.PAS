program TypeTest;

type TTest=record
       x,y: integer;
       bla: string[20];
     end;

var Test: TTest;
    f: file of TTest;

begin
  Assign(f,'test.dat');
  Rewrite(f);
  Test.x := 5;
  Test.y := 10;
  Test.bla := 'This is only a test!!';
  Write(f, Test);



end.
