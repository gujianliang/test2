##  Create wallet   
>
>    @param password :Wallet password  
>    @param block : Callback after the end；The attributes of a class has mnemonicPhras , address, privateKey, keystore 
> 

```
+ (void)creatWalletWithPassword:(NSString *)password
                       callback:(void(^)(WalletAccountModel *account,NSError *error))callBack;

```

## Create wallet with mnemonic   
>
>    @param mnemonicList :12 words for create wallet  
>    @param password :Wallet password    
>    @param block : Callback after the end；The attributes of a class has mnemonicPhras , address, privateKey, keystore 
> 
```

+ (void)creatWalletWithMnemonic:(NSArray *)mnemonicList
                       password:(NSString *)password
                       callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

```

##  Verify the mnemonic words    
>
>   @param mnemonicList :12 words   
>@return verification results
> 
```
+ (BOOL)isValidMnemonic:(NSArray *)mnemonicList;
```


##  Get checksum address    
>
>  @param address :wallet address   
>  @return checksum address   
>
```
+ (NSString *)getChecksumAddress:(NSString *)address;
```




##  Recover address
>
>  @param message : Data before signature  
>  @param signatureData : Data after signature  
>  @return  address  
> 

```
+ (NSString *)recoverAddressFromMessage:(NSData *)message
                          signatureData:(NSData *)signatureData;
```

##  Decrypt keystore
>
 >  @param keystore : Keystore in json format   
 >  @param password : Wallet password   
 >  @param callback : Callback after the end   
 >
 >
 ```
+ (void)decryptkeystore:(NSString *)keystore
               password:(NSString *)password
               callback:(void(^)(WalletAccountModel *account,NSError *error))callback;
```
##  Change wallet password
>
>   @param password :Wallet password   
>   @param account :WalletAccountModel object   
>   @param callback :Callback after the end   
> 
> 
```
+ (void)encryptkeystore:(NSString *)keystore
                account:(WalletAccountModel *)account
               callback:(void (^)(NSString *))callback;
```
##  Set node url   
>
>  @param nodelUrl :node url   
>
>
```
+ (void)setNode:(NSString *)nodelUrl;
```

/**
 *  @abstract
 *  get node url
 *
 */
+ (NSString *)getNode;



##   Sign message  
>
>   @param message : Prepare the data to be signed   
>   @param keystoreJson :Keystore in json format   
>   @param password :  Wallet password   
>   @param callback :Callback after the end  
>

```
+ (void)sign:(NSData *)hashedMessage
    keystore:(NSString *)keystoreJson
    password:(NSString *)password
    callback:(void (^)(NSData *signatureData,NSError *error))callback;

```

##   Sign and send
>
>  @param parameter: signature parameters   
>  @param keystoreJson: wallet for keystore    
>  @param block: callback   
>
>
```
+ (void)sendWithKeystore:(NSString *)keystoreJson parameter:(TransactionParameter *)parameter callback:(void(^)(NSString *txId,NSString *signer))callback;
```

##   Verify the keystore word is legal 
>
>  @param keystoreJson : wallet for keystore   
>  @return verification results   
>

```
+ (BOOL)isValidKeystore:(NSString *)keystoreJson;
```


##  Set the keystore list to sdk  
>
>  @param keystoreList :Array of keystore json
>
>

```
+ (void)initDappWebViewWithKeystore:(NSArray *)keystoreList;  

```


##   inject js into webview   
>
>  @param webview :Developer generated webview object
>
>
```
+ (void)injectJSWithWebView:(WKWebView *)webview;
```

##  Display a JavaScript text input panel.  
>
> @param webView :The web view invoking the delegate method.   
> @param defaultText: The initial text to display in the text entry field.   
> @param completionHandler: The completion handler to call after the text   
  input panel has been dismissed. Pass the entered text if the user chose
  OK, otherwise nil.
>
```
+ (void)webView:(WKWebView *)webView defaultText:(NSString *)defaultText completionHandler:(void (^)(NSString *result))completionHandler;
```
