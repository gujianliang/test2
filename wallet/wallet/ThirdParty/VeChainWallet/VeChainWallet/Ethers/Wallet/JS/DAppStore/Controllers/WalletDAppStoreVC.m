//
//  WalletDAppStoreVC.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppStoreVC.h"
#import <WebKit/WebKit.h>
#import "NSJSONSerialization+NilDataParameter.h"
#import "YYModel.h"
//#import "WalletSqlDataEngine.h"
#import "WalletBlockInfoApi.h"
#import "WalletVETBalanceApi.h"
#import "WalletSignatureView.h"
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletDappStoreSelectView.h"
#import "WalletDAppHead.h"
#import "WalletDAppStoreVC+web3JSHandle.h"
#import "WalletDAppStoreVC+ConnexJSHandle.h"
#import "NSJSONSerialization+NilDataParameter.h"


#import "WalletDAppPeersApi.h"
#import "WalletDAppTransferDetailApi.h"
#import "WalletSingletonHandle.h"

@interface WalletDAppStoreVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
{
    WKWebView *_webView;
    NSMutableArray *_walletList;
}
@end


@implementation WalletDAppStoreVC

- (void)viewDidLoad
{
//    [super viewDidLoad];
//    self.view.backgroundColor = UIColor.whiteColor;
    NSLog(@"ddd");
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH  , SCREEN_HEIGHT)];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    NSURL *webURL = [NSURL URLWithString:@"https://cdn.vechain.com/vechainthorwallet/h5/test.html"];
    webURL = [NSURL URLWithString:@"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/test.html"];

//    webURL = [NSURL URLWithString:@"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/dist/index.html#test"];
//    webURL = [NSURL URLWithString:@"https://wallet-dapps-test.vechaindev.com/#/dapps"];
//    webURL = [NSURL URLWithString:@"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/yijianfabi/dist/index.html"];
//    webURL = [NSURL URLWithString:@"http://192.168.43.114:8080/#/test"];
    [_webView loadRequest:[NSURLRequest requestWithURL:webURL]];
//    [self.view addSubview:_webView];
    
}

