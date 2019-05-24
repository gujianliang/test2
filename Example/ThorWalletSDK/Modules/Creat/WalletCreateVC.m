/**
    Copyright (c) 2019 Tom <tom.zeng@vechain.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

**/

//
//  WalletCreateVC.m
//  walletSDKDemo
//
//  Created by Tom on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletCreateVC.h"
#import "WalletUtils.h"

#import "MBProgressHUD.h"

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
   
//    [self signAndRecover];
    /*
     Please note that you should do more judges according to what your demand is.
     Here, We just do some simple judges. This is just a demo that tell you how to create a wallet.
     */
    
    
    /* Check the password can not be blank. */
    if (self.passwordLabel.text.length  == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"input_empty", nil);
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    
    /* show loading state. */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"wait", nil);
    
    
    /* Create a wallet with your password. */
    [WalletUtils createWalletWithPassword:self.passwordLabel.text
                                 callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error)

    {
        [hud hideAnimated:YES];
        self.bottomCoverView.hidden = YES;
        self.topCoverView.hidden = NO;
        
        self.mnemonicTextView.text = [account.words componentsJoinedByString:@" "];
        self.addressLabel.text = account.address;
        NSString *privateKey = account.privatekey;
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
        [currentDict setObject:account.address forKey:@"address"];
        [[NSUserDefaults standardUserDefaults]setObject:currentDict forKey:@"currentWallet"];
    }];
}


/**
* Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)signAndRecover
{
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
    {
        NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
        NSLog(@"address == %@",address);
    }];
}

- (void)checkMnemonicWords
{
    NSString *test = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    BOOL result = [WalletUtils isValidMnemonicWords:[test componentsSeparatedByString:@" "]];
}

- (void)checkKeystore
{
    NSString *keystore = @"{\"version\":3,\"id\":\"1150C15C-2E20-462B-8A88-EDF8A0E4DB71\",\"crypto\":{\"ciphertext\":\"1cf8d74d31b1ec2568f903fc2c84d215c0401cbb710b7b3de081af1449ae2a89\",\"cipherparams\":{\"iv\":\"03ccae46eff93b3d9bdf2b21739d7205\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"r\":8,\"p\":1,\"n\":262144,\"dklen\":32,\"salt\":\"a71ecee9a1c33f0311e46f7da7da8d218a8c5b3d1067716a9bcdb767785d8e83\"},\"mac\":\"82b20c61854621f35b4d60ffb795655258356f310cdffa587f7db68a1789de75\",\"cipher\":\"aes-128-ctr\"},\"address\":\"cc2b456b2c9399b4b68ef632cf6a1aeabe67b417\"}";
    BOOL result = [WalletUtils isValidKeystore:keystore];
    
}


@end
