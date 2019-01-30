//
//  walletChangePWVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/29.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "walletChangePWVC.h"
//#import <walletSDK/WalletUtils.h>
#import <walletSDK/Wallet.h>
//#import "MBProgressHUD.h"
#import <walletSDK/MBProgressHUD.h>

@interface walletChangePWVC ()
@property (weak, nonatomic) IBOutlet UITextField *oldPWTextField;
@property (weak, nonatomic) IBOutlet UITextField *nextPWTextField;
@property (weak, nonatomic) IBOutlet UITextField *makeSureTextField;

@end

@implementation walletChangePWVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (IBAction)changePW:(id)sender
{
    
    
    if (_oldPWTextField.text.length == 0 || _nextPWTextField.text.length == 0 || _makeSureTextField.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                                  animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"Invalid";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    if (![_nextPWTextField.text isEqualToString:_makeSureTextField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                                  animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"Invalid";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *keystore = currentWallet[@"keystore"];
    NSString *address = currentWallet[@"address"];
    
    [WalletUtils decryptSecretStorageJSON:keystore
                                 password:_oldPWTextField.text
                                 callback:^(Account *account, NSError *NSError)
     {
         if (NSError != nil) {
             return ;
         }
         [WalletUtils encryptSecretStorageJSON:_nextPWTextField.text account:account callback:^(NSString *json) {
             
             if (json.length > 0) {
                 NSMutableDictionary *currentDict = [NSMutableDictionary dictionary];
                 [currentDict setObject:address forKey:@"address"];
                 [currentDict setObject:json forKey:@"keystore"];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:currentDict forKey:@"currentWallet"];;
             }
         }];
     }];
}


@end
