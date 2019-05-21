//
//  WalletAddVthoNodeVC.m
//  walletSDKDemo
//
//  Created by Tom on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WalletAddVthoNodeVC.h"
#import "MBProgressHUD.h"
#import <ThorWalletSDK/WalletUtils.h>

@interface WalletAddVthoNodeVC ()

@property (weak, nonatomic) IBOutlet UITextField *customNameTextFild;   /*  It is used to input the custom node environment name */
@property (weak, nonatomic) IBOutlet UITextView *customNodeTextView;     /*  It is used to input the custom node environment URL */

@end

@implementation WalletAddVthoNodeVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Add Custom Node";
}


/**
*  Set and save custom node environment.
*/
- (IBAction)setCustomNodeEnvironment:(id)sender{
    
    NSString *nodeName = self.customNameTextFild.text;
    NSString *nodeUrl = self.customNodeTextView.text;
    
    
    /* Check your input node name and node URL that can not be blank. */
    if (nodeName.length == 0 || nodeUrl.length == 0 ){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text =  @"The input cannot be blank.";
        [hud hideAnimated:YES afterDelay:2.5];
        return;
    }
    
    
    /* Check your URL is available */
    NSURL *URL = [NSURL URLWithString:nodeUrl];
    if (![[UIApplication sharedApplication] canOpenURL:URL]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text =  @"The URL is not available.";
        [hud hideAnimated:YES afterDelay:2.5];
        return;
    }
    
    
    NSArray *oldList = [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeList"];
    NSMutableArray *newList = [NSMutableArray arrayWithArray:oldList];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:nodeName forKey:@"nodeName"];
    [dict setObject:nodeUrl forKey:@"nodeUrl"];
    [newList addObject:dict];
    
    [[NSUserDefaults standardUserDefaults] setObject:newList forKey:@"nodeList"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"currentNode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [WalletUtils setNodeUrl:nodeUrl];

    [self.navigationController popViewControllerAnimated:YES];
}


/**
*  Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
