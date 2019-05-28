The wallet function is implemented by calling SDK WalletUtils class: #import "WalletUtils.h"

##  Set node url   
>
>  @param nodelUrl : Node url   
>
>
```obj-c
+ (void)setNodeUrl:(NSString *)nodelUrl;

Example:
 //Set it as a Main_Node environment
 [WalletUtils setNodeUrl:Main_Node];

```



##  Get node url   
### If nodeUrl is not set, the default value is Main_Node.
```obj-c
+ (NSString *)getNodeUrl;
 
Example:
    NSString *nodeUrl = [WalletUtils getNodeUrl];

```


##  Create wallet   
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
        NSString *mnemonic = [account.words componentsJoinedByString:@" "];
        NSString *address = account.address;
        NSString *privateKey = account.privatekey;
        NSString *keystore = account.keystore;
        
    }];
    
```



## Create wallet with mnemonic words   
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
        NSString *address = account.address;
        NSString *privateKey = account.privatekey;
        NSString *keystore = account.keystore;
         
    }];

```

##  Verify the mnemonic words    
>
>   @param mnemonicList : Mnemonic words list  
>   @return result   
> 
```obj-c
+ (BOOL)isValidMnemonicWords:(NSArray<NSString *> *)mnemonicWords;


Example:

    NSString *mnemonicWords = @"admit mad dream stable scrub rubber cabbage exist maple excuse copper month";
    BOOL result = [WalletUtils isValidMnemonicWords:[mnemonicWords componentsSeparatedByString:@" "]];
    
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
    BOOL result = [WalletUtils isValidKeystore:keystore];
    
    
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
            
        }else{//fail
            
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
    [WalletUtils modifyKeystore:keystore newPassword:newPassword oldPassword:oldPassword callback:^(NSString * _Nonnull newKeystore) {

        if (newKeystore.length > 0) {
            //success

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
 ```
+ (void)decryptkeystore:(NSString *)keystoreJson
               password:(NSString *)password
               callback:(void(^)(WalletAccountModel *account,NSError *error))callback;
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
```

##  Get checksum address    
>
>  @param address : Wallet address   
>  @return checksum address   
>
```obj-c
+ (NSString *)getChecksumAddress:(NSString *)address;
```
##  Get address from keystore   
 >  @param keystoreJson : Keystore JSON encryption format for user wallet private key   
 >  retuen : Wallet address   
 >
 >
 ```obj-c
+ (NSString *)getAddressWithKeystore:(NSString *)keystoreJson;
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

```



##  Add the signature address to the authentication signature data  
>
>  @param signer : Enforces the specified address to sign the certificate   
>  @param message : Authentication signature data   
>

```obj-c
+ (NSString *)addSignerToCertMessage:(NSString *)signer message:(NSDictionary *)message;
```

##  Recover address
>
>  @param message : Data to be signed      
>  @param signatureData : Signature is 65 bytes   
>  @return  address  
> 

```obj-c
+ (NSString *)recoverAddressFromMessage:(NSData *)message signatureData:(NSData *)signatureData;
```



 ##  Get chainTag of block chain 
 >  
 >  @param callback : Callback after the end. 
 >
 >
 ```obj-c
+ (void)getChainTag:(void (^)(NSString *chainTag))callback;
```
 ## Get reference of block chain   
 >  @param callback : Callback after the end.    
 >
 >
 ```obj-c
+ (void)getBlockReference:(void (^)(NSString *blockReference))callback;
```
 


##   Sign and send Transaction
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
```
TransactionParameter attribute description：

- clauses : NSArry<Clause> - Multi-transaction information

- gas : NSString  - Miner Fee Parameters for Packing

- chainTag : NSString - Genesis block ID last byte hexadecimal

- blockReference : NSString - Refer to the last 8 bytes of blockId in hexadecimal

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

##   Signe transaction
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
```




## Support the DApp development environment in webview
###  Set delegate to SDK
>
>  @param delegate : Delegate object  
>

```obj-c
+ (void)initDAppWithDelegate:(id)delegate;

```


##   Inject js into webview   
>
>  @param config : Developer generated WKWebViewConfiguration object
>
>
```obj-c
+ (void)injectJSWithWebView:(WKWebViewConfiguration *)config;  

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

```


 ## Memory Recycling to Prevent Memory Leakage  
 >  Call this method when exiting the contrller where DApp is located 
 >
 >
 >
 ```obj-c
+ (void)deallocDApp;
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

 ```


 ##  App developer implementation when DApp calls get address function    
 
 >  delegate function that must be implemented to support the DApp environment   
 >  @param callback : Callback after the end. addressList :address list   
 >
 >
 
```obj-c
- (void)onGetWalletAddress:(void(^)(NSArray<NSString *> *addressList))callback;
```



 ##   App developer implementation when dapp calls authentication function   

 >  delegate function that must be implemented to support the DApp environment   
 >  @param message : Data to be signed,form dapp  
 >  @param signer : Enforces the specified address to sign the certificate    
 >  @param callback : Callback after the end.signer: Signer address; signatureData : Signature is 65 bytes   
 >
  
 ```obj-c
- (void)onCertificate:(NSDictionary *)message 
               signer:(NSString *)signer 
             callback:(void(^)(NSString *signer, NSData *signatureData))callback;

 ```



 ##    App developer implementation when dapp calls checkOwn address function   
 
 >  delegate function that must be implemented to support the DApp environment   
 >  @param address : Address from dapp  
 >  @param callback : Callback after the end  
 >
  
```obj-c
- (void)onCheckOwnAddress:(NSString *)address callback:(void(^)(BOOL result))callback;
```