-(instancetype)initWithWalletDict:(NSMutableArray *)walletList
{
    self = [super init];
    if (self) {
        _walletList = walletList;
        
        WalletSingletonHandle *walletSignlet = [WalletSingletonHandle shareWalletHandle];
        [walletSignlet addWallet:_walletList];
    }
    return self;
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    NSLog(@"defaultText == %@",defaultText);
    
    NSString *result = [defaultText stringByReplacingOccurrencesOfString:@"wallet://" withString:@""];
    NSDictionary *dict = [NSJSONSerialization dictionaryWithJsonString:result];
    
    
    
    NSString *callbackID = dict[@"callbackId"];
    NSString *requestId = dict[@"requestId"];
    NSString *method = dict[@"method"];
    NSDictionary *dictP = dict[@"params"];
    
//    if (![self checkNetwork]) {
//
//        [FFBMSTools callback:requestId
//                        data:@""
//                  callbackID:callbackID
//                     webview:webView
//                        code:ERROR_NETWORK
//                     message:@"network error"];
//
//        return;
//    }
    
    if ([method isEqualToString:@"getStatus"]) {

        [self getStatusWithRequestId:requestId completionHandler:completionHandler];
        return;

    }else if ([method isEqualToString:@"getGenesisBlock"])
    {

        [self getGenesisBlockWithRequestId:requestId completionHandler:completionHandler];

        return;
    }else if ([method isEqualToString:@"getAccount"]){

        [self getAccountRequestId:requestId webView:webView address:dictP[@"address"] callbackID:callbackID];

    }else if([method isEqualToString:@"getAccountCode"])
    {
        [self getAccountCode:callbackID
                     webView:webView
                   requestId:requestId
                     address:dictP[@"address"]];

    }else if([method isEqualToString:@"getBlock"])
    {
        [self getBlock:callbackID
               webView:webView
             requestId:requestId
              revision:dictP[@"revision"]];

    }else if([method isEqualToString:@"getTransaction"])
    {
        [self getTransaction:callbackID
                     webView:webView
                   requestId:requestId
                        txID:dictP[@"id"]];
    }
    else if([method isEqualToString:@"getTransactionReceipt"])
    {
        [self getTransactionReceipt:callbackID
                            webView:webView
                          requestId:requestId
                               txid:dictP[@"id"]];
    }
    else if([method isEqualToString:@"methodAsClause"])
    {
        [self methodAsClauseWithDictP:dictP
                            requestId:requestId
                    completionHandler:completionHandler];
        return;
        
    }else if ([method isEqualToString:@"getAccounts"])
    {
        [self getAccountsWithRequestId:requestId callbackID:callbackID webView:webView];
        
    }
    else if([method isEqualToString:@"sign"])
    {
//        if ([self.navigationController.view viewWithTag:SelectWalletTag]) {
//            completionHandler(@"{}");
//            return;
//        }
        NSArray *clausesList = dictP[@"clauses"][0];
        if (clausesList.count == 0) {
            completionHandler(@"{}");
            return;
        }
        
        NSString *to = dictP[@"clauses"][0][@"to"];
        NSString *amount = dictP[@"clauses"][0][@"value"];
        NSString *clauseData = dictP[@"clauses"][0][@"data"];
        NSNumber *gas =  dictP[@"options"][@"gas"];
        
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValueIfNotNil:@(0) forKey:@"isICO"];
        
        BigNumber *gasBig = [BigNumber bigNumberWithNumber:gas];
        
        BigNumber *gasCanUse = [[[[BigNumber bigNumberWithDecimalString:@"1000000000000000"] mul:[BigNumber bigNumberWithInteger:(1 + 120/255.0)*1000000]] mul:gasBig] div:[BigNumber bigNumberWithDecimalString:@"1000000"]];
        
        NSString *miner = [[Payment formatEther:gasCanUse options:2] stringByAppendingString:@" VTHO"];
        
        [dictParam setValueIfNotNil:miner forKey:@"miner"];
        [dictParam setValueIfNotNil:[BigNumber bigNumberWithInteger:120] forKey:@"gasPriceCoef"];
        [dictParam setValueIfNotNil:gas forKey:@"gas"];
        [dictParam setValueIfNotNil:to forKey:@"to"];
        [dictParam setValueIfNotNil:amount forKey:@"amount"];
        
        NSData *secureData = [SecureData hexStringToData:clauseData];
        [dictParam setValueIfNotNil:secureData forKey:@"clouseData"];
        
        CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.floatValue/pow(10, 18);
        
        WalletDappStoreSelectView *selcetView = [[WalletDappStoreSelectView alloc]initWithFrame:[FFBMSTools getCurrentVC].view.frame ];
        selcetView.tag = SelectWalletTag;
        selcetView.amount = [NSString stringWithFormat:@"%lf",amountTnteger];
        [[FFBMSTools getCurrentVC].navigationController.view addSubview:selcetView];
        selcetView.block = ^(NSString *from,WalletDappStoreSelectView *viewSelf){
            
            [viewSelf removeFromSuperview];
            
            [dictParam setValueIfNotNil:from forKey:@"from"];
            
            [self ConnexTransferWithClauseData:clauseData
                                   dictParam:dictParam
                                        from:from
                                          to:to
                                   requestId:requestId
                                         gas:gas
                                     webView:webView
                                  callbackID:callbackID
                                      amount:amount
                                   gasCanUse:gasCanUse];
        };
    }else if ([method isEqualToString:@"getAddress"] ) {
        
        [self getAddress:webView callbackID:callbackID];
        
    }else if ([method isEqualToString:@"getBalance"]){
        
        [self getBalance:callbackID
                 webView:webView
               requestId:requestId
                 address:dictP[@"address"]];
        
    }else if([method isEqualToString:@"getChainTag"]){
      
        [self getChainTag:requestId completionHandler:completionHandler];
        return;
        
    }else if ([method isEqualToString:@"send"]){
        
        if ([[FFBMSTools getCurrentVC].navigationController.view viewWithTag:SelectWalletTag]) {
            completionHandler(@"{}");
            return;
        }
        __block NSString *to = dictP[@"to"];
        __block NSString *amount = dictP[@"value"];
        NSString *cluseData = dictP[@"data"];
        __block NSString *tokenAddress;
        NSString *gas = [BigNumber bigNumberWithHexString:dictP[@"gas"]].decimalString;
        
        NSString *gasPrice = dictP[@"gasPrice"];
        if (gasPrice.length == 0) {
            gasPrice = @"0x78";
        }
        
        CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.floatValue/pow(10, 18);
        
        WalletDappStoreSelectView *selcetView = [[WalletDappStoreSelectView alloc]initWithFrame:[FFBMSTools getCurrentVC].view.frame ];
        selcetView.tag = SelectWalletTag;
        selcetView.amount = [NSString stringWithFormat:@"%lf",amountTnteger];
        [[FFBMSTools getCurrentVC].navigationController.view addSubview:selcetView];
        selcetView.block = ^(NSString *from,WalletDappStoreSelectView *viewSelf){
            
            [viewSelf removeFromSuperview];
            
            WalletSignatureView *signaVC = [[WalletSignatureView alloc] initWithFrame:[FFBMSTools getCurrentVC].view.bounds];
            if (cluseData.length < 3) { // vet 转账clauseData == nil,
                signaVC.transferType = JSVETTransferType;
            }else if ([cluseData hasPrefix:transferMethodId]) {// vtho 转账
                tokenAddress = dictP[@"to"];
                NSString *cluseData1 = [cluseData stringByReplacingOccurrencesOfString:transferMethodId withString:@""];
                NSString *first = [cluseData1 substringToIndex:64];
                to = [@"0x" stringByAppendingString: [first substringFromIndex:24]];
                amount = [cluseData1 substringFromIndex:65];
                signaVC.transferType = JSVTHOTransferType;
            }else{
                signaVC.transferType = JSContranctTransferType;
            }
          
            BigNumber *gasBig = [BigNumber bigNumberWithDecimalString:gas];
            NSString *gasPriceDecimal = [BigNumber bigNumberWithHexString:gasPrice].decimalString;
            BigNumber *gasCanUse = [[[[BigNumber bigNumberWithDecimalString:@"1000000000000000"] mul:[BigNumber bigNumberWithInteger:(1+gasPriceDecimal.integerValue/255.0)*1000000]] mul:gasBig] div:[BigNumber bigNumberWithDecimalString:@"1000000"]];
            
            [self WEB3TransferWithClauseData:cluseData
                                         from1:from
                                            to:to
                                     requestId:requestId
                                           gas:gas
                                       webView:webView
                                    callbackID:callbackID
                                        amount:amount
                                     gasCanUse:gasCanUse
                                       signaVC:signaVC
                                      gasPrice:gasPrice
                                  tokenAddress:tokenAddress];
            };
        }
    completionHandler(@"{}");
}

