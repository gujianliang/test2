# The wallet function is implemented by calling class: WalletUtils

## SDK initialization

SDK initialization
Inherit the AppDelegate class and implement the following methods:
```obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [WalletUtils setNodeUrl:Main_Node];
    
    ...
    
    return YES;
}
```

##  Set node url   
>
>  
> Node: Any form of server in a block chain network.
> 
> Node url: Unified resource location address for participating block chain servers.
>
```obj-c
@param nodelUrl : Node url   
+ (void)setNodeUrl:(NSString *)nodelUrl;
```

Example:
```obj-c
 //Set it as a Main_Node environment

 [WalletUtils setNodeUrl:Main_Node];

Or if you have a corresponding node url, you can change it to your own node url:

 [WalletUtils setNodeUrl:@"customNode"];
            
Switching test node url:

 [WalletUtils setNodeUrl:Test_Node];

If nodeUrl is not set, the default value is Main_Node
```   

```



##  Get node url   
### If nodeUrl is not set, the default value is Main_Node.
```obj-c
+ (NSString *)getNodeUrl;
 
Example:
    NSString *nodeUrl = [WalletUtils getNodeUrl];

```


##  Create wallet   
After entering the wallet password, the user can create the wallet through the following methods:

>
>    @param password : Wallet password  
>    @param callback : Callback after the end; The attributes of a class has mnemonicPhras , address, privateKey and keystore    
> 

```obj-c
+ (void)createWalletWithPassword:(NSString *)password  
                        callback:(void(^)(WalletAccountModel *account,NSError *error))callback;


Example:
    //Create a wallet with your password.
    [WalletUtils createWalletWithPassword:password
                                 callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error)

    {
       if(error == nil){
    
            NSString *mnemonic = [account.words componentsJoinedByString:@" "];
            NSString *address = account.address;
            NSString *privateKey = account.privatekey;
            NSString *keystore = account.keystore;
        
             //Keystore is saved in files or databases
             
        }else{
            //fail
        }
    }];
    
```



## Create wallet with mnemonic words  
When the user has mnemonic words, enter the mnemonic words and the password of the keystore of the wallet to import the wallet. The method of using the mnemonic words as follows:

>
>    @param mnemonicList : Mnemonic Words   
>    @param password : Wallet password    
>    @param callback : Callback after the end；The attributes of a class has mnemonicPhras , address, privateKey and keystore    
> 
```obj-c

+ (void)createWalletWithMnemonicWords:(NSArray<NSString *> *)mnemonicWords
                            password:(NSString *)password
                            callback:(void(^)(WalletAccountModel *account,NSError *error))callback;


Example:
    // Create a wallet with your password and mnemonic words.
    [WalletUtils createWalletWithMnemonicWords:mnemonicWords
                                password:self.password.text
                                callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error)
    {
        if(error == nil){
            
            NSString *address = account.address;
            NSString *privateKey = account.privatekey;
            NSString *keystore = account.keystore;

            //Keystore is saved in files or databases
            
        }else{
            //fail
        }
         
    }];

```

##  Verify the mnemonic words    
>
>   @param mnemonicList : Mnemonic words list  ,The range of mnemonic words is limited to 12, 15, 18, 21 and 24.
>   @return result   
> 
```obj-c
+ (BOOL)isValidMnemonicWords:(NSArray<NSString *> *)mnemonicWords;


Example:

    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    BOOL isValid = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    // isValid is YES
```
##  Verify keystore format   

>
>  @param keystoreJson : Keystore JSON encryption format for user wallet private key    
>  @return result  
>

```obj-c
+ (BOOL)isValidKeystore:(NSString *)keystoreJson;

Example:
    NSString *keystore = @"{\"version\":3,\"id\":\"1150C15C-2E20-462B-8A88-EDF8A0E4DB71\",\n \"crypto\":{\"ciphertext\":\"1cf8d74d31b1ec2568f903fc2c84d215c0401cbb710b7b3de081af1449ae2a89\",\"cipherparams\":{\"iv\":\"03ccae46eff93b3d9bdf2b21739d7205\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"r\":8,\"p\":1,\"n\":262144,\"dklen\":32,\"salt\":\"a71ecee9a1c33f0311e46f7da7da8d218a8c5b3d1067716a9bcdb767785d8e83\"},\"mac\":\"82b20c61854621f35b4d60ffb795655258356f310cdffa587f7db68a1789de75\",\"cipher\":\"aes-128-ctr\"},\"address\":\"cc2b456b2c9399b4b68ef632cf6a1aeabe67b417\"}";
    BOOL isValid = [WalletUtils isValidKeystore:keystore];
    // isValid is YES
    
