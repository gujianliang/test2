//
//  FFBMSTextView.h
//  FFBMS
//
//  Created by 曾新 on 16/4/19.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import "FFBMSTextView.h"

//@interface FFBMSTextView()<KRKeyboardDelegate>
//{
//
//}
//@end

const NSInteger placeLabelTag = 77777;

@implementation FFBMSTextView

- (void)setText:(NSString *)text
{
    BOOL originalValue = self.scrollEnabled;

    [self setScrollEnabled:YES];
    [super setText:text];
    [self setScrollEnabled:originalValue];
    if (self.text.length > 0) {
//        self.placeholder = @"";
    }
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (self.text.length > 0) {
//            self.placeholder = @"";
        }
        [self addInputAccessoryView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addInputAccessoryView];
    if (self.text.length > 0) {
//        self.placeholder = @"";
    }
}

- (void)addInputAccessoryView
{
    UIView *keyBoardTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    keyBoardTopView.backgroundColor =  RGBCOLOR(244, 244, 246);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 12, 4, 60, 36)];
    [btn setTitle:VCNSLocalizedBundleString(@"完成", nil) forState:UIControlStateNormal];
    [btn setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventTouchUpInside];
    [keyBoardTopView addSubview:btn];
    //self.inputAccessoryView = keyBoardTopView;
    
    [self.layer setCornerRadius:2];
    [self setClipsToBounds:YES];
    
    _placeholderColor = PLACE_HOLDER_COLOR;    
}


- (void)onKeyBoardDown:(id)sender
{
    [self resignFirstResponder];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;

    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGFloat startX = 0.0f;
    if (_displayPlaceHolder && _placeholderImg) {
        CGFloat startY = (self.bounds.size.height - _placeholderImg.size.height) / 2.0f;
        [_placeholderImg drawAtPoint:CGPointMake(startX, startY)];
        startX += _placeholderImg.size.width;
    }

    if (_placeholder.length > 0 && _placeholderColor && self.text.length == 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        [paragraphStyle setLineSpacing:10];
        
        _placeLabel = [self viewWithTag:placeLabelTag];
        CGRect rect = [_placeholder boundingRectWithSize:CGSizeMake(self.frame.size.width - 16.0f - startX, NSIntegerMax)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Scale(13)]}
                                            context:nil];
        
        if (_placeLabel == nil) {
            _placeLabel  = [[UILabel alloc]initWithFrame:CGRectMake(startX + 8.0f + self.placeHolderXOffset, self.placeHolderYOffset != 0 ? self.placeHolderYOffset : 8, self.frame.size.width - 16.0f - startX,  rect.size.height + 5)];
            [_placeLabel setText:_placeholder];
            [_placeLabel setTag:placeLabelTag];
            [_placeLabel setFont:[UIFont systemFontOfSize:Scale(13)]];
            _placeLabel.textAlignment = self.textAlignment;
            [_placeLabel setTextColor:_placeholderColor];
            [_placeLabel setNumberOfLines:0];
            [_placeLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [_placeLabel setBackgroundColor:[UIColor clearColor]];
            [self addSubview:_placeLabel];
        }
    }else{
    
        UILabel *placeLabel = [self viewWithTag:placeLabelTag];
        if (placeLabel) {
            [placeLabel removeFromSuperview];
            placeLabel = nil;
        }
    }
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:))
        return !self.disablePaste;
    // 禁用选择功能
    if (action == @selector(select:))
        return !self.disableSelect;
    // 禁用全选功能
    if (action == @selector(selectAll:))
        return !self.disableSelectAll;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)contentSizeToFit
{
    //先判断一下有没有文字（没文字就没必要设置居中了）
    if([self.text length]>0)
    {
        //textView的contentSize属性
        CGSize contentSize = self.contentSize;
        //textView的内边距属性
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= self.frame.size.height)
        {
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = (self.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else          //如果文字高度超出textView的高度
        {
            newSize = self.frame.size;
            offset = UIEdgeInsetsZero;
            newSize = contentSize;
        }
        
        //根据前面计算设置textView的ContentSize和Y方向偏移量
        [self setContentSize:newSize];
        [self setContentInset:offset];
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
