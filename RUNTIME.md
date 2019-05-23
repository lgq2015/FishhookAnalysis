`Method swizzling`用于改变一个已经存在的 `selector`的实现。这项技术使得在运行时通过改变 `selector` 在类的消息分发列表中的映射从而改变方法的掉用成为可能。

例如：我们想要在一款 iOS app 中追踪每一个视图控制器被用户呈现了几次： 这可以通过在每个视图控制器的 `viewDidAppear:` 方法中添加追踪代码来实现，但这样会大量重复的样板代码。继承是另一种可行的方式，但是这要求所有被继承的视图控制器如`UIViewController`, `UITableViewController`, `UINavigationController` 都在 `viewDidAppear`：实现追踪代码，这同样会造成很多重复代码。 幸运的是，这里有另外一种可行的方式：从 `category` 实现 `Method Swizzling` 。下面是实现方式：


```
#import <objc/runtime.h>

@implementation UIViewController (Tracking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling
- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
}

@end

```







1. 只在 +load 中执行 swizzling 才是安全的。

2. 被 hook 的方法必须是当前类自身的方法，如果把继承来的 IMP copy 到自身上面会存在问题。父类的方法应该在调用的时候使用，而不是 swizzling 的时候 copy 到子类。

3. 被 Swizzled 的方法如果依赖与 cmd ，hook 之后 cmd 发送了变化，就会有问题(一般你 hook 的是系统类，也不知道系统用没用 cmd 这个参数)。

4. 命名如果冲突导致之前 hook 的失效 或者是循环调用。

上述问题中第一条和第四条说的是通常的 MethodSwizzling 是在分类里面实现的, 而分类的 Method 是被Runtime 加载的时候追加到类的 MethodList ，如果不是在 +load 是执行的 Swizzling 一旦出现重名，那么 SEL 和 IMP 不匹配致 hook 的结果是循环调用。

第三条是一个不容易被发现的问题。
我们都知道 Objective-C Method 都会有两个隐含的参数 self, cmd，有的时候开发者在使用关联属性的适合可能懒得声明 (void *) 的 key，直接使用 cmd 变量 objc_setAssociatedObject(self, _cmd, xx, 0); 这会导致对当前IMP对 cmd 的依赖。

一旦此方法被 Swizzling，那么方法的 cmd 势必会发生变化，出现了 bug 之后想必你一定找不到，等你找到之后心里一定会问候那位 Swizzling 你的方法的开发者祖宗十八代安好的，再者如果你 Swizzling 的是系统的方法恰好系统的方法内部用到了 cmd ...~_~（此处后背惊起一阵冷汗）。
