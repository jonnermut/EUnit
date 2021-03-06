﻿namespace RemObjects.Elements.EUnit;

interface

uses
  Sugar,
  Sugar.Collections;

type
  BaseWriter = public abstract class
  protected
    method WriteNode(Node: ITestResult; Filter: Predicate<ITestResult>); virtual;

    method WriteSuite(Item: ITestResult); virtual; abstract;
    method WriteTest(Item: ITestResult); virtual; abstract;
    method WriteTestcase(Item: ITestResult); virtual; abstract;
  public
    constructor(TestResults: ITestResult);

    method &Write(Filter: Predicate<ITestResult>);
    method WriteFull;
    method WriteFailed(TestcaseOnly: Boolean := false);
    method WriteSummary(IncludeAll: Boolean := false);
    method WriteLine(Line: String); virtual; abstract;

    property Items: ITestResult read write; readonly;
  end;

implementation

method BaseWriter.WriteNode(Node: ITestResult; Filter: Predicate<ITestResult>);
begin
  if Node = nil then
    exit;

  if (Filter = nil) or ((Filter <> nil) and Filter(Node)) then
    case Node.Test.Kind of
      TestKind.Suite: WriteSuite(Node);
      TestKind.Test: WriteTest(Node);
      TestKind.Testcase: WriteTestcase(Node);
    end;

  for child in Node.Children do
    WriteNode(child, Filter);
end;

constructor BaseWriter(TestResults: ITestResult);
begin
  ArgumentNilException.RaiseIfNil(TestResults, "TestResults");
  Items := TestResults;
end;

method BaseWriter.Write(Filter: Predicate<ITestResult>);
begin
  WriteNode(Items, Filter);
end;

method BaseWriter.WriteFull;
begin
  WriteNode(Items, nil);
end;

method BaseWriter.WriteFailed(TestcaseOnly: Boolean);
begin
  var Predicate: Predicate<ITestResult>;

  if TestcaseOnly then
    Predicate := item -> (item.Test.Kind = TestKind.Testcase) and (Item.State = TestState.Failed)
  else
    Predicate := item -> Item.State = TestState.Failed;

  WriteNode(Items, Predicate);
end;

method BaseWriter.WriteSummary(IncludeAll: Boolean);
begin
  var Predicate: Predicate<ITestResult> := nil;

  if not IncludeAll then
    Predicate := item -> item.Test.Kind <> TestKind.Suite;

  var S := new Summary(Items, Predicate);
  WriteLine(String.Format("{0} succeeded, {1} failed, {2} skipped, {3} untested", S.Succeeded, S.Failed, S.Skipped, S.Untested));
end;

end.    