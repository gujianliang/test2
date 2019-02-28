//
//  WalletKeystoreImportVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletKeystoreImportVC.h"
#import <WalletSDK/WalletUtils.h>
#import "WalletDetailVC.h"
#import "AppDelegate.h"
#import <WalletSDK/MBProgressHUD.h>

@interface WalletKeystoreImportVC ()

@property (weak, nonatomic) IBOutlet UITextView *keystoreTextView;  
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation WalletKeystoreImportVC


/**
*
*/
- (IBAction)recoverWalletByKeystore:(id)sender{
    [self.view endEditing:YES];

    if (self.password.text.length == 0 || self.keystoreTextView.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"Invalid";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =  @"waiting ...";
    
    
    [WalletUtils decryptSecretStorageJSON:self.keystoreTextView.text.lowercaseString
                                 password:self.password.text
                                 callback:^(Account *account, NSError *NSError)
     {
         [hud hide:YES];
         if (NSError == nil) {
             NSString *address = account.address.checksumAddress;
             NSLog(@"address == %@;----\nprivateKey = %@ ",address, [SecureData dataToHexString:account.privateKey]);
             
             NSMutableDictionary *walletDict = [[NSMutableDictionary alloc]init];
             [walletDict setObject:account.address.checksumAddress forKey:@"address"];
             [walletDict setObject:self.keystoreTextView.text forKey:@"keystore"];
             
             [[NSUserDefaults standardUserDefaults]setObject:walletDict forKey:@"currentWallet"];
             
             [self.navigationController popToRootViewControllerAnimated:NO];
             
             WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
             [self.navigationController pushViewController:detailVC animated:YES];
             
         }else{
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.labelText =  @"Invalid";
             [hud hide:YES afterDelay:1];
         }
     }];
}


/**
 *  Just hidden the keyboard.
 */
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
