#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSWorkspaceDidLaunchApplicationNotification;
static VALUE
osx_NSWorkspaceDidLaunchApplicationNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceDidLaunchApplicationNotification, "NSWorkspaceDidLaunchApplicationNotification", nil);
}

// NSString * NSWorkspaceDidMountNotification;
static VALUE
osx_NSWorkspaceDidMountNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceDidMountNotification, "NSWorkspaceDidMountNotification", nil);
}

// NSString * NSWorkspaceDidPerformFileOperationNotification;
static VALUE
osx_NSWorkspaceDidPerformFileOperationNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceDidPerformFileOperationNotification, "NSWorkspaceDidPerformFileOperationNotification", nil);
}

// NSString * NSWorkspaceDidTerminateApplicationNotification;
static VALUE
osx_NSWorkspaceDidTerminateApplicationNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceDidTerminateApplicationNotification, "NSWorkspaceDidTerminateApplicationNotification", nil);
}

// NSString * NSWorkspaceDidUnmountNotification;
static VALUE
osx_NSWorkspaceDidUnmountNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceDidUnmountNotification, "NSWorkspaceDidUnmountNotification", nil);
}

// NSString * NSWorkspaceWillLaunchApplicationNotification;
static VALUE
osx_NSWorkspaceWillLaunchApplicationNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceWillLaunchApplicationNotification, "NSWorkspaceWillLaunchApplicationNotification", nil);
}

// NSString * NSWorkspaceWillPowerOffNotification;
static VALUE
osx_NSWorkspaceWillPowerOffNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceWillPowerOffNotification, "NSWorkspaceWillPowerOffNotification", nil);
}

// NSString * NSWorkspaceWillUnmountNotification;
static VALUE
osx_NSWorkspaceWillUnmountNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceWillUnmountNotification, "NSWorkspaceWillUnmountNotification", nil);
}

// NSString * NSPlainFileType , * NSDirectoryFileType , * NSApplicationFileType;
static VALUE
osx_NSApplicationFileType(VALUE mdl)
{
  return nsresult_to_rbresult(_PRIV_C_PTR, &NSApplicationFileType, "NSApplicationFileType", nil);
}

// NSString * NSFilesystemFileType , * NSShellCommandFileType;
static VALUE
osx_NSShellCommandFileType(VALUE mdl)
{
  return nsresult_to_rbresult(_PRIV_C_PTR, &NSShellCommandFileType, "NSShellCommandFileType", nil);
}

// NSString * NSWorkspaceMoveOperation;
static VALUE
osx_NSWorkspaceMoveOperation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceMoveOperation, "NSWorkspaceMoveOperation", nil);
}

// NSString * NSWorkspaceCopyOperation;
static VALUE
osx_NSWorkspaceCopyOperation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceCopyOperation, "NSWorkspaceCopyOperation", nil);
}

// NSString * NSWorkspaceLinkOperation;
static VALUE
osx_NSWorkspaceLinkOperation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceLinkOperation, "NSWorkspaceLinkOperation", nil);
}

// NSString * NSWorkspaceCompressOperation;
static VALUE
osx_NSWorkspaceCompressOperation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceCompressOperation, "NSWorkspaceCompressOperation", nil);
}

// NSString * NSWorkspaceDecompressOperation;
static VALUE
osx_NSWorkspaceDecompressOperation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceDecompressOperation, "NSWorkspaceDecompressOperation", nil);
}

// NSString * NSWorkspaceEncryptOperation;
static VALUE
osx_NSWorkspaceEncryptOperation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceEncryptOperation, "NSWorkspaceEncryptOperation", nil);
}

// NSString * NSWorkspaceDecryptOperation;
static VALUE
osx_NSWorkspaceDecryptOperation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceDecryptOperation, "NSWorkspaceDecryptOperation", nil);
}

// NSString * NSWorkspaceDestroyOperation;
static VALUE
osx_NSWorkspaceDestroyOperation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceDestroyOperation, "NSWorkspaceDestroyOperation", nil);
}

// NSString * NSWorkspaceRecycleOperation;
static VALUE
osx_NSWorkspaceRecycleOperation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceRecycleOperation, "NSWorkspaceRecycleOperation", nil);
}

// NSString * NSWorkspaceDuplicateOperation;
static VALUE
osx_NSWorkspaceDuplicateOperation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWorkspaceDuplicateOperation, "NSWorkspaceDuplicateOperation", nil);
}

void init_NSWorkspace(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSWorkspaceDidLaunchApplicationNotification", osx_NSWorkspaceDidLaunchApplicationNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDidMountNotification", osx_NSWorkspaceDidMountNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDidPerformFileOperationNotification", osx_NSWorkspaceDidPerformFileOperationNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDidTerminateApplicationNotification", osx_NSWorkspaceDidTerminateApplicationNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDidUnmountNotification", osx_NSWorkspaceDidUnmountNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceWillLaunchApplicationNotification", osx_NSWorkspaceWillLaunchApplicationNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceWillPowerOffNotification", osx_NSWorkspaceWillPowerOffNotification, 0);
  rb_define_module_function(mOSX, "NSWorkspaceWillUnmountNotification", osx_NSWorkspaceWillUnmountNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationFileType", osx_NSApplicationFileType, 0);
  rb_define_module_function(mOSX, "NSShellCommandFileType", osx_NSShellCommandFileType, 0);
  rb_define_module_function(mOSX, "NSWorkspaceMoveOperation", osx_NSWorkspaceMoveOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceCopyOperation", osx_NSWorkspaceCopyOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceLinkOperation", osx_NSWorkspaceLinkOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceCompressOperation", osx_NSWorkspaceCompressOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDecompressOperation", osx_NSWorkspaceDecompressOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceEncryptOperation", osx_NSWorkspaceEncryptOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDecryptOperation", osx_NSWorkspaceDecryptOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDestroyOperation", osx_NSWorkspaceDestroyOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceRecycleOperation", osx_NSWorkspaceRecycleOperation, 0);
  rb_define_module_function(mOSX, "NSWorkspaceDuplicateOperation", osx_NSWorkspaceDuplicateOperation, 0);
}