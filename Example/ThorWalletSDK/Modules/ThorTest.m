//
//  ThorTest.m
//  ThorWalletSDK_Example
//
//  Created by vechaindev on 2019/5/27.
//  Copyright © 2019 VeChain. All rights reserved.
//

#import "ThorTest.h"
#import "WalletUtils.h"

@implementation ThorTest

// mnemonic recovery wallet
/* Mnemonic correct */
- (void)createWallet{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"Mnemonic correct");
        NSAssert(account != NULL, @"Mnemonic correct");
    }];
}

- (void)createWallet1{

    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];

    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"Mnemonic=null, Wrong result %@", [error localizedDescription]);
        NSAssert([error code]== -101, @"The error code is -101");
        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"Error message");
    }];
}
/* Mnemonic is an empty string */
- (void)createWallet2{
    NSArray *mnemonicWords = @[];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"Mnemonic is an empty string, wrong result %@", [error localizedDescription]);
        NSAssert([error code]== -101, @"The error code is -101");
        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"Error message");
    }];
}
/*The mnemonic is 13 */
- (void)createWallet3{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"Assistive words are 13, wrong results %@", [error localizedDescription]);
        NSAssert([error code]== -101, @"The error code is -101");
        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"Error message");
    }];
}
/* The mnemonic is 11 */
- (void)createWallet4{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@" The mnemonic is 11, wrong result %@", [error localizedDescription]);
        NSAssert([error code]== -101, @"The error code is -101");
        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"Error message");
    }];
}
/* Mnemonic error*/
- (void)createWallet5{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper exist";
    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"Mnemonic error, wrong result %@", [error localizedDescription]);
        NSAssert([error code]== -101, @"The error code is -101");
        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"Error message");
    }];
}
/* Mnemonic correct, password = null */
- (void)createWallet6{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:NULL callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"Mnemonic correct, password = null, wrong result %@", [error localizedDescription]);
        NSAssert(account != NULL, @"Mnemonic correct, password = null");
    }];
}
/* Mnemonic correct, password = @"" */
- (void)createWallet7{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:@"" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"Mnemonic correct, password = empty string");
        NSAssert(account != NULL, @"Mnemonic correct, password = empty string");
    }];
}
/* The mnemonic is correct, the password is correct, and the mnemonic separator is null. */
- (void)createWallet8{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"Mnemonic correct, password = empty string");
        NSAssert(account == NULL, @"Mnemonic correct, password = empty string");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//Create a wallet
