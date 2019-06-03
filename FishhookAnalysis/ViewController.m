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
#import "classes/Vehicle.h"
#import "classes/Car.h"
#import <objc/runtime.h>
#import <objc/message.h>
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

void functionForMethod1(id self, SEL _cmd) {
    NSLog(@"%@, %p", self, _cmd);
}


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Class currentClass = [self class];
//    const char *a = object_getClassName(currentClass);
//    for (int i = 1; i < 5; i++) {
//        NSLog(@"Following the isa pointer %d times gives %p---%s", i, currentClass,a);
//        currentClass = object_getClass(currentClass);
//        a = object_getClassName(currentClass);
//    }

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

//    Vehicle* vehicle = [[Vehicle alloc] init];
//    [vehicle performSelector:@selector(fly)];
    
    
//    Car* car = [[Car alloc] init];
//    [car performSelector:@selector(fly)];
    //[self performSelector:@selector(testMethod)];
    [self testForwarding];
}

- (void) testForwarding {
    _objc_msgForward();
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    NSLog(@"%@ 🐶🐶🐶🏃‍♂️",selectorString);
    return [super respondsToSelector:sel];
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"FORWARDING: %@", NSStringFromSelector(aSelector));
    return [super forwardingTargetForSelector:aSelector];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击屏幕");
    NSLog(@"%p %p", self, [self class]);
    NSLog(@"%@", [self methodSignatureForSelector:@selector(viewDidAppear:)]);
}


//- (NSMethodSignature*) methodSignatureForSelector:(SEL)aSelector {
//    NSLog(@"Get Called %@", NSStringFromSelector(aSelector));
//    return [super methodSignatureForSelector:aSelector];
//}

@end
