//
//  CreatVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "CreatVC.h"
#import <walletSDK/WalletUtils.h>

@interface CreatVC ()

@end

@implementation CreatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)creatWallet:(id)sender
{
    // 生成钱包
    if (self.passwordLabel.text.length  == 0) {
        return;
    }
    [WalletUtils  creatWalletWithPassword:self.passwordLabel.text
                                 callBack:^(Account *account)
     {
         self.mnemonicTextView.text = account.mnemonicPhrase;
         self.addressLabel.text = account.address.checksumAddress;
         NSString *privateKey = [SecureData dataToHexString:account.privateKey];
         self.keystoreTextVeiw.text = account.keystore;
         
         NSLog(@"words = %@;\n address = %@;\n privateKey = %@;\n keystore = %@",self.mnemonicTextView.text,self.addressLabel.text,privateKey,self.keystoreTextVeiw.text);
     }];
    
//    [WalletUtils cr];
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
