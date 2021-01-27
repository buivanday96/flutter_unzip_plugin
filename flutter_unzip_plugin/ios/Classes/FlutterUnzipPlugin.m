#import "FlutterUnzipPlugin.h"
#if __has_include(<flutter_unzip_plugin/flutter_unzip_plugin-Swift.h>)
#import <flutter_unzip_plugin/flutter_unzip_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_unzip_plugin-Swift.h"
#endif

@implementation FlutterUnzipPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterUnzipPlugin registerWithRegistrar:registrar];
}
@end