```





## Verify the keystore with a password   
 >  @param password : Wallet password  
 >  @param keystoreJson : Keystore JSON encryption format for user wallet private key  
 >  @param callback : Callback after the end.   

 ```obj-c
 
+ (void)verifyKeystore:(NSString *)keystoreJson
              password:(NSString *)password
              callback:(void (^)(BOOL result))callback;

Example:
//Verification keystore
    [WalletUtils verifyKeystore:keystore password:password callback:^(BOOL result) {
        if (result) {
            //success
            
            //Keystore is saved in files or databases
        }else{ //fail
            
        }
    }];
    
```

## Modify password of keystore
>  @param oldPassword : Old password  
>  @param newPassword : New password   
>  @param keystoreJson : Keystore JSON encryption format for user wallet private key   
>  @param callback : Callback after the end. newKeystore: new keystore   
 >
 >
 ```obj-c
+ (void)modifyKeystore:(NSString *)keystoreJson
           newPassword:(NSString *)newPassword
           oldPassword:(NSString *)oldPassword
              callback:(void (^)(NSString *newKeystore))callback;

Example:
//change Password
    [WalletUtils modifyKeystore:keystore 
                    newPassword:newPassword 
                    oldPassword:oldPassword 
                       callback:^(NSString * _Nonnull newKeystore) {

        if (newKeystore.length > 0) {
            //success
            //Keystore is saved in files or databases
        }else {
            //fail
        }
    }];
    
```

##  Decrypt keystore
>
 >  @param keystoreJson : Keystore JSON encryption format for user wallet private key   
 >  @param password : Wallet password   
 >  @param callback : Callback after the end . account :The attributes of a class has mnemonicPhras , address, privateKey and keystore   
 >
 >
 ```obj-c
+ (void)decryptkeystore:(NSString *)keystoreJson
               password:(NSString *)password
               callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

Example:
//Get the private key through the keystore
NSString *keystoreJson = "{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";

    [WalletUtils decryptKeystore:keystoreJson
                        password:@"123456" 
                        callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        
        if (!error) {
            //success
            
            //privateKey:0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85ee

            
        }else //fail
        {
            
        }
    }];
```
## Encrypted private key
>
>   @param password : Wallet password   
>   @param privateKey : Private Key   
>   @param callback : Callback after the end . keystore :Keystore in json format     
> 
> 
```obj-c
+ (void)encryptPrivateKeyWithPassword:(NSString *)password
                           privateKey:(NSString *)privateKey
                             callback:(void (^)(NSString *keystoreJson))callback;

Example:
    //Private key to keystore
        NSString *privateKey = "0xbc9fe2428a8faec37674412c113f4a9a66b2e40076014547bfe7bbdc2c5a85ee";
        [WalletUtils encryptPrivateKeyWithPassword:@"123" 
                                        privateKey:privatekey 
                                          callback:^(NSString * _Nonnull keystoreJson) {
                
                NSString *address = [WalletUtils getAddressWithKeystore:keystoreJson];
                //address:0x36D7189625587D7C4c806E0856b6926Af8d36FEa
        }];
```

##  Get checksum address    
>
>  @param address : Wallet address   
>  @return checksum address   
>
```obj-c
+ (NSString *)getChecksumAddress:(NSString *)address;

Example:
//Get checksum address
    NSString *address = @"0x36d7189625587d7c4c806e0856b6926af8d36fea";
    NSString *checksumAddress = [WalletUtils getChecksumAddress:address];
    //checkSumAddress:0x36D7189625587D7C4c806E0856b6926Af8d36FEa
```
##  Get address from keystore   
 >  @param keystoreJson : Keystore JSON encryption format for user wallet private key   
 >  retuen : Wallet address   
 >
 >
 ```obj-c
+ (NSString *)getAddressWithKeystore:(NSString *)keystoreJson;
 
Example:
//Get the address through the keystore
    NSString keystoreJson = "{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";

    NSString *address = [WalletUtils getAddressWithKeystore:keystoreJson];
    //address:0x36D7189625587D7C4c806E0856b6926Af8d36FEa
```
##   Sign message  
>
>   @param message : Prepare the data to be signed   
>   @param keystoreJson : Keystore JSON encryption format for user wallet private key   
>   @param password :  Wallet password   
>   @param callback : Callback after the end .   
>

```obj-c
+ (void)signWithMessage:(NSData *)message
               keystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void (^)(NSData *signatureData,NSError *error))callback;

