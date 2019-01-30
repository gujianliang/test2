//
//  FFBMSTopSinglePixelLineView.m
//  FFBMS
//
//  Created by 曾新 on 16/4/18.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import "FFBMSTopSinglePixelLineView.h"
#define POINT_MINUS_ONE_PIXEL (([UIScreen mainScreen].scale - 1.0f) / [UIScreen mainScreen].scale)
#define CGDrawingOnePixelWidth      (1.0f)

//(1.0f/[UIScreen mainScreen].scale)

@implementation FFBMSTopSinglePixelLineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, _lineColor.CGColor);
    CGContextSetShouldAntialias(context, NO);
    CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, CGDrawingOnePixelWidth));
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
