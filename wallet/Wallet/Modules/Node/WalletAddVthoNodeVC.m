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

@property (weak, nonatomic) IBOutlet UITextField *customNameTextFild;   /*  It is used to input the custom network environment name */
@property (weak, nonatomic) IBOutlet UITextView *customNetTextView;     /*  It is used to input the custom network environment URL */

@end

@implementation WalletAddVthoNodeVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Add Custom Node";
}


/**
*  Set and save custom network environment.
*/
- (IBAction)setCustomNetworkEnvironment:(id)sender{
    
    NSString *nodeName = self.customNameTextFild.text;
    NSString *nodeUrl = self.customNetTextView.text;
    
    
    /* Check your input network name and network URL that can not be blank. */
    if (nodeName.length == 0 || nodeUrl.length == 0 ){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"The input cannot be null.";
        [hud hide:YES afterDelay:2.5];
        return;
    }
    
    
    /* Check your URL is available */
    NSURL *URL = [NSURL URLWithString:nodeUrl];
    if (![[UIApplication sharedApplication] canOpenURL:URL]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"The URL is not available.";
        [hud hide:YES afterDelay:2.5];
        return;
    }
    
    
    NSArray *oldList = [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeList"];
    NSMutableArray *newList = [NSMutableArray arrayWithArray:oldList];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:nodeName forKey:@"nodeName"];
    [dict setObject:nodeUrl forKey:@"nodeUrl"];
    [newList addObject:dict];
    
    [[NSUserDefaults standardUserDefaults] setObject:newList forKey:@"nodeList"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"CurrentNode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [WalletUtils setNode:nodeUrl];

    [self.navigationController popViewControllerAnimated:YES];
}


/**
*  Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
