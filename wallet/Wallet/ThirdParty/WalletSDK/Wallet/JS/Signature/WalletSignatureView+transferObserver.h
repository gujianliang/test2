//
//  WalletSignatureView+transferObserver.h
//  VeWallet
//
//  Created by 曾新 on 2019/1/22.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletSignatureView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletSignatureView (transferObserver)
-(void)transferAccountObserver:(NSString *)valueFormated;

@end

NS_ASSUME_NONNULL_END
