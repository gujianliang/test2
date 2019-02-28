//
//  WalletRecoverMainVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletRecoverMainVC.h"
#import "WalletKeystoreImportVC.h"
#import "WalletMnemonicImportVC.h"

@interface WalletRecoverMainVC ()

@end

@implementation WalletRecoverMainVC


/**
*  Enter the mnemonic ViewControll.
*/
- (IBAction)mnemonicImport:(id)sender {
    WalletMnemonicImportVC *vc = [[WalletMnemonicImportVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
*  Enter the keystore ViewControll.
*/
- (IBAction)keystoreImport:(id)sender {
    WalletKeystoreImportVC *vc = [[WalletKeystoreImportVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