Example:
    NSString *keystore = @"{\"address\":\"36d7189625587d7c4c806e0856b6926af8d36fea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"cipherparams\":{\"iv\":\"c4a723d57e1325a99d88572651959a9d\"},\"ciphertext\":\"73a4a3a6e8706d099b536e41f6799e71ef9ff3a9f115e21c58d9e81ade036705\",\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a322d4dce0f075f95a7748c008048bd3f80dbb5645dee37576ea93fd119feda2\"},\"mac\":\"66744cc5967ff5858266c247dbb088e0986c6f1d50156b5e2ce2a19afdc0e498\"},\"id\":\"0fe540de-1957-4bfe-a326-16772e61f677\",\"version\":3}";

    NSData *messageData = [@"dkfjalsdjfk" dataUsingEncoding:NSUTF8StringEncoding];
    //Data signature
    [WalletUtils signWithMessage:messageData
                        keystore:keystore
                        password:password
                        callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error)
     {
         
         NSString *strSignature = [SecureData dataToHexString:signatureData];
         //strSignature:0x4eb1ae9254217b356b2958ab0b7a02e72f6fa86858240ca4998f74ef8a0fd68155e71ba8bd15625dc3d5e0c89c021f3852070d290688a65ba7e1d608a03d6e8400

     }];

```




##  Recover address
>
>  @param message : Data to be signed      
>  @param signatureData : Signature is 65 bytes   
>  @return  address  
> 

```obj-c
+ (NSString *)recoverAddressFromMessage:(NSData *)message signatureData:(NSData *)signatureData;
 
Example:
    //Signature information, recovery address
    NSString *strSignture = @"0x4eb1ae9254217b356b2958ab0b7a02e72f6fa86858240ca4998f74ef8a0fd68155e71ba8bd15625dc3d5e0c89c021f3852070d290688a65ba7e1d608a03d6e8400";
    NSString *signatureData = [SecureData hexStringToData::strSigntureData];
    NSData *messageData = [@"dkfjalsdjfk" dataUsingEncoding:NSUTF8StringEncoding];
      NSString *address = [WalletUtils recoverAddressFromMessage:messageData signatureData:signatureData];
      NSLog(@"address == %@",address);
    //address:0x36D7189625587D7C4c806E0856b6926Af8d36FEa

```

##  Add the signature address to the authentication signature data  
>
>  @param signer : Enforces the specified address to sign the certificate   
>  @param message : Authentication signature data   
>

```obj-c
+ (NSString *)addSignerToCertMessage:(NSString *)signer message:(NSDictionary *)message;

Example:
 NSString *newMessage = [WalletUtils addSignerToCertMessage:signer.lowercaseString message:message];
      
```



 ##  Get chainTag of block chain 
 >  
 >  @param callback : Callback after the end. 
 >
 >
 ```obj-c
+ (void)getChainTag:(void (^)(NSString *chainTag))callback;

Example:
//Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        
        //Main_Node chainTag:0x4a
        //Test_Node chainTag:0x27
    }];
    
```
 ## Get reference of block chain   
 >  @param callback : Callback after the end.    
 >
 >
 ```obj-c
+ (void)getBlockReference:(void (^)(NSString *blockReference))callback;
 
Example:
 //Get the reference of the block chain
    [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            NSLog(@"blockReference == %@",blockReference);
    }];

```
 


##   Sign and send transaction
>
>  @param parameter: Transaction parameters   
>  @param keystoreJson: Keystore JSON encryption format for user wallet private key   
>  @param password :  Wallet password   
>  @param callback: Callback after the end. txid: Transaction identifier
>
>
```obj-c
+ (void)signAndSendTransferWithParameter:(TransactionParameter *)parameter
                                keystore:(NSString*)keystoreJson
                                password:(NSString *)password
                                callback:(void(^)(NSString *txid))callback;

Example:
[WalletUtils signAndSendTransferWithParameter:transactionModel
                                     keystore:keystore
                                     password:password
                                     callback:^(NSString * _Nonnull txid)
                     {
                         //Developers can use txid to query the status of data packaged on the chain

                         NSLog(@"\n txId: %@", txid);
                         
                         // Pass txid and signature address back to dapp webview
                         NSString *singerAddress = [WalletUtils getAddressWithKeystore:keystore];
                         callback(txid,singerAddress.lowercaseString);
                         
                     }];

