﻿namespace RemObjects.Elements.EUnit;

interface

type
  ResultLock<T> = public class (Lock) 
  public
    method Signal(aResult: T); locked;

    property &Result: T read private write;
  end;

implementation

method ResultLock<T>.Signal(aResult: T);
begin
  self.Result := aResult;
  Signal;
end;

end.    