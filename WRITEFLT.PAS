program WriteFltTest;

uses Crt, VFx;

begin
  ClrScr;
  WriteFlt('This is only a test');
  WriteFlt('Please do not call the police or ambulance but be careful!');
  WriteFlt('Sieht das hier nicht schick aus?');
  WriteImp('Six million ways to die - choose one');
  GotoXY(1,wherey-1);
  WriteExp('Six million ways to die - choose one');
  GotoXY(1,wherey-1);
  WriteImp('Six million ways to die - choose one');
  WriteImp('Now that you''ve chosen one, kill yourself by doing as it says ...');
end.