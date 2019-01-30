//
//  WebViewVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/29.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WebViewVC.h"
#import <WebKit/WebKit.h>
#import <walletSDK/WalletDAppStoreVC.h>

@interface WebViewVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
{
    WKWebView *_webView;
    WalletDAppStoreVC *_dsVC;
}
@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width  , self.view.frame.size.height)];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    NSURL *webURL = [NSURL URLWithString:@"https://cdn.vechain.com/vechainthorwallet/h5/test.html"];
    webURL = [NSURL URLWithString:@"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/test.html"];
    
    //    webURL = [NSURL URLWithString:@"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/dist/index.html#test"];
//    webURL = [NSURL URLWithString:@"https://wallet-dapps-test.vechaindev.com/#/dapps"];
    //    webURL = [NSURL URLWithString:@"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/yijianfabi/dist/index.html"];
    //    webURL = [NSURL URLWithString:@"http://192.168.43.114:8080/#/test"];
    [_webView loadRequest:[NSURLRequest requestWithURL:webURL]];
    [self.view addSubview:_webView];
    
    
    
// 设置 钱包
    
    NSMutableArray *walletList = [NSMutableArray array];
    
    NSMutableDictionary *walletDict = [NSMutableDictionary dictionary];
    [walletDict setObject:@"0x4FCE07115eC3Cc0e2428f5a8c4EEA2412650220e" forKey:@"address"];
    [walletDict setObject:@"{\"version\":3,\"id\":\"7F050F89-C4C5-47A0-B420-BC7BF7ABFD61\",\"crypto\":{\"ciphertext\":\"95ba6fc5cfc0c9f52b6f021ca36e4893761e8bfbbb28ae67f511fa532eaec4a6\",\"cipherparams\":{\"iv\":\"b51a16666d522d453f40e6d258a9cefc\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"r\":8,\"p\":1,\"n\":262144,\"dklen\":32,\"salt\":\"e437ab3006d75f969ff4dd2ce82b2397100ff3a7370cd5e68730cabfe5ae4d4f\"},\"mac\":\"3cd363094eb04f627871e2e5d2c3a7add65393deac61896fe23ec0ed4675db73\",\"cipher\":\"aes-128-ctr\"},\"address\":\"4fce07115ec3cc0e2428f5a8c4eea2412650220e\"}" forKey:@"keystore"];
    [walletList addObject:walletDict];

    _dsVC = [[WalletDAppStoreVC alloc]initWithWalletDict:walletList];
}

//  页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_dsVC injectJS:webView];
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

    [_dsVC webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
}
@end
