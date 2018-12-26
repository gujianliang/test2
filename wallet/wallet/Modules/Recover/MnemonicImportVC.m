//
//  MnemonicImportVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "MnemonicImportVC.h"
#import <walletSDK/WalletUtils.h>
#import <walletSDK/WalletUtils.h>

@interface MnemonicImportVC ()

@end

@implementation MnemonicImportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)recover:(id)sender
{

    if (self.password.text.length == 0) {
         return;
    }
//    self.pa
//    [walletUtils cr];
//    [w];
    
//    [WalletUtils  creatWalletWithPassword:self.passwordLabel.text
//                                 callBack:^(Account *account)
//     {
//         self.mnemonicTextView.text = account.mnemonicPhrase;
//         self.addressLabel.text = account.address.checksumAddress;
//         NSString *privateKey = [SecureData dataToHexString:account.privateKey];
//         self.keystoreTextVeiw.text = account.keystore;
//
//         NSLog(@"words = %@;\n address = %@;\n privateKey = %@;\n keystore = %@",self.mnemonicTextView.text,self.addressLabel.text,privateKey,self.keystoreTextVeiw.text);
//     }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