```
TransactionParameter attribute description：

- clauses : NSArry<Clause> - Multi-transaction information

- gas : NSString  - Miner Fee Parameters for Packing

- chainTag : NSString - Genesis block ID last byte hexadecimal.[WalletUtils getBlockReference]

- blockReference : NSString - Refer to the last 8 bytes of blockId in hexadecimal.[WalletUtils getBlockReference]

- nonce : NSString  - The random number of trading entities. Changing Nonce can make the transaction have different IDs, which can be used to accelerate the trader.

- gasPriceCoef : NSString - This value adjusts the priority of the transaction, and the current value range is between 0 and 255 (decimal),The default value is "0"

- expiration : NSString - Deal expiration/expiration time in blocks,The default value is "720"

- dependsOn :NSString - The ID of the dependent transaction. If the field is not empty, the transaction will be executed only if the transaction specified by it already exists.The default value is null.

- reserveds: List  -  Currently empty, reserve fields. Reserved fields for backward compatibility,The default value is null

```obj-c
    TransactionParameter *transactionModel = [TransactionParameterBuiler creatTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {
                
                builder.chainTag        = chainTag;
                builder.blockReference  = blockReference;
                builder.nonce           = nonce;
                builder.clauses         = clauseList;
                builder.gas             = gas;
                builder.expiration      = expiration;
                builder.gasPriceCoef    = gasPriceCoef;
                
            } checkParams:^(NSString * _Nonnull errorMsg) {
               
            }];
    }];
    
```

##   Sign transaction
>
>  @param parameter: Transaction parameters     
>  @param keystoreJson: Keystore JSON encryption format for user wallet private key   
>   @param password :  Wallet password     
>  @param callback: Callback after the end. raw: RLP encode data and signature  
>
>
```obj-c
+ (void)signWithParameter:(TransactionParameter *)parameter
                 keystore:(NSString*)keystoreJson
                 password:(NSString*)password
                 callback:(void(^)(NSString *raw))callback;

Example:
[WalletUtils signWithParameter:transactionModel
                      keystore:keystore
                      password:password
                      callback:^(NSString * _Nonnull raw)
                     {

                         NSLog(@"\n raw: %@", raw);
                         
                     }];
                     
```




## Support the DApp development environment in webview
###  Support DApp development environment in Webview
To support the Dapp function, WebView needs the following initialization before opening Dapp.
Initialization is mainly JS injected into connex and web3.
[connex reference.](https://github.com/vechain/connex/blob/master/docs/api.md/)

###  Set delegate to SDK
>
>  @param delegate : Delegate object  
>

```obj-c
+ (void)initDAppWithDelegate:(id)delegate;

Example:
 // Set delegate
    [WalletUtils initDAppWithDelegate:self];

```


##   Inject js into webview   
>
>  @param config : Developer generated WKWebViewConfiguration object
>
>
```obj-c
+ (void)injectJSWithWebView:(WKWebViewConfiguration *)config;  

Example:

    // Please note that, This is a 'WKWebView' object, does not support a "UIWebView" object.

    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    
    //inject js to wkwebview
    [WalletUtils injectJSWithWebView:configuration];
    

```

##  Parsing data in webview's callback method runJavaScriptTextInputPanelWithPrompt
>
> @param webView :The web view invoking the delegate method.   
> @param defaultText: The initial text to display in the text entry field.   
> @param completionHandler: The completion handler to call after the text   
  input panel has been dismissed. Pass the entered text if the user choose
  OK, otherwise nil
>
```obj-c
+ (void)webView:(WKWebView *)webView 
    defaultText:(NSString *)defaultText 
completionHandler:(void (^)(NSString *result))completionHandler;


Example:
/**
* You must implement this delegate method to call js.
*/
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
        
    /*
     You must call this method. It is used to response web3 or connex operations.
     */
    [WalletUtils webView:webView  defaultText:defaultText completionHandler:completionHandler];
}

```


 ## Memory Recycling to Prevent Memory Leakage  
 >  Call this method when exiting the contrller where DApp is located 
 >
 >
 >
 ```obj-c
+ (void)deallocDApp;

Example:
/**
 * You must implement this method to free memory, otherwise there may be a memory overflow or leak.
 */
- (void)dealloc{
    [WalletUtils deallocDApp];
}
```

 

 ##  App developer implementation when DApp calls transaction function  
 
 >  delegate function that must be implemented to support the DApp environment   
 >  @param clauses : Clause list   
 >  @param gas :  Set maximum gas allowed for call   
 >  @param signer :   Enforces the specified address to sign the transaction    
 >  @param callback : Callback after the end. txid:Transaction identifier ; signer:Signer address  
 >
 >
 ```obj-c
