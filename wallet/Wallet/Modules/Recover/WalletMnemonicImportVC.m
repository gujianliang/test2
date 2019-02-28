//
//  WalletMnemonicImportVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletMnemonicImportVC.h"
#import <WalletSDK/WalletUtils.h>
#import "WalletDetailVC.h"
#import <WalletSDK/MBProgressHUD.h>

@interface WalletMnemonicImportVC ()

@property (weak, nonatomic) IBOutlet UITextView *improtMnemonicWords;   /* The wallet new password that you want to create */
@property (weak, nonatomic) IBOutlet UITextField *password;             /* The wallet new password that you want to create */

@end

@implementation WalletMnemonicImportVC


/**
* Recover a wallet by your mnemonic words.
*/
- (IBAction)recoverWalletByMnemonicWords:(id)sender{
    [self.view endEditing:YES];
    
    /*
     Please note that you should do more judges according to what your demand is.
     Here, We just do some simple judges. This is just a demo that tell you how to recover a wallet by mnemonic words.
     */
    
    /* Check your input password and mnemonic words that can not be blank. */
    if (self.password.text.length == 0 || self.improtMnemonicWords.text.length == 0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"Invalid";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    /* Check your input mnemonic words are available. */
    if (![WalletUtils isValidMnemonicPhrase:self.improtMnemonicWords.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"Invalid";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    /* show loading state */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =  @"waiting...";
    
    
    /* Create a wallet with your password and mnemonic words. */
    [WalletUtils creatWalletWithMnemonic:self.improtMnemonicWords.text.lowercaseString
                                password:self.password.text
                                callback:^(Account *account)
    {
        [hud hide:YES];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
        [self.navigationController pushViewController:detailVC animated:YES];
        
        
        /*
         Please note that this is just a demo that tell you how to recover a wallet by mnemonic words.
         We save the wallet keystore and addrss in the Sandbox by the class 'NSUserDefaults'. It is not a safety way.
         We do not recommend it. You can use some more better way to save it, like as Sqlite、CoreData and so on.
         In general, we recommend that you use some way of secure encryption.
         */
        NSMutableDictionary *walletDict = [[NSMutableDictionary alloc]init];
        [walletDict setObject:account.address.checksumAddress forKey:@"address"];
        [walletDict setObject:account.keystore forKey:@"keystore"];
        [[NSUserDefaults standardUserDefaults]setObject:walletDict forKey:@"currentWallet"];
    }];
}


/**
 *  Just hidden the keyboard.
 */
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
