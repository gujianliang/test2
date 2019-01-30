//
//  AddNetVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "AddNetVC.h"

@interface AddNetVC ()
@property (weak, nonatomic) IBOutlet UITextField *netName;
@property (weak, nonatomic) IBOutlet UITextField *netUrl;

@end

@implementation AddNetVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加网络";
    // Do any additional setup after loading the view from its nib.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)addNet:(id)sender
{
    if (self.netName.text.length > 0 && self.netUrl.text.length > 0 )
    {
        
    }
}

@end
