//
//  WalletDAppHandle+transfer.h
//  WalletSDK
//
//  Created by 曾新 on 2019/4/2.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "WalletDAppHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppHandle (transfer)

- (void)signTransfer:(TransactionParameter *)paramModel
            keystore:(NSString *)keystore
            password:(NSString *)password
              isSend:(BOOL)isSend
            callback:(void(^)(NSString *txId))callback;

@end

NS_ASSUME_NONNULL_END