/* pw=NULL */
- (void)createWallet11{
    [WalletUtils createWalletWithPassword:NULL callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"Password=NULL, wrong result %@", error.localizedDescription);
        NSAssert([error code]== -101, @"The error code is -101");
        NSAssert([error.localizedDescription isEqualToString: @"password is invaild"], @"Create wallet password for nil creation failed");
    }];
}
/*Password is an empty string""*/
- (void)createWallet12{
    [WalletUtils createWalletWithPassword:@"" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"Password = empty string, wrong result %@", error.localizedDescription);
        NSAssert([error code]== -101, @"The error code is -101");
        NSAssert([error.localizedDescription isEqualToString: @"password is invaild"], @"Create wallet password for nil creation failed");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//Verify that the mnemonic is legal
/*mnemonic=NULL*/
- (void)isValidMnemonicWords1{
    NSString *mnemonicWords = NULL;
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*Mnemonic = empty string*/
- (void)isValidMnemonicWords2{
    NSString *mnemonicWords = @"";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*The mnemonic is 13*/
- (void)isValidMnemonicWords3{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month dream";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*The mnemonic is 11*/
- (void)isValidMnemonicWords4{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*Mnemonic error*/
- (void)isValidMnemonicWords5{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper exist";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*Mnemonic case sensitivity*/
- (void)isValidMnemonicWords6{
    NSString *mnemonicWords = @"admit mad dream stable Scrub rubber cabbage exist maple excuse copper month";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}

/*------------------------------------------------------------------------------------------------------------------*/
// Get checksum address
/* Address is all lowercase */
- (void)getChecksumAddress{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffed";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert([checksumAddress isEqualToString: @"0x7567D83b7b8d80ADdCb281A71d54Fc7B3364ffed"], @"Get the checksum address");
    NSLog(@"checksumAddress= %@", checksumAddress);
}
/*address=null*/
- (void)getChecksumAddress1{
    NSString *address = NULL;
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert(checksumAddress == NULL, @"Get the checksum address");
}
/*address=""*/
- (void)getChecksumAddress2{
    NSString *address = @"";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert([checksumAddress isEqualToString:@""], @"Get the checksum address");
}
/*Address length = 43 */
- (void)getChecksumAddress3{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffed1";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert([checksumAddress isEqualToString:@""], @"Get empty string checksum address");
    NSLog(@"Wrong result %@", checksumAddress);
}
/*Address length =41*/
- (void)getChecksumAddress4{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffe";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert([checksumAddress isEqualToString:@""], @"Get empty string checksum address");
    NSLog(@"Wrong result %@", checksumAddress);
}
/*Address is not hexadecimal*/
- (void)getChecksumAddress5{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffeg";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert([checksumAddress isEqualToString:@""], @"Get empty string checksum address");
    NSLog(@"Wrong result %@", checksumAddress);
}
/*------------------------------------------------------------------------------------------------------------------*/
// Verify keystore format
/*keystore=null*/
- (void)isValidKeystore1{
    NSString *keystore = NULL;
    BOOL isOKKestore = [WalletUtils isValidKeystore:keystore];
    NSAssert(isOKKestore == false, @"keystore=null");
}
/*keystore=”“*/
- (void)isValidKeystore2{
    NSString *keystore = @"";
    BOOL isOKKestore = [WalletUtils isValidKeystore:keystore];
    NSAssert(isOKKestore == false, @"Keystore=empty string");
}
/*keystore=”true“*/
- (void)isValidKeystore3{
    NSString *keystore = @"true";
    BOOL isOKKestore = [WalletUtils isValidKeystore:keystore];
    NSAssert(isOKKestore == false, @"keystore=Non-json format string");
}
/*------------------------------------------------------------------------------------------------------------------*/
//Get the address through the keystore
/*keystore=null*/
- (void)getAddress1{
    NSString *keystore = NULL;
    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];
    NSAssert([getAddress isEqualToString:@""], @"Get the address through the keystore, keystore=null");
}
/*keystore=”“*/
- (void)getAddress2{
    NSString *keystore = @"";
    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];
    NSAssert([getAddress isEqualToString:@""], @"Get the address through the keystore, keystore=null");
}
/*keystore=”true“*/
- (void)getAddress3{
    NSString *keystore = @"true";
    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];
    NSAssert([getAddress isEqualToString:@""], @"Get the address through keystore, keystore=string in non-json format");
}
/*------------------------------------------------------------------------------------------------------------------*/
//Data signature
/*keystore=null*/
- (void)sign1{
    NSString *keystore = NULL;
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData)
     {
//         NSAssert([error code]== -1, @"sign1");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"sign1");
     }];
}
/*keystore=""*/
- (void)sign2{
    NSString *keystore = @"";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData)
     {
//         NSAssert([error code]== -1, @"sign2");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"sign2");
     }];
}
/*keystore="true"*/
- (void)sign3{
    NSString *keystore = @"true";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData)
     {
//         NSAssert([error code]== -1, @"sign3");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"sign3");
     }];
}
/*The keystore is correct and the password is =null*/
- (void)sign4{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:NULL
                        callback:^(NSData * _Nonnull signatureData)
     {
//         NSLog(error.localizedDescription);
//         NSAssert([error code]== -10, @"sign4");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"sign4");
     }];
}
/*The keystore is correct, the password is = ""*/
- (void)sign5{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@""
                        callback:^(NSData * _Nonnull signatureData)
     {
//         NSLog(error.localizedDescription);
//         NSAssert([error code]== -10, @"sign4");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"sign4");
     }];
}
/*Keystore is correct, password is wrong*/
- (void)sign6{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"1"
                        callback:^(NSData * _Nonnull signatureData)
     {
//         NSLog(error.localizedDescription);
//         NSAssert([error code]== -10, @"sign4");
//         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"sign4");
     }];
}
/*The keystore password is correct and the signature is empty.*/
- (void)sign7{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:NULL
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData)
     {
         //签名信息，恢复地址
         //         NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
//         NSLog(@"address == %@",error.localizedDescription);
     }];
}
/*The keystore password is correct, signature = ""*/
- (void)sign8{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:@""
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData)
     {
         //签名信息，恢复地址
         //         NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
//         NSLog(@"address == %@",error.localizedDescription);
     }];
}
/*------------------------------------------------------------------------------------------------------------------*/
// Signature information, recovery address
/*Signature information=null*/
- (void)recoverAddress1{
    NSData *messageData = [@"test" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:NULL];
    NSAssert(address == NULL, @"recoverAddress1");
}
/*Signature information=""*/
- (void)recoverAddress2{
    NSData *messageData = [@"test" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:@""];
    NSAssert(address == NULL, @"recoverAddress1");
}
/*messageData=null*/
- (void)recoverAddress3{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    
    NSData *messageData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData)
     {
         
         //Signature information, recovery address
         NSString *address = [WalletUtils recoverAddressFromMessage:NULL signatureData:signatureData];
         NSLog(@"address == %@",address);
         //         NSAssert([address isEqualToString:@"0x7567D83b7b8d80ADdCb281A71d54Fc7B3364ffed"], @"错误码为-1");
     }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//change Password
