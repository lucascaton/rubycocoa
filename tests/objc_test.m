// $Id$
//
//   some tests require objc codes
#import <Foundation/Foundation.h>

@interface RBExceptionTestBase : NSObject
{
}
@end

@implementation RBExceptionTestBase
-(NSException *)testExceptionRoundTrip
{   
  NSException *result = nil;
  NS_DURING
      // defined in test/tc_exception.rb
      [self performSelector:@selector(testExceptionRaise)]; 
  NS_HANDLER
      result = localException;
  NS_ENDHANDLER
  return result;
}
@end

@interface Override : NSObject
{
}
@end

@implementation Override
-(int) foo
{   
  return 321;
}
@end

@interface RetainCount : NSObject
{
}
@end

@implementation RetainCount

+(int) rbAllocCount
{
  int retainCount;
  id obj;
  obj = [NSClassFromString(@"RBSubclass") alloc];
  retainCount = [obj retainCount];
  [obj release];
  return retainCount;
}

+(id) ocObjectFromPlaceholder
{
  return [[NSMutableString alloc] init];
}

+(int) rbInitCount
{
  int retainCount;
  id obj;
  obj = [[NSClassFromString(@"RBSubclass") alloc] init];
  retainCount = [obj retainCount];
  [obj release];
  return retainCount;
}

+(id) ocObject
{
  return [[NSObject alloc] init];
}

+(id) rbObject
{
  return [[NSClassFromString(@"RBSubclass") alloc] init];
}

@end

// tc_uniqobj.rb
@interface UniqObjC : NSObject
@end

@implementation UniqObjC

- (void)start:(id)o
{
    [o retain];
}

- (id)pass:(id)o
{
    return o;
}

- (void)end:(id)o
{
    [o release];
}

@end

// tc_passbyref.rb
@interface PassByRef : NSObject
@end

@implementation PassByRef

- (BOOL)passByRefObject:(id *)obj
{
    if (obj != NULL) {
        *obj = self;
        return YES;
    }
    return NO;
}

- (BOOL)passByRefInteger:(int *)integer
{
    if (integer != NULL) {
        *integer = 666;
        return YES;
    }
    return NO;
}

- (BOOL)passByRefFloat:(float *)floating
{
    if (floating != NULL) {
        *floating = 666.0;
        return YES;
    }
    return NO;
}

- (void)passByRefVarious:(id *)object integer:(int *)integer floating:(float *)floating
{
    if (object != NULL)
        *object = self;
    if (integer != NULL)
        *integer = 666;
    if (floating != NULL)
        *floating = 666.0;
}

@end

// tc_subclass.rb 
@interface __SkipInternalClass : NSData
@end
@implementation __SkipInternalClass {
}
@end

@interface SkipInternalClass : __SkipInternalClass
@end
@implementation SkipInternalClass {
}
@end

@interface CallerClass : NSObject
@end

@interface NSObject (TcSubclassFoo)

- (int)calledFoo:(id)arg;

@end

@implementation CallerClass

- (id)callFoo:(id)receiver
{
    return (id)[receiver calledFoo:nil];
}

@end

@protocol Helper
- (char) testChar:(char) i;
- (int) testInt:(int) i;
- (short) testShort:(short) i;
- (long) testLong:(long) i;
- (float) testFloat:(float) f;
- (double) testDouble:(double) d;
- (long long)testLongLong:(long long)ll;
- (id)foo1;
- (int)foo2:(int)i;
- (void)foo3:(id)ary obj:(id)obj;
- (NSRect)foo4:(NSPoint)point size:(NSSize)size;
@end

@interface TestRig : NSObject { }
- (void) run;
@end

@interface TestObjcExport : NSObject
@end

@implementation TestObjcExport

- (void) run
{
    Class helperClass = NSClassFromString(@"ObjcExportHelper");
    id helper = [[helperClass alloc] init];

    id s = [helper foo1];
    if (![s isKindOfClass:[NSString class]] || ![s isEqualToString:@"s"])
      [NSException raise:@"TestObjCExportError" format:@"assertion foo1 failed, expected %@, got %@", @"s", s];

    int i = [helper foo2:40];
    if (i != 42)
      [NSException raise:@"TestObjCExportError" format:@"assertion foo2 failed, expected %d, got %d", 42, i];

    id ary = [NSMutableArray array];
    id o = [[NSObject alloc] init];
    [helper foo3:ary obj:o];
    if ([ary count] != 1 || [ary objectAtIndex:0] != o)
      [NSException raise:@"TestObjCExportError" format:@"assertion foo3 failed, object %@ is not in array %@", o, ary];

    NSRect r = [helper foo4:NSMakePoint(1, 2) size:NSMakeSize(3, 4)];
    if (r.origin.x != 1 || r.origin.y != 2 || r.size.width != 3 || r.size.height != 4)
      [NSException raise:@"TestObjCExportError" format:@"assertion foo4 failed, expected %@, got %@", NSStringFromRect(NSMakeRect(1, 2, 3, 4)), NSStringFromRect(r)];
}

@end

@implementation TestRig

- (void) run 
{
    Class helperClass = NSClassFromString(@"RigHelper");
    id helper = [[helperClass alloc] init];

    id name = [helper name];
    if (![name isKindOfClass:[NSString class]] || ![name isEqualToString:@"helper"])
      [NSException raise:@"TestRigError" format:@"assertion name failed, expected %@, got %@", @"helper", name];

    char c = [helper testChar:2];
    if (c != 2)
      [NSException raise:@"TestRigError" format:@"assertion testChar: failed, expected %d, got %d", 2, c];

    int i = [helper testInt:2];
    if (i != 2)
      [NSException raise:@"TestRigError" format:@"assertion testInt: failed, expected %d, got %d", 2, i];

    short s = [helper testShort:2];
    if (s != 2)
      [NSException raise:@"TestRigError" format:@"assertion testShort: failed, expected %hd, got %hd", 2, s];

    long l = [helper testLong:2];
    if (l != 2)
      [NSException raise:@"TestRigError" format:@"assertion testLong: failed, expected %ld, got %ld", 2, l];

    float f2 = 3.141592;
    float f = [helper testFloat:f2];
    if (f != f2)
      [NSException raise:@"TestRigError" format:@"assertion testFloat: failed, expected %f, got %f", f2, f];

    double d2 = 6666666.666;
    double d = [helper testDouble:d2];
    if (d != d2)
      [NSException raise:@"TestRigError" format:@"assertion testDouble: failed, expected %lf, got %lf", d2, d];

    long long ll2 = 1000000000;
    long long ll = [helper testLongLong:ll2];
    if (ll != ll2)
      [NSException raise:@"TestRigError" format:@"assertion testLongLong: failed, expected %lld, got %lld", ll2, ll];
}

@end

@interface TestRBObject : NSObject
@end

@implementation TestRBObject

- (long)addressOfObject:(id)obj
{
  return (long)obj;
}

@end

@interface DirectOverride : NSObject
@end

@implementation DirectOverride

- (id)overrideMe
{
  return nil;
}

@end

void Init_objc_test(){
  // dummy initializer for ruby's `require'
}