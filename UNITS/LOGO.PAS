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
    Write(' [ o ]��[ f ]�������[ n ]��[ O ]��[ O ]��[ b ] ');
    TextBackground(0);
    TextColor(1);
    WriteLn;
    WriteLn('     ���������������������� ');
    Write('     ����������������������');
    WriteLn;
    TextColor(8);
    WriteLn('     Robo.Cop@gmx.net � http://RoboCop.home.pages.de � irc.germany.net:6667');
    TextColor(0);
    WriteLn('              (C)1995-1998 by RoboCop of nOOb');
    WriteLn('If you cannot decrypt ^THAT^ Symbol, install the ANSI.SYS Driver!');
  end;

begin
  WriteLn('� Loading Unit: Logo - RoboCop of nOOb <Robo.Cop@gmx.net>');
end.