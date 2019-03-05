//
//  NSMutableDictionary+Helpers.h
//  OntheRoadV3
//
//  Created by Ronnie Xiang on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Helpers)
- (void)setValueIfNotNil:(id)value forKey:(NSString *)key;

- (void)setStringIfNotEmpty:(NSString *)str forKey:(NSString *)key;

- (void)setDataBaseValue:(id)value forKey:(NSString *)key;
- (void)setEmptyStringIfNil:(id)value forKey:(NSString*)key;
@end
