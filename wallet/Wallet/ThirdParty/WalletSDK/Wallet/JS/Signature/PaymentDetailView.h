//
//  PaymentDetailView.h
//  VeWallet
//
//  Created by VeChain on 2018/4/26.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentDetailView : UIView
@property (nonatomic, strong) void (^didClickCloseButton)(void);
@property (nonatomic, strong) void (^didClickEnterButton)(void);

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *toAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *minerFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinTypeLabel;

@end
