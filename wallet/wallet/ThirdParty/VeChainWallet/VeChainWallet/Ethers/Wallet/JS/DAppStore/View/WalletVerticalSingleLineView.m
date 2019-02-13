//
//  WalletVerticalSingleLineView.m
//  Wallet
//
//  Created by 曾新 on 16/5/9.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import "WalletVerticalSingleLineView.h"

@implementation WalletVerticalSingleLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, _lineColor.CGColor);
    CGContextSetShouldAntialias(context, NO);
    CGContextFillRect(context, CGRectMake(rect.origin.x, 0, CGDrawingOnePixelWidth, rect.size.height));
    CGContextRestoreGState(context);
    [self setBackgroundColor:[UIColor clearColor]];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineColor = HEX_RGB(0xeeeeee);
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return  self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _lineColor  = HEX_RGB(0xeeeeee);
    [self setBackgroundColor:[UIColor clearColor]];
}

@end
