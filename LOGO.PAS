unit Logo;

interface
         procedure WriteLogo;
implementation
uses crt;


  procedure WriteLogo;
    begin;
    TextColor(1);
    WriteLn('        ����������������');
    Write('      /����������');
    TextColor(9);
    Write('��������');
    TextColor(1);
    WriteLn('\');
    Write('     ����������');
    TextColor(9);
    Write('������۲���');
    TextColor(1);
    Write('�');
    TextColor(15);
    WriteLn('   ����   ���  ����   ���       ����  ���  ����');
    TextColor(1);
    Write('     ������������');
    TextColor(9);
    Write('��������');
    TextColor(1);
    Write('۳');
    TextColor(15);
    WriteLn('   �   � �   �  �  � �   �     �     �   � �   �');
    TextColor(1);
    Write('     �����������Ŀ�');
    TextColor(9);
    Write('����');
    TextColor(1);
    Write('��۳');
    TextColor(15);
    WriteLn('   ����  �   �  ���� �   �     �     �   � ����');
    TextColor(1);
    Write('      �');
    TextColor(4);
    Write('����������');
    TextColor(1);
    Write('���');
    TextColor(9);
    Write('��');
    TextColor(1);
    Write('���۳');
    TextColor(15);
    WriteLn('   �  �  �   �  �  � �   �     �     �   � �');
    TextColor(1);
    Write('     ������������������۲��');
    TextColor(15);
    WriteLn('   �   �  ���  ����   ���       ����  ���  �');
    TextColor(1);
    Write('     ����������������������  ');
    TextColor(0);
    TextBackground(7);
    Write(' I    N    D    U    S    T    R    I    E   S ');
    TextBackground(0);
    TextColor(1);
    WriteLn;
    WriteLn('     ���������������������� ');
    Write('     ����������������������');
    TextColor(0);
    WriteLn('              (C)1995-1996 by RoboCop INDUSTRIES');
    WriteLn('If you cannot decrypt ^THAT^ Symbol, install the ANSI.SYS Driver!');
  end;

begin
  WriteLn('� Loading Unit: Logo - geschrieben von RoboCop IND.');
end.