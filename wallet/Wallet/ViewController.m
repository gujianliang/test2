//
//  ViewController.m
//  wallet
//
//  Created by vechain on 2018/7/5.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "ViewController.h"
#import <WalletSDK/Wallet.h>
#import "WebViewVC.h"
#import "WalletCreatVC.h"
#import "WalletRecoverMainVC.h"
#import "WalletDetailVC.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rawLabel;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];;
    
    if (currentWallet) { //有钱包，直接去详情
        
        WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detailVC];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        });
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
}

- (IBAction)touchMe:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {

            WalletCreatVC *creat = [[WalletCreatVC alloc]init];
            [self.navigationController pushViewController:creat animated:YES];
        }
            break;
        case 11:
        {

            WalletRecoverMainVC *recoverVC = [[WalletRecoverMainVC alloc]init];
            [self.navigationController pushViewController:recoverVC animated:YES];

        }
            break;
        case 12:
        {

            WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
            [self.navigationController pushViewController:detailVC animated:YES];
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detailVC];
//            [self presentViewController:nav animated:YES completion:NULL];
            
        }
            break;
        case 13:
        {
            
            WebViewVC *detailVC = [[WebViewVC alloc]init];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 14:
        {
            WebViewVC *detailVC = [[WebViewVC alloc]init];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;

        default:
            break;
    }
}

@end
