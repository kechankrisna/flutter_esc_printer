#import "FlutterEscPrinterPlugin.h"
#if __has_include(<flutter_esc_printer/flutter_esc_printer-Swift.h>)
#import <flutter_esc_printer/flutter_esc_printer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_esc_printer-Swift.h"
#endif

@implementation FlutterEscPrinterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterEscPrinterPlugin registerWithRegistrar:registrar];
}
@end
