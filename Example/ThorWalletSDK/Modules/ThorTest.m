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

// 助记词恢复钱包
/* 助记词正确 */
- (void)createWallet{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"助记词正确");
        NSAssert(account != NULL, @"助记词正确");
    }];
}
/* 助记词=null*/
- (void)createWallet1{

    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];

    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"助记词=null, 错误结果 %@", [error localizedDescription]);
        NSAssert([error code]== -101, @"错误码为-101");
        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"错误信息");
    }];
}
/* 助记词为空字符串 */
- (void)createWallet2{
    NSArray *mnemonicWords = @[];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"助记词为空字符串, 错误结果 %@", [error localizedDescription]);
        NSAssert([error code]== -101, @"错误码为-101");
        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"错误信息");
    }];
}
/* 助记词为13个 */
- (void)createWallet3{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"助记词为13个, 错误结果 %@", [error localizedDescription]);
        NSAssert([error code]== -101, @"错误码为-101");
        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"错误信息");
    }];
}
/* 助记词为11个 */
- (void)createWallet4{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"助记词为11个, 错误结果 %@", [error localizedDescription]);
        NSAssert([error code]== -101, @"错误码为-101");
        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"错误信息");
    }];
}
/* 助记词错误 */
- (void)createWallet5{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper exist";
    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"助记词错误, 错误结果 %@", [error localizedDescription]);
        NSAssert([error code]== -101, @"错误码为-101");
        NSAssert([error.localizedDescription isEqualToString: @"mnemonicWords is invaild"], @"错误信息");
    }];
}
/* 助记词正确，密码=null */
- (void)createWallet6{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:NULL callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"助记词正确，密码=null, 错误结果 %@", [error localizedDescription]);
        NSAssert(account != NULL, @"助记词正确，密码=null");
    }];
}
/* 助记词正确，密码=@"" */
- (void)createWallet7{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    [WalletUtils createWalletWithMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "] password:@"" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"助记词正确，密码=空字符串");
        NSAssert(account != NULL, @"助记词正确，密码=空字符串");
    }];
}
/* 助记词正确，密码正确，助记词分隔符为null */
- (void)createWallet8{
    NSArray *mnemonicWords = @[@"admit", @"mad", @"dream" ,@"stable", @"scrub" ,@"rubber" ,@"cabbage", @"exist" ,@"maple" ,@"excuse" ,@"copper", @"month"];
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords password:@"123" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"助记词正确，密码=空字符串");
        NSAssert(account == NULL, @"助记词正确，密码=空字符串");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//创建钱包
