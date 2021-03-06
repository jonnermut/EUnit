﻿namespace EUnit.Tests;

interface

uses
  RemObjects.Elements.EUnit;

type
  StringAssertTest = public class (Test) 
  public
    method AreEqual;
    method AreNotEqual;
    method Contains;
    method DoesNotContains;
    method StartsWith;
    method EndsWith;
    method IsEmpty;
    method IsNotEmpty;
  end;

implementation

method StringAssertTest.AreEqual;
begin
  Assert.AreEqual("ABC", "ABC");
  Assert.AreEqual("ABC", "ABC", true);
  var S: String := nil;
  Assert.AreEqual(nil, S);
  Assert.AreEqual(nil, S, true);
  Assert.AreEqual("", "");

  Assert.Throws(->Assert.AreEqual("ABc", "ABC"), typeOf(AssertException));
  Assert.AreEqual("ABc", "ABC", true);

  Assert.Throws(->Assert.AreEqual(nil, "abc"));
  Assert.Throws(->Assert.AreEqual(nil, "abc", true));
  Assert.Throws(->Assert.AreEqual("abc", nil));
  Assert.Throws(->Assert.AreEqual("abc", nil, true));
end;

method StringAssertTest.AreNotEqual;
begin
  Assert.AreNotEqual("ABC", "ABc");
  Assert.Throws(->Assert.AreNotEqual("ABC", "ABc", true), typeOf(AssertException));
  Assert.AreNotEqual(nil, "abc");
  Assert.AreNotEqual("abc", nil);
  Assert.AreNotEqual("xyz", "zyx");
  Assert.AreNotEqual("xyz", "zyx", true);

  Assert.Throws(->Assert.AreNotEqual("abc", "abc"), typeOf(AssertException)); 
  Assert.Throws(->Assert.AreNotEqual("abc", "aBc", true), typeOf(AssertException));
  Assert.Throws(->Assert.AreNotEqual(nil, nil), typeOf(AssertException));
end;

method StringAssertTest.Contains;
begin
  Assert.Contains("x", "zxcvbn");
  Assert.Contains("", "abc");
  Assert.Contains("", ""); 
  
  Assert.Throws(->Assert.Contains(nil, "abc"), typeOf(ArgumentNilException)); 
  Assert.Throws(->Assert.Contains("bca", "abc"), typeOf(AssertException));
  Assert.Throws(->Assert.Contains("aBc", "abc"), typeOf(AssertException));
  Assert.Throws(->Assert.Contains("abc", nil), typeOf(ArgumentNilException)); 
end;

method StringAssertTest.DoesNotContains;
begin
  Assert.DoesNotContains("x", "qwerty");
  Assert.DoesNotContains("abc", "aBc");

  Assert.Throws(->Assert.DoesNotContains(nil, "abc"), typeOf(ArgumentNilException)); 
  Assert.Throws(->Assert.DoesNotContains("abc", nil), typeOf(ArgumentNilException));
  Assert.Throws(->Assert.DoesNotContains("abc", "abc"), typeOf(AssertException));
  Assert.Throws(->Assert.DoesNotContains("", ""), typeOf(AssertException));
  Assert.Throws(->Assert.DoesNotContains("", "abc"), typeOf(AssertException)); 
end;

method StringAssertTest.StartsWith;
begin
  Assert.StartsWith("", "abc");
  Assert.StartsWith("a", "abc");
  Assert.StartsWith("", "");

  Assert.Throws(->Assert.StartsWith(nil, "abc"), typeOf(ArgumentNilException)); 
  Assert.Throws(->Assert.StartsWith("a", nil), typeOf(ArgumentNilException));
  Assert.Throws(->Assert.StartsWith("b", "abc"), typeOf(AssertException));
  Assert.Throws(->Assert.StartsWith("A", "abc"), typeOf(AssertException));
end;

method StringAssertTest.EndsWith;
begin
  Assert.EndsWith("", "abc");
  Assert.EndsWith("c", "abc");
  Assert.EndsWith("", "");

  Assert.Throws(->Assert.EndsWith(nil, "abc"), typeOf(ArgumentNilException)); 
  Assert.Throws(->Assert.EndsWith("a", nil), typeOf(ArgumentNilException));
  Assert.Throws(->Assert.EndsWith("b", "abc"), typeOf(AssertException));
  Assert.Throws(->Assert.EndsWith("C", "abc"), typeOf(AssertException));
end;

method StringAssertTest.IsEmpty;
begin
  Assert.IsEmpty("");

  Assert.Throws(->Assert.IsEmpty(nil), typeOf(ArgumentNilException)); 
  Assert.Throws(->Assert.IsEmpty(" "), typeOf(AssertException));
  Assert.Throws(->Assert.IsEmpty("abc"), typeOf(AssertException));
end;

method StringAssertTest.IsNotEmpty;
begin
  Assert.IsNotEmpty(" ");
  Assert.IsNotEmpty("abc");

  Assert.Throws(->Assert.IsNotEmpty(nil), typeOf(ArgumentNilException)); 
  Assert.Throws(->Assert.IsNotEmpty(""), typeOf(AssertException));
end;

end.    