- (void)onTransfer:(NSArray<ClauseModel *> *)clauses
            signer:(NSString *)signer
               gas:(NSString *)gas
          callback:(void(^)(NSString *txid ,NSString *signer))callback;


Example:
- (void)onTransfer:(NSArray<ClauseModel *> *)clauses
            signer:(NSString *)signer
               gas:(NSString *)gas
          callback:(void(^)(NSString *txid ,NSString *signer))callback
{
    
   //Get the local keystore
    
    NSString *address = [WalletUtils getAddressWithKeystore:keystore];
    
    //Specified signature address
    if (signer.length > 0 && [address.lowercaseString isEqualToString:signer.lowercaseString]) {
        
        callback(@"",@"");
        return;
    }


    ... Preparation parameters
    ... Assembly transactionParameter
    ... Verify parameters
    ... Initiate a transaction

[WalletUtils signAndSendTransferWithParameter:transactionModel
                                     keystore:keystore
                                     password:password
                                     callback:^(NSString * _Nonnull txid)
                     {
                         //Developers can use txid to query the status of data packaged on the chain

                         NSLog(@"\n txId: %@", txid);
                         
                         // Pass txid and signature address back to dapp webview
                         NSString *singerAddress = [WalletUtils getAddressWithKeystore:keystore];
                         callback(txid,singerAddress.lowercaseString);
                         
                     }];


}

 ```


 ##  App developer implementation when DApp calls get address function    
 
 >  Delegate function that must be implemented to support the DApp environment   
 >  @param callback : Callback after the end. addressList :address list   
 >
 >
 
```obj-c
- (void)onGetWalletAddress:(void(^)(NSArray<NSString *> *addressList))callback;

Example:
- (void)onGetWalletAddress:(void (^)(NSArray<NSString *> * _Nonnull))callback
{
    //Get the wallet address from local database or file cache

    //Callback to webview
    callback(@[address]);
}
```



 ##   App developer implementation when dapp calls authentication function   

 >  Delegate function that must be implemented to support the DApp environment   
 >  @param message : Data to be signed,form dapp  
 >  @param signer : Enforces the specified address to sign the certificate    
 >  @param callback : Callback after the end.signer: Signer address; signatureData : Signature is 65 bytes   
 >
  
 ```obj-c
- (void)onCertificate:(NSDictionary *)message 
               signer:(NSString *)signer 
             callback:(void(^)(NSString *signer, NSData *signatureData))callback;

Example:
- (void)onCertificate:(NSDictionary *)message signer:(NSString *)signer callback:(void (^)(NSString * signer, NSData *  signatureData))callback
{
   
    
    if (signer.length > 0) { //Specified signature address
       
        if ([address.lowercaseString isEqualToString:signer.lowercaseString]) {
            
            NSString *strMessage = [WalletUtils addSignerToCertMessage:signer.lowercaseString message:message];
            NSData *dataMessage = [strMessage dataUsingEncoding:NSUTF8StringEncoding];
            [self signCert:dataMessage signer:address.lowercaseString keystore:keystore callback:callback];
        }else{
            //Cusmtom alert error
            callback(@"",nil);
        }
    }else{
        NSString *strMessage = [WalletUtils addSignerToCertMessage:address.lowercaseString message:message];
        NSData *dataMessage = [strMessage dataUsingEncoding:NSUTF8StringEncoding];
        [self signCert:dataMessage signer:address.lowercaseString keystore:keystore callback:callback];
    }


    ... Verify password

 [WalletUtils signWithMessage:dataMessage
                     keystore:keystore 
                     password:password
                     callback:^(NSData * _Nonnull signatureData, NSError * _Nonnull error) {
                                         
                                         if (!error) {
                                             callback(signer,signatureData);
                                         }else{
                                             NSLog(@"error == %@",error.userInfo);
                                         }
                                     }];

}

 ```



 ##    App developer implementation when dapp calls checkOwn address function   
 
 >  Delegate function that must be implemented to support the DApp environment   
 >  @param address : Address from dapp  
 >  @param callback : Callback after the end  
 >
  
```obj-c
- (void)onCheckOwnAddress:(NSString *)address callback:(void(^)(BOOL result))callback;

Example:
- (void)onCheckOwnAddress:(NSString *)address callback:(void(^)(BOOL result))callback
{

    if ([localAddrss.lowercaseString isEqualToString:address.lowercaseString]) {
        callback(YES);
    }else{
        callback(NO);
    }
}

```

## Several main data structures

### keystore
```obj-c
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
```
### Hexadecimal must start with 0x.

### Address : 20 bytes hex string and start with 0x.



