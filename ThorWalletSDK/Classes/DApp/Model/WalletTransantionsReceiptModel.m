//
//  WalletTransantionsReceiptModel.m
//  VeWallet
//
//  Created by Tom on 2018/6/1.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletTransantionsReceiptModel.h"

@implementation WalletTransantionsReceiptModel

+(NSDictionary *)modelContainerPropertyGenericClass
{
   return @{@"outputs":[outputsModel class]};
}
@end

@implementation blockModel

@end

@implementation outputsModel
+(NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"events":[eventsModel class]};
}
@end


@implementation eventsModel

@end


