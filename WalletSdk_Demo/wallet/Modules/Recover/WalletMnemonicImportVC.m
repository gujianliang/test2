//
//  WalletMnemonicImportVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletMnemonicImportVC.h"
#import "WalletDetailVC.h"
#import <WalletSDK/WalletUtils.h>


@interface WalletMnemonicImportVC ()

@property (weak, nonatomic) IBOutlet UITextView *importMnemonicWords;   /* It is used to input the wallet mnemonic words */
@property (weak, nonatomic) IBOutlet UITextField *password;             /* The wallet new password that you want to create */

@end

@implementation WalletMnemonicImportVC

/**
*  Mnemonic words are taken from a fixed thesaurus, and the number of mnemonic words generated is different in different dimensions.
*  This demo uses 12 english mnemonic words. Like as follows:
*  — — — — — — — — — — — — — — — — — — — — — — — — — — ——
*    since scrub way wheel omit flush shield remove idea recipe behind mesh
*  — — — — — — — — — — — — — — — — — — — — — — — — — — ——
*  Please note that:
*          1、Every Mnemonic word is a correct word.
*          2、Mnemonic words are separated by Spaces.Do not use other separator.
*          3、Mnemonic words are strictly case-limited and all are lowercase.
*          4、Mnemonic words are fastidious about correct spelling.
*          5、Do not cotain any other special character，such as "" 、; 、: and so on.
*
*  When you recovered a wallet by Mnemonic words, then you should take care of your Mnemonic words and password.
*  Because once you lose it, it means you lose your crypto assets, and you can't get it back.
*
*/


/**
*  Recover a wallet by your mnemonic words.
*/
- (IBAction)recoverWalletByMnemonicWords:(id)sender{
    [self.view endEditing:YES];
    
    /*
     Please note that you should do more judges according to what your demand is.
     Here, We just do some simple judges. This is just a demo that tell you how to recover a wallet by mnemonic words.
     */
    
    
    /* Removing the string both ends the whitespace and newline characters. */
    NSString *string = self.importMnemonicWords.text;
    NSString *mnemonicWords = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    /* Check your input password and mnemonic words that can not be blank. */
    if (self.password.text.length == 0 || mnemonicWords.length == 0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text =  @"The input cannot be null.";
        [hud hideAnimated:YES afterDelay:3];
        return;
    }
    
    /* Check your input mnemonic words are available. */
    NSArray *arr = [mnemonicWords componentsSeparatedByString:@" "];
    if (![WalletUtils isValidMnemonicWords:arr]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text =  @"Mnemonic Words is not available.";
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    
    /* show loading state */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text =  @"Waiting...";
    
    
    /* Create a wallet with your password and mnemonic words. */
    [WalletUtils creatWalletWithMnemonicWords:arr
                                password:self.password.text
                                callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error)
     {
         [hud hideAnimated:YES];
         
         if (error) {
             NSLog(@"error：%@", error);
             return ;
         }
         
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
         [walletDict setObject:account.address forKey:@"address"];
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
