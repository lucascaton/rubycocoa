/* 
 * Copyright (c) 2006-2008, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

#import "RBClassUtils.h"
#import <Foundation/Foundation.h>

#import <objc/objc.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>

#import "RBObject.h"
#import "OverrideMixin.h"
#import "ocdata_conv.h"

// XXX: the NSMutableDictionary-based hashing methods should be rewritten
// to use st_table, which is 1) faster and 2) independent from ObjC (no need
// to create autorelease pools etc...).

Class objc_class_alloc(const char* name, Class super_class)
{
  Class klass = objc_getClass(name);
  if (klass != NULL) {
	rb_warn("An Objective-C class with name `%s' already exists. Using the existing class instead of a new Ruby class representation.", name);
    return klass;
  }
  return objc_allocateClassPair(super_class, name, 0);
}

/**
 * Dictionary for Ruby class (key by name)
 **/
static NSMutableDictionary* class_dic_by_name()
{
  static NSMutableDictionary* dic = nil;
  if (!dic) dic = [[NSMutableDictionary alloc] init];
  return dic;
}

/**
 * Dictionary for Ruby class (key by value)
 **/
static NSMutableDictionary* class_dic_by_value()
{
  static NSMutableDictionary* dic = nil;
  if (!dic) dic = [[NSMutableDictionary alloc] init];
  return dic;
}

static NSMutableDictionary* derived_class_dic()
{
  static NSMutableDictionary* dic = nil;
  if (!dic) dic = [[NSMutableDictionary alloc] init];
  return dic;
}

@interface RBClassMapInfo : NSObject {
  NSString* kls_name;
  NSNumber* kls_value;
}
- (id)initWithName:(const char*)name value:(VALUE) kls;
- (NSString*) name;
- (NSNumber*) value;
@end

@implementation RBClassMapInfo
- (id)initWithName:(const char*)name value:(VALUE) kls {
  self = [self init];
  if (self) {
    kls_name = [[NSString alloc] initWithUTF8String: name];
    kls_value = [[NSNumber alloc] initWithUnsignedLong: kls];
  }
  return self;
}
- (void) dealloc {
  [kls_name release];
  [kls_value release];
  [super dealloc];
}
- (NSString*) name  { return kls_name;  }
- (NSNumber*) value { return kls_value; }
@end

/**
 * add class map entry to dictionaries.
 **/
static void class_map_dic_add (const char* name, VALUE kls)
{
  RBClassMapInfo* info =
    [[RBClassMapInfo alloc] initWithName:name value:kls];
  [class_dic_by_name()  setObject:info forKey: [info name]];
  [class_dic_by_value() setObject:info forKey: [info value]];
  [info release];
}

Class RBObjcClassFromRubyClass (VALUE kls)
{
  id pool;
  NSNumber* kls_value;
  RBClassMapInfo* info;
  Class result = nil;

  pool = [[NSAutoreleasePool alloc] init];

  kls_value = [NSNumber numberWithUnsignedLong: kls];
  info = [class_dic_by_value() objectForKey: kls_value];
  result = NSClassFromString ([info name]);
  [pool release];
  return result;
}

VALUE RBRubyClassFromObjcClass (Class cls)
{
  id pool;
  RBClassMapInfo* info;
  NSString* kls_name;
  VALUE result = Qnil;

  pool = [[NSAutoreleasePool alloc] init];

  kls_name = NSStringFromClass(cls);
  info = [class_dic_by_name() objectForKey: kls_name];
  result = [[info value] unsignedLongValue];
  [pool release];
  return result;
}

Class RBObjcClassNew(VALUE kls, const char* name, Class super_class)
{
  Class c;

  c = objc_class_alloc(name, super_class);
  objc_registerClassPair(c);
  class_map_dic_add (name, kls);
  return c;
}

BOOL is_objc_derived_class(VALUE kls)
{
  id pool;
  BOOL ok;
 
  pool = [[NSAutoreleasePool alloc] init];
  ok = [derived_class_dic() objectForKey:[NSNumber numberWithUnsignedLong:kls]] != nil;
  [pool release];
  return ok;
}

void derived_class_dic_add(VALUE kls)
{
  id pool;
 
  pool = [[NSAutoreleasePool alloc] init];
  [derived_class_dic() setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedLong:kls]];
  [pool release];
}

Class RBObjcDerivedClassNew(VALUE kls, const char* name, Class super_class)
{
  Class c;

  c = objc_class_alloc(name, super_class);

  // init instance variable
  install_ovmix_ivars(c);

  // init instance methods
  install_ovmix_methods(c);

  // init class methods
  install_ovmix_class_methods(c);
  
  // add class to runtime system
  objc_registerClassPair(c);
  class_map_dic_add(name, kls);
  derived_class_dic_add(kls);

  // init hooks
  install_ovmix_hooks(c);

  return c;
}

