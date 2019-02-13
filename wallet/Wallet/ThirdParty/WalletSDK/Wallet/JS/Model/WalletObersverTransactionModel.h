//
//  WalletObersverTransactionModel.h
//  VeWallet
//
//  Created by 曾新 on 2018/8/20.
//  Copyright © 2018年 VeChain. All rights reserved.
//

//#import <ethers/ethers.h>
#import "WalletAddressAuthModel.h"
typedef enum {
    QRCodeVetType = 0,          // 冷钱包或者观察钱包 vet 转账 【交易预览】
    
    QRCodeTokenType = 1,        // 冷钱包或者观察钱包 vet 代币转账 【交易预览】
    
    QRCodeNormalAuthType = 2,   //普通钱包地址授权
    
    QRCodeObserverAuthType = 3, //观察钱包地址授权
    
    QRCodeNormalTranfer = 4,    // 正常转账页面
    
    QRCodeUnKnowType = 5,       // 未知类型
    
    QRCodeObserverSignType = 6, //观察钱包签名
    
    
}QRCodeAddressType;

@interface WalletObersverTransactionModel : NSObject

@property (nonatomic, copy)NSString *amount;//币的数量
@property (nonatomic, copy)NSString *cost;
@property (nonatomic, copy)NSString *tokenAddress; //合约地址
@property (nonatomic, copy)NSString *gas;
@property (nonatomic, copy)NSString *gasPriceCoef;
@property (nonatomic, copy)NSNumber *decimals;
@property (nonatomic, copy)NSString *to; //收款地址
@property (nonatomic, copy)NSString *from; //付款地址，授权地址
@property (nonatomic, copy)NSString *nonce;
@property (nonatomic, copy)NSString *symbol; //币类型
@property (nonatomic, copy)NSString *chainTag;
@property (nonatomic, copy)NSString *blockRef;
@property (nonatomic, copy)NSString *expiration;

@property (nonatomic, copy)NSString *ico;// 0 不是ico，1 是ico
@property (nonatomic, assign)QRCodeAddressType addressType; //返回类型


//地址授权相关
@property (nonatomic, strong)WalletAddressAuthModel *addressAuth;

@end
