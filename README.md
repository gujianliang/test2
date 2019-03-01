
> /* create wallet   
>
>    @param password :wallet password  
> 	 @param block : finish create wallet callback；The attributes of a class has mnemonicPhras , address, privateKey, keystore 
> */


    + (void)creatWalletWithPassword:(NSString *)password
                         callBack:(void(^)(Account *account)) block;



>/* create wallet with mnemonic   
>
>    @param mnemonicList :12 words for create wallet
>    @param password :wallet password  
> 	 @param block : finish create wallet callback；The attributes of a class has mnemonicPhras , address, privateKey, keystore 
> */


      + (void)creatWalletWithMnemonic:(NSArray *)mnemonicList
                      password:(NSString *)password
                       callback:(void(^)(WalletAccountModel *account,NSError *error))block;



>/* Verify the mnemonic word is legal     
>
>  	@param mnemonicList :12 words for create wallet 
>  	@return verification results
> */
     
        + (BOOL)isValidMnemonicPhrase:(NSString*)mnemonicList;



>/* Decryption keystore  
>
>   @param json : json string for keystore
>   @param password : password for wallet
>   @param callback : finish decryption keystore callback
> */
     
        + (BOOL)isValidMnemonicPhrase:(NSString*)mnemonicList;




>/*  verify Message  
>
>  @param message : to verify the information  
>  @param signatureData : NSData signature (r,s,v)   
>  @return object for address  
> */

   
        + (NSString *)recoverAddressFromMessage:(NSData*)message
                          signatureData:(NSData*)signatureData;


>/*
>   sign message  
>
>   @param message : message for sign  
>   @param json :json string for keystore   
>   @param password :password for wallet  
>   @param block :finish sign block  
> */


        + (void)signature:(NSData*)message
         keystore:(NSString*)json
         password:(NSString*)password
            block:(void (^)(NSData *signatureData,NSError *error))block;


>/*
>   encrypt private key to keystore
>
>   @param password :password for wallet
>   @param walletAccount :object for private key
>   @param callback :finish encrypt callback
> 
> */
        
        + (void)encryptSecretStorageJSON:(NSString*)password
                         account:(WalletAccountModel *)walletAccount
                        callback:(void (^)(NSString *))callback;

>/*
>   encrypt set current wallet address  
>
>  @param address :current wallet address  
>
*/


        + (void)setCurrentWallet:(NSString>)address;

/*
>  encrypt set current wallet address   
>
>  @param walletList :wallet list ,one item NSDictionary,has 2 key,address and keystore
 address: wallet addres
 keystore: json
>
>/

        + (void)initWithWalletDict:(NSMutableArray>)walletList;

/*! @abstract Displays a JavaScript text input panel.  
 @param webView The web view invoking the delegate method.   
 @param defaultText The initial text to display in the text entry field.   
 @param completionHandler The completion handler to call after the text   
 input panel has been dismissed. Pass the entered text if the user chose
 OK, otherwise nil.
>/

        + (void)webView:(WKWebView>)webView defaultText:(NSString>)defaultText completionHandler:(void (^)(NSString>result))completionHandler;

/*
>  encrypt inject js into webview   
>
>  @param webview The web view invoking the developper new.
>
>/

        + (void)injectJS:(WKWebView>)webview;

/*
>  encrypt The call sign control   
>
>  @param parameter Signature parameters   
>  @param keystore wallet for keystore    
>  @param block callback   
>
>/

        + (void)transactionWithKeystore:(NSString>)keystore parameter:(TransactionParameter>)parameter block:(void(^)(NSString>txId,NSString>signer))block;

/*
>  Verify the mnemonic word is legal 
>
>  @param keystore :wallet for keystore   
>  @return verification results   
>/

        + (BOOL)isValidKeystore:(NSString>)keystore;

/*
>  Verify get checksum address    
>
>  @param address :wallet for address   
>  @return checksum address   
>/

        + (NSString>)getChecksumAddress:(NSString>)address;

/*
>  setup node url   
>
>  @param nodelUrl :node url   
>
>/

        + (void)setNode:(NSString>)nodelUrl;


