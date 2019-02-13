//
//  WalletObersverTransactionModel.m
//  VeWallet
//
//  Created by 曾新 on 2018/8/20.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletObersverTransactionModel.h"

@implementation WalletObersverTransactionModel

- (NSString *)amount{   // 币的数量
    if (_amount.length == 0) {
        _amount = @"";
    }
    return _amount;
}


- (NSString *)tokenAddress{  // 合约地址
    if (_tokenAddress.length == 0) {
        _tokenAddress = @"";
    }
    return _tokenAddress;
}

- (NSString *)to{  // 收款地址
    if (_to.length == 0) {
        _to = @"";
    }
    return _to;
}

- (NSString *)from{  // 付款地址，授权地址
    if (_from.length == 0) {
        _from = @"";
    }
    return _from;
}

- (NSString *)symbol{  // 币类型
    if (_symbol.length == 0) {
        _symbol = @"";
    }
    return _symbol;
}



@end
