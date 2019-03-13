//
//  WalletAddVthoNodeVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WalletAddVthoNodeVC.h"

@interface WalletAddVthoNodeVC ()
@property (weak, nonatomic) IBOutlet UITextField *netName;
@property (weak, nonatomic) IBOutlet UITextField *netUrl;

@end

@implementation WalletAddVthoNodeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加网络";
}

- (IBAction)addNet:(id)sender
{
    if (self.netName.text.length > 0 && self.netUrl.text.length > 0 )
    {
        NSArray *oldList = [[NSUserDefaults standardUserDefaults]objectForKey:@"netList"];
        NSMutableArray *newList = [NSMutableArray arrayWithArray:oldList];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.netName.text forKey:@"serverName"];
        [dict setObject:self.netUrl.text forKey:@"serverUrl"];
        
        [newList addObject:dict];
        
        [[NSUserDefaults standardUserDefaults] setObject:newList forKey:@"netList"];
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"CurrentNet"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
