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


#### Support installation with CocoaPods
 
 ```obj-c
    pod 'ThorWalletSDK', '~>  1.0.0'
 ```





#### Set up the node environment. (```Test_Node environment``` , ```Main_Node environment``` and custom node environment in demo)

```obj-c
#import "WalletUtils.h"
```
```obj-c
[WalletUtils setNode:Main_Node];
````


## Tips

Before the release of DApp, it is recommended that different versions of WebView be adapted to ensure the reliable and stable operation of HTML 5 pages.

## API Reference：

+ [API Reference](https://vit.digonchain.com/vechain-mobile-apps/ios-wallet-sdk/blob/master/API%20Reference%20.md) for VeChain app developers

## License

Vechain Wallet SDK is licensed under the
[MIT LICENSE](https://mit-license.org), also included
in *LICENSE* file in the repository.


