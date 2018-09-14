//
//  ViewController.m
//  wallet
//
//  Created by vechain on 2018/7/5.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "ViewController.h"

#import <walletSDK/WalletUtils.h>



@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rawLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (IBAction)touchMe:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {
            // 生成钱包
            [WalletUtils  creatWalletWithPassword:@"123456"
                                         callBack:^(Account *account)
             {
                 NSString *words = account.mnemonicPhrase;
                 NSString *address = account.address.checksumAddress;
                 NSString *privateKey = [SecureData dataToHexString:account.privateKey];
                 NSString *keystore = account.keystore;
                 
                 NSLog(@"words = %@;\n address = %@;\n privateKey = %@;\n keystore = %@",words,address,privateKey,keystore);
             }];
        }
            break;
        case 11:
        {
            //验证助记词
            BOOL result = [WalletUtils isValidMnemonicPhrase:@"lava boost century jaguar detail notice chunk carpet loud secret allow endorse"];

        }
            break;
        case 12:
        {
            //通过keystore 获得地址，私钥
            NSString *keystore = @"{\"address\":\"ea4802c2af57ed4c57cda9cc566bf5edb4014eeb\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"c2b5cf2cdc4409c170eaf6c918ccfada0907447b5cc98c3cce9d746271e85135\",\"cipherparams\":{\"iv\":\"9ba54ec714eb1504874ff45fbc7875f5\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"0cb11415a0ce79919e5d0beaa9c171a920666cfa4be4c8212f7f1132d9ace904\"},\"mac\":\"f626b12d6dbe548b61fd0faaa7ebc2e3833124bbad66f44065a0406f378f50c9\"},\"id\":\"e309335b-183d-4b65-b504-282a211aad94\",\"version\":3}";
            
            [WalletUtils decryptSecretStorageJSON:keystore password:@"123456"
                                         callback:^(Account *account, NSError *NSError)
             {
                 if (NSError == nil) {
                     NSString *address = account.address.checksumAddress;
                     NSLog(@"address == %@;privateKey = %@ ",address, [SecureData dataToHexString:account.privateKey]);
                 }
             }];
        }
            break;
        case 13:
        {
            
            //根据签名信息得到钱包地址，
            NSString *sigatureStr = @"7f989bc424beea9ad6c45a77ebfb8177b45d9524a602d1bdd52ac173a0a6bd6f77b8b117854d06a8e6127ad4044ee66b8235dac1b99daff6eb2d6ae6531188aa01";
            NSData *signatureData = [SecureData  hexStringToData: [@"0x" stringByAppendingString:sigatureStr]];
            Signature *sigature = [Signature signatureWithData:signatureData];
            
            
            NSData *messageData = [SecureData hexStringToData:@"0x195665436861696e205369676e6564204d6573736167653a0a33328afc397415e50257c92ceb74ff6346d96bd190a84999c4154ed27e0c6da0d1d5"];
            SecureData *msgDataHash = [SecureData BLAKE2B:messageData];
            
            Address *verifyAddress = [WalletUtils verifyMessage:msgDataHash.data signature:sigature];
            NSString *address = verifyAddress.checksumAddress;
            NSLog(@"address -- %@",address);
        }
            break;
        case 14:
        {
            //通过keystore 获得地址，私钥
            NSString *keystore = @"{\"address\":\"ea4802c2af57ed4c57cda9cc566bf5edb4014eeb\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"c2b5cf2cdc4409c170eaf6c918ccfada0907447b5cc98c3cce9d746271e85135\",\"cipherparams\":{\"iv\":\"9ba54ec714eb1504874ff45fbc7875f5\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"0cb11415a0ce79919e5d0beaa9c171a920666cfa4be4c8212f7f1132d9ace904\"},\"mac\":\"f626b12d6dbe548b61fd0faaa7ebc2e3833124bbad66f44065a0406f378f50c9\"},\"id\":\"e309335b-183d-4b65-b504-282a211aad94\",\"version\":3}";
            //签名
            NSData *signMessageData = [@"This is the signature information I prepared." dataUsingEncoding:NSUTF8StringEncoding];
            
            [WalletUtils sign:signMessageData
                     keystore:keystore
                     password:@"123456"
                        block:^(Signature *signature)
             {
                 NSMutableData *signatureData = [[NSMutableData alloc]init];
                 [signatureData appendData:signature.r];
                 [signatureData appendData:signature.s];
                 
                 unsigned char b = signature.v;
                 [signatureData appendBytes:&b length:1];
                 NSLog(@"signtrue");
             }];
        }
            break;
            
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