/*keystore=null*/
- (void)modifyKeystorePassword1{
    NSString *keystore = NULL;
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"123456" callback:^(NSString * _Nonnull newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword1");
    }];
}
/*keystore=""*/
- (void)modifyKeystorePassword2{
    NSString *keystore = @"";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"123456" callback:^(NSString * _Nonnull newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword2");
    }];
}
/*keystore="true"*/
- (void)modifyKeystorePassword3{
    NSString *keystore = @"true";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"123456" callback:^(NSString * _Nonnull newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword3");
    }];
}
/*Keystore is correct, old password = null*/
- (void)modifyKeystorePassword4{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:NULL callback:^(NSString * _Nonnull newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword4");
    }];
}
/*Keystore is correct, old password = ""*/
- (void)modifyKeystorePassword5{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"" callback:^(NSString * _Nonnull newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword5");
    }];
}
/*Keystore is correct, old password is wrong*/
- (void)modifyKeystorePassword6{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"1" callback:^(NSString * _Nonnull newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword6");
    }];
}
/*Keystore old password is correct, new password = null*/
- (void)modifyKeystorePassword7{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:NULL oldPassword:@"123456" callback:^(NSString * _Nonnull newKeystore) {
        NSString *getAddress = [WalletUtils getAddressWithKeystore:newKeystore];
        NSLog(@"newKeystore.length=%ld, getAddress=%@", newKeystore.length, getAddress);
        NSAssert(newKeystore.length != 0, @"modifyKeystorePassword7");
        NSAssert([getAddress isEqualToString:@"0x36D7189625587D7C4c806E0856b6926Af8d36FEa"], @"modifyKeystorePassword7");
    }];
    
    
}
/*Keystore old password is correct, new password=""*/
- (void)modifyKeystorePassword8{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"123456" callback:^(NSString * _Nonnull newKeystore) {
        NSString *getAddress = [WalletUtils getAddressWithKeystore:newKeystore];
        NSLog(@"newKeystore.length=%ld, getAddress=%@", newKeystore.length, getAddress);
        NSAssert([getAddress isEqualToString:@"0x36D7189625587D7C4c806E0856b6926Af8d36FEa"], @"modifyKeystorePassword8");
    }];
}

