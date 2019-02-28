//
//  WalletChangePWVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/29.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletChangePWVC.h"
#import <WalletSDK/Wallet.h>
#import <WalletSDK/MBProgressHUD.h>

@interface WalletChangePWVC ()

@property (weak, nonatomic) IBOutlet UITextField *oldPWTextField;     /* The wallet current password taht you created */
@property (weak, nonatomic) IBOutlet UITextField *nextPWTextField;    /* The wallet new password taht you want create */
@property (weak, nonatomic) IBOutlet UITextField *makeSureTextField;  /* Check the new password */

@end

@implementation WalletChangePWVC


/**
*  Change the wallet current password with your new password.
*/
- (IBAction)changeTheWalletPassword:(id)sender{
    [self.view endEditing:YES];
    
    /*
      Please note that you should do more judges according to what your demand is.
      Here, We just do some simple judges. This is just a demo that tell you how to change the password.
     */
    
    /* Check your input password that can not be blank. */
    if (_oldPWTextField.text.length == 0 || _nextPWTextField.text.length == 0 || _makeSureTextField.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"Check your input password that can not be blank.";
        [hud hide:YES afterDelay:2.5];
        return;
    }
    
    /*  Check the new password is correct. */
    if (![_nextPWTextField.text isEqualToString:_makeSureTextField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"The new password is not correct.";
        [hud hide:YES afterDelay:2.5];
        return;
    }
    
    /* show loading state */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =  @"waiting...";
    
    /* Read the keystore and check the old password is vailable. */
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWallet"];
    NSString *keystore = currentWallet[@"keystore"];
    NSString *address = currentWallet[@"address"];
    [WalletUtils decryptSecretStorageJSON:keystore
                                 password:_oldPWTextField.text
                                 callback:^(Account *account, NSError *NSError)
     {
        [hud hide:YES];
         if (NSError) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             hud.labelText = @"Wrong Password, Try again!";
             [hud hide:YES afterDelay:1.5];
             return ;
         }
         
         /* Use the new password to encrypt. */
         [WalletUtils encryptSecretStorageJSON:self.nextPWTextField.text
                                       account:account
                                      callback:^(NSString *json) {
             
             if (json.length > 0) {
                 NSMutableDictionary *currentDict = [NSMutableDictionary dictionary];
                 [currentDict setObject:address forKey:@"address"];
                 [currentDict setObject:json forKey:@"keystore"];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:currentDict forKey:@"currentWallet"];;
                 
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                                           animated:YES];
                 hud.mode = MBProgressHUDModeText;
                 hud.labelText = @"Change the password success!";
                 [hud hide:YES afterDelay:1.5];
                 
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                 });
             }
         }];
     }];
}


@end
