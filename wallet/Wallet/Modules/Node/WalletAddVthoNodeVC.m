//
//  WalletAddVthoNodeVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WalletAddVthoNodeVC.h"
#import <WalletSDK/MBProgressHUD.h>
#import <WalletSDK/WalletUtils.h>

@interface WalletAddVthoNodeVC ()

@property (weak, nonatomic) IBOutlet UITextView *customNetTextView;

@end

@implementation WalletAddVthoNodeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Custom Network";
}

- (IBAction)setCustomNetworkEnvironment:(id)sender{
    
    NSString *netUrl = self.customNetTextView.text;
    
    
    /* Check your input password that can not be blank. */
    if (netUrl.length == 0 ){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"Check your input node url that can not be blank.";
        [hud hide:YES afterDelay:2.5];
        return;
    }
    
    
    NSArray *oldList = [[NSUserDefaults standardUserDefaults]objectForKey:@"netList"];
    NSMutableArray *newList = [NSMutableArray arrayWithArray:oldList];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Custom" forKey:@"serverName"];
    [dict setObject:netUrl forKey:@"serverUrl"];
    
    [newList addObject:dict];
    
    [[NSUserDefaults standardUserDefaults] setObject:newList forKey:@"netList"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"CurrentNet"];
    
    [WalletUtils setNode:netUrl];

    [self.navigationController popViewControllerAnimated:YES];
}

/**
*  Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