/* 密码=NULL */
- (void)createWallet11{
    [WalletUtils createWalletWithPassword:NULL callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"密码=NULL, 错误结果 %@", error.localizedDescription);
        NSAssert([error code]== -101, @"错误码为-101");
        NSAssert([error.localizedDescription isEqualToString: @"password is invaild"], @"创建钱包密码为nil 创建失败");
    }];
}
/*密码为空字符串""*/
- (void)createWallet12{
    [WalletUtils createWalletWithPassword:@"" callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error) {
        NSLog(@"密码=空字符串, 错误结果 %@", error.localizedDescription);
        NSAssert([error code]== -101, @"错误码为-101");
        NSAssert([error.localizedDescription isEqualToString: @"password is invaild"], @"创建钱包密码为nil 创建失败");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//验证助记词是的合法
/*助记词=NULL*/
- (void)isValidMnemonicWords1{
    NSString *mnemonicWords = NULL;
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*助记词=空字符串*/
- (void)isValidMnemonicWords2{
    NSString *mnemonicWords = @"";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*助记词为13个*/
- (void)isValidMnemonicWords3{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month dream";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*助记词为11个*/
- (void)isValidMnemonicWords4{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*助记词错误*/
- (void)isValidMnemonicWords5{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper exist";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*助记词大小写敏感*/
- (void)isValidMnemonicWords6{
    NSString *mnemonicWords = @"admit mad dream stable Scrub rubber cabbage exist maple excuse copper month";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*助记词正确 componentsSeparatedByString=null*/
- (void)isValidMnemonicWords7{
    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    BOOL isValidMnemonicWords = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:NULL]];
    NSAssert(isValidMnemonicWords== false, @"isValidMnemonicWords为false");
}
/*------------------------------------------------------------------------------------------------------------------*/
// 获得checksum地址
/* 地址全小写 */
- (void)getChecksumAddress{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffed";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert([checksumAddress isEqualToString: @"0x7567D83b7b8d80ADdCb281A71d54Fc7B3364ffed"], @"获取checksum地址");
    NSLog(@"checksumAddress= %@", checksumAddress);
}
/*地址=null*/
- (void)getChecksumAddress1{
    NSString *address = NULL;
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert(checksumAddress == NULL, @"获取checksum地址");
}
/*地址=""*/
- (void)getChecksumAddress2{
    NSString *address = @"";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert([checksumAddress isEqualToString:@""], @"获取checksum地址");
}
/*地址长度=43位*/
- (void)getChecksumAddress3{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffed1";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert([checksumAddress isEqualToString:@""], @"获取空字符串checksum地址");
    NSLog(@"错误结果 %@", checksumAddress);
}
/*地址长度=41位*/
- (void)getChecksumAddress4{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffe";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert([checksumAddress isEqualToString:@""], @"获取空字符串checksum地址");
    NSLog(@"错误结果 %@", checksumAddress);
}
/*地址非16进制*/
- (void)getChecksumAddress5{
    NSString *address = @"0x7567d83b7b8d80addcb281a71d54fc7b3364ffeg";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    NSAssert([checksumAddress isEqualToString:@""], @"获取空字符串checksum地址");
    NSLog(@"错误结果 %@", checksumAddress);
}
/*------------------------------------------------------------------------------------------------------------------*/
// 验证keystore 格式
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
    NSAssert(isOKKestore == false, @"keystore=空字符串");
}
/*keystore=”true“*/
- (void)isValidKeystore3{
    NSString *keystore = @"true";
    BOOL isOKKestore = [WalletUtils isValidKeystore:keystore];
    NSAssert(isOKKestore == false, @"keystore=非json格式的字符串");
}
/*------------------------------------------------------------------------------------------------------------------*/
//通过keystore获得地址
/*keystore=null*/
- (void)getAddress1{
    NSString *keystore = NULL;
    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];
    NSAssert([getAddress isEqualToString:@""], @"通过keystore获得地址,keystore=null");
}
/*keystore=”“*/
- (void)getAddress2{
    NSString *keystore = @"";
    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];
    NSAssert([getAddress isEqualToString:@""], @"通过keystore获得地址,keystore=空字符串");
}
/*keystore=”true“*/
- (void)getAddress3{
    NSString *keystore = @"true";
    NSString *getAddress = [WalletUtils getAddressWithKeystore:keystore];
    NSAssert([getAddress isEqualToString:@""], @"通过keystore获得地址,keystore=非json格式的字符串");
}
/*------------------------------------------------------------------------------------------------------------------*/
//数据签名
/*keystore=null*/
- (void)sign1{
    NSString *keystore = NULL;
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         NSAssert([error code]== -1, @"sign1");
         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"sign1");
     }];
}
/*keystore=""*/
- (void)sign2{
    NSString *keystore = @"";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         NSAssert([error code]== -1, @"sign2");
         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"sign2");
     }];
}
/*keystore="true"*/
- (void)sign3{
    NSString *keystore = @"true";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         NSAssert([error code]== -1, @"sign3");
         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -1.)"], @"sign3");
     }];
}
/*keystore正确，密码为=null*/
- (void)sign4{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:NULL
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         NSLog(error.localizedDescription);
         NSAssert([error code]== -10, @"sign4");
         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"sign4");
     }];
}
/*keystore正确，密码为=“”*/
- (void)sign5{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@""
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         NSLog(error.localizedDescription);
         NSAssert([error code]== -10, @"sign4");
         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"sign4");
     }];
}
/*keystore正确，密码错误*/
- (void)sign6{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:@"1"
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         NSLog(error.localizedDescription);
         NSAssert([error code]== -10, @"sign4");
         NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"sign4");
     }];
}
/*keystore密码正确，签名为空*/
- (void)sign7{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:NULL
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         //签名信息，恢复地址
         //         NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
         NSLog(@"address == %@",error.localizedDescription);
     }];
}
/*keystore密码正确，签名=“”*/
- (void)sign8{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    
    NSData *messageData = [@"test unit" dataUsingEncoding:NSUTF8StringEncoding];
    [WalletUtils signWithMessage:@""
                        keystore:keystore
                        password:@"123456"
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         //签名信息，恢复地址
         //         NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
         NSLog(@"address == %@",error.localizedDescription);
     }];
}
/*------------------------------------------------------------------------------------------------------------------*/
// 签名信息，恢复地址
/*签名信息=null*/
- (void)recoverAddress1{
    NSData *messageData = [@"test" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:NULL];
    NSAssert(address == NULL, @"recoverAddress1");
}
/*签名信息=""*/
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
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         
         //签名信息，恢复地址
         NSString *address = [WalletUtils recoverAddressFromMessage:NULL signatureData:signatureData];
         NSLog(@"address == %@",address);
         //         NSAssert([address isEqualToString:@"0x7567D83b7b8d80ADdCb281A71d54Fc7B3364ffed"], @"错误码为-1");
     }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//修改密码
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
/*keystore正确，旧密码=null*/
- (void)modifyKeystorePassword4{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:NULL callback:^(NSString * _Nonnull newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword4");
    }];
}
/*keystore正确，旧密码=”“*/
- (void)modifyKeystorePassword5{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"" callback:^(NSString * _Nonnull newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword5");
    }];
}
/*keystore正确，旧密码错误*/
- (void)modifyKeystorePassword6{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"1" callback:^(NSString * _Nonnull newKeystore) {
        NSLog(@"newKeystore.length=%ld", newKeystore.length);
        NSAssert(newKeystore.length == 0, @"modifyKeystorePassword6");
    }];
}
/*keystore旧密码正确，新密码=null*/
- (void)modifyKeystorePassword7{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:NULL oldPassword:@"123456" callback:^(NSString * _Nonnull newKeystore) {
        NSString *getAddress = [WalletUtils getAddressWithKeystore:newKeystore];
        NSLog(@"newKeystore.length=%ld, getAddress=%@", newKeystore.length, getAddress);
        NSAssert(newKeystore.length != 0, @"modifyKeystorePassword7");
        NSAssert([getAddress isEqualToString:@"0x36D7189625587D7C4c806E0856b6926Af8d36FEa"], @"modifyKeystorePassword7");
    }];
    
    
}
/*keystore旧密码正确，新密码=""*/
- (void)modifyKeystorePassword8{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils modifyKeystore:keystore newPassword:@"123" oldPassword:@"123456" callback:^(NSString * _Nonnull newKeystore) {
        NSString *getAddress = [WalletUtils getAddressWithKeystore:newKeystore];
        NSLog(@"newKeystore.length=%ld, getAddress=%@", newKeystore.length, getAddress);
        NSAssert([getAddress isEqualToString:@"0x36D7189625587D7C4c806E0856b6926Af8d36FEa"], @"modifyKeystorePassword8");
    }];
}

