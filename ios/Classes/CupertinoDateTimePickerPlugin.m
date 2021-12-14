#import "CupertinoDateTimePickerPlugin.h"
#if __has_include(<cupertino_date_time_picker/cupertino_date_time_picker-Swift.h>)
#import <cupertino_date_time_picker/cupertino_date_time_picker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cupertino_date_time_picker-Swift.h"
#endif

@implementation CupertinoDateTimePickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCupertinoDateTimePickerPlugin registerWithRegistrar:registrar];
}
@end
