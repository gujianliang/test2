/**
    Copyright (c) 2019 Tom <tom.zeng@vechain.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

**/

//
//  WalletMBProgressShower.m
//  Stonebang
//
//  Created by Tom on 18/4/7.
//  Copyright © 2016年 stonebang. All rights reserved.
//

#import "WalletMBProgressShower.h"
#import "ThorWalletHeader.h"
#import "MBProgressHUD.h"

const NSInteger kWalletHudTag = 9090;

@implementation WalletMBProgressShower

+(MBProgressHUD*)showCircleIn:(UIView*)view{
    MBProgressHUD *org_hud = [view viewWithTag:kWalletHudTag];
    if(org_hud){
        [org_hud hideAnimated:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kWalletHudTag;
    return hud;
}

+(MBProgressHUD*)showTextIn:(UIView*)view Text:(NSString*)text{
    MBProgressHUD *org_hud = [view viewWithTag:kWalletHudTag];
    if(org_hud){
        [org_hud hideAnimated:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kWalletHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.offset = CGPointMake(0.f, 0.f);
    return hud;
}

+(MBProgressHUD*)showMulLineTextIn:(UIView*)view Text:(NSString*)text{
    MBProgressHUD *org_hud = [view viewWithTag:kWalletHudTag];
    if(org_hud){
        [org_hud hideAnimated:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kWalletHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text =  text;
     hud.offset = CGPointMake(0.f, 0.f);
    return hud;
}

+(void)showTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time{
    if (text.length == 0) {
        MBProgressHUD *org_hud = [view viewWithTag:kWalletHudTag];
        if(org_hud){
            [org_hud hideAnimated:YES];
        }
        return;
    }
    
    MBProgressHUD *org_hud = [view viewWithTag:kWalletHudTag];
    if(org_hud){
        [org_hud hideAnimated:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kWalletHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text =  VCNSLocalizedBundleString(text, nil);
    hud.offset = CGPointMake(0.f, 0.f);
    [hud hideAnimated:YES afterDelay:time];
}

+(void)showMulLineTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time{
    if (text.length == 0) {
        MBProgressHUD *org_hud = [view viewWithTag:kWalletHudTag];
        if(org_hud){
            [org_hud hideAnimated:YES];
        }
        return;
    }
    
    MBProgressHUD *org_hud = [view viewWithTag:kWalletHudTag];
    if(org_hud){
        [org_hud hideAnimated:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kWalletHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text =  text;
    hud.offset = CGPointMake(0.f, 0.f);
    [hud hideAnimated:YES afterDelay:time];
}

+ (MBProgressHUD*)showLoadData:(UIView*)view Text:(NSString*)text
{
    MBProgressHUD *org_hud = [view viewWithTag:kWalletHudTag];
    if(org_hud){
        [org_hud hideAnimated:YES];
        [org_hud removeFromSuperview];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = kWalletHudTag;
    hud.label.text = text;
    // Set the details label text. Let's make it multiline this time
    return hud;
}


+(void)hide:(UIView*)view{
    MBProgressHUD* hud = [view viewWithTag:kWalletHudTag];
    if(hud){
      [hud hideAnimated:YES];
    }
}


@end
