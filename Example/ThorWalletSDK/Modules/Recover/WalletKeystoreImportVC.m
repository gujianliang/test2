//
//  WalletKeystoreImportVC.m
//  walletSDKDemo
//
//  Created by Tom on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletKeystoreImportVC.h"
#import "WalletDetailVC.h"
#import "MBProgressHUD.h"
#import "WalletUtils.h"

@interface WalletKeystoreImportVC ()

@property (weak, nonatomic) IBOutlet UITextView *keystoreTextView;   /* It is used to input the wallet keystore */
@property (weak, nonatomic) IBOutlet UITextField *password;          /* The wallet new password that you want to create */

@end

@implementation WalletKeystoreImportVC


/**
*  Keystore is a json string. Its file structure is as follows:
*
*  — — — — — — — — — — — — — — — — — — — — — — — — — — ——
*      {
*          "version": 3,
*          "id": "F56FDA19-FB1B-4752-8EF6-E2F50A93BFB8",
*          "kdf": "scrypt",
*          "mac": "9a1a1db3b2735c36015a3893402b361d151b4d2152770f4a51729e3ac416d79f",
*          "cipher": "aes-128-ctr"
*          "address": "ea8a62180562ab3eac1e55ed6300ea7b786fb27d"
*          "crypto": {
*                      "ciphertext": "d2820582d2434751b83c2b4ba9e2e61d50fa9a8c9bb6af64564fc6df2661f4e0",
*                      "cipherparams": {
*                                          "iv": "769ef3174114a270f4a2678f6726653d"
*                                      },
*                      "kdfparams": {
*                              "r": 8,
*                              "p": 1,
*                              "n": 262144,
*                              "dklen": 32,
*                              "salt": "67b84c3b75f9c0bdf863ea8be1ac8ab830698dd75056b8133350f0f6f7a20590"
*                      },
*          },
*      }
*
*  — — — — — — — — — — — — — — — — — — — — — — — — — — ——
*  Field description:
*          version: This is a version information, when you decryption, you should use the same version.
*          id: You can ignore. It is just a UUIDString.
*          Kdf: This is a encryption function.
*          mac: This is the mac device information.
*          cipher: Describes the encryption algorithm used.
*          address：The wallet address.
*          crypto: This section is the main encryption area.
*
*  If you want to recover a wallet by keystore, you should have the correct password.
*
*/


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
        hud.label.text = NSLocalizedString(@"input_empty", nil);
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    /* show loading state */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"wait", nil);

    /*
     Please note that this is just a demo that tell you how to recover a wallet by keystore.
     We save the wallet keystore and addrss in the Sandbox by the class 'NSUserDefaults'. It is not a safety way.
     We do not recommend it. You can use some more better way to save it, like as Sqlite、CoreData and so on.
     In general, we recommend that you use some way of secure encryption.
     */
    
    /* Create a wallet with your password and keystore. */
    
//    @weakify(self);
    [WalletUtils verifyKeystore:self.keystoreTextView.text.lowercaseString password:self.password.text callback:^(BOOL result) {
//        @strongify(self);
        [hud hideAnimated:YES];
        if (result) {
            
            NSString *address = [WalletUtils getAddressWithKeystore:self.keystoreTextView.text];
            NSMutableDictionary *walletDict = [[NSMutableDictionary alloc]init];
            [walletDict setObject:address forKey:@"address"];
            [walletDict setObject:self.keystoreTextView.text forKey:@"keystore"];
            [[NSUserDefaults standardUserDefaults]setObject:walletDict forKey:@"currentWallet"];
                        
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"Check_right", nil);
            [hud hideAnimated:YES afterDelay:3];
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
