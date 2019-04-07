##  Create wallet   
>
>    @param password :Wallet password  
>    @param callback : Callback after the end；The attributes of a class has mnemonicPhras , address, privateKey and keystore    
> 

```obj-c
+ (void)creatWalletWithPassword:(NSString *)password  
                       callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

```

## Create wallet with mnemonic words   
>
>    @param mnemonicList :mnemonic Words
>    @param password :Wallet password    
>    @param callback : Callback after the end；The attributes of a class has mnemonicPhras , address, privateKey and keystore    
> 
```obj-c

+ (void)creatWalletWithMnemonicWords:(NSArray *)mnemonicWords
                            password:(NSString *)password
                            callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

```

##  Verify the mnemonic words    
>
>   @param mnemonicList : words   
>   @return result   
> 
```obj-c
+ (BOOL)isValidMnemonicWords:(NSArray *)mnemonicWords;
```


##  Get checksum address    
>
>  @param address :Wallet address   
>  @return checksum address   
>
```obj-c
+ (NSString *)getChecksumAddress:(NSString *)address;
```


##  Recover address
>
>  @param message : Data before signature  
>  @param signatureData : Data after signature  
>  @return  address  
> 

```obj-c
+ (NSString *)recoverAddressFromMessage:(NSData *)message signatureData:(NSData *)signatureData;
```

##  Decrypt keystore
>
 >  @param keystoreJson : Keystore in json format   
 >  @param password : Wallet password   
 >  @param callback : Callback after the end . account :The attributes of a class has mnemonicPhras , address, privateKey and keystore   
 >
 >
 ```
+ (void)decryptkeystore:(NSString *)keystoreJson
               password:(NSString *)password
               callback:(void(^)(WalletAccountModel *account,NSError *error))callback;
```
##  Change wallet password
>
>   @param password :Wallet password   
>   @param privateKey : privateKey
>   @param callback :Callback after the end . keystore :Keystore in json format   
> 
> 
```obj-c
+ (void)encryptPrivateKeyWithPassword:(NSString *)password
                              privateKey:(NSString *)privateKey
                             callback:(void (^)(NSString *keystoreJson))callback;
```
##  Set node url   
>
>  @param nodelUrl :node url   
>
>
```obj-c
+ (void)setNodeUrl:(NSString *)nodelUrl;
```



##  Get node url   
```obj-c
+ (NSString *)getNodeUrl;
```


##   Sign message  
>
>   @param message : Prepare the data to be signed   
>   @param keystoreJson :Keystore in json format   
>   @param password :  Wallet password   
>   @param callback :Callback after the end .   
>

```obj-c
+ (void)signWithMessage:(NSData *)message
               keystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void (^)(NSData *signatureData,NSError *error))callback;

```

##   Sign and send
>
>  @param parameter: signature parameters   
>  @param keystoreJson: Keystore in json format   
>   @param password :  Wallet password   
>  @param callback: Callback after the end. txId: Transaction identifier ; signer:  signer address   
>
>
```obj-c
+ (void)signAndSendTransfer:(NSString *)keystoreJson
                  parameter:(TransactionParameter *)parameter
                   password:(NSString *)password
                   callback:(void(^)(NSString *txId))callback;
```

##   Sign transfer message
>
>  @param parameter: signature parameters     
>  @param keystoreJson: Keystore in json format     
>   @param password :  Wallet password     
>  @param callback: Callback after the end. raw: txid and signature  
>
>
```obj-c
+ (void)signWithParameter:(TransactionParameter *)parameter
                 keystore:(NSString*)keystoreJson
                 password:(NSString*)password
                 callback:(void(^)(NSString *raw))callback;
```


##  Check if the keystore format is correct

>
>  @param keystoreJson : Keystore in json format   
>  @return result  
>

```obj-c
+ (BOOL)isValidKeystore:(NSString *)keystoreJson;
```


##  Set delegate to SDK
>
>  @param delegate : delegate object
>   reture :YES ,set delegate success;NO ,set delegate fail
>

```obj-c
+ (BOOL)initDAppWithDelegate:(id)delegate;

```


##   Inject js into webview   
>
>  @param webview :Developer generated WKWebView object , Can not be UIWebView
>
>
```obj-c
+ (void)injectJSWithWebView:(WKWebView *)webview;
```

##  Analyze data in webview's runJavaScriptTextInputPanelWithPrompt callback method
>
> @param webView :The web view invoking the delegate method.   
> @param defaultText: The initial text to display in the text entry field.   
> @param completionHandler: The completion handler to call after the text   
  input panel has been dismissed. Pass the entered text if the user chose
  OK, otherwise nil.
>
```obj-c
+ (void)webView:(WKWebView *)webView defaultText:(NSString *)defaultText completionHandler:(void (^)(NSString *result))completionHandler;
```


 ## Release the singleton of dapp
 >  Call this method when exiting the contrller where dapp is located
 >
 >
 >
 ```obj-c
+ (void)deallocDappSingletion;
```

 ## Change Wallet password  
>  @param oldPassword : Old password  
>  @param newPassword : New password   
>  @param keystoreJson : Keystore in json format     
>  @param callback : Callback after the end. newKeystore: new keystore   
 >
 >
 ```obj-c
+ (void)modifyKeystorePassword:(NSString *)oldPassword
                         newPW:(NSString *)newPassword
                  keystoreJson:(NSString *)keystoreJson
                      callback:(void (^)(NSString *newKeystore))callback;
```

 ## Verify the keystore with a password   
 >  @param password : Wallet password  
 >  @param keystoreJson : Keystore in json format    
 >  @param callback : Callback after the end.   

 ```obj-c
+ (void)verifyKeystorePassword:(NSString *)keystoreJson
                      password:(NSString *)password
                      callback:(void (^)(BOOL result))callback;
```
 ##  Get chainTag
 >  
 >  @param callback : Callback after the end. 
 >
 >
 ```obj-c
+ (void)getChainTag:(void (^)(NSString *chainTag))callback;
```
 ## Get reference of block   
 >  @param callback : Callback after the end.    
 >
 >
 ```obj-c
+ (void)getBlockReference:(void (^)(NSString *blockReference))callback;
```
 ##  Get address from keystore   
 >  @param keystoreJson : Keystore in json format.   
 >  retuen : address   
 >
 >
 ```obj-c
+ (NSString *)getAddressWithKeystore:(NSString *)keystoreJson;
```


 ##  Dapp call transfer function ,app developer implementation   
 >  @param clauses : clause list   
 >  @param gas :  Set maximum gas allowed for call   
 >  @param callback : Callback after the end. txid:Transaction identifier   
 >
 >
 ```obj-c
- (void)onTransfer:(NSArray *)clauses gas:(NSString *)gas callback:(void(^)(NSString *txid))callback;

 ```



 ##  Dapp call get address ,app developer implementation   
 >  @param callback : Callback after the end. addressList :address list   
 >
 >
 ```obj-c
- (void)onGetWalletAddress:(void(^)(NSArray *addressList))callback;
```


