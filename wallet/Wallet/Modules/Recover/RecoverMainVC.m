//
//  RecoverMainVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "RecoverMainVC.h"
#import "KeystoreImportVC.h"
#import "MnemonicImportVC.h"

@interface RecoverMainVC ()

@end

@implementation RecoverMainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)mnemonicImport:(id)sender
{
    MnemonicImportVC *vc = [[MnemonicImportVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)keystoreImport:(id)sender
{
    KeystoreImportVC *vc = [[KeystoreImportVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
