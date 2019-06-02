//
//  Vehicle.m
//  FishhookAnalysis
//
//  Created by 刘宇轩 on 2019/6/1.
//  Copyright © 2019 yuxuanliu. All rights reserved.
//

#import "Vehicle.h"
#import <objc/runtime.h>

void functionForFly(id self, SEL _cmd) {
    NSLog(@"%@, %p", self, _cmd);
}


@implementation Vehicle
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"fly"]) {
        NSLog(@" 🐶🐶🥺  ");
        class_addMethod(self.class, @selector(fly), (IMP)functionForFly, "v@:");
    }
    return [super resolveInstanceMethod:sel];
}
@end
