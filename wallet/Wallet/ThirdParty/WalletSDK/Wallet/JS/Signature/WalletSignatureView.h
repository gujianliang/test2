//
//  WalletSignatureVC.h
//  VeWallet
//
//  Created by 曾新 on 2018/10/15.
//  Copyright © 2018年 VeChain. All rights reserved.
//

//#import "VCBaseVC.h"



#import <UIKit/UIKit.h>
#import "WalletManageModel.h"
#import "WalletUtils.h"
#import "WalletTools.h"
@class WalletSignatureViewSubView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,JSTransferType)
{
    JSVETTransferType,
    JSVTHOTransferType,
    JSContranctTransferType
};



@interface WalletSignatureView : UIView

@property (nonatomic,copy) NSString *enter_path;
@property (nonatomic,assign) BusinessType business_type;

@property (nonatomic,copy) void(^block)(BOOL result);
@property (nonatomic,copy) void(^transferBlock)(NSString *txid);

@property(nonatomic, strong) BigNumber *gasPriceCoef;
@property(nonatomic, assign) BOOL isICO;
@property(nonatomic, strong) WalletCoinModel *currentCoinModel;
@property(nonatomic, copy) NSString *fromAddress;
@property(nonatomic, copy) NSString *toAddress;
@property(nonatomic, assign) ContractType contractType;
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, strong) NSNumber *gas;
@property(nonatomic, copy) NSString *gasLimit;
@property(nonatomic, strong) NSData *clauseData;
@property(nonatomic, copy) NSString *tokenAddress;
@property (nonatomic, assign) JSTransferType transferType;
@property(nonatomic, copy) NSString *txid;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) WalletSignatureViewSubView *signatureSubView;



- (void)updateView:(NSString *)fromAddress
         toAddress:(NSString *)toAddress
      contractType:(ContractType)contractType
            amount:(NSString *)amount
            params:(NSArray *)params;

- (void)tokenID:(NSString *)tokenID expiration:(NSString *)expiration;

- (void)timerCountBlock;
@end

NS_ASSUME_NONNULL_END
