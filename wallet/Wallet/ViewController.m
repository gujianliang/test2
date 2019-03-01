//
//  ViewController.m
//  wallet
//
//  Created by vechain on 2018/7/5.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "ViewController.h"
#import <WalletSDK/WalletUtils.h>
#import "WebViewVC.h"
#import "WalletCreateVC.h"
#import "WalletRecoverMainVC.h"
#import "WalletDetailVC.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rawLabel;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    /* Read the local cache information and decide whether to go to the detail ViewController */
    NSDictionary *currentWallet = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWallet"];;
    
    if (currentWallet) {
        
        WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detailVC];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController presentViewController:nav animated:YES completion:NULL];
        });
    }
}


/**
*  Enter the Create Or Import ViewController to generate a wallet.
*/
- (IBAction)clickCreateOrImportWalletEvent:(UIButton *)sender{
    switch (sender.tag) {
        case 10:{
            
            WalletCreateVC *create = [[WalletCreateVC alloc] init];
            [self.navigationController pushViewController:create animated:YES];
        }break;
            
        case 11:{
            WalletRecoverMainVC *recoverVC = [[WalletRecoverMainVC alloc] init];
            [self.navigationController pushViewController:recoverVC animated:YES];
        }break;
    
        default:break;
    }
}


@end
