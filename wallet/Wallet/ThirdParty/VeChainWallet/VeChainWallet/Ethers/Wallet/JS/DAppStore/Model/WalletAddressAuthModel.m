//
//  WalletAddressAuthModel.m
//  VeWallet
//
//  Created by 曾新 on 2018/7/17.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletAddressAuthModel.h"

@implementation WalletAddressAuthModel



@end

@implementation WalletAuthorizedDataModel

+(NSDictionary *)modelCustomPropertyMapper
{
    return @{@"pdescription":@"description"};
}

- (NSString *)name{  // 第三方平台，业务请求方
    if (_name.length == 0) {
        _name = @"";
    }
    return _name;
}

- (NSString *)pdescription{  // 授权用途
    if (_pdescription.length == 0) {
        _pdescription = @"";
    }
    return _pdescription;
}
@end
