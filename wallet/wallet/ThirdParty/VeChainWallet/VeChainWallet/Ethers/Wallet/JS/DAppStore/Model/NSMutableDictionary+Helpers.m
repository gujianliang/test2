//
//  NSMutableDictionary+Helpers.m
//  OntheRoadV3
//
//  Created by Ronnie Xiang on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSMutableDictionary+Helpers.h"

@implementation NSMutableDictionary (Helpers)
- (void)setValueIfNotNil:(id)value forKey:(NSString *)key {
    if (value != nil && value != NULL) {
        [self setValue:value forKey:key];
    }
}

- (void)setStringIfNotEmpty:(NSString *)str forKey:(NSString *)key
{
    if ([str length] > 0) {
        [self setValue:str forKey:key];
    }
}

-(void)setDataBaseValue:(id)value forKey:(NSString *)key {
    if (nil == value) {
        [self setValue:[NSNull null] forKey:key];
    }else{
        [self setValue:value forKey:key];
    }
}

-(void)setEmptyStringIfNil:(id)value forKey:(NSString*)key
{
    if (nil == value) {
        [self setValue:@"" forKey:key];
    }else{
        [self setValue:value forKey:key];
    }
}
@end
