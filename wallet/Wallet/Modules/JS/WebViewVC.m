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
//    WalletDAppHandle *_dAppHandle;
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
    
    
    NSString *stringurl= _url;
    
    NSURL *url=[NSURL URLWithString:stringurl];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                       
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                       
                                                          timeoutInterval:1.0];
    
    [_webView loadRequest:theRequest];
    [self.view addSubview:_webView];
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    
    // 设置 钱包
    NSMutableArray *walletList = [NSMutableArray array];
    if (currentWallet) {
        [walletList addObject:currentWallet];
    }
    
#warning  keystore 具体格式
    // intput wallet list detail
    [WalletUtils initWithWalletDict:walletList];
    
//   BOOL ttt = [WalletUtils isValidMnemonicPhrase:@"earth patient ticket rapid domain genuine absorb head situate matrix stone fantasy"];
//    NSLog(@"dd");
}

//  页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [WalletUtils injectJS:webView];
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

    [WalletUtils webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
}
@end
