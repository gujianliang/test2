>/* 生成钱包 
> 	 输入：生成keystore的密码
> 	 输出：Account类，这个类的属性有mnemonicPhras>e，address.checksumAddress,privateKey,keystore
> */


    + (void)creatWalletWithPassword:(NSString *)password
                         callBack:(void(^)(Account *account)) block;



>/* 验证助记词有效 
>  	输入：助记词
>  	输出：YES，助记词合法，NO，助记词不合法
> */
     
    + (BOOL)isValidMnemonicPhrase: (NSString*)phrase;


>/* 验证keystore 
> 	 输入：keystore,密码
> 	 输出：NSError == nil >，密码正确，否则，密码错误；2，account，有助记词，私钥>>，地址信息
> */
 
    + (void)decryptSecretStorageJSON: (NSString*)json
                                password: (NSString*)password
                                callback: (void (^)(Account *account, NSError *NSError))callback;


>/* 签名 
> 	 输入：message,需要签名的信息；json,keystore;passwor>d,keystore的密码
> 	 输出：signature 签名后得到信息，
> */
 
    + (void)sign: (NSData*)message
     keystore: (NSString*)json
     password: (NSString*)password
          block:(void (^)(Signature *signature))block;


>	输入：message,需要签名的信息 , 使用BLAKE2B hash
>  	输出：地址信息
> */
 
    + (Address*)verifyMessage: (NSData*)message
                signature: (Signature*)signature;
