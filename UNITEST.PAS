{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/UNITEST)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Unit UNITEST;

INTERFACE

Function IsBoolean(Const TestName:String;Got,Expected:Boolean):Boolean;
Function IsInteger(Const TestName:String;Got,Expected:LongInt):Boolean;
Function IsReal(Const TestName:String;Got,Expected:Extended):Boolean;
Function IsPChar(Const TestName:String;Got,Expected:PChar):Boolean;
Function IsPointer(Const TestName:String;Got,Expected:Pointer):Boolean;
Function IsString(const TestName,Got,Expected:String):Boolean;
Function IsSkipping:Boolean;
Function IsTodo:Boolean;
Procedure MaxFailCheck;
Function Pass(Const TestName:String):Boolean;
Procedure Plan(Count:LongInt);
Procedure TestFail(Const TestName:String);
Procedure TestPass(Const TestName:String);
Procedure TestSkip;
Procedure TestTodo;

IMPLEMENTATION

Uses Strings;

Var
 MaxFailures,TestsPlanned,TestsRun,TestsFailed,RunCount,CurrSkipCount,CurrTodoCount:LongInt;
 CurrSkipMsg,CurrTodoMsg:String;
 PlanShown:Boolean;

Function Boolean2Str(B:Boolean):String;Begin
 Case b of
  True:Boolean2Str:='true';
  False:Boolean2Str:='false';
 End;
End;

Function Ptr2Str(P:Pointer):String;
Const HexChars:String[16]='0123456789ABCDEF';
Var
 S:String;
 I:Integer;
 B:Byte;
 Vector:{$IFDEF FPC}PtrInt{$ELSE}LongInt{$ENDIF};
Begin
{$IFDEF FPC}
  Vector:=PtrInt(P);
{$ELSE}
  Vector:=LongInt(P);
{$ENDIF}
 S:='';
 For I:=3 downto 0 do Begin
  B:=Vector shr((i*8) and $FF);
  S:=S+HexChars[B shr 4+1];
  S:=S+HexChars[B and $F+1];
 End;
 Ptr2Str:='$'+S;
End;

Procedure Plan(Count:LongInt);Begin
 Inc(RunCount);
 If(Not PlanShown)Then Begin
  TestsPlanned:=Count;
  Writeln('1..',TestsPlanned);
  PlanShown := true;
 End
  Else
 Begin
  WriteLn('ERREUR : Tentative d''‚mission de plusieurs plans en un seul test. ');
  Halt(10);
 End;
End;

Function Pass(Const TestName:String):Boolean;Begin
 If(Not IsSkipping)and(Not IsTodo)Then TestPass(TestName);
 Pass:=True;
End;

Procedure MaxFailCheck;Begin
 If(MaxFailures>0)and(TestsFailed>=MaxFailures)Then Begin
   WriteLn( 'ABANDONNEE: Le nombre maximum d''‚chec est d‚passement de ',MaxFailures);
  Halt(255);
 End;
End;

Procedure TestFail(Const TestName:String);Begin
 Inc(TestsRun);
 Inc(TestsFailed);
 WriteLn(TestName,' : ECHEC');
End;

Procedure TestPass(Const TestName:String);Begin
 Inc(TestsRun);
 WriteLn(TestName,' : BON');
End;

Procedure TestSkip;Begin
 Inc(TestsRun);
 WriteLn(CurrSkipMsg,' : BON, SAUTER');
 Dec(CurrSkipCount);
 If(CurrSkipCount<=0)Then CurrSkipMsg:='';
End;

Procedure TestTodo;Begin
 Inc(TestsRun);
 WriteLn(CurrTodoMsg,' ECHEC, A FAIRE');
 Dec(CurrTodoCount);
 If(CurrTodoCount<=0)Then CurrTodoMsg:='';
End;

Function IsSkipping:Boolean;Begin
 IsSkipping:=False;
 If(CurrSkipCount>0)Then Begin
  IsSkipping:=True;
  TestSkip;
 End;
End;

Function IsTodo:Boolean;Begin
 IsTodo:=False;
 If(CurrTodoCount>0)Then Begin
  IsTodo:=True;
  TestTodo;
 End;
End;

Function IsBoolean(Const TestName:String;Got,Expected:Boolean):Boolean;
Var
 Passed:Boolean;
Begin
 Passed:=True;
 If(Not IsSkipping)and(Not IsTodo)Then Begin
  If(Got<>Expected)Then Begin
   TestFail(TestName);
   Write('ATTENDU : ''',Boolean2Str(Got),'''' );
   WriteLn('RECU : ''',Boolean2Str(Expected),'''');
   Passed:=False;
   MaxFailCheck;
  End
   Else
  TestPass(TestName);
 End;
 IsBoolean:=Passed;
End;

Function IsInteger(Const TestName:String;Got,Expected:LongInt):Boolean;
Var
 Passed:Boolean;
Begin
 Passed:=True;
 If(Not IsSkipping)and(Not IsTodo)Then Begin
  If(Got<>Expected)Then Begin
   TestFail(TestName);
   Write('ATTENDU : ''',Got,'''' );
   WriteLn('RECU : ''',Expected,'''');
   Passed:=False;
   MaxFailCheck;
  End
   Else
  TestPass(TestName);
 End;
 IsInteger:=Passed;
End;

Function IsPChar(Const TestName:String;Got,Expected:PChar):Boolean;
Var
 Passed:Boolean;
Begin
 Passed:=True;
 If(Not IsSkipping)and(Not IsTodo)Then Begin
  If(StrComp(Got,Expected)<>0)Then Begin
   TestFail(TestName);
   Write('ATTENDU : ''',Ptr2Str(Got),'''' );
   WriteLn('RECU : ''',Ptr2Str(Expected),'''');
   Passed:=False;
   MaxFailCheck;
  End
   Else
  TestPass(TestName);
 End;
 IsPChar:=Passed;
End;

Function IsPointer(Const TestName:String;Got,Expected:Pointer):Boolean;
Var
 Passed:boolean;
Begin
 Passed:=True;
 If(Not IsSkipping)and(Not IsTodo)Then Begin
  If(Got<>Expected)Then Begin
   TestFail(TestName);
   Write('ATTENDU : ''',Ptr2Str(Got),'''' );
   WriteLn('RECU : ''',Ptr2Str(Expected),'''');
   Passed:=False;
   MaxFailCheck;
  End
   Else
  TestPass(TestName);
 End;
 IsPointer:=Passed;
End;

Function IsReal(Const TestName:String;Got,Expected:Extended):Boolean;
Var
 Passed:Boolean;
Begin
 Passed:=True;
 If(Not IsSkipping)and(Not IsTodo)Then Begin
  If(Abs(Got-Expected)>0.00001)Then Begin
   TestFail(TestName);
   Write('ATTENDU : ''',Got,'''' );
   WriteLn('RECU : ''',Expected,'''');
   Passed:=False;
   MaxFailCheck;
  End
   Else
  TestPass(TestName);
 End;
 IsReal:=Passed;
End;

Function IsString(const TestName,Got,Expected:String):Boolean;
Var
 Passed:boolean;
Begin
  Passed := true;
  If( Not IsSkipping)and(Not IsTodo)Then Begin
   If(Got<>Expected)Then Begin
   TestFail(TestName);
   Write('ATTENDU : ''',Got,'''' );
   WriteLn('RECU : ''',Expected,'''');
   Passed:=False;
   MaxFailCheck;
  End
   Else
  TestPass(TestName);
 End;
 IsString:=Passed;
End;

BEGIN
 MaxFailures:=25;
 TestsPlanned:= 0;
 TestsRun:=0;
 TestsFailed:=0;
 PlanShown:=False;
 RunCount:=0;
 CurrSkipCount:=0;
 CurrSkipMsg:='';
 CurrTodoCount:=0;
 CurrTodoMsg:='';
END.
