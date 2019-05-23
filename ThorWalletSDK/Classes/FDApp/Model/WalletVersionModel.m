//
//  WalletVersionModel.m
//  WalletSDK
//
//  Created by Tom on 2019/5/20.
//  Copyright © 2019 Ethers. All rights reserved.
//

#import "WalletVersionModel.h"

@implementation WalletVersionModel
+(NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"pdescription":@"description"
             };
}

@end
