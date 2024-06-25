#import "CwSharedExternalPlugin.h"
#if __has_include(<wow_cw_shared_external/wow_cw_shared_external-Swift.h>)
#import <wow_cw_shared_external/wow_cw_shared_external-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "wow_cw_shared_external-Swift.h"
#endif

@implementation CwSharedExternalPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCwSharedExternalPlugin registerWithRegistrar:registrar];
}
@end
