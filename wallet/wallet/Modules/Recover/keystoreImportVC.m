//
//  keystoreImportVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/26.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "keystoreImportVC.h"
#import <walletSDK/WalletUtils.h>
#import "WalletDetailVC.h"
//#import "MBProgressHUD.h"
#import <walletSDK/MBProgressHUD.h>
#import "AppDelegate.h"

@interface keystoreImportVC ()
@property (weak, nonatomic) IBOutlet UITextView *keystoreTextView;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation keystoreImportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)importWallet:(id)sender
{
    if (self.password.text.length == 0 || self.keystoreTextView.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                                  animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"Invalid";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                              animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =  @"waiting ...";
    
    [WalletUtils decryptSecretStorageJSON:self.keystoreTextView.text.lowercaseString
                                 password:self.password.text
                                 callback:^(Account *account, NSError *NSError)
     {
         [hud hide:YES];
         if (NSError == nil) {
             NSString *address = account.address.checksumAddress;
             NSLog(@"address == %@;----\nprivateKey = %@ ",address, [SecureData dataToHexString:account.privateKey]);
             
             NSMutableDictionary *walletDict = [[NSMutableDictionary alloc]init];
             [walletDict setObject:account.address.checksumAddress forKey:@"address"];
             [walletDict setObject:self.keystoreTextView.text forKey:@"keystore"];
             
             [[NSUserDefaults standardUserDefaults]setObject:walletDict forKey:@"currentWallet"];
             
             [self.navigationController popToRootViewControllerAnimated:NO];
             
             
             WalletDetailVC *detailVC = [[WalletDetailVC alloc]init];
             [self.navigationController pushViewController:detailVC animated:YES];
//             UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detailVC];
//             [self presentViewController:nav animated:YES completion:NULL];
             
         }
     }];
}


//- (UINavigationController *) getActiveTabController
//{
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UITabBarController *tabBarController = (UITabBarController*)delegate.rootTab;
//    UIViewController *nav = [tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex];
//    return (UINavigationController *)nav;
//}
//
//- (void) restoreTabNavToRoot
//{
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.rootTab dismissViewControllerAnimated:NO completion:NULL];
//
//    for (int i = 0; i < delegate.rootTab.viewControllers.count; i++) {
//        [[self getTabControllerByIndex:i] popToRootViewControllerAnimated:NO];
//    }
//
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    [delegate.rootTab setSelectedIndex:0];
//}

@end
