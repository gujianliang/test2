//
//  WalletCreatVC.h
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletCreatVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextView *mnemonicTextView;
@property (weak, nonatomic) IBOutlet UITextView *keystoreTextVeiw;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;

@end

NS_ASSUME_NONNULL_END
