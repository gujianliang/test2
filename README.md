# Vechain ThorWallet SDK    


## Introduction

Vechain wallet SDK provides a series of functional interface can help the iOS developers, for example: quickly create the wallet, the private key signature, call the vechain block interface, put data in the vechain block, and support dapp development environment.

**Features:**

#### Features:

##### Setting
- Set node url
- Get node url

##### Manage Wallet
- Create wallet
- Create wallet with mnemonic words
- Get checksum address
- Change Wallet password
- Verify mnemonic words
- Verify keystore
- Recover address

##### Sign
- Sign message
- Sign transaction
- Sign and send transaction

##### Support DApp development environment
- 100% support for the [connex.](https://github.com/vechain/connex/blob/master/docs/api.md/)
- Support for web3 features :getNodeUrl, getAccounts,sign,getBalance

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
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [WalletUtils setNodeUrl:Main_Node];
    
    ...
    
    return YES;
}
````



## API Reference：

+ [API Reference](https://vit.digonchain.com/vechain-mobile-apps/ios-wallet-sdk/blob/master/API%20Reference%20.md) for VeChain app developers

## License

Vechain Wallet SDK is licensed under the
[MIT LICENSE](https://mit-license.org), also included
in *LICENSE* file in the repository.


