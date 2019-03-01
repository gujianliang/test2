//
//  WalletAddVthoNodeVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WalletAddVthoNodeVC.h"
#import <WalletSDK/MBProgressHUD.h>
#import <WalletSDK/Wallet.h>

@interface WalletAddVthoNodeVC ()

@property (weak, nonatomic) IBOutlet UITextField *customNameTextFild;   /*  It is used to input the custom network environment name */
@property (weak, nonatomic) IBOutlet UITextView *customNetTextView;     /*  It is used to input the custom network environment URL */

@end

@implementation WalletAddVthoNodeVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Add Custom Network";
}


/**
*  Set and save custom network environment.
*/
- (IBAction)setCustomNetworkEnvironment:(id)sender{
    
    NSString *netName = self.customNameTextFild.text;
    NSString *netUrl = self.customNetTextView.text;
    
    
    /* Check your input network name and network URL that can not be blank. */
    if (netName.length == 0 || netUrl.length == 0 ){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"The name and URL can not be blank.";
        [hud hide:YES afterDelay:2.5];
        return;
    }
    
    
    /* Check your URL is available */
    NSURL *URL = [NSURL URLWithString:netUrl];
    if (!URL) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"The URL is not available.";
        [hud hide:YES afterDelay:2.5];
        return;
    }
    
    
    NSArray *oldList = [[NSUserDefaults standardUserDefaults] objectForKey:@"netList"];
    NSMutableArray *newList = [NSMutableArray arrayWithArray:oldList];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:netName forKey:@"serverName"];
    [dict setObject:netUrl forKey:@"serverUrl"];
    [newList addObject:dict];
    
    [[NSUserDefaults standardUserDefaults] setObject:newList forKey:@"netList"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"CurrentNet"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
