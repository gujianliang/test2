//
//  WalletSignatureView+transferToken.h
//  VeWallet
//
//  Created by 曾新 on 2019/1/12.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletSignatureView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletSignatureView (transferToken)

@property (nonatomic,copy) void(^block)(BOOL result);

@property (nonatomic,copy) void(^transferBlock)(NSString *txid);

- (void)signTransfer:(void(^)(NSString *txid))transferBlock;
@end

NS_ASSUME_NONNULL_END