//  页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self injectJS:webView];
    });
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)injectJS:(WKWebView *)webview
{
    [WalletUserDefaultManager setServerType:TEST_SERVER];
    
    NSString *js = connex_js;
    [webview evaluateJavaScript:js completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"inject error == %@",error);
    }];
    
    //web3
    NSString *web3js = web3_js;
    [webview evaluateJavaScript:web3js completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"web3js error == %@",error);
    }];
}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:VCNSLocalizedBundleString(@"dialog_yes", nil)
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
    }])];
    [[FFBMSTools getCurrentVC] presentViewController:alertController animated:YES completion:nil];
     completionHandler();
}

- (void)ConnexTransferWithClauseData:(NSString *)clauseData
                         dictParam:(NSMutableDictionary *)dictParam
                              from:(NSString *)from
                                to:(NSString *)to
                         requestId:(NSString *)requestId
                               gas:(NSNumber *)gas
                           webView:(WKWebView *)webView
                        callbackID:(NSString *)callbackID
                            amount:(NSString *)amount
                         gasCanUse:(BigNumber *)gasCanUse
{
//    UIView *conventView = [self.navigationController.view viewWithTag:SignViewTag];
//    if (conventView) {
//        return;
//    }
    
    if (clauseData.length < 3) { // vet 转账clauseData == nil,
        CGFloat amountTnteger = [BigNumber bigNumberWithDecimalString:amount].decimalString.floatValue/pow(10, 18);
        [self VETTransferDictParam:dictParam
                              from:from
                                to:to
                     amountTnteger:amountTnteger
                         requestId:requestId
                               gas:gas
                           webView:webView
                        callbackID:callbackID];
        
    }else{
        if ([clauseData hasPrefix:transferMethodId]) { // token 转账
            
            [self VTHOTransferDictParam:dictParam
                                   from:from
                                     to:to
                              requestId:requestId
                                    gas:gas
                                webView:webView
                             callbackID:callbackID
                              gasCanUse:gasCanUse
                             clauseData:clauseData];
            
        }else{ // 其他合约交易
            CGFloat amountTnteger = [BigNumber bigNumberWithDecimalString:amount].decimalString.floatValue/pow(10, 18);
            [self contractSignDictParam:dictParam
                                     to:to
                                   from:from
                          amountTnteger:amountTnteger
                              requestId:requestId
                                    gas:gas
                                webView:webView
                             callbackID:callbackID
                             clauseData:clauseData];
        }
    }
}

