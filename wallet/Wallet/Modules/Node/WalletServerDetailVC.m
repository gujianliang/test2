//
//  WalletServerDetailVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WalletServerDetailVC.h"
#import <WalletSDK/Wallet.h>
#import <WalletSDK/MBProgressHUD.h>
#import "WalletSdkMacro.h"

@interface WalletServerDetailVC ()
{
    NSString *_netNameText;
    NSString *_netUrlText;
}
@property (weak, nonatomic) IBOutlet UILabel *netName;
@property (weak, nonatomic) IBOutlet UILabel *netUrl;

@end

@implementation WalletServerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _netName.text = _netNameText;
    _netUrl.text = _netUrlText;
}


- (void)netName:(NSString *)netName netUrl:(NSString *)netUrl{
    _netNameText = netName;
    _netUrlText = netUrl;
}


- (IBAction)deleteCustomNewWork:(id)sender {
    
    NSArray *oldList = [[NSUserDefaults standardUserDefaults] objectForKey:@"netList"];
    
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
        NSString *tempUrl = dic[@"serverUrl"];
        if ([_netUrlText isEqualToString:tempUrl]) {
            [newList2 removeObject:dic];
            isEqual = YES;
            break;
        }
    }
    
    if (isEqual) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"Develop Network" forKey:@"serverName"];
        [dict setObject:Test_BlockHost forKey:@"serverUrl"];
        
        [[NSUserDefaults standardUserDefaults] setObject:newList2 forKey:@"netList"];
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
