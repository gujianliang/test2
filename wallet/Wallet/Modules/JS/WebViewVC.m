//
//  WebViewVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/29.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WebViewVC.h"
#import <WebKit/WebKit.h>
#import <WalletSDK/WalletDAppHandle.h>

@interface WebViewVC ()<WKNavigationDelegate,WKUIDelegate>
{
    NSString *_url;
    WKWebView *_webView;
    WalletDAppHandle *_dAppHandle;
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
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self.view addSubview:_webView];
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    
    // 设置 钱包
    NSMutableArray *walletList = [NSMutableArray array];
    if (currentWallet) {
        [walletList addObject:currentWallet];
    }
    
#warning  keystore 具体格式
    // intput wallet list detail
    _dAppHandle = [[WalletDAppHandle alloc]initWithWalletDict:walletList];
}

//  页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_dAppHandle injectJS:webView];
}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:NSLocalizedString(@"dialog_yes", nil)
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{

    [_dAppHandle webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
}
@end
