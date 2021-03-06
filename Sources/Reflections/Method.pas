﻿namespace RemObjects.Elements.EUnit.Reflections;

interface

uses
  {$IF NETFX_CORE}System.Reflection,{$ENDIF}
  RemObjects.Elements.EUnit;

type
  MethodReference = public class
  private
    Native: NativeMethod;

    method GetName: String;
    method GetHasParameters: Boolean;
    method GetIsVoid: Boolean;
    {$IF COOPER}class method HasMethod(aMethod: NativeMethod; InType: NativeType): Boolean;{$ENDIF}
  public
    constructor(aType: TypeReference; &Method: NativeMethod);

    method Invoke(anInstance: Object);
    method {$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF}; override;

    property Name: String read GetName;
    property IsOverriden: Boolean read write; readonly;
    property HasParameters: Boolean read GetHasParameters;
    property IsVoid: Boolean read GetIsVoid;
    property &Type: TypeReference read write; readonly;
    property NativeMethod: NativeMethod read Native;
  end;

implementation

constructor MethodReference(aType: TypeReference; &Method: NativeMethod);
begin
  if aType = nil then
    raise new ArgumentNilException("Type");

  if &Method = nil then
    raise new ArgumentNilException("Method");

  Native := &Method;
  self.Type := aType;  
  {$IF COOPER}
  IsOverriden := Native.DeclaringClass <> aType.NativeType;

  if not IsOverriden then begin
    var Super := aType.NativeType.getSuperclass;

    while Super <> nil do begin
      if HasMethod(Native, Super) then begin
        IsOverriden := true;
        break;
      end;

      Super := Super.getSuperclass;
    end;
  end;
  {$ELSEIF NETFX_CORE}
  IsOverriden := not aType.EqualsTo(new TypeReference(&Method.GetRuntimeBaseDefinition.DeclaringType));
  {$ELSEIF ECHOES}
  IsOverriden := not aType.EqualsTo(new TypeReference(&Method.GetBaseDefinition.DeclaringType));
  {$ELSEIF NOUGAT}
  var Super := class_getSuperclass(aType.NativeType);
  var MethodSelector := method_getName(Native);
  IsOverriden := false;

  while Super <> nil do begin
    var SuperMethod := method_getImplementation(class_getInstanceMethod(Super, MethodSelector));
    if SuperMethod <> nil then begin
      IsOverriden := true;
      break;
    end;

    Super := class_getSuperclass(Super);
  end;
  {$ENDIF}
end;

method MethodReference.GetName: String;
begin
  {$IF COOPER}
  exit Native.Name;
  {$ELSEIF ECHOES}
  exit Native.Name;
  {$ELSEIF NOUGAT}
  exit Foundation.NSString.stringWithUTF8String(sel_getName(method_getName(self.Native)));
  {$ENDIF}
end;

method MethodReference.GetHasParameters: Boolean;
begin
  {$IF COOPER}
  exit Native.getParameterTypes.length <> 0;
  {$ELSEIF ECHOES}
  exit Native.GetParameters.Length <> 0;
  {$ELSEIF NOUGAT}
  exit method_getNumberOfArguments(self.Native) > 2;
  {$ENDIF}
end;

method MethodReference.GetIsVoid: Boolean;
begin
  {$IF COOPER}
  exit Native.ReturnType.Name.Equals("void");
  {$ELSEIF ECHOES}
  exit Native.ReturnType.Name.Equals("Void");
  {$ELSEIF NOUGAT}
  var MethodSelector := method_getName(self.Native);  
  var Signature := self.Type.NativeType.instanceMethodSignatureForSelector(MethodSelector);

  exit Signature.methodReturnLength = 0;
  {$ENDIF}
end;

method MethodReference.Invoke(anInstance: Object);
begin
  ArgumentNilException.RaiseIfNil(anInstance, "anInstance");

  {$IF COOPER}
  Native.invoke(anInstance, nil);
  {$ELSEIF ECHOES}
  Native.Invoke(anInstance, nil);
  {$ELSEIF NOUGAT}
  var MethodSelector := method_getName(self.Native);
  var Signature := anInstance.methodSignatureForSelector(MethodSelector);
  var Invocation := Foundation.NSInvocation.invocationWithMethodSignature(Signature);
  Invocation.target := anInstance;
  Invocation.selector := MethodSelector;
  Invocation.invoke;
  {$ENDIF}
end;

method MethodReference.{$IF NOUGAT}description: Foundation.NSString{$ELSEIF COOPER}ToString: java.lang.String{$ELSEIF ECHOES}ToString: System.String{$ENDIF};
begin
  exit "Method: " + Name;
end;

{$IF COOPER}
class method MethodReference.HasMethod(aMethod: NativeMethod; InType: NativeType): Boolean;
begin
  var lMethods := InType.getMethods;
  var lParams := aMethod.getParameterTypes;

  for lMethod in lMethods do 
    if (lMethod.Name = aMethod.Name) and (lMethod.ReturnType = aMethod.ReturnType) then begin
      var lMethodParams := lMethod.getParameterTypes;

      if lMethodParams.length <> lParams.length then
        continue;

      if lParams.length = 0 then
        exit true;

      var SameParams: Boolean := false;
      for i: Integer := 0 to lParams.length - 1 do
        if not lParams[i].equals(lMethodParams[i]) then begin
          SameParams := true;
          break;
        end;

      if not SameParams then
        continue;

      exit true;
    end;

  exit false;
end;
{$ENDIF}

end.