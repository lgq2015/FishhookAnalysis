//
//  ViewController.m
//  FishhookAnalysis
//
//  Created by 刘宇轩 on 2019/4/30.
//  Copyright © 2019 yuxuanliu. All rights reserved.
//

#include <mach-o/dyld.h>
#import "ViewController.h"
#import "fishhook.h"
#import <objc/runtime.h>
static void (*originalNSLog)(NSString *format, ...);
static void (*originalNSLog2)(NSString *format, ...);

void hookedNSLog(NSString *format, ...) {
    NSString* hookedString = [format stringByAppendingString:@"  Hooked!! 🐶🐶"];
    originalNSLog(hookedString);
}

void newHookedNSLog(NSString *format, ...) {
    NSString* hookedString = [format stringByAppendingString:@"  Hooked!! 🐶🐶🐶🐶"];
    originalNSLog2(hookedString);
}


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SEL sel1 = @selector(method1);
    NSLog(@"sel : %p", sel1);
//    struct rebinding nslogBind;
//    nslogBind.name = "NSLog";
//    nslogBind.replacement = hookedNSLog;
//    nslogBind.replaced = (void *)&originalNSLog;
//
//    printf("%d %p %p \n",_dyld_image_count(),
//                        _dyld_get_image_header(1),
//                        _dyld_get_image_vmaddr_slide(1));
//    printf("%p \n", &a);
//    struct rebinding rebs[] = {nslogBind};
//    rebind_symbols(rebs, 1);
    NSLog(@" class address %p ", [self class]);

}

+ (void) classMethod {
    NSLog(@" class %p ", self);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击屏幕");
    [ViewController classMethod];
    NSLog(@"%p %p", self, [self class]);
}


@end
