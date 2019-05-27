# Vechain ThorWallet SDK    


## Introduction

Vechain wallet SDK provides a series of functional interface can help the iOS developers, for example: quickly create the wallet, the private key signature, call the vechain block interface, put data in the vechain block, and support dapp development environment.

**Features:**

- Set node url
- Get node url
- Creat wallet
- Creat wallet with mnemonic words
- Get checksum address
- Change wallet password
- Verify mnemonic words
- Verify keystore
- Recover address
- Sign message
- Sign transfer message
- Sign and send
- Inject js into webview
- Support dapp development environment


## Get Started 

####  Requires iOS 10

#### Latest version 1.0.0

#### The dependency package should be added to the project, as listed below:


#### Support installation with CocoaPods
 
 ```obj-c
    pod 'ThorWalletSDK', '~>  1.0.0'
 ```



###  1，Basic wallet development

#### 1.1 Set node url
##### Set up the node environment. (```Test_Node environment``` , ```Main_Node environment``` and custom node environment in demo)

```obj-c
#import <ThorWalletSDK/WalletUtils.h>
```
```obj-c
[WalletUtils setNode:Main_Node];
````
#### 1.2 Create wallet



```obj-c
[WalletUtils createWalletWithPassword:Password
                             callback:^(WalletAccountModel * _Nonnull account, NSError * _Nonnull error)
{}];
```
### 2，Support dapp development environment (connex or web3)

#### 2.1 Set delegate
#####  Set the delegate, and the developer needs to implement several delegate methods

```obj-c

@interface ViewContrller ()<WalletUtilsDelegate>

[WalletUtils initDAppWithDelegate:self];

- (void)onTransfer:(NSArray<ClauseModel *> *)clauses 
            signer:(NSString *)signer 
               gas:(NSString *)gas
          callback:(void(^)(NSString *txid ,NSString *signer))callback;
          

- (void)onGetWalletAddress:(void(^)(NSArray<NSString *> *addressList))callback;


- (void)onCertificate:(NSData *)message 
               signer:(NSString *)signer 
             callback:(void(^)(NSString *signer, NSData *signatureData))callback;
              
              
- (void)onCheckOwnAddress:(NSString *)address callback:(void(^)(BOOL result))callback;

             

````

#### 2.2  Inject js bridge into webview
##### 
When declaring wkwebview, pass the WKWebViewConfiguration object to [WalletUtils injectJSWithWebView:configuration].   
The injectJSWithWebView method injects connex bridge js and web3 bridge js into wkwebview


```obj-c  

 WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
 configuration.userContentController = [[WKUserContentController alloc] init];
    
 //inject js to wkwebview
 [WalletUtils injectJSWithWebView:configuration];
    
 WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) configuration:configuration];


```

#### 2.3 Parsing data in webview's callback method runJavaScriptTextInputPanelWithPrompt
##### 
```obj-c
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    [WalletUtils webView:webView  defaultText:defaultText completionHandler:completionHandler];
}
```
### 3. Several main data structures

#### 1，keystore
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
#### 2，Hexadecimal must start with 0x.

#### 3，Address : 20 bytes hex string and start with 0x.

## Attention：

Before the release of DApp, it is recommended that different versions of WebView be adapted to ensure the reliable and stable operation of HTML 5 pages.

## API Reference：

+ [API Reference](https://vit.digonchain.com/vechain-mobile-apps/ios-wallet-sdk/blob/master/API%20Reference%20.md) for VeChain app developers

## License

Vechain Wallet SDK is licensed under the
[GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0.html), also included
in *LICENSE* file in the repository.