/*------------------------------------------------------------------------------------------------------------------*/
// 验证keystore密码正确
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
/*keystore正确, 密码=null*/
- (void)verifyKeystorePassword4{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils verifyKeystore:keystore password:NULL callback:^(BOOL result) {
        NSAssert(result == false, @"verifyKeystorePassword4");
    }];
}
/*keystore正确, 密码=”“*/
- (void)verifyKeystorePassword5{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils verifyKeystore:keystore password:@"" callback:^(BOOL result) {
        NSAssert(result == false, @"verifyKeystorePassword4");
    }];
}
/*keystore正确, 密码错误*/
- (void)verifyKeystorePassword6{
    NSString *keystore = @"{\"address\":\"7567d83b7b8d80addcb281a71d54fc7b3364ffed\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"61f56506769dbddf0366a3fd479ceb05\"},\"ciphertext\":\"23077a4e5aa7cd30590a878083d802d9c1b44c78923236524918e023d189b69f\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"93e8cea9e1e4822258e453a11a2c8e5b8168cfaadc5821258c18f75e7ef36d90\"},\"mac\":\"f99cd87ed0c4cb9248fcee03fddd7f791c92e10533f3a103a46cbbc4f0324b22\"},\"id\":\"fad80d2d-1826-4383-a49e-a36183ccdf7e\",\"version\":3}";
    [WalletUtils verifyKeystore:keystore password:@"a" callback:^(BOOL result) {
        NSAssert(result == false, @"verifyKeystorePassword4");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
// 通过keystore 获得私钥
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
/*keystore正确，密码=null*/
- (void)decryptKeystore4{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils decryptKeystore:keystore password:NULL callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        NSAssert([error code]== -10, @"decryptKeystore4");
        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"decryptKeystore4");
    }];
}
/*keystore正确，密码=""*/
- (void)decryptKeystore5{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils decryptKeystore:keystore password:@"" callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        NSAssert([error code]== -10, @"decryptKeystore4");
        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"decryptKeystore4");
    }];
}

/*keystore正确，密码错误*/
- (void)decryptKeystore6{
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    [WalletUtils decryptKeystore:keystore password:@"a" callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        NSAssert([error code]== -10, @"decryptKeystore4");
        NSAssert([error.localizedDescription isEqualToString: @"The operation couldn’t be completed. (io.AccountError error -10.)"], @"decryptKeystore4");
    }];
}
/*------------------------------------------------------------------------------------------------------------------*/
//私钥转keystore
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
/*privatekey=非16进制*/
- (void)encryptPrivateKey3{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85eg";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey3");
    }];
}
/*privatekey 0x后65位*/
- (void)encryptPrivateKey4{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85eee";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey4");
    }];
}
/*privatekey 0x后63位*/
- (void)encryptPrivateKey5{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85e";
    [WalletUtils encryptPrivateKeyWithPassword:@"123" privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@", keystoreJson);
        NSAssert(keystoreJson.length == 0, @"encryptPrivateKey5");
    }];
}
/*privatekey正确，密码为null*/
- (void)encryptPrivateKey6{
    NSString *privatekey = @"0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85ee";
    [WalletUtils encryptPrivateKeyWithPassword:NULL privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
        NSLog(@"keystoreJson=%@ %ld", keystoreJson, keystoreJson.length);
        NSAssert(keystoreJson.length == 491, @"encryptPrivateKey6");
    }];
}
/*privatekey正确，密码为""*/
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
/*keystore正确, 密码=null*/
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
/*keystore正确, 密码=""*/
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
/*keystore正确, 密码错误*/
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
/*keystore 密码正确, transactionModel=null*/
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
/* keystore正确，密码=null */
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
/* keystore正确，密码="" */
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
/* keystore正确，密码错误 transactionModel=null*/
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
/* keystore正确，密码正确， */
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
    
    [self signAndSendTransfer7];
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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
            
            TransactionParameter *transactionModel = [TransactionParameter creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
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

