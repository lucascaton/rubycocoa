#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSParagraphStyle(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSLeftTabStopType", INT2NUM(NSLeftTabStopType));
  rb_define_const(mOSX, "NSRightTabStopType", INT2NUM(NSRightTabStopType));
  rb_define_const(mOSX, "NSCenterTabStopType", INT2NUM(NSCenterTabStopType));
  rb_define_const(mOSX, "NSDecimalTabStopType", INT2NUM(NSDecimalTabStopType));
  rb_define_const(mOSX, "NSLineBreakByWordWrapping", INT2NUM(NSLineBreakByWordWrapping));
  rb_define_const(mOSX, "NSLineBreakByCharWrapping", INT2NUM(NSLineBreakByCharWrapping));
  rb_define_const(mOSX, "NSLineBreakByClipping", INT2NUM(NSLineBreakByClipping));
  rb_define_const(mOSX, "NSLineBreakByTruncatingHead", INT2NUM(NSLineBreakByTruncatingHead));
  rb_define_const(mOSX, "NSLineBreakByTruncatingTail", INT2NUM(NSLineBreakByTruncatingTail));
  rb_define_const(mOSX, "NSLineBreakByTruncatingMiddle", INT2NUM(NSLineBreakByTruncatingMiddle));

}
