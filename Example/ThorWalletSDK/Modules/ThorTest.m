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
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";
    
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