/*------------------------------------------------------------------------------------------------------------------*/
// Verify that the keystore password is correct
/*keystore=null*/
- (void)verifyKeystorePassword1{
    NSString *keystore = NULL;
    [WalletUtils verifyKeystore:keystore password:@"123456" callback:^(BOOL result) {
        NSAssert(result == false, @"verifyKeystorePassword1");
    }];
}
/*keystore=”“*/
- (void)verifyKeystorePassword2{
    NSString *keystore = @"";
    [WalletUtils verifyKeystore:keystore password:@"123456" callback:^(BOOL result) {
        NSAssert(result == false, @"verifyKeystorePassword2");
    }];
}
/*keystore=”trur“*/
- (void)verifyKeystorePassword3{
    NSString *keystore = @"true";
    [WalletUtils verifyKeystore:keystore password:@"123456" callback:^(BOOL result) {
        NSAssert(result == false, @"verifyKeystorePassword3");
    }];
}
/*Keystore is correct, password = null*/
- (void)verifyKeystorePassword4{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils verifyKeystore:keystore password:NULL callback:^(BOOL result) {
        NSAssert(result == false, @"verifyKeystorePassword4");
    }];
}
/*Keystore is correct, password = ""*/
- (void)verifyKeystorePassword5{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils verifyKeystore:keystore password:@"" callback:^(BOOL result) {
        NSAssert(result == false, @"verifyKeystorePassword4");
    }];
}
/*Keystore is correct, password is wrong*/
- (void)verifyKeystorePassword6{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils verifyKeystore:keystore password:@"a" callback:^(BOOL result) {
        NSAssert(result == false, @"verifyKeystorePassword4");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
// Get the private key through the keystore
/*keystore=null*/
- (void)decryptKeystore1{
    NSString *keystore = NULL;
    [WalletUtils decryptKeystore:keystore password:@"123456" callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        NSAssert([error code]== -1, @"decryptKeystore1");
        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"decryptKeystore1");
    }];
}
/*keystore=""*/
- (void)decryptKeystore2{
    NSString *keystore = @"";
    [WalletUtils decryptKeystore:keystore password:@"123456" callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        NSAssert([error code]== -1, @"decryptKeystore2");
        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"decryptKeystore2");
    }];
}
/*keystore="true"*/
- (void)decryptKeystore3{
    NSString *keystore = @"true";
    [WalletUtils decryptKeystore:keystore password:@"123456" callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        NSAssert([error code]== -1, @"decryptKeystore3");
        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"decryptKeystore3");
    }];
}
/*Keystore is correct, password = null*/
- (void)decryptKeystore4{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils decryptKeystore:keystore password:NULL callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        NSAssert([error code]== -10, @"decryptKeystore4");
        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"decryptKeystore4");
    }];
}
/*Keystore is correct, password=""*/
- (void)decryptKeystore5{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils decryptKeystore:keystore password:@"" callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        NSAssert([error code]== -10, @"decryptKeystore4");
        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"decryptKeystore4");
    }];
}

/*Keystore is correct, password is wrong*/
- (void)decryptKeystore6{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils decryptKeystore:keystore password:@"a" callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        NSAssert([error code]== -10, @"decryptKeystore4");
        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"decryptKeystore4");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//Private key to keystore
/*privatekey=null*/
- (void)encryptPrivateKey1{
    NSString *privatekey = NULL;
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey1");
    }];
}
/*privatekey=""*/
- (void)encryptPrivateKey2{
    NSString *privatekey = @"";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey2");
    }];
    

}
/*Privatekey=non-hexadecimal*/
- (void)encryptPrivateKey3{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85eg";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey3");
    }];
}
/*65 after privatekey 0x*/
- (void)encryptPrivateKey4{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85eee";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey4");
    }];
}
/*63 after privatekey 0x*/
- (void)encryptPrivateKey5{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85e";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey5");
    }];
}
/*Privatekey is correct, password is null*/
- (void)encryptPrivateKey6{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85ee";
    [WalletUtils encryptPrivateKeyWithPassword:NULL privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@ %ld", keystoreJson, keystoreJson.length);
        NSAssert(keystoreJson.length == 491, @"encryptPrivateKey6");
    }];
}
/*Privatekey is correct, password is ""*/
- (void)encryptPrivateKey7{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85ee";
    [WalletUtils encryptPrivateKeyWithPassword:@"" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@ %ld", keystoreJson, keystoreJson.length);
        NSAssert(keystoreJson.length == 491, @"encryptPrivateKey7");
    }];
}

