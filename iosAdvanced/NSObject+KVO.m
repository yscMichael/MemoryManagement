//
//  NSObject+KVO.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const YYKVOClassPrefix = @"YYKVOClassPrefix_";
NSString *const YYKVOAssociatedObservers = @"YYKVOAssociatedObservers";


@interface YYObservationInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) YYObserverBlock block;

@end

@implementation YYObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key block:(YYObserverBlock)block
{
    self = [super init];
    if (self)
    {
        _observer = observer;
        _key = key;
        _block = block;
    }
    return self;
}

@end

@implementation NSObject (KVO)

//简单介绍一下步骤:
//1、检查对象的类有没有相应的setter方法,如果没有抛出异常;
//   这里是查看Tomato的price是否已经实现了setter方法
//
//2、检查对象isa指向的类是不是一个KVO类.如果不是,新建一个继承原来类的子类,并把isa指向这个新建的子类
//   这里是新建YYKVOClassPrefix_Tomato(继承自Tomato)
//
//3、检查对象的KVO类重写过没有这个setter方法.如果没有,添加重写的setter方法;
//   这里是检查YYKVOClassPrefix_Tomato
//
//4、添加这个观察者
//   这里是根据YYKVOAssociatedObservers找到对应的数组NSMutableArray
//   将YYObservationInfo添加到NSMutableArray
//
//5、移除观察者
//   这里是根据YYKVOAssociatedObservers找到对应的数组NSMutableArray
//   将YYObservationInfo从NSMutableArray移除

#pragma mark - 添加观察者
- (void)YY_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(YYObserverBlock)block
{
    //1、检查对象的类有没有相应的setter方法.如果没有抛出异常;
    //查看Tomato的price是否已经实现了setter方法
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);

    if (!setterMethod)
    {//1.1、没有setter方法
        //这里直接不往下进行,因为你连setter方法都没有,根本无法使用
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];

        return;
    }

    //2、检查对象isa指向的类是不是一个KVO类.
    //如果不是,新建一个继承原来类的子类,并把isa指向这个新建的子类
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);//当前是Tomato

    if (![clazzName hasPrefix:YYKVOClassPrefix])
    {
        NSLog(@"Tomato不是KVO类");
        //2.1、新建一个继承自Tomato的子类
        clazz = [self makeKvoClassWithOriginalClassName:clazzName];//YYKVOClassPrefix_Tomato
        //将Tomato设置为YYKVOClassPrefix_Tomato
        //返回对象为当前类(Tomato)
        object_setClass(self, clazz);
    }

    //3、检查对象的KVO类重写过没有这个setter方法.如果没有,添加重写的setter方法;
    //此时的self指向YYKVOClassPrefix_Tomato
    if (![self hasSelector:setterSelector])
    {
        NSLog(@"没有set方法");
        const char *types = method_getTypeEncoding(setterMethod);
        //添加setter方法
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
    }

    //4、添加这个观察者
    //observer:ViewController
    //     key:price
    //   block:任务
    YYObservationInfo *info = [[YYObservationInfo alloc] initWithObserver:observer Key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(YYKVOAssociatedObservers));
    if (!observers)
    {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(YYKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    NSLog(@"观察者添加成功");
    [observers addObject:info];
}

#pragma mark - 移除观察者
- (void)YY_removeObserver:(NSObject *)observer forKey:(NSString *)key
{
    NSMutableArray* observers = objc_getAssociatedObject(self, (__bridge const void *)(YYKVOAssociatedObservers));

    YYObservationInfo *infoToRemove;
    for (YYObservationInfo* info in observers)
    {
        if (info.observer == observer && [info.key isEqual:key])
        {
            NSLog(@"观察者移除成功");
            infoToRemove = info;
            break;
        }
    }

    [observers removeObject:infoToRemove];
}

#pragma mark - 获取setter方法名称
//这里是setPrice
static NSString * setterForGetter(NSString *getter)
{
    if (getter.length <= 0)
    {
        return nil;
    }
    //upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];

    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];

    return setter;
}

#pragma mark - 新建一个子类
//YYKVOClassPrefix_Tomato(继承自Tomato)
- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClazzName
{
    //1、检查YYKVOClassPrefix_Tomato这个类是否存在
    NSString *kvoClazzName = [YYKVOClassPrefix stringByAppendingString:originalClazzName];//YYKVOClassPrefix_Tomato
    Class clazz = NSClassFromString(kvoClazzName);
    NSLog(@"clazz = %@",clazz);//这里clazz为null(因为当前没有这个类)

    if (clazz)
    {
        //有这个类就返回
        return clazz;
    }

    //2、不存在YYKVOClassPrefix_Tomato这个类,就需要创建
    Class originalClazz = object_getClass(self);

    //2.1、创建YYKVOClassPrefix_Tomato类
    /*objc_allocateClassPair(Class _Nullable superclass, const char * _Nonnull name,size_t extraBytes)
     *
     * superclass: 父类
     * name: 继承类名称
     * extraBytes: 大小
     */
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);//YYKVOClassPrefix_Tomato

    //2.2、为YYKVOClassPrefix_Tomato添加class方法,IMP指向kvo_class
    //获取原始类的class方法
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);

    //2.3、注册YYKVOClassPrefix_Tomato
    //应该和objc_allocateClassPair配对使用
    objc_registerClassPair(kvoClazz);

    return kvoClazz;
}

#pragma mark - 新的class方法
//YYKVOClassPrefix_Tomato的class方法
static Class kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}

#pragma mark - 判断是否含有某个方法
- (BOOL)hasSelector:(SEL)selector
{
    //当前的这个类是YYKVOClassPrefix_Tomato
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++)
    {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector)
        {
            free(methodList);
            return YES;
        }
    }

    free(methodList);
    return NO;
}

#pragma mark - 重写setter方法
static void kvo_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);//setPrice
    NSString *getterName = getterForSetter(setterName);//price

    if (!getterName)
    {//没有getter方法直接报错
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }

    id oldValue = [self valueForKey:getterName];

    struct objc_super superclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };

    //这里是因为objc_msgSendSuper不做类型转化,xcode6会报错
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    //调用父类的setter方法
    objc_msgSendSuperCasted(&superclazz, _cmd, newValue);
    //查看观察者,调用blocks
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(YYKVOAssociatedObservers));
    for (YYObservationInfo *each in observers)
    {
        if ([each.key isEqualToString:getterName])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                each.block(self, getterName, oldValue, newValue);
            });
        }
    }
}

#pragma mark - 获取getter方法
//这里是- (NSString *)price
static NSString * getterForSetter(NSString *setter)
{
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"])
    {
        return nil;
    }

    //remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];

    //lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];

    return key;
}

@end



