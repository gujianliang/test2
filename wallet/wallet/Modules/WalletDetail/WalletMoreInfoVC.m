//
//  WalletMoreInfoVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/29.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletMoreInfoVC.h"
#import "walletChangePWVC.h"
#import <walletSDK/WalletUtils.h>

//#import <walletSDK/Wallet.h>

@interface WalletMoreInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *keystoreTextView;

@end

@implementation WalletMoreInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    self.addressLabel.text = currentWallet[@"address"];
}

- (IBAction)changePW:(id)sender
{
    walletChangePWVC *changeVC = [[walletChangePWVC alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
}

- (IBAction)exportKeystore:(id)sender
{
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *keystore = currentWallet[@"keystore"];
    self.keystoreTextView.text = keystore;
}

- (IBAction)delWallet:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentWallet"];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"ddd");
    }];
}


@end