-(void)WEB3TransferWithClauseData:(NSString *)cluseData
                               from1:(NSString *)from1
                                 to:(NSString *)to
                          requestId:(NSString *)requestId
                                gas:(NSString *)gas
                            webView:(WKWebView *)webView
                         callbackID:(NSString *)callbackID
                             amount:(NSString *)amount
                          gasCanUse:(BigNumber *)gasCanUse
                            signaVC:(WalletSignatureView *)signaVC
                           gasPrice:(NSString *)gasPrice
                       tokenAddress:(NSString *)tokenAddress
{
    UIView *conventView = [[FFBMSTools getCurrentVC].navigationController.view viewWithTag:SignViewTag];
    if (conventView) {
        return;
    }
    signaVC.tag = SignViewTag;
    if (cluseData.length > 3) {
        if (![cluseData hasPrefix:@"0xa9059cbb"]) { // 签合约
            [self WEB3contractSign:signaVC
                                to:to
                             from1:from1
                            amount:amount
                         requestId:requestId
                               gas:gas
                          gasPrice:gasPrice
                         gasCanUse:(BigNumber *)gasCanUse
                           webView:webView
                        callbackID:callbackID
                         cluseData:cluseData];
        }else{
            //vtho 转账
            [self WEB3VTHOTransfer:signaVC
                              from:from1
                                to:to
                            amount:amount
                         requestId:requestId
                               gas:gas
                          gasPrice:gasPrice
                           webView:webView
                        callbackID:callbackID
                         gasCanUse:gasCanUse
                         cluseData:cluseData
                      tokenAddress:tokenAddress];
        }
    }else{
        // VET 转账
        [self WEB3VETTransferFrom1:from1
                                to:to
                            amount:amount
                         requestId:requestId
                               gas:gas
                           webView:webView
                        callbackID:callbackID
                         gasCanUse:gasCanUse
                          gasPrice:gasPrice];
    }
}

- (void)wark
{
//    _webView 
}



@end
