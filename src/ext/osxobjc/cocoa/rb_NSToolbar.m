#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSToolbarWillAddItemNotification;
static VALUE
osx_NSToolbarWillAddItemNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSToolbarWillAddItemNotification);
}

// NSString *NSToolbarDidRemoveItemNotification;
static VALUE
osx_NSToolbarDidRemoveItemNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSToolbarDidRemoveItemNotification);
}

void init_NSToolbar(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSToolbarDisplayModeDefault", INT2NUM(NSToolbarDisplayModeDefault));
  rb_define_const(mOSX, "NSToolbarDisplayModeIconAndLabel", INT2NUM(NSToolbarDisplayModeIconAndLabel));
  rb_define_const(mOSX, "NSToolbarDisplayModeIconOnly", INT2NUM(NSToolbarDisplayModeIconOnly));
  rb_define_const(mOSX, "NSToolbarDisplayModeLabelOnly", INT2NUM(NSToolbarDisplayModeLabelOnly));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSToolbarWillAddItemNotification", osx_NSToolbarWillAddItemNotification, 0);
  rb_define_module_function(mOSX, "NSToolbarDidRemoveItemNotification", osx_NSToolbarDidRemoveItemNotification, 0);
}
