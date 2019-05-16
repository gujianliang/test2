//
//  NSObject+LKModel.m
//  LKDBHelper
//
//  Created by LJH on 13-4-15.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import "NSObject+LKModel.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation NSObject (LKModel)

#pragma mark - your can overwrite
- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"nil 这种设置到了 int 等基础类型中");
}
- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"你有get方法没实现，key:%@", key);
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"你有set方法没实现，key:%@", key);
}



@end
