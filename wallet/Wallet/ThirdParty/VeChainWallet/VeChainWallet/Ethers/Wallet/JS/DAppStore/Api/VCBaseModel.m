//
//  VCBaseModel.m
//  Wallet
//
//  Created by 曾新 on 16/4/7.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import "VCBaseModel.h"
//#import "NSObject+RuntimeEx.h"

@implementation VCBaseModel

#pragma mark -
#pragma mark NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:decoder];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self yy_modelEncodeWithCoder:encoder];
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}


+(NSDictionary*)modelCustomPropertyMapper{
    return nil;
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return nil;
}



@end
