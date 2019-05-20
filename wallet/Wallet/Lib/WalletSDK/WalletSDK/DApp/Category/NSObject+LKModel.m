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
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}



@end
