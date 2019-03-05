//
//  WalletDetailVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
// 

#import "WalletDetailVC.h"
#import <WalletSDK/AFNetworking.h>
#import "WalletTransferVC.h"
#import "WalletMoreInfoVC.h"
#import "WebViewVC.h"
#import "WalletChooseNodeView.h"
#import "WalletNodeDetailVC.h"
#import "WalletAddVthoNodeVC.h"
#import "WalletSdkMacro.h"
#import <WalletSDK/WalletUtils.h>

@interface WalletDetailVC ()<UISearchBarDelegate>
{
    NSString *_blockHost;  /* The main Node environment of block */
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrant;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;       /* The wallet address that you created */
@property (weak, nonatomic) IBOutlet UILabel *vetAmountLabel;     /* The VET label */
@property (weak, nonatomic) IBOutlet UILabel *vthoAmountLabel;    /* The VTHO label */
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;      /* Search bar control */

@end

@implementation WalletDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNodeEnvironmentHost];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}


/**
*  Config subviews and load it.
*/
- (void)initView {
   
    /* Set right bar buttonItem */
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Choose Node"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(selectTheMainNodeEnvironment)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    /* Set UI */
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    if (systemVersion.doubleValue < 11.0) {
        self.topConstrant.constant = 70.0;
        
    } else {
        self.topConstrant.constant = 16.0;
    }
    
    self.searchBar.delegate = self;
    self.searchBar.text = @"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/test.html";
    self.searchBar.text = @"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/dist/index.html#test";
    
    /* Set the VET and VTHO logo */
    [self.vetImageView setImage:[UIImage imageNamed:@"VET"]];
    [self.vthoImageView setImage:[UIImage imageNamed:@"VTHO"]];
    
    
    /* Show the wallet address you created */
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    self.addressLabel.text = currentWallet[@"address"];
    
    /* Set font adjust the the form */
    self.vetAmountLabel.adjustsFontSizeToFitWidth = YES;
    self.vthoAmountLabel.adjustsFontSizeToFitWidth = YES;
    
    /* Show the demo version information */
    NSString *version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    version = [NSString stringWithFormat:@"Demo Version：(%@)",version];
    CGFloat y = ScreenH -  kNavigationBarHeight;
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, ScreenW - 40, 30)];
    versionLabel.text = version;
    versionLabel.font = [UIFont systemFontOfSize:15.0];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
}



/**
*  Displays a selection of Node controls，then you can change the main Node environment
*  or add what you custom Node environment.
*/
- (void)selectTheMainNodeEnvironment {
    
    [self.view endEditing:YES];
    
    WalletChooseNodeView *chooseNodeView = [self.view viewWithTag:90];
    if (!chooseNodeView) {
        chooseNodeView = [[WalletChooseNodeView alloc] initWithFrame:self.view.frame];
        chooseNodeView.tag = 90;
        [self.view addSubview:chooseNodeView];
        
        chooseNodeView.block = ^(NSString *nodeName, NSString *nodeUrl) {

            if (nodeUrl.length == 0) {
                WalletAddVthoNodeVC *detailVC = [[WalletAddVthoNodeVC alloc]init];
                [self.navigationController pushViewController:detailVC animated:YES];
                
            }else{
                self.title = nodeName;
                
                [WalletUtils setNode:nodeUrl];
                
                WalletNodeDetailVC *detailVC = [[WalletNodeDetailVC alloc]init];
                [detailVC nodeName:nodeName nodeUrl:nodeUrl];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        };
    }
}


/**
*  Change the main Node environment or add what you custom Node environment.
*/
- (void)setNodeEnvironmentHost{
    
    NSDictionary *dictCurrentNode = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentNode"];
    
    if (dictCurrentNode) { /* Set to the main Node of your choice. */
        NSString *customServerUrl = dictCurrentNode[@"nodeUrl"];
        if (customServerUrl.length > 0 ) {
            _blockHost = customServerUrl;
            self.title = dictCurrentNode[@"nodeName"];
        }
    }
    
    if (_blockHost.length == 0) {  /* THe default Boloc Host. */
        _blockHost = Test_Node;
        self.title =  @"Test Node";
        
        NSMutableDictionary *serverDict = [NSMutableDictionary dictionary];
        [serverDict setObject:_blockHost forKey:@"nodeUrl"];
        [serverDict setObject:self.title forKey:@"nodeName"];
    }
    
    
    [WalletUtils setNode:_blockHost];
    
    self.vthoAmountLabel.text = @"0.00";
    self.vetAmountLabel.text = @"0.00";
    
    [self getVETBalance];
    [self getVTHOBalance];
}


/**
*  Get the VET balance from Node environment, '_blockHost' is a Node variable. Which Node environment
*  they work in depends on how you set it up.
*/
- (void)getVETBalance {
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@", _blockHost, self.addressLabel.text];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [httpManager GET:urlString
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                 
         NSDictionary *dictResponse = (NSDictionary *)responseObject;
         NSString *amount = dictResponse[@"balance"];
         BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
         
         NSString *coinAmount = @"0.00";
         if (!bigNumberCount.isZero) {
             coinAmount = [Payment formatToken:bigNumberCount
                                      decimals:18  //coin decimals
                                       options:2]; //Keep 2 decimals
         }
         self.vetAmountLabel.text = coinAmount;
                 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"Get VET balance failure. error: %@", error);
    }];
}


/**
*  Get the VTHO balance from Node environment, '_blockHost' is a Node variable . Which Node environment
*  they work in depends on how you set it up.
*  'vthoTokenAddress' is a fixed contract address. It is declarationed in the file of 'WalletSdkMacro.h'.
*  vthoTokenAddress : '0x0000000000000000000000000000456e65726779'
*/
- (void)getVTHOBalance {
    NSString *contractAddress = [NSString stringWithFormat:@"/accounts/%@", vthoTokenAddress];
    NSString *urlString = [_blockHost stringByAppendingString:contractAddress];

    NSMutableDictionary *dictParm = [NSMutableDictionary dictionary];
    [dictParm setObject:[self tokenBalanceData:self.addressLabel.text] forKey:@"data"];
    [dictParm setObject:@"0x0" forKey:@"value"];
    
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [httpManager POST:urlString
           parameters:dictParm
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dictResponse = (NSDictionary *)responseObject;
        NSString *amount = dictResponse[@"data"];
        BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
        
        NSString *coinAmount = @"0.00";
        if (!bigNumberCount.isZero) {
            coinAmount = [Payment formatToken:bigNumberCount
                                     decimals:18
                                      options:2];
        }
        self.vthoAmountLabel.text = coinAmount;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Get VTHO balance failure. error: %@", error);
    }];
}


/**
*  This method is used to splicing header information.
*  The total length of the header is 34 and the rule is: 0x + methodID + twentyfour 0's.
*  MethodID is an 8-length hex string , used to access methods on a contract.
*/
- (NSString *)tokenBalanceData:(NSString *)toAddress {
    if ([[toAddress lowercaseString] hasPrefix:@"0x"]) {
        toAddress = [toAddress stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    }
    NSString *head = @"0x70a08231000000000000000000000000";
    NSString *data = [NSString stringWithFormat:@"%@%@",head,toAddress];
    return data;
}


#pragma mark -- UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString *url = searchBar.text;
    WebViewVC *webVC = [[WebViewVC alloc] initWithURL:url];
    [self.navigationController pushViewController:webVC animated:YES];
}



#define click event

/**
*  Enter the address detail ViewControll and see more information.
*/
- (IBAction)enterMoreInfo:(id)sender {
    WalletMoreInfoVC *moreInfoVC = [[WalletMoreInfoVC alloc] init];
    [self.navigationController pushViewController:moreInfoVC animated:YES];
}


/**
*  Enter the transfer ViewControll and do some transactions.
*/
- (IBAction)enterTransfer:(id)sender {
    WalletTransferVC *transfer = [[WalletTransferVC alloc] init];
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 10) { /* vet transfer */
        transfer.isVET = YES;
        transfer.coinAmount = [self.vetAmountLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        
    }else if (btn.tag == 20){ /* vtho transfer */
        transfer.isVET = NO;
        transfer.coinAmount = [self.vthoAmountLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    
    [self.navigationController pushViewController:transfer animated:YES];
}


/**
*  Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
