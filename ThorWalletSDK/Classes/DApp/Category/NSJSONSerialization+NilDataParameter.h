//
//  NSJSONSerialization+NilDataParameter.h
//  OntheRoadV4
//
//  Created by hz on 9/16/14.
//  Copyright (c) 2014 EricHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (NilDataParameter)

+ (id)JSONObjectWithDataMayBeNil:(NSData *)data
                         options:(NSJSONReadingOptions)opt
                           error:(NSError *__autoreleasing *)error;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
