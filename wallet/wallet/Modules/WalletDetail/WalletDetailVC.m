//
//  WalletDetailVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
// 

#import "WalletDetailVC.h"
#import <walletSDK/AFNetworking.h>
#import "TransferVC.h"
#import <walletSDK/Payment.h>
#import "WalletMoreInfoVC.h"
#import "WebViewVC.h"
#import "CoverView.h"
#import "NETDetailVC.h"
#import "AddNetVC.h"

@interface WalletDetailVC ()<UISearchBarDelegate>
{
    NSString *_blockHost;
}
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *vetAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *vthoAmountLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, copy)NSString *vetAmount;
@property (nonatomic, copy)NSString *vthoAmount;

@end

@implementation WalletDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchBar.delegate = self;
    
    [self setHost];

    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    self.addressLabel.text = currentWallet[@"address"];
    
    [self.vetImageView setImage:[UIImage imageNamed:@"VET"]];
    [self.vthoImageView setImage:[UIImage imageNamed:@"VTHO"]];
    
    [self initView];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    version = [NSString stringWithFormat:@"版本号：(%@)",version];
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 450, 150, 30)];
    versionLabel.text = version;
    [self.view addSubview:versionLabel];
}

- (void)initView
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"选择网络"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(selectNET)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.searchBar.text = @"https://appwallet.oss-cn-shanghai.aliyuncs.com/testJS/test.html";
}

- (void)selectNET
{
    CoverView *coverView = [self.view viewWithTag:90];
    if (!coverView) {
        coverView = [[CoverView alloc]initWithFrame:self.view.frame];
        coverView.tag = 90;
        [self.view addSubview:coverView];
        
        coverView.block = ^(NSString *netName,NSString *netUrl) {
            
            self.title = netName;
            if ([netName containsString:@"自定义"]) {
                AddNetVC *detailVC = [[AddNetVC alloc]init];
                [self.navigationController pushViewController:detailVC animated:YES];
            }else{
                NETDetailVC *detailVC = [[NETDetailVC alloc]init];
                [detailVC netName:netName netUrl:netUrl];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        };
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHost];
}

- (void)setHost
{
    NSDictionary *dictCurrentNet = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentNet"];
    
    if (dictCurrentNet) {
        _blockHost = dictCurrentNet[@"netUrl"];
        self.title = dictCurrentNet[@"netName"];
        
    }else{
        _blockHost = @"https://vethor-node-test.vechaindev.com";
        self.title =  @"（测试）";
    }
    
    self.vthoAmountLabel.text = @"";
    self.vetAmountLabel.text = @"";
    
    [self getVETBalance];
    
    [self getVTHOBalance];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSString *url = searchBar.text;
    WebViewVC *webVC = [[WebViewVC alloc]initWithURL:url];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)getVETBalance
{
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@",_blockHost,_addressLabel.text];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [httpManager GET:urlString
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *dictResponse = (NSDictionary *)responseObject;
         NSString *amount = dictResponse[@"balance"];
         BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:amount];
         
         NSString *coinAmount = @"0.00";
         if (!bigNumberCount.isZero) {
             coinAmount = [Payment formatToken:bigNumberCount
                                      decimals:18
                                       options:2];
         }
         self.vetAmountLabel.text = coinAmount;
         self.vetAmount = amount;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
        
        
    }];
}

- (void)getVTHOBalance
{
    NSString *urlString = [_blockHost stringByAppendingString:@"/accounts/0x0000000000000000000000000000456e65726779"] ;

    NSMutableDictionary *dictParm = [NSMutableDictionary dictionary];
    [dictParm setObject:[self tokenBalanceData:_addressLabel.text] forKey:@"data"];
    [dictParm setObject:@"0x0" forKey:@"value"];
    
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [httpManager POST:urlString parameters:dictParm progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
        self.vthoAmount= amount;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"dd");
    }];
}


//查询thor 余额
- (NSString *)tokenBalanceData:(NSString *)toAddress
{
    if ([[toAddress lowercaseString] hasPrefix:@"0x"]) {
        toAddress = [toAddress stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    }
    NSString *head = @"0x70a08231000000000000000000000000";
    NSString *data = [NSString stringWithFormat:@"%@%@",head,toAddress];
    return data;
}

- (void)tableView:(UITableView *)tableView didselect:(NSIndexPath *)indexPath
{
    
}
- (IBAction)enterMoreInfo:(id)sender
{
    WalletMoreInfoVC *moreInfoVC = [[WalletMoreInfoVC alloc]init];
    [self.navigationController pushViewController:moreInfoVC animated:YES];
}

- (IBAction)enterTransfer:(id)sender
{
    TransferVC *transfer = [[TransferVC alloc]init];
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 10) { //vet transfer
        transfer.isVET = YES;
        transfer.amount = _vetAmount;
    }else if (btn.tag == 20){ //vtho transfer
         transfer.isVET = NO;
        transfer.amount = _vthoAmount;
    }
    [self.navigationController pushViewController:transfer animated:YES];

}

@end
