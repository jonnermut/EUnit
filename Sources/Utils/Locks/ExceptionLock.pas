﻿namespace RemObjects.Elements.EUnit;

interface

type
  ExceptionLock = public class (ResultLock<Exception>) 
  public
    method WaitFor; override;
    method WaitFor(Timeout: Integer): Boolean; override;
  end;

implementation

method ExceptionLock.WaitFor;
begin
  inherited;

  if assigned(self.Result) then
    raise self.Result;
end;

method ExceptionLock.WaitFor(Timeout: Integer): Boolean;
begin
  result := inherited WaitFor(Timeout);

  if assigned(self.Result) then
    raise self.Result;
end;

end.    