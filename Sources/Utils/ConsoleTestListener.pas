﻿namespace RemObjects.Elements.EUnit;

interface

uses
  Sugar;

type
  ConsoleTestListener = public class (IEventListener)
  private
    Offset: Integer;
    fEmitParseableMessages: Boolean;
    method StringOffset: String;
    method StateToString(State: TestState): String;
  protected
    method Output(Message: String); virtual;
  public
    method RunStarted(Test: ITest); virtual;
    method TestStarted(Test: ITest); virtual;
    method TestFinished(TestResult: ITestResult); virtual;
    method RunFinished(TestResult: ITestResult); virtual;
    
    constructor (aEmitParseableMessages: Boolean := false);
    begin
      //writeLn("EUNIT_PARSABLE_MESSAGES="+Environment.GetEnvironmentVariable("EUNIT_PARSABLE_MESSAGES"));
      fEmitParseableMessages := aEmitParseableMessages or (length(Environment.GetEnvironmentVariable("EUNIT_PARSABLE_MESSAGES")) > 0);
    end;
  end;

implementation

method ConsoleTestListener.StateToString(State: TestState): String;
begin
  case State of
    TestState.Untested: exit "Untested";
    TestState.Skipped: exit "Skipped";
    TestState.Failed: exit "Failed";
    TestState.Succeeded: exit "Succeeded";
  end;
end;

method ConsoleTestListener.TestFinished(TestResult: ITestResult);
begin
  if TestResult.State = TestState.Skipped then
    exit;

  if TestResult.Test.Kind <> TestKind.Testcase then
      dec(Offset, 2);

  if fEmitParseableMessages then begin
    Output(TestResult.ParsableMessage);
  end
  else begin
    if TestResult.State = TestState.Failed then
      Output(String.Format("{0}{1} finished. State: Failed. Message: {2}", StringOffset, TestResult.Name, TestResult.Message))
    else
      Output(String.Format("{0}{1} finished. State: Succeded.", StringOffset, TestResult.Name));
  end;
  
end;

method ConsoleTestListener.RunStarted(Test: ITest);
begin
  Offset := 0;
end;

method ConsoleTestListener.RunFinished(TestResult: ITestResult);
begin
  Output("======================================");
  var S := new Summary(TestResult, item -> (item.Test.Kind = TestKind.Testcase));
  Output(String.Format("{0} succeeded, {1} failed, {2} skipped, {3} untested", S.Succeeded, S.Failed, S.Skipped, S.Untested));
end;

method ConsoleTestListener.Output(Message: String);
begin
  {$IFNDEF NETFX_CORE}  
  writeLn(Message); 
  {$ELSE}  
  System.Diagnostics.Debug.WriteLine(Message);
  {$ENDIF}
end;

method ConsoleTestListener.TestStarted(Test: ITest);
begin
  if (Test.Kind = TestKind.Testcase) or (Test.Skip) then
    exit;
  
  Output(String.Format("{0}{1} started", StringOffset, Test.Name));
  inc(Offset, 2);
end;

method ConsoleTestListener.StringOffset: String;
begin
  if Offset <= 0 then
    exit "";

  exit new StringBuilder().Append(' ', Offset).ToString;
end;

end.