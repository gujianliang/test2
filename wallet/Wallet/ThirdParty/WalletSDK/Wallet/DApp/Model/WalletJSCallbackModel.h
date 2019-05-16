//
//  WalletJSCallbackModel.h
//  WalletSDK
//
//  Created by Tom on 2019/2/14.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletJSCallbackModel : WalletBaseModel

@property (nonatomic, copy)NSString *callbackId;
@property (nonatomic, copy)NSString *requestId;
@property (nonatomic, copy)NSString *method;
@property (nonatomic, copy)NSDictionary *params;

@end

NS_ASSUME_NONNULL_END
