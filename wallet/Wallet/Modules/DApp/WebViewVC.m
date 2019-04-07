//
//  WebViewVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/29.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WebViewVC.h"
#import <WebKit/WebKit.h>
#import <WalletSDK/WalletUtils.h>
#import "WalletSdkMacro.h"

@interface WebViewVC ()<WKNavigationDelegate,WKUIDelegate>
{
    NSURL *_URL;
    WKWebView *_webView;  /* It is a 'WKWebView' object that used to interact with dapp. */
}

@end

@implementation WebViewVC

- (instancetype)initWithURL:(NSURL *)URL{
    self = [super init];
    if (self) {
        _URL = URL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*
     Please note that, This is a 'WKWebView' object, does not support a "UIWebView" object.
     */
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    _webView.UIDelegate = self;             /* set UIDelegate */
    _webView.navigationDelegate = self;     /* set navigationDelegate */
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:_URL
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:30.0];
    [_webView loadRequest:theRequest];
    [self.view addSubview:_webView];
    
    
    /*
     CurrentWallet has two key; addres and ketstore
                Address: 0 x hex 20 bytes
                Keystore: NSDictionary, specific format, please read the readme
     */
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];

    NSMutableArray *walletList = [NSMutableArray array];
    if (currentWallet) {
        [walletList addObject:currentWallet[@"keystore"]];
    }
    
    // intput wallet list detail to sdk，
    [WalletUtils initDAppWithDelegate:self];
}


#pragma mark -- WKNavigationDelegate
/**
* You must implement this method that is used to inject js to WebView。
*/
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
     [WalletUtils injectJSWithWebView:webView];
}


#pragma mark -- WKUIDelegate

/**
* You must implement this method that is used to response js feedback。
*/
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    /* This method can be called if you want to display js call information. This is optional. */
    [self alertMessage:message];
    
    completionHandler();
}


/**
* Show the js call information.
*/
- (void)alertMessage:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message?:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle: @"Confirm"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                         }])];
    [self presentViewController:alertController animated:YES completion:nil];
}


/**
* You must implement this delegate method to call js.
*/
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
        
    /*
     You must call this method. It is used to response web3 or connex operations.
     */
    [WalletUtils webView:webView  defaultText:defaultText completionHandler:completionHandler];
}

- (void)clickBackBtnClick {
    if (_webView.canGoBack) {
        [_webView goBack];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onTransfer:(NSArray *)clauses gas:(NSString *)gas callback:(void(^)(NSString *txid))callback
{
    
    NSDictionary *currentWalletDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    
    NSMutableArray *walletList = [NSMutableArray array];
    if (currentWalletDict) {
        [walletList addObject:currentWalletDict];
    }
    
    NSString *keystore = currentWalletDict[@"keystore"];

    
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    
    TransactionParameter *paramters = [[TransactionParameter alloc]init];

    paramters.noce = [BigNumber bigNumberWithData:randomData].hexString;
    
    paramters.gas = [NSString stringWithFormat:@"%@",gas];  //Set maximum gas allowed for call,
    
    paramters.clauses = clauses;
    
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        paramters.chainTag = chainTag;
        
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            paramters.blockRef = blockReference;
            
            [paramters checkParameter:^(NSString * _Nonnull error, BOOL result)
             {
                 if (!result) {
                     NSLog(@"error == %@",error);
                 }else{
                     
                     [WalletUtils signAndSendTransfer:keystore
                                            parameter:paramters
                                             password:@"12345678Aa"
                                             callback:^(NSString *txId)
                      {
                          NSLog(@"\n txId: %@", txId);
                          
                          // txid callback to webview
                          if (callback) {
                              callback(txId);
                          }
                      }];
                 }
             }];
        }];
    }];
}


- (BigNumber *)amountConvertWei:(NSString *)amount dicimals:(NSInteger )dicimals
{
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, dicimals)]];
    NSDecimalNumber *weiNumber = [number decimalNumberByMultiplyingBy:number1];
    
    return [BigNumber bigNumberWithNumber:weiNumber];
}

- (void)onGetWalletAddress:(void(^)(NSArray *addressList))callback
{
    //get the wallet address from local database or file cache
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    
    NSString *address = [WalletUtils getAddressWithKeystore:currentWallet[@"keystore"]];
    
    //callback to webview
    callback(@[address]);
}

/**
 * You must implement this method to free memory, otherwise there may be a memory overflow or leak.
 */
- (void)dealloc{
    [WalletUtils deallocDappSingletion];
}

@end
