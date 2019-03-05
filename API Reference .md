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
>    @param mnemonicList :12 words
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
>   @param mnemonicList :12 words   
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
+ (NSString *)recoverAddressFromMessage:(NSData *)message
                          signatureData:(NSData *)signatureData;
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
>   @param account :WalletAccountModel object   
>   @param callback :Callback after the end . keystore :Keystore in json format   
> 
> 
```obj-c
+ (void)encryptKeystoreWithPassword:(NSString *)password
                            account:(WalletAccountModel *)account
                           callback:(void (^)(NSString *keystoreJson))callback;
```
##  Set node url   
>
>  @param nodelUrl :node url   
>
>
```obj-c
+ (void)setNode:(NSString *)nodelUrl;
```



##  Get node url   
```obj-c
+ (NSString *)getNode;
```


##   Sign message  
>
>   @param message : Prepare the data to be signed   
>   @param keystoreJson :Keystore in json format   
>   @param password :  Wallet password   
>   @param callback :Callback after the end .   
>

```obj-c
+ (void)sign:(NSData *)hashedMessage
    keystore:(NSString *)keystoreJson
    password:(NSString *)password
    callback:(void (^)(NSData *signatureData,NSError *error))callback;

```

##   Sign and send
>
>  @param parameter: signature parameters   
>  @param keystoreJson: Keystore in json format   
>  @param callback: Callback after the end. txId: Transaction identifier ; signer:  signer address   
>
>
```obj-c
+ (void)sendWithKeystore:(NSString *)keystoreJson parameter:(TransactionParameter *)parameter callback:(void(^)(NSString *txId,NSString *signer))callback;
```

##   Verify keystore format  
>
>  @param keystoreJson : Keystore in json format   
>  @return result  
>

```obj-c
+ (BOOL)isValidKeystore:(NSString *)keystoreJson;
```


##  Set keystore list to SDK
>
>  @param keystoreList :Array of keystore json
>
>

```obj-c
+ (void)initDappWebViewWithKeystore:(NSArray *)keystoreList;  

```


##   Inject js into webview   
>
>  @param webview :Developer generated webview object   
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


 ## Release the singleton object in the dapp
 >  Call this method when exiting the contrller where dapp is located
 >
 >
 >
 ```obj-c
+ (void)dealocDappSingletion;
```


