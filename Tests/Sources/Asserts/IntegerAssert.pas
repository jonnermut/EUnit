﻿namespace EUnit.Tests;

interface

uses
  RemObjects.Elements.EUnit;

type
  IntegerAssert = public class (Test) 
  public
    method AreEqual;
    method AreNotEqual;
    method Greater;
    method GreaterOrEquals;
    method Less;
    method LessOrEquals;
  end;

implementation

method IntegerAssert.AreEqual;
begin
  Assert.AreEqual(1, 1);
  Assert.AreEqual(Int64(2), Int64(2));
  Assert.Throws(->Assert.AreEqual(1, 2)); 
  Assert.Throws(->Assert.AreEqual(Int64(1), Int64(2)));
end;

method IntegerAssert.AreNotEqual;
begin
  Assert.AreNotEqual(1, 2);
  Assert.AreNotEqual(Int64(2), Int64(1));
  Assert.Throws(->Assert.AreNotEqual(1, 1)); 
  Assert.Throws(->Assert.AreNotEqual(Int64(1), Int64(1))); 
end;

method IntegerAssert.Greater;
begin
  Assert.Greater(2, 1);
  Assert.Greater(Int64(2), Int64(1));
  Assert.Throws(->Assert.Greater(1, 1)); 
  Assert.Throws(->Assert.Greater(Int64(1), Int64(1))); 
  Assert.Throws(->Assert.Greater(1, 2)); 
  Assert.Throws(->Assert.Greater(Int64(1), Int64(2))); 
end;

method IntegerAssert.GreaterOrEquals;
begin
  Assert.GreaterOrEquals(2, 1);
  Assert.GreaterOrEquals(Int64(2), Int64(1));
  Assert.GreaterOrEquals(2, 2);
  Assert.GreaterOrEquals(Int64(2), Int64(2));
  Assert.Throws(->Assert.GreaterOrEquals(1, 2)); 
  Assert.Throws(->Assert.GreaterOrEquals(Int64(1), Int64(2))); 
end;

method IntegerAssert.Less;
begin
  Assert.Less(1, 2);
  Assert.Less(Int64(1), Int64(2));
  Assert.Throws(->Assert.Less(1, 1)); 
  Assert.Throws(->Assert.Less(Int64(1), Int64(1))); 
  Assert.Throws(->Assert.Less(2, 1)); 
  Assert.Throws(->Assert.Less(Int64(2), Int64(1))); 
end;

method IntegerAssert.LessOrEquals;
begin
  Assert.LessOrEquals(1, 2);
  Assert.LessOrEquals(Int64(1), Int64(2));
  Assert.LessOrEquals(1, 1);
  Assert.LessOrEquals(Int64(1), Int64(1));
  Assert.Throws(->Assert.LessOrEquals(2, 1)); 
  Assert.Throws(->Assert.LessOrEquals(Int64(2), Int64(1))); 
end;

end.
    