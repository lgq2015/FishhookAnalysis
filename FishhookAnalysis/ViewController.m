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
    NSLog(@"Start");
    struct rebinding nslogBind;
    nslogBind.name = "NSLog";
    nslogBind.replacement = hookedNSLog;
    nslogBind.replaced = (void *)&originalNSLog;
    
    printf("%d %p %p \n",_dyld_image_count(),
                        _dyld_get_image_header(0),
                        _dyld_get_image_vmaddr_slide(0));
    
    struct rebinding rebs[] = {nslogBind};
    rebind_symbols(rebs, 1);
    
//    struct rebinding nslogBind2;
//    nslogBind2.name = "NSLog";
//    nslogBind2.replacement = newHookedNSLog;
//    nslogBind2.replaced = (void *)&originalNSLog2;
//    struct rebinding rebs2[] = {nslogBind2};
//    rebind_symbols(rebs2, 1);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击屏幕");
}


@end
