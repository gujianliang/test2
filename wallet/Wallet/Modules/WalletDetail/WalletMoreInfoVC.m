//
//  WalletMoreInfoVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/29.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletMoreInfoVC.h"
#import "WalletChangePWVC.h"
#import <WalletSDK/WalletUtils.h>

@interface WalletMoreInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;         /* The wallet address you created */
@property (weak, nonatomic) IBOutlet UITextView *keystoreTextView;  /* It is used to show the wallet keystore you export. */

@end

@implementation WalletMoreInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}

/* Config subviews and load it */
- (void)initView{
    
    self.keystoreTextView.layer.cornerRadius = 5.0;
    self.keystoreTextView.layer.borderWidth = 1.0;
    self.keystoreTextView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    self.addressLabel.text = currentWallet[@"address"];
    self.addressLabel.adjustsFontSizeToFitWidth = YES;
}

- (IBAction)changeWalletPassWord:(id)sender {
    WalletChangePWVC *changeVC = [[WalletChangePWVC alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
}

- (IBAction)exportWalletKeystore:(id)sender {
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *keystore = currentWallet[@"keystore"];
    self.keystoreTextView.text = keystore;
}

- (IBAction)delCurrentWallet:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentWallet"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
