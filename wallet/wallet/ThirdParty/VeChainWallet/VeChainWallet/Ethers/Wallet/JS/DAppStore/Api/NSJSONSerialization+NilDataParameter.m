//
//  NSJSONSerialization+NilDataParameter.m
//  OntheRoadV4
//
//  Created by hz on 9/16/14.
//  Copyright (c) 2014 EricHuang. All rights reserved.
//

#import "NSJSONSerialization+NilDataParameter.h"

@implementation NSJSONSerialization (NilDataParameter)

+ (id)JSONObjectWithDataMayBeNil:(NSData *)data
                         options:(NSJSONReadingOptions)opt
                           error:(NSError *__autoreleasing *)error
{
    if (data == nil) {
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:opt
                                             error:error];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json：%@  解析失败：%@",jsonString, err);
        return nil;
    }
    return dic;
}
@end
