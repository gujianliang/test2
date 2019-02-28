//
//  WalletCreateVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletCreateVC.h"
#import <WalletSDK/Wallet.h>
#import <WalletSDK/MBProgressHUD.h>

@interface WalletCreateVC ()

@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;    /* It is used to input the wallet password */

@property (weak, nonatomic) IBOutlet UITextView *mnemonicTextView;  /* It is used to show the wallet mnemonic words when you create success */
@property (weak, nonatomic) IBOutlet UITextView *keystoreTextVeiw;  /* It is used to show the wallet keystore when you create success */
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;      /* It is used to show the wallet address when you create success */

@property (weak, nonatomic) IBOutlet UIView *topCoverView;          /* Base view control */
@property (weak, nonatomic) IBOutlet UIView *bottomCoverView;       /* Base view control */

@end

@implementation WalletCreateVC


/**
* Create a wallet.
*/
- (IBAction)creatWallet:(id)sender{
    [self.view endEditing:YES];
   
   
    /*
     Please note that you should do more judges according to what your demand is.
     Here, We just do some simple judges. This is just a demo that tell you how to create a wallet.
     */
    
    
    /* Check the password can not be blank. */
    if (self.passwordLabel.text.length  == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"please input wallet password.";
        [hud hide:YES afterDelay:1.5];
        return;
    }
    
    
    /* show loading state. */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =  @"waiting...";
    
    
    /* Create a wallet with your password. */
    [WalletUtils createWalletWithPassword:self.passwordLabel.text
                                callback:^(Account *account)
    {
        [hud hide:YES];
        self.bottomCoverView.hidden = YES;
        self.topCoverView.hidden = NO;
        
        self.mnemonicTextView.text = account.mnemonicPhrase;
        self.addressLabel.text = account.address.checksumAddress;
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
        self.keystoreTextVeiw.text = account.keystore;
        
        NSLog(@"\n **********\n mnemonic words = %@\n wallet address = %@\n wallet privateKey = %@\n keystore = %@\n **********", self.mnemonicTextView.text, self.addressLabel.text, privateKey, self.keystoreTextVeiw.text);
        
        /*
           Please note that this is just a demo that tell you how to create a wallet. We save the wallet
           keystore and addrss in the Sandbox by the class 'NSUserDefaults'. It is not a safety way.
           We do not recommend it. You can use some more better way to save it, like as Sqlite、CoreData and so on.
           In general, we recommend that you use some way of secure encryption.
         */
        NSMutableDictionary *currentDict = [NSMutableDictionary dictionary];
        [currentDict setObject:account.keystore forKey:@"keystore"];
        [currentDict setObject:account.address.checksumAddress forKey:@"address"];
        [[NSUserDefaults standardUserDefaults]setObject:currentDict forKey:@"currentWallet"];
    }];
}


/**
 * Just hidden the keyboard.
 */
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
