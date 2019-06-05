/**
 Copyright (c) 2019 VeChain <support@vechain.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 **/
//
//  DAppWebViewVC.m
//  walletSDKDemo
//
//  Created by VeChain on 2019/1/29.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "DAppWebViewVC.h"
#import <WebKit/WebKit.h>
#import "WalletDemoMacro.h"
#import "WalletUtils.h"

@interface DAppWebViewVC ()<WKNavigationDelegate,WKUIDelegate,WalletUtilsDelegate>
{
    NSURL *_URL;
    WKWebView *_webView;  /* It is a 'WKWebView' object that used to interact with dapp. */
}

@end

@implementation DAppWebViewVC

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
    
    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    
    //inject js to wkwebview
    [WalletUtils injectJSWithWebView:configuration];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) configuration:configuration];
    _webView.UIDelegate = self;             /* set UIDelegate */
    _webView.navigationDelegate = self;     /* set navigationDelegate */
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:_URL
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:30.0];
    [_webView loadRequest:theRequest];
    [self.view addSubview:_webView];
    
    // Set delegate
    [WalletUtils initDAppWithDelegate:self];
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


- (void)onWillTransfer:(NSArray<ClauseModel *> *)clauses
            signer:(NSString *)signer
               gas:(NSString *)gas
          callback:(void(^)(NSString *txid ,NSString *signer))callback
{
    
   //Get the local keystore
    NSDictionary *currentWalletDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *keystore = currentWalletDict[@"keystore"];
    
    NSString *address = [WalletUtils getAddressWithKeystore:keystore];
    
    //Specified signature address
    if (signer.length > 0 && [address.lowercaseString isEqualToString:signer.lowercaseString]) {
        
        callback(@"",@"");
        return;
    }
    
    //Custom password input box
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"Please enter the wallet password"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    @weakify(self);
    [alertController addAction:([UIAlertAction actionWithTitle: @"Confirm"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
     {
         
         UITextField *textF =  alertController.textFields.lastObject;
         
         NSString *password = textF.text;
         
         [WalletUtils verifyKeystore:keystore password:password callback:^(BOOL result) {
             @strongify(self);
             if (result) {
                 
                 [self packageParameter:clauses gas:gas keystore:keystore password:password callback:callback] ;
             }
         }];
         
     }])];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)packageParameter:(NSArray *)clauses gas:(NSString *)gas keystore:(NSString *)keystore password:(NSString *)password callback:(void(^)(NSString *txid ,NSString *address))callback
{
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    
    //nonce: hex string
    NSString *nonce = [BigNumber bigNumberWithData:randomData].hexString;

    [self packageTranstionModelClauseList:clauses
                                    nonce:nonce  //nonce: hex string
                                      gas:[NSString stringWithFormat:@"%@",gas]
                               expiration:@"720" //Expiration relative to blockRef
                             gasPriceCoef:@"0"   // Coefficient used to calculate the final gas price (0 - 255)
                                 keystore:keystore
                                 password:password
                                 callback:callback];
}

- (void)packageTranstionModelClauseList:(NSArray *)clauseList
                                  nonce:(NSString *)nonce
                                    gas:(NSString *)gas
                             expiration:(NSString *)expiration
                           gasPriceCoef:(NSString *)gasPriceCoef
                               keystore:(NSString *)keystore
                               password:(NSString *)password
                            callback:(void(^)(NSString *txid ,NSString *address))callback
{
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
                WalletTransactionParameter *transactionModel = [WalletTransactionParameter createTransactionParameter:^(TransactionParameterBuiler * _Nonnull builder) {

                    builder.chainTag = chainTag;
                    builder.blockReference = blockReference;
                    builder.nonce = nonce;
                    builder.clauses = clauseList;
                    builder.gas = gas;
                    builder.expiration = expiration;
                    builder.gasPriceCoef = gasPriceCoef;

                } checkParams:^(NSString * _Nonnull errorMsg) {
                    NSLog(@"errorMsg == %@",errorMsg);
                }];
            
                if (transactionModel != nil) {

                    [WalletUtils signAndSendTransferWithParameter:transactionModel
                                                         keystore:keystore
                                                         password:password
                                                         callback:^(NSString * _Nonnull txid)
                     {
                         //Developers can use txid to query the status of data packaged on the chain

                         NSLog(@"\n txId: %@", txid);
                         
                         // Pass txid and signature address back to dapp webview
                         NSString *singerAddress = [WalletUtils getAddressWithKeystore:keystore];
                         callback(txid,singerAddress.lowercaseString);
                         
                     }];
                }

        }];
    }];
}

- (BigNumber *)amountConvertWei:(NSString *)amount dicimals:(NSInteger )dicimals
{
    NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *dicimalNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, dicimals)]];
    NSDecimalNumber *weiNumber = [amountNumber decimalNumberByMultiplyingBy:dicimalNumber];
    
    return [BigNumber bigNumberWithNumber:weiNumber];
}

- (void)onGetWalletAddress:(void (^)(NSArray<NSString *> * _Nonnull))callback
{
    //Get the wallet address from local database or file cache
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    
    NSString *address = [WalletUtils getAddressWithKeystore:currentWallet[@"keystore"]];
    
    //Callback to webview
    callback(@[address]);
}

- (void)onCheckOwnAddress:(NSString *)address callback:(void(^)(BOOL result))callback
{
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    
    NSString *localAddrss = [WalletUtils getAddressWithKeystore:currentWallet[@"keystore"]];
    if ([localAddrss.lowercaseString isEqualToString:address.lowercaseString]) {
        callback(YES);
    }else{
        callback(NO);
    }
}

- (void)onWillCertificate:(NSDictionary *)message signer:(NSString *)signer callback:(void (^)(NSString * signer, NSData *  signatureData))callback
{
    NSDictionary *currentWalletDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *keystore = currentWalletDict[@"keystore"];
    
    NSString *address = [WalletUtils getAddressWithKeystore:keystore];
    
    if (signer.length > 0) { //Specified signature address
       
        if ([address.lowercaseString isEqualToString:signer.lowercaseString]) {
            
            NSString *strMessage = [WalletUtils addSignerToCertMessage:signer.lowercaseString message:message];
            NSData *dataMessage = [strMessage dataUsingEncoding:NSUTF8StringEncoding];
            [self signCert:dataMessage signer:address.lowercaseString keystore:keystore callback:callback];
        }else{
            //Cusmtom alert error
            callback(@"",nil);
        }
    }else{
        NSString *strMessage = [WalletUtils addSignerToCertMessage:address.lowercaseString message:message];
        NSData *dataMessage = [strMessage dataUsingEncoding:NSUTF8StringEncoding];
        [self signCert:dataMessage signer:address.lowercaseString keystore:keystore callback:callback];
    }
}

- (void)signCert:(NSData *) message
          signer:(NSString *)signer
        keystore:(NSString *)keystore
        callback:(void (^)(NSString * _Nonnull signer, NSData * _Nonnull signatureData))callback
{
    //Custom password input box
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"Please enter the wallet password"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addAction:([UIAlertAction actionWithTitle: @"Confirm"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     
                                     UITextField *textF =  alertController.textFields.lastObject;
                                     
                                     [WalletUtils signWithMessage:message keystore:keystore password:textF.text callback:^(NSData * _Nonnull signatureData) {
                                         
                                         if (!signatureData) {
                                             callback(signer,signatureData);
                                         }else{
                                         }
                                     }];
                                     
                                 }])];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 * You must implement this method to free memory, otherwise there may be a memory overflow or leak.
 */
- (void)dealloc{
    [WalletUtils deallocDApp];
}

@end
