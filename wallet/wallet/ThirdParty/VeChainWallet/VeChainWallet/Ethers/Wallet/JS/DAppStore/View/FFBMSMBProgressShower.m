//
//  FFBMSMBProgressShower.m
//  Stonebang
//
//  Created by 曾新 on 16/4/7.
//  Copyright © 2016年 stonebang. All rights reserved.
//

#import "FFBMSMBProgressShower.h"

const NSInteger kFFBMSHudTag = 12345;

@implementation FFBMSMBProgressShower

+(MBProgressHUD*)showCircleIn:(UIView*)view{
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hide:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kFFBMSHudTag;
    return hud;
}

+(MBProgressHUD*)showTextIn:(UIView*)view Text:(NSString*)text{
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hide:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kFFBMSHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.labelText =  text;
    //hud.label.text = text;
    hud.xOffset = 0.f;
    hud.yOffset = 0.f;
   // hud.offset = CGPointMake(0.f, 0.f);
    return hud;
}

+(MBProgressHUD*)showMulLineTextIn:(UIView*)view Text:(NSString*)text{
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hide:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kFFBMSHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText =  text;

    hud.xOffset = 0.f;
    hud.yOffset = 0.f;
    // hud.offset = CGPointMake(0.f, 0.f);
    return hud;
}

+(void)showTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time{
    if (text.length == 0) {
        NSLog(@"网络请求失败，不做弹框");
        MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
        if(org_hud){
            [org_hud hide:YES];
        }
        return;
    }
    
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hide:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kFFBMSHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText =  NSLocalizedString(text, nil);
    hud.xOffset = 0.f;
    hud.yOffset = 0.f;
    [hud hide:YES afterDelay:time];
}

+(void)showMulLineTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time{
    if (text.length == 0) {
        NSLog(@"网络请求失败，不做弹框");
        MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
        if(org_hud){
            [org_hud hide:YES];
        }
        return;
    }
    
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hide:YES];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.tag = kFFBMSHudTag;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText =  text;
    //hud.label.text = text;
    hud.xOffset = 0.f;
    hud.yOffset = 0.f;
    [hud hide:YES afterDelay:time];
}

+ (MBProgressHUD*)showLoadData:(UIView*)view Text:(NSString*)text
{
    MBProgressHUD *org_hud = [view viewWithTag:kFFBMSHudTag];
    if(org_hud){
        [org_hud hide:YES];
        [org_hud removeFromSuperview];
//        return nil;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = kFFBMSHudTag;
    hud.labelText = text;
    // Set the details label text. Let's make it multiline this time
    return hud;
}


+(void)hide:(UIView*)view{
    MBProgressHUD* hud = [view viewWithTag:kFFBMSHudTag];
    if(hud){
      [hud hide:YES];
    }
}


@end
