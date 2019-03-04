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
    NSString *_nodeNameText;   /*  It‘s a temp variable that used to save node environment name */
    NSString *_nodeUrlText;    /*  It‘s a temp variable that used to save node environment URL */
}
@property (weak, nonatomic) IBOutlet UILabel *nodeName;   /* It's used to show node environment name */
@property (weak, nonatomic) IBOutlet UILabel *nodeUrl;    /* It's used to show node environment URL */

@end

@implementation WalletNodeDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _nodeName.text = _nodeNameText;
    _nodeUrl.text = _nodeUrlText;
}


/**
*  Just save the node environment URL and name.
*/
- (void)nodeName:(NSString *)nodeName nodeUrl:(NSString *)nodeUrl{
    _nodeNameText = nodeName;
    _nodeUrlText = nodeUrl;
}


/**
*  Delete the you custom node environment.
*/
- (IBAction)deleteCustomNewWork:(id)sender {
    
    NSArray *oldList = [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeList"];
    
    if (oldList.count == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"It's not a custom node.";
        [hud hide:YES afterDelay:2.5];
        return;
    }
    
    NSMutableArray *newList1 = [NSMutableArray arrayWithArray:oldList];
    NSMutableArray *newList2 = [NSMutableArray arrayWithArray:oldList];
    
    BOOL isEqual = NO;
    for (NSDictionary *dic in newList1) {
        NSString *tempUrl = dic[@"nodeUrl"];
        if ([_nodeUrlText isEqualToString:tempUrl]) {
            [newList2 removeObject:dic];
            isEqual = YES;
            break;
        }
    }
    
    if (isEqual) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"Test Node" forKey:@"nodeName"];
        [dict setObject:Test_Node forKey:@"nodeUrl"];
        
        [[NSUserDefaults standardUserDefaults] setObject:newList2 forKey:@"nodeList"];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"CurrentNode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [WalletUtils setNode:Test_Node];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"It's not a custom node.";
        [hud hide:YES afterDelay:2.5];
    }
}


@end
