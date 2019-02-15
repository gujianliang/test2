//
//  WalletSignatureViewSubView.h
//  WalletSDK
//
//  Created by 曾新 on 2019/2/15.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletGradientLayerButton.h"
#import "WalletBlockInfoApi.h"
#import "WalletTransactionApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletSignatureView+transferToken.h"
#import "WalletDAppSignPreVC.h"
#import "UIButton+block.h"
#import "WalletDAppSignPreVC.h"
#import "WalletSingletonHandle.h"
#import "NSBundle+Localizable.h"
#import "WalletSignatureViewHandle.h"
#import "WalletSignatureViewSubView.h"
#import "WalletTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletSignatureViewSubView : UIView <UITextFieldDelegate>

@property (nonatomic, strong)UIView *lastView;
@property (nonatomic, strong)UIButton *timeBtn;
@property (nonatomic, strong)UIButton *lastBtn;
@property (nonatomic, strong)UITextField *pwTextField;

- (void)initSignature:(UIScrollView *)scrollView contractType:(ContractType)contractType amount:(NSString *)amount currentCoinModel:(WalletCoinModel *)currentCoinModel gasLimit:(NSString *)gasLimit jsUse:(BOOL)jsUse fromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress pwTextField:(UITextField *)pwTextField transferType:(JSTransferType)transferType
                  gas:(NSNumber *)gas gasPriceCoef:(BigNumber *)gasPriceCoef clauseData:(NSData *)clauseData signatureHandle:(WalletSignatureViewHandle *)signatureHandle additionalMsg:(NSString *)additionalMsg;

- (void)creatLeftView:(void(^)(void))enterSignViewBlock;
- (void)creatRightView:(void(^)(void))signBlock;
- (void)creatLastView:(void(^)(void))transferBlock removeBlock:(void(^)(void))removeBlock;

@end

NS_ASSUME_NONNULL_END
