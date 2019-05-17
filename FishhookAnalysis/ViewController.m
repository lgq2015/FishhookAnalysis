//
//  ViewController.m
//  FishhookAnalysis
//
//  Created by 刘宇轩 on 2019/4/30.
//  Copyright © 2019 yuxuanliu. All rights reserved.
//

#import "ViewController.h"
#import "fishhook.h"
#import <objc/runtime.h>
static void (*originalNSLog)(NSString *format, ...);
void hookedNSLog(NSString *format, ...) {
    NSString* hookedString = [format stringByAppendingString:@"  Hooked!! 🐶🐶"];
    originalNSLog(hookedString);
}

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", [self class]);
    NSLog(@"%@", [object_getClass(self) class]);
    
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(serialQueue, dispatch_get_main_queue());
    
    UIView* aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    aView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:aView];
    
    dispatch_async(serialQueue, ^{
        dispatch_suspend(serialQueue);
        NSLog(@"first");
        [UIView animateWithDuration:2.0 animations:^{
            aView.center = CGPointMake(aView.center.x, aView.center.y + 100);
        } completion:^(BOOL finished) {
            NSLog(@"first end");
            dispatch_resume(serialQueue);
        }];
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"PRINT RANDOM THING");
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"second");
        [UIView animateWithDuration:2.0 animations:^{
            aView.center = CGPointMake(aView.center.x + 100, aView.center.y);
        } completion:^(BOOL finished) {
            NSLog(@"asas");
        }];
    });
    
    
   
}

@end
