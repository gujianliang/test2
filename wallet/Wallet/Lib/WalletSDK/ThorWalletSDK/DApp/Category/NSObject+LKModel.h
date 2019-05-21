//
//  NSObject+LKModel.h
//  LKDBHelper
//
//  Created by LJH on 13-4-15.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN




@interface NSObject (LKModel)

- (void)setNilValueForKey:(NSString *)key;

- (id)valueForUndefinedKey:(NSString *)key;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
