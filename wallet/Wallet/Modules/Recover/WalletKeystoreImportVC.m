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

@property (weak, nonatomic) IBOutlet UITextView *keystoreTextView;   /* It is used to input the wallet keystore */
@property (weak, nonatomic) IBOutlet UITextField *password;          /* The wallet new password that you want to create */

@end

@implementation WalletKeystoreImportVC


/**
*  Recover a wallet by your keystore.
*/
- (IBAction)recoverWalletByKeystore:(id)sender{
    [self.view endEditing:YES];

    /*
     Please note that you should do more judges according to what your demand is.
     Here, We just do some simple judges. This is just a demo that tell you how to recover a wallet by keystore.
     */
    
    /* Check your input password and keystore that can not be blank. */
    if (self.password.text.length == 0 || self.keystoreTextView.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"Password and keystore can not be blank";
        [hud hide:YES afterDelay:3];
        return;
    }
    
    /* show loading state */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =  @"Waiting ...";
    
    
    /* Create a wallet with your password and keystore. */
    [WalletUtils decryptSecretStorageJSON:self.keystoreTextView.text.lowercaseString
                                 password:self.password.text
                                 callback:^(Account *account, NSError *NSError)
     {
         [hud hide:YES];
         
         if (NSError == nil) {
             
             NSString *address = account.address.checksumAddress;
             NSLog(@"address == %@;----\nprivateKey = %@ ",address, [SecureData dataToHexString:account.privateKey]);
             
             /*
              Please note that this is just a demo that tell you how to recover a wallet by keystore.
              We save the wallet keystore and addrss in the Sandbox by the class 'NSUserDefaults'. It is not a safety way.
              We do not recommend it. You can use some more better way to save it, like as Sqlite、CoreData and so on.
              In general, we recommend that you use some way of secure encryption.
              */
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
             hud.labelText = @"Import failure, Please check keystore and password are correct";
             [hud hide:YES afterDelay:3];
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
