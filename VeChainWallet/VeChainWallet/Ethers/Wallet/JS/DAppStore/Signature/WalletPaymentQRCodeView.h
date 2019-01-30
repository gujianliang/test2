//
//  WalletPaymentQRCodeView.h
//  VeWallet
//
//  Created by 曾新 on 2018/8/20.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletObersverTransactionModel.h"

typedef NS_ENUM(NSInteger,QRCodeViewType)
{
    HotWalletQrCodeType = 10,
    HotWalletScanType = 11,
    ColdShowQrCodeType = 12,
};

@interface WalletPaymentQRCodeView : UIView

@property (nonatomic,assign)QRCodeViewType viewType;
@property (nonatomic, copy)NSString *enter_path;
@property (nonatomic, assign)BusinessType businessType;

@property (nonatomic, copy)void (^block)(NSString *result);
@property (nonatomic, copy)void (^blockBack)(void);

- (instancetype)initWithFrame:(CGRect)frame
                         type:(QRCodeViewType)viewType
                         json:(NSString *)json
                     codeType:(QRCodeAddressType)codeType;

@end
