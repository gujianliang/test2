//
//  WalletBaseConfigModel.m
//  VeWallet
//
//  Created by 曾新 on 2018/5/29.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletBaseConfigModel.h"

@implementation WalletBaseConfigModel
+(NSDictionary *)modelContainerPropertyGenericClass
{
   return @{@"walletInfo":[walletInfoModel class]};
}
@end

@implementation walletInfoModel
@end
