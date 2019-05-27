//
//  ThorTest.m
//  ThorWalletSDK_Example
//
//  Created by Tom on 2019/5/27.
//  Copyright © 2019 VeChain. All rights reserved.
//

#import "ThorTest.h"
#import "WalletUtils.h"

@implementation ThorTest

- (void)startTest
{
    //Mnemonic recovery wallet
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"result");
    }];
    
    //Create a wallet
    [WalletUtils createWalletWithPassword:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"result");
    }];
    
    //Set node
    [WalletUtils setNodeUrl:Test_Node];
    
    //Get node
    NSString *nodeUrl = [WalletUtils getNodeUrl];
    
    //Verify that the mnemonic is legal
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    
    //Get checksum address
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffed";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    
    //Verify keystore format
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    
    BOOL isOKKeystore = [WalletUtils isValidKeystore:keystore];

    //Get the address through the keystore
    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];

    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    //Data signature
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         //Signature information, recovery address
         NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
         NSLog(@"address == %@",address);
     }];


    //change Password
    [WalletUtils modifyKeystore:keystore newPassword:@"12345" oldPassword:@"123456" callback:^(NSString * _Nonnull newKeystore) {

        if (newKeystore.length > 0) {


        }else {

        }
    }];


    //Verification keystore
    [WalletUtils verifyKeystore:keystore password:@"123456" callback:^(BOOL result) {
        if (result) {

        }
    }];
    
    //Get the private key through the keystore
    [WalletUtils decryptKeystore:keystore password:@"123456" callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        
        if (!error) {
       
            //Private key to keystore
            [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
                
            }];
        }
    }];
        
    
    //Get chaintag
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        
    }];
    
    //Get blockReference
    [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
        NSLog(@"blockReference == %@",blockReference);

    }];
    
}

@end
