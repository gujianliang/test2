//
//  WalletDAppHandle+transfer.h
//  WalletSDK
//
//  Created by Tom on 2019/4/2.
//  Copyright © 2019年 VeChain. All rights reserved.
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
