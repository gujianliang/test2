//
//  WalletAddressAuthModel.h
//  VeWallet
//
//  Created by 曾新 on 2018/7/17.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseModel.h"
@class WalletAuthorizedDataModel;

@interface WalletAddressAuthModel : VCBaseModel

@property (nonatomic, copy)NSString *type; //给多类型提示
@property (nonatomic, strong)WalletAuthorizedDataModel *authorizedData;
@property (nonatomic, copy)NSString *address;//为空，不指定地址，不为空，指定地址
@property (nonatomic, copy)NSString *sign;// 签名信息
@property (nonatomic, copy)WalletAuthorizedDataModel *data;// copy authorizedData
@property (nonatomic, strong)NSString *status; //2 pending, -1 fail, 1 success

@end


@interface WalletAuthorizedDataModel : VCBaseModel

@property (nonatomic, copy)NSString *enterpriseName;
@property (nonatomic, copy)NSString *authKey;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *pdescription;
@property (nonatomic, copy)NSNumber *expire;
@property (nonatomic, copy)NSString *randomStr;
@property (nonatomic, copy)NSNumber *signTimeStamp;
//@property (nonatomic, copy)NSDictionary *content;
@property (nonatomic, copy)NSNumber *authtype;

@end
