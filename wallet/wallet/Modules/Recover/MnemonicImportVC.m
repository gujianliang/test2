//
//  MnemonicImportVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "MnemonicImportVC.h"
#import <walletSDK/WalletUtils.h>
#import "WalletDetailVC.h"
#import "MBProgressHUD.h"

@interface MnemonicImportVC ()

@end

@implementation MnemonicImportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)recover:(id)sender
{

    if (self.password.text.length == 0 || self.improtKeys.text.length == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                                  animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"填写信息不完整";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    [WalletUtils creatWalletWithMnemonic:self.improtKeys.text password:self.password.text callBack:^(Account *account)
    {
        WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
        [self.navigationController pushViewController:detailVC animated:YES];
        
        NSMutableDictionary *walletDict = [[NSMutableDictionary alloc]init];
        [walletDict setObject:account.address.checksumAddress forKey:@"address"];
        [walletDict setObject:account.keystore forKey:@"keystore"];

        [[NSUserDefaults standardUserDefaults]setObject:walletDict forKey:@"currentWallet"];
    }];

    
}


@end
