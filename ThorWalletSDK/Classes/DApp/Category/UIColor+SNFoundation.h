//
//  UIColor+SNFoundation.h
//  Wallet
//
//  Created by vechaindev on 18/4/11.
//  Copyright ©  VeChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+SNFoundation.h"

@interface UIColor (SNFoundation)
//颜色创建
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#undef  RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#undef	HEX_RGB
#define HEX_RGB(V)		[UIColor colorWithRGBHex:V]

#undef HEX_COLOR
#define HEX_COLOR(h)  [UIColor colorWithRGBHex:(h)]

#undef HEXSTR_COLOR
#define HEXSTR_COLOR(h) [UIColor colorWithHexString:h]

#undef KSF
#define KSF(value) (value)/[UIScreen mainScreen].scale


+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (NSString*)hexStringWithColor:(UIColor*)color;


@end
