//
//  WalletManageModel.m
//  VCWallet
//
//  Created by 曾新 on 2018/4/18.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "FFBMSTools+NodeModel.h"
#import "WalletManageModel.h"

@implementation WalletManageModel

//+ (NSDictionary *)modelContainerPropertyGenericClass
//{
//    return @{
//             @"tokens" : [WalletTokenModel class]
//             };
//}

- (void)setAddressNodeType:(NSString *)addressNodeType {
    _addressNodeType = addressNodeType;
    
    NSString *nodeType = addressNodeType.uppercaseString;
    
    self.addressNodeTypeImageName = [FFBMSTools convertXnodeImageName:nodeType];
}

@end

@implementation WalletCoinModel


+(NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"pdescription_cn":@"description_cn",
             @"pdescription_en":@"description_en",             
             };
}

@end
