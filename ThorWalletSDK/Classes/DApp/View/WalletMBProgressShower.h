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
//  WalletMBProgressShower.h
//  Stonebang
//
//  Created by Tom on 18/4/7.
//  Copyright © 2016年 stonebang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"


@interface WalletMBProgressShower : NSObject

/**
 *  Show daisy wheel
 *
 *  @param view Need to display the view of the daisy wheel
 *
 *  @return HUD
 */
+(MBProgressHUD*)showCircleIn:(UIView*)view;

/**
 *  展示文本
 *
 *  @param view View of the text
 *  @param text Display text content
 *
 *  @return HUD
 */
+(MBProgressHUD*)showTextIn:(UIView*)view
                       Text:(NSString*)text;

/**
 *  Text that disappears at a fixed time
 *
 *  @param view View of the text
 *  @param text Display text content
 *  @param time display time
 */
+(void)showTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time;
/**
 *  hide HUD
 */

+ (MBProgressHUD*)showLoadData:(UIView*)view Text:(NSString*)text ;

+(MBProgressHUD*)showMulLineTextIn:(UIView*)view Text:(NSString*)text;

+(void)showMulLineTextIn:(UIView*)view Text:(NSString*)text During:(NSTimeInterval)time;

+(void)hide:(UIView*)view;

@end


