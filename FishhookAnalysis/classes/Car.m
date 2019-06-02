//
//  Car.m
//  FishhookAnalysis
//
//  Created by 刘宇轩 on 2019/6/1.
//  Copyright © 2019 yuxuanliu. All rights reserved.
//

#import "Car.h"

@implementation Car
+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    NSString *selectorString = NSStringFromSelector(sel);
//    if ([selectorString isEqualToString:@"fly"]) {
//        NSLog(@" Subclass Resolve ");
//    }
    return NO;
}
@end
