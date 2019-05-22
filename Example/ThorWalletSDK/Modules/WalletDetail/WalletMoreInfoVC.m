//
//  WalletMoreInfoVC.m
//  walletSDKDemo
//
//  Created by Tom on 2018/12/29.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletMoreInfoVC.h"
#import "WalletChangePWVC.h"
#import "WalletUtils.h"

@interface WalletMoreInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;         /* The wallet address that you created */
@property (weak, nonatomic) IBOutlet UITextView *keystoreTextView;  /* It is used to show the wallet keystore that you exported */

@end

@implementation WalletMoreInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}


/**
*  Config subviews and load it.
*/
- (void)initView{
    
    self.keystoreTextView.layer.borderWidth = 1.0;
    self.keystoreTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWallet"];
    self.addressLabel.text = currentWallet[@"address"];
    self.addressLabel.adjustsFontSizeToFitWidth = YES;
}


/**
*  Enter the change password ViewControll.
*/
- (IBAction)changeWalletPassWord:(id)sender {
    WalletChangePWVC *changeVC = [[WalletChangePWVC alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
}


/**
*  Export the wallet keystore.
*/
- (IBAction)exportWalletKeystore:(id)sender {
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWallet"];
    NSString *keystore = currentWallet[@"keystore"];
    self.keystoreTextView.text = keystore;
}


/**
*  Delete the current wallet by the class 'NSUserDefaults'.
*  Please note that this is just a demo, We save the wallet information in your SandBox by the class 'NSUserDefaults'.
*  You should think about the safety and operation, then get a better way to save your wallet information.
*/
- (IBAction)delCurrentWallet:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentWallet"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
