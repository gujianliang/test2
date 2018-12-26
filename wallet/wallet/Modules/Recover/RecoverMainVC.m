//
//  RecoverMainVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "RecoverMainVC.h"
#import "keystoreImportVC.h"
#import "MnemonicImportVC.h"

@interface RecoverMainVC ()

@end

@implementation RecoverMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)mnemonicImport:(id)sender
{
    MnemonicImportVC *vc = [[MnemonicImportVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)keystoreImport:(id)sender
{
    keystoreImportVC *vc = [[keystoreImportVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
