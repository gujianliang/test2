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
#import <walletSDK/MBProgressHUD.h>
//#import "MBProgressHUD.h"

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
        hud.labelText =  @"Invalid";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                              animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =  @"waiting...";
    
    [WalletUtils creatWalletWithMnemonic:self.improtKeys.text.lowercaseString
                                password:self.password.text
                                callback:^(Account *account)
    {
        [hud hide:YES];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
        [self.navigationController pushViewController:detailVC animated:YES];
        
        NSMutableDictionary *walletDict = [[NSMutableDictionary alloc]init];
        [walletDict setObject:account.address.checksumAddress forKey:@"address"];
        [walletDict setObject:account.keystore forKey:@"keystore"];
        
        [[NSUserDefaults standardUserDefaults]setObject:walletDict forKey:@"currentWallet"];
    }];
}

@end
