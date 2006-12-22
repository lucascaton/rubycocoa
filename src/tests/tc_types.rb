#
#  Copyright (c) 2006 Laurent Sansonetti, Apple Computer Inc.
#

require 'test/unit'
require 'osx/cocoa'

class TC_Types < Test::Unit::TestCase

  def test_auto_boolean_conversion_objc
    s1 = OSX::NSString.alloc.initWithString("foo")
    s2 = s1.copy
    s3 = OSX::NSString.alloc.initWithString("bar")
    assert_equal(true, s1.isEqualToString(s2))
    assert_equal(true, s1.isEqualToString?(s2))
    assert_equal(false, s1.isEqualToString(s3))
    assert_equal(false, s1.isEqualToString?(s3))
  end

  def test_auto_boolean_conversion_c
    str = OSX::CFStringCreateWithCString(OSX::KCFAllocatorDefault, 'foobar', OSX::KCFStringEncodingASCII)
    assert_equal(true, OSX::CFStringHasPrefix(str, 'foo'))
    assert_equal(false, OSX::CFStringHasPrefix(str, 'bar'))
  end

  def test_char_conversion
    v = OSX::NSNumber.numberWithChar(?v)
    assert_equal(?v, v.charValue)
  end

  def test_uchar_conversion
    v = OSX::NSNumber.numberWithUnsignedChar(?v)
    assert_equal(?v, v.unsignedCharValue)
  end

  def test_short_conversion
    v = OSX::NSNumber.numberWithShort(42)
    assert_equal(42, v.shortValue)
  end

  def test_ushort_conversion
    v = OSX::NSNumber.numberWithUnsignedShort(42)
    assert_equal(42, v.unsignedShortValue)
  end

  def test_int_conversion
    v = OSX::NSNumber.numberWithInt(42)
    assert_equal(42, v.intValue)
  end

  def test_float_conversion
    v = OSX::NSNumber.numberWithFloat(42.42)
    assert((42.42 - v.floatValue).abs < 0.01)
  end

  def test_nsrect
    rect = OSX::NSRect.new
    assert_equal(0, rect.origin.x)
    assert_equal(0, rect.origin.y)
    assert_equal(0, rect.size.width)
    assert_equal(0, rect.size.height)
    assert_equal(OSX::NSZeroRect.to_a.flatten.map { |x| x.to_i }, rect.to_a.flatten.map { |x| x.to_i })
    rect = OSX::NSRect.new(OSX::NSPoint.new(1, 2), OSX::NSSize.new(3, 4))
    assert_equal(1, rect.origin.x)
    assert_equal(2, rect.origin.y)
    assert_equal(3, rect.size.width)
    assert_equal(4, rect.size.height)
    rect = OSX::NSRect.new(1, 2, 3, 4)
    assert_equal(1, rect.origin.x)
    assert_equal(2, rect.origin.y)
    assert_equal(3, rect.size.width)
    assert_equal(4, rect.size.height)
    assert_equal([[1, 2], [3, 4]], rect.to_a)
    rect.origin.x = 42
    rect.origin.y = 43
    assert_equal(42, rect.origin.x)
    assert_equal(43, rect.origin.y)
    assert_equal(rect, OSX::NSRectFromString('{{42, 43}, {3, 4}'))
    assert_equal('{{42, 43}, {3, 4}}', OSX::NSStringFromRect(rect).to_s)
  end

  def test_nssize
    size = OSX::NSSize.new
    assert_equal(0, size.width)
    assert_equal(0, size.height)
    assert_equal(OSX::NSZeroSize, size)
    size.width = 42
    size.height = 43
    assert_equal([42, 43], size.to_a)
    assert_equal(size, OSX::NSSize.new(42, 43))
    assert_equal(size, OSX::NSSizeFromString('{42, 43}'))
    assert_equal('{42, 43}', OSX::NSStringFromSize(size).to_s)
  end

  def test_nsrange
    range = OSX::NSRange.new
    assert_equal(0, range.location)
    assert_equal(0, range.length)
    assert_equal(OSX::NSRange.new(0, 0), range)
    range = OSX::NSRange.new(2..6)
    assert_equal(2, range.location)
    assert_equal(5, range.length)
    assert_equal(2..6, range.to_range)
    range = OSX::NSRange.new(2, 10)
    assert_equal(2, range.location)
    assert_equal(10, range.length)
    assert_equal([2, 10], range.to_a)
    range.location = 42
    range.length = 43
    assert_equal(42, range.location)
    assert_equal(43, range.length)
  end

  def test_bool_nsnumber
    d = OSX::NSMutableDictionary.alloc.init
    d.setValue_forKey(true, 'true')
    d.setValue_forKey(false, 'false')
    d.setValue_forKey(123, '123')
    assert_kind_of(OSX::NSCFBoolean, d.objectForKey('true'))
    assert_kind_of(OSX::NSCFBoolean, d.objectForKey('false'))
    assert_kind_of(OSX::NSDecimalNumber, d.objectForKey('123'))
  end

  def test_cftypes
    str = OSX::NSString.alloc.initWithCString_encoding('foo', OSX::NSASCIIStringEncoding)
    assert_equal(3, str.length)
    assert_equal(3, OSX::CFStringGetLength(str))
    str2 = OSX::CFStringCreateWithCString(OSX::KCFAllocatorDefault, 'foo', OSX::KCFStringEncodingASCII)
    assert_kind_of(OSX::NSString, str2)
    assert_equal(3, str2.length)
    assert_equal(3, OSX::CFStringGetLength(str2))
    assert(str.isEqualToString(str2))
    assert(OSX::CFEqual(str, str2))
    url = OSX::CFURLCreateWithString(OSX::KCFAllocatorDefault, 'http://www.google.com', nil)
    assert_kind_of(OSX::NSURL, url)
    assert_equal(url.path, OSX::CFURLCopyPath(url))
  end

  def test_cftype_proxies
    assert_kind_of(OSX::CFRunLoopRef, OSX::CFRunLoopGetCurrent())
  end

  def test_opaque_boxed
    z = OSX::NSDefaultMallocZone()
    assert_kind_of(OSX::NSZone, z)
    assert_kind_of(OSX::Boxed, z)
    assert_kind_of(OSX::NSString, OSX::NSZoneName(z))
  end
end