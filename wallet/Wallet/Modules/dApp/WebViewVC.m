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

@interface WebViewVC ()<WKNavigationDelegate,WKUIDelegate>
{
    NSString *_url;
    WKWebView *_webView;
}

@end

@implementation WebViewVC

- (instancetype)initWithURL:(NSString *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width  , self.view.frame.size.height)];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    
    NSString *stringurl = _url;
    
    NSURL *url = [NSURL URLWithString:stringurl];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                       
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                       
                                                          timeoutInterval:1.0];
    
    [_webView loadRequest:theRequest];
    [self.view addSubview:_webView];
    
    /*
     CurrentWallet has two key, addres and ketstore
                Address: 0 x hex 20 bytes
                Keystore: NSDictionary, specific format, please read the readme
     */
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];

    NSMutableArray *walletList = [NSMutableArray array];
    if (currentWallet) {
        [walletList addObject:currentWallet];
    }
    
    // intput wallet list detail to sdk，
    [WalletUtils initWithWalletDict:walletList];
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
{
    [WalletUtils injectJS:webView];
}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:NSLocalizedString(@"dialog_yes", nil)
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    [WalletUtils webView:webView  defaultText:defaultText completionHandler:completionHandler];
}


@end
