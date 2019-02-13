//
//  ViewController.m
//  wallet
//
//  Created by vechain on 2018/7/5.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "ViewController.h"
#import <walletSDK/Wallet.h>
#import "WebViewVC.h"
#import "WalletCreatVC.h"
#import "WalletRecoverMainVC.h"
#import "WalletDetailVC.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rawLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];;

    if (currentWallet) { //有钱包，直接去详情

        WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
//        [self.navigationController pushViewController:detailVC animated:YES];

        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detailVC];
        [self presentViewController:nav animated:YES completion:NULL];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
