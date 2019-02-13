//
//  WalletRewardNodeModel.m
//  VeWallet
//
//  Created by 曾新 on 2018/5/17.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletRewardNodeModel.h"

@implementation WalletRewardNodeModel

+(NSDictionary *)modelContainerPropertyGenericClass
{
   return @{@"nodeReason":[nodeReasonModel class]};
}

@end

@implementation nodeReasonModel

@end

@implementation reasonModel

@end
