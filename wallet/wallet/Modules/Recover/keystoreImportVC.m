//
//  keystoreImportVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "keystoreImportVC.h"
#import <walletSDK/WalletUtils.h>

@interface keystoreImportVC ()
@property (weak, nonatomic) IBOutlet UITextView *keystoreTextView;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation keystoreImportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)importWallet:(id)sender
{
    if (self.password.text.length == 0 || self.keystoreTextView.text.length == 0) {
        return;
    }
    
    
    [WalletUtils decryptSecretStorageJSON:self.keystoreTextView.text
                                 password:self.password.text
                                 callback:^(Account *account, NSError *NSError)
     {
         if (NSError == nil) {
             NSString *address = account.address.checksumAddress;
             NSLog(@"address == %@;----\nprivateKey = %@ ",address, [SecureData dataToHexString:account.privateKey]);
         }
     }];
    
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
