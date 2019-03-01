//
//  WalletNodeDetailVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WalletNodeDetailVC.h"
#import <WalletSDK/WalletUtils.h>
#import <WalletSDK/MBProgressHUD.h>
#import "WalletSdkMacro.h"

@interface WalletNodeDetailVC ()
{
    NSString *_netNameText;   /*  It‘s a temp variable that used to save network environment name */
    NSString *_netUrlText;    /*  It‘s a temp variable that used to save network environment URL */
}
@property (weak, nonatomic) IBOutlet UILabel *netName;   /* It's used to show network environment name */
@property (weak, nonatomic) IBOutlet UILabel *netUrl;    /* It's used to show network environment URL */

@end

@implementation WalletNodeDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _netName.text = _netNameText;
    _netUrl.text = _netUrlText;
}


/**
*  Just save the network environment URL and name.
*/
- (void)netName:(NSString *)netName netUrl:(NSString *)netUrl{
    _netNameText = netName;
    _netUrlText = netUrl;
}


/**
*  Delete the you custom network environment.
*/
- (IBAction)deleteCustomNewWork:(id)sender {
    
    NSArray *oldList = [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeList"];
    
    if (oldList.count == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"It's not a custom network.";
        [hud hide:YES afterDelay:2.5];
        return;
    }
    
    NSMutableArray *newList1 = [NSMutableArray arrayWithArray:oldList];
    NSMutableArray *newList2 = [NSMutableArray arrayWithArray:oldList];
    
    BOOL isEqual = NO;
    for (NSDictionary *dic in newList1) {
        NSString *tempUrl = dic[@"nodeUrl"];
        if ([_netUrlText isEqualToString:tempUrl]) {
            [newList2 removeObject:dic];
            isEqual = YES;
            break;
        }
    }
    
    if (isEqual) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"Develop Network" forKey:@"nodeName"];
        [dict setObject:Test_BlockHost forKey:@"nodeUrl"];
        
        [[NSUserDefaults standardUserDefaults] setObject:newList2 forKey:@"nodeList"];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"CurrentNet"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [WalletUtils setNode:Test_BlockHost];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"It's not a custom network.";
        [hud hide:YES afterDelay:2.5];
    }
}


@end