// signTransfer
/* keystore=null */
- (void)signTransfer1{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:NULL
                                      password:@"123456"
                                      callback:^(NSString * _Nonnull txid)
                 {
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* keystore="" */
- (void)signTransfer2{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:@""
                                      password:@"123456"
                                      callback:^(NSString * _Nonnull txid)
                 {
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* keystore="true" */
- (void)signTransfer3{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:@"true"
                                      password:@"123456"
                                      callback:^(NSString * _Nonnull txid)
                 {
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/*Keystore is correct, password = null*/
- (void)signTransfer4{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:keystore
                                      password:NULL
                                      callback:^(NSString * _Nonnull txid)
                 {
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/*Keystore is correct, password=""*/
- (void)signTransfer5{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:keystore
                                      password:@""
                                      callback:^(NSString * _Nonnull txid)
                 {
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/*Keystore is correct, password is wrong*/
- (void)signTransfer6{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:keystore
                                      password:@"1"
                                      callback:^(NSString * _Nonnull txid)
                 {
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/*Keystore password is correct, transactionModel=null*/
- (void)signTransfer7{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:NULL
                                      keystore:keystore
                                      password:@"123456"
                                      callback:^(NSString * _Nonnull txid)
                 {
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
                
            }
        }];
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//signAndSendTransfer
/* keystore=null */
- (void)signAndSendTransfer1
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:NULL
                                                     password:@"123456"
                                                     callback:^(NSString * _Nonnull txid)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* keystore="" */
- (void)signAndSendTransfer2
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:@""
                                                     password:@"123456"
                                                     callback:^(NSString * _Nonnull txid)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* keystore="true" */
- (void)signAndSendTransfer3
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:@"true"
                                                     password:@"123456"
                                                     callback:^(NSString * _Nonnull txid)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* Keystore is correct, password = null */
- (void)signAndSendTransfer4
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:keystore
                                                     password:NULL
                                                     callback:^(NSString * _Nonnull txid)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* Keystore is correct, password="" */
- (void)signAndSendTransfer5
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:keystore
                                                     password:@""
                                                     callback:^(NSString * _Nonnull txid)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* Keystore is correct, password is incorrect transactionModel=null*/
- (void)signAndSendTransfer6
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:keystore
                                                     password:@"a"
                                                     callback:^(NSString * _Nonnull txid)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/* The keystore is correct and the password is correct.*/
- (void)signAndSendTransfer7
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                

                [WalletUtils signAndSendTransferWithParameter:nil
                                                     keystore:keystore
                                                     password:@"123456"
                                                     callback:^(NSString * _Nonnull txid)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     NSLog(@"\n txId: %@", txid);
                     NSAssert(txid == NULL, @"signTransfer1");
                 }];
            }
        }];
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/

- (void)startTest
{
    //    [self createWallet]; /* 助记词正确 */
    //    [self createWallet1];/* 助记词=null */
    //    [self createWallet2];/* 助记词为空字符串 */
    //    [self createWallet3];/* 助记词为13个 */
    //    [self createWallet4];/* 助记词为11个 */
    //    [self createWallet5];/* 助记词错误 */
    //    [self createWallet6];/* 助记词正确，密码=null */
    //    [self createWallet7];/* 助记词正确，密码=@"" */
    //    [self createWallet8];/* 助记词正确，密码正确，助记词分隔符为null */
    //    [self createWallet11];/* 密码=NULL */
    //    [self createWallet12];/*密码为空字符串""*/
    //    [self isValidMnemonicWords1];/*助记词为=NULL*/
    //    [self isValidMnemonicWords2];/*助记词为=NULL*/
    //    [self isValidMnemonicWords3];/*助记词为13个*/
    //    [self isValidMnemonicWords4];/*助记词为11个*/
    //    [self isValidMnemonicWords5];/*助记词错误*/
    //    [self isValidMnemonicWords6];/*助记词大小写敏感*/
//    [self isValidMnemonicWords7];/*助记词和密码正确，助记词分割为null*/
    //    [self getChecksumAddress]; /* 地址全小写 */
    //    [self getChecksumAddress1]; /* 地址=null */
    //    [self getChecksumAddress2]; /* 地址="" */
    //    [self getChecksumAddress3]; /*地址=43位*/
    //    [self getChecksumAddress4]; /*地址=41位*/
    //    [self getChecksumAddress5]; /*地址=非16进制*/
    //    [self isValidKeystore1];/*keystore=null*/
    //    [self isValidKeystore2];/*keystore=”“*/
    //    [self isValidKeystore3];/*keystore=”true“*/
    //    [self getAddress1];/*keystore=null*/
    //    [self getAddress2];/*keystore=”“*/
    //    [self getAddress3];/*keystore=”true“*/
    //    [self sign1];/*keystore=null*/
    //    [self sign2];/*keystore=”“*/
    //    [self sign3];/*keystore=”true“*/
    //    [self sign4];/*keystore正确，密码为=null*/
    //    [self sign5];/*keystore正确，密码为=""*/
    //    [self sign6];/*keystore正确，密码错误*/
    //    [self sign7];/*keystore密码正确，签名=null*/
    //    [self sign8];/*keystore密码正确，签名=“”*/
    //    [self recoverAddress1];/*签名信息=null*/
    //    [self recoverAddress2];/*签名信息=""*/
    //    [self recoverAddress3];/*message=null*/
    //    [self modifyKeystorePassword1];/*keystore=null*/
    //    [self modifyKeystorePassword2];/*keystore=""*/
    //    [self modifyKeystorePassword3];/*keystore="true"*/
    //    [self modifyKeystorePassword4];/*keystore正确，旧密码=null*/
    //    [self modifyKeystorePassword5];/*keystore正确，旧密码=""*/
    //    [self modifyKeystorePassword6];/*keystore正确，旧密码错误*/
    //    [self modifyKeystorePassword7];/*keystore旧密码正确，新密码=null*/
    //    [self modifyKeystorePassword8];/*keystore旧密码正确，新密码=""*/
    //    [self verifyKeystorePassword1];/*keystore=null*/
    //    [self verifyKeystorePassword2];/*keystore=""*/
    //    [self verifyKeystorePassword3];/*keystore="true"*/
    //    [self verifyKeystorePassword4];/*keystore正确, 密码=null*/
    //    [self verifyKeystorePassword5];/*keystore正确, 密码=""*/
    //    [self verifyKeystorePassword6];/*keystore正确, 密码=错误*/
    //    [self verifyKeystorePassword1];/*keystore=null*/
    //    [self verifyKeystorePassword2];/*keystore=""*/
    //    [self verifyKeystorePassword3];/*keystore="true"*/
    //    [self verifyKeystorePassword4];/*keystore正确, 密码=null*/
    //    [self verifyKeystorePassword5];/*keystore正确, 密码=""*/
    //    [self verifyKeystorePassword6];/*keystore正确, 密码=错误*/
    //    [self encryptPrivateKey1];/*privateKey=null*/
    //    [self encryptPrivateKey2];/*privateKey=null*/
    //    [self encryptPrivateKey3];/*privateKey=null*/
    //    [self encryptPrivateKey4];/*privateKey=null*/
    //    [self encryptPrivateKey5];/*privateKey=null*/
    //    [self encryptPrivateKey6];/*privateKey=null*/
    //    [self encryptPrivateKey7];/*privateKey=null*/
    /*------------------------------------------------------------------------------------------------------------------*/
    
    //    //Mnemonic recovery wallet
    //    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    //    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
    //        NSLog(@"result");
    //    }];
    //
    //    //Create a wallet
    //    [WalletUtils createWalletWithPassword:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
    //        NSLog(@"result");
    //    }];
    //
    //    //Set node
    //    [WalletUtils setNodeUrl:Test_Node];
    //
    //    //Get node
    //    NSString *nodeUrl = [WalletUtils getNodeUrl];
    //
    //    //Verify that the mnemonic is legal
    //    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    //
    //    //Get checksum address
    //    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffed";
    //    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    //
    //    //Verify keystore format
    //    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    //
    //    BOOL isOKKeystore = [WalletUtils isValidKeystore:keystore];
    //
    //    //Get the address through the keystore
    //    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];
    //
    //    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    //    //Data signature
    //    [WalletUtils signWithMessage:messageData
    //                        keystore:keystore
    //                        password:@"123456"
    //                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
    //     {
    //         //Signature information, recovery address
    //         NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
    //         NSLog(@"address == %@",address);
    //     }];
    //
    //
    //    //change Password
    //    [WalletUtils modifyKeystore:keystore newPassword:@"12345" oldPassword:@"123456" callback:^(NSString * _Nonnull newKeystore) {
    //
    //        if (newKeystore.length > 0) {
    //
    //
    //        }else {
    //
    //        }
    //    }];
    //
    //
    //    //Verification keystore
    //    [WalletUtils verifyKeystore:keystore password:@"123456" callback:^(BOOL result) {
    //        if (result) {
    //
    //        }
    //    }];
    //
    //    //Get the private key through the keystore
    //    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    //    [WalletUtils decryptKeystore:keystore password:@"123456" callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
    //
    //        if (!error) {
    //
    //            //Private key to keystore
    //            [WalletUtils encryptPrivateKeyWithPassword:@"" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
    //                NSLog(@"keystoreJson=%@",keystoreJson);
    //
    //            }];
    //        }
    //    }];
    
    //
    //
    //    //Get chaintag
    //    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
    //        NSLog(@"chainTag == %@",chainTag);
    //
    //    }];
    //
    //    //Get blockReference
    //    [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
    //        NSLog(@"blockReference == %@",blockReference);
    //
    //    }];
    
}


- (void)signAndSend
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                     keystore:keystore
                                                     password:@"123456"
                                                     callback:^(NSString * _Nonnull txid)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     
                     NSLog(@"\n txId: %@", txid);
                 }];
            }
        }];
    }];
}

