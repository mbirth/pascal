 {Ord.PAS}

{Beispielcode fÅr die Funktion Ord }

 uses Crt;

 type
   Colors = (RED,GREEN,BLUE);
 begin
   Writeln('BLUE has an ordinal value of ',
           Ord(BLUE));
   Writeln('The ASCII code for "c" is ',
           Ord('c'), ' decimal');
 end.
