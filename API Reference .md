##  create wallet   
>
>    @param password :Wallet password  
>    @param block : Callback after the end；The attributes of a class has mnemonicPhras , address, privateKey, keystore 
> 

```
+ (void)creatWalletWithPassword:(NSString *)password
                       callBack:(void(^)(Account *account)) block;

```

## create wallet with mnemonic   
>
>    @param mnemonicList :12 words for create wallet
>    @param password :Wallet password  
>    @param block : Callback after the end；The attributes of a class has mnemonicPhras , address, privateKey, keystore 
> 
```

+ (void)creatWalletWithMnemonic:(NSArray *)mnemonicList
                       password:(NSString *)password
                       callback:(void(^)(WalletAccountModel *account,NSError *error))block;

```

##  Verify the mnemonic word is legal     
>
>   @param mnemonicList :12 words 
>   @return verification results
> 
```
+ (BOOL)isValidMnemonicPhrase:(NSString*)mnemonicList;
```



##  recover address
>
>  @param message : Data before signature
>  @param signatureData : Data after signature
>  @return  address  
> 

```
+ (NSString *)recoverAddressFromMessage:(NSData*)message
                          signatureData:(NSData*)signatureData;
```

##   signature message  
>
>   @param message : Prepare the data to be signed
>   @param json :Keystore in json format
>   @param password :  Wallet password
>   @param block :Callback after the end
>

```
+ (void)signature:(NSData*)message
         keystore:(NSString*)json
         password:(NSString*)password
            block:(void (^)(NSData *signatureData,NSError *error))block;

```

##  Decryption keystore
>
 >  @param json : Keystore in json format
 >  @param password : Wallet password
 >  @param callback : Callback after the end
 >
 >
 ```
+ (void)decryptSecretStorageJSON:(NSString*)json
                        password:(NSString*)password
                        callback:(void(^)(WalletAccountModel *account,NSError *error))callback;
```
##  Use the new password to encrypt.
>
>   @param password :Wallet password
>   @param walletAccount :Account object
>   @param callback :Callback after the end
> 
> 
```
+ (void)encryptSecretStorageJSON:(NSString*)password
                         account:(WalletAccountModel *)walletAccount
                        callback:(void (^)(NSString *))callback;
```


##  Set the keystore list to sdk  
>
>  @param keystoreList :Array of keystore json
>
>

```
+ (void)initWebViewWithKeystore:(NSArray *)keystoreList;
```

##  Displays a JavaScript text input panel.  
>
> @param webView :The web view invoking the delegate method.   
> @param defaultText: The initial text to display in the text entry field.   
> @param completionHandler: The completion handler to call after the text   
  input panel has been dismissed. Pass the entered text if the user chose
  OK, otherwise nil.
>
```
+ (void)webView:(WKWebView>)webView defaultText:(NSString>)defaultText completionHandler:(void (^)(NSString>result))completionHandler;
```

##   inject js into webview   
>
>  @param webview :Developer generated webview object
>
>
```
+ (void)injectJSWithWebView:(WKWebView>)webview;
```
##   call sign control
>
>  @param parameter: signature parameters   
>  @param keystore: wallet for keystore    
>  @param block: callback   
>
>
```
+ (void)transactionWithKeystore:(NSString>)keystore parameter:(TransactionParameter>)parameter block:(void(^)(NSString>txId,NSString>signer))block;
```
##   Verify the keystore word is legal 
>
>  @param keystore :wallet for keystore   
>  @return verification results   
>

```
+ (BOOL)isValidKeystore:(NSString>)keystore;
```

##  Verify get checksum address    
>
>  @param address :wallet address   
>  @return checksum address   
>
```
+ (NSString>)getChecksumAddress:(NSString>)address;
```
##  setup node url   
>
>  @param nodelUrl :node url   
>
>
```
+ (void)setNode:(NSString>)nodelUrl;
```