- (void)sign
{
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:@"2" dicimals:18];
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0x1231231231231231231231231231231231231231";//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    
    
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            WalletTransactionParameter *transactionModel = [WalletTransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag = chainTag;
                builder.blockReference = blockReference;
                builder.nonce = nonce;
                builder.clauses = clauseList;
                builder.gas = @"600000";
                builder.expiration = @"720";
                builder.gasPriceCoef = @"0";
                
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
                NSLog(@"errorMsg == %@",errorMsg);
            }];
            
            
            if (transactionModel != nil) {
                
                NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
                
                
                [WalletUtils signWithParameter:transactionModel
                                      keystore:keystore
                                      password:@"123456"
                                      callback:^(NSString * _Nonnull txid)
                 {
                     //Developers can use txid to query the status of data packaged on the chain
                     
                     NSLog(@"\n txId: %@", txid);
                 }];
            }
        }];
    }];
}



- (BigNumber *)amountConvertWei:(NSString *)amount dicimals:(NSInteger )dicimals
{
    NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *dicimalNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, dicimals)]];
    NSDecimalNumber *weiNumber = [amountNumber decimalNumberByMultiplyingBy:dicimalNumber];
    
    return [BigNumber bigNumberWithNumber:weiNumber];
}

- (BOOL)checkEnoughCoinBalance:(NSString *)coinBalance transferAmount:(NSString *)transferAmount
{
    NSDecimalNumber *coinBalanceNumber = [NSDecimalNumber decimalNumberWithString:coinBalance];
    NSDecimalNumber *transferAmounttnumber = [NSDecimalNumber decimalNumberWithString:transferAmount];
    
    if ([coinBalanceNumber compare:transferAmounttnumber] == NSOrderedAscending) {
        return NO;
    }
    return YES;
}

@end

