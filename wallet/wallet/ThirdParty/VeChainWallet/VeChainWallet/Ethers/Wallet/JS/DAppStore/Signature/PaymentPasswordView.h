//
//  PaymentPasswordView.h
//  VeWallet
//
//  Created by VeChain on 2018/4/26.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FFBMSTextFieldView.h"

@interface PaymentPasswordView : UIView
@property (nonatomic, strong) void (^didClickCloseButton)(void);

@property (nonatomic, strong) void (^didClickEnterButton)(void);

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
