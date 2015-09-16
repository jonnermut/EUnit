﻿namespace RemObjects.Elements.EUnit;

interface


type
  BaseException = public class({$IF NOUGAT}Foundation.NSException{$ELSE}Exception{$ENDIF})
  public
    constructor (aMessage: String);
  {$IF NOUGAT}
    property Message: String read reason;
  {$ENDIF}
  end;

implementation

constructor BaseException(aMessage: String);
begin
  {$IF NOUGAT}
  result := inherited initWithName('SugarTestException') reason(aMessage) userInfo(nil);
  {$ELSE}
  inherited constructor(aMessage);
  {$ENDIF}
end;

end.