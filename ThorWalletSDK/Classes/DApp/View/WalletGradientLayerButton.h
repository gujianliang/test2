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
//  WalletGradientLayerButton.h
//  VeWallet
//
//  Created by  VechainIOS on 2018/5/23.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThorWalletHeader.h"

typedef enum {
    lowBlueType = 0,         // Dark gray--light gray
    
    highBlueType = 1,        // Blue -- Purple
    
    lowYellowType = 2,       // Light yellow -- light yellow
    
    highYellowType = 3,      // Dark yellow -- light yellow
    
    PurpleType = 4,          // Light purple -- deep purple
    
    cyanType = 5,            // Cyan -- Cyan
    
    bgBlueType = 6,          // Color blue -- Color purple
    
    bgWhiteType = 7,          // White -- white
    
}GradientLayerType;

@interface WalletGradientLayerButton : UIButton

/* isEnable
YES: Blue -- Purple
NO: Light gray---light white
 */
- (void)setGrayGradientLayerType:(GradientLayerType)type;
- (void)setDisableGradientLayer:(BOOL)isEnable;

@end
