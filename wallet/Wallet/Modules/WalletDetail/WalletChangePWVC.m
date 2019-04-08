//
//  WalletChangePWVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/29.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletChangePWVC.h"
#import <WalletSDK/WalletUtils.h>
#import "MBProgressHUD.h"

@interface WalletChangePWVC ()

@property (weak, nonatomic) IBOutlet UITextField *oldPWTextField;     /* The wallet current password that you created */
@property (weak, nonatomic) IBOutlet UITextField *nextPWTextField;    /* The wallet new password that you want to create */
@property (weak, nonatomic) IBOutlet UITextField *makeSureTextField;  /* Check the new password */

@end

@implementation WalletChangePWVC


/**
*  Change wallet password.
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
        hud.label.text = NSLocalizedString(@"input_empty", nil);
        [hud hideAnimated:YES afterDelay:2.5];
        return;
    }
    
    /*  Check the new password is correct. */
    if (![_nextPWTextField.text isEqualToString:_makeSureTextField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"modify_password_new_error", nil);
        [hud hideAnimated:YES afterDelay:2.5];
        return;
    }
    
    /* show loading state */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"wait", nil);
    
    /* Read the keystore and check the old password is vailable. */
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWallet"];
    NSString *keystore = currentWallet[@"keystore"];
    NSString *address = currentWallet[@"address"];
    
    
    [WalletUtils modifyKeystoreWithPassword:_oldPWTextField.text
                                      newPW:self.nextPWTextField.text
                               keystoreJson:keystore
                                   callback:^(NSString * _Nonnull newKeystore)
    {
        
        [hud hideAnimated:YES];
        if (newKeystore.length > 0) {
            NSMutableDictionary *currentDict = [NSMutableDictionary dictionary];
            [currentDict setObject:address forKey:@"address"];
            [currentDict setObject:newKeystore forKey:@"keystore"];
            
            [[NSUserDefaults standardUserDefaults]setObject:currentDict forKey:@"currentWallet"];;
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"modify_password_success", nil);
            [hud hideAnimated:YES afterDelay:2.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"modify_password_failr", nil);
            [hud hideAnimated:YES afterDelay:2.5];
        }
    }];
}


/**
*  Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


/**
 *  Just hidden the keyboard.
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

@end
