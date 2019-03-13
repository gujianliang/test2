//
//  WalletAccountModel.h
//  WalletSDK
//
//  Created by 曾新 on 2019/2/28.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletAccountModel : NSObject

@property (nonatomic, copy) NSString *keystore;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *privatekey;
@property (nonatomic, copy) NSArray *words;

@end

NS_ASSUME_NONNULL_END
