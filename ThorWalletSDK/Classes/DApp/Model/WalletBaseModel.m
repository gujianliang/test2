//
//  WalletBaseModel.m
//  Wallet
//
//  Created by Tom on 18/4/7.
//  Copyright © VECHAIN. All rights reserved.
//

#import "WalletBaseModel.h"
#import "YYModel.h"

@implementation WalletBaseModel

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
