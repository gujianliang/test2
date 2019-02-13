//
//  FFBMSAlertShower.m
//  Stonebang
//
//  Created by 曾新 on 16/4/7.
//  Copyright © 2016年 stonebang. All rights reserved.
//

#import "FFBMSAlertShower.h"
#import "FFBMSVerticalSingleLineView.h"
#import "FFBMSTopSinglePixelLineView.h"
#import "FFBMSTextView.h"
//#import "SelectableLabel.h"

#define  CellHeight 60
@interface FFBMSAlertShower ()<UITextViewDelegate>

@property (nonatomic, strong) __block FFBMSTextView *inputView;
@property (nonatomic, assign) BOOL nonSecureInput;
@property (nonatomic, assign) BOOL isPlaceHolder;

@end

@implementation FFBMSAlertShower
{
    NSDate *_clickDate;
    NSMutableString *_originalText;
}
//SIGLEIMP(FFBMSAlertShower)


+(void)removeAlertShowerinCtl:(UIViewController*)ctl {
    UIView *superView = nil;
    if (ctl.navigationController) {
        superView = ctl.navigationController.view;
        if ([ctl.navigationController.view viewWithTag:8080000]) {
            UIView *view =  [ctl.navigationController.view viewWithTag:8080000];
            [view removeFromSuperview];
            view = nil;
        }
    }else{
        superView = ctl.view;
        if ([ctl.view viewWithTag:8080000]) {
            UIView *view =  [ctl.view viewWithTag:8080000];
            [view removeFromSuperview];
            view = nil;
        }
    }
}

+(void)showAlert:(NSString*)title
             msg:(id)msg
           inCtl:(UIViewController*)ctl
           items:(NSArray<NSString*>*)items
      clickBlock:(void(^)(NSInteger))clickCallBack
{
    if(!items || items.count==0){
        return;
    }
    
    UIView *superView = nil;
    if([ctl isKindOfClass:UIViewController.class]){
        
        if (ctl.navigationController) {
            superView = ctl.navigationController.view;
            if ([ctl.navigationController.view viewWithTag:8080000]) {
                UIView *view =  [ctl.navigationController.view viewWithTag:8080000];
                [view removeFromSuperview];
                view = nil;
            }
        }else{
            superView = ctl.view;
            if ([ctl.view viewWithTag:8080000]) {
                UIView *view =  [ctl.view viewWithTag:8080000];
                [view removeFromSuperview];
                view = nil;
            }
        }
        
    }else {
        superView = (UIView *)ctl;
        if ([superView viewWithTag:8080000]) {
            UIView *view =  [superView viewWithTag:8080000];
            [view removeFromSuperview];
            view = nil;
        }
    }

    FFBMSAlertShower* shower = [[FFBMSAlertShower alloc]init];
    shower.alertClickBack = clickCallBack;
    [shower setAlpha:1];
    [shower setTag:8080000];
    [shower initAlertViewWithTitle:title msg:msg magAlignment:NSTextAlignmentLeft  inView:superView items:items];
}

+(void)showAlertMutil:(NSString*)title
             msg:(NSString*)msg
           inCtl:(UIViewController*)ctl
           items:(NSArray<NSString*>*)items
      clickBlock:(void(^)(NSInteger))clickCallBack
{
    if(!items || items.count==0){
        return;
    }
    
    UIView *superView = nil;
    if (ctl.navigationController) {
        superView = ctl.navigationController.view;
        if ([ctl.navigationController.view viewWithTag:8080000]) {
            UIView *view =  [ctl.navigationController.view viewWithTag:8080000];
            [view removeFromSuperview];
            view = nil;
        }
    }else{
        superView = ctl.view;
        if ([ctl.view viewWithTag:8080000]) {
            UIView *view =  [ctl.view viewWithTag:8080000];
            [view removeFromSuperview];
            view = nil;
        }
    }
    
    FFBMSAlertShower* shower = [[FFBMSAlertShower alloc]init];
    shower.alertClickBack = clickCallBack;
    [shower setAlpha:1];
    [shower setTag:8080000];
    [shower initAlertViewWithTitleMutil:title msg:msg magAlignment:NSTextAlignmentLeft  inView:superView items:items];
}


- (void)initAlertViewWithTitleMutil:(NSString *)title
                           msg:(id)msg
                  magAlignment:(NSTextAlignment)textAlignment
                        inView:(UIView*)inView
                         items:(NSArray<NSString*>*)items
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.4];
    [self addSubview:bgView];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 0)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    
    if (title.length > 0) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, contentView.frame.size.width - 40, 50)];
        [titleLabel setText:title];
        [titleLabel setTextColor:HEX_RGB(0x333333)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        titleLabel.numberOfLines = 2;
        [contentView addSubview:titleLabel];
    }
    UILabel *msgLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20,  40 ,20)];
    if ([msg isKindOfClass:[NSString class]]) {
        NSString* msgStr = (NSString*)msg;
        if (msgStr.length > 0) {
            
            CGRect msgRect = [msgStr boundingRectWithSize:CGSizeMake(contentView.frame.size.width - 40, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            
            msgLable = [[UILabel alloc]initWithFrame:CGRectMake(20, (title.length > 0 ? 60 : 30), contentView.frame.size.width - 40 ,ceil(msgRect.size.height) + 2)];
            [msgLable setText:msgStr];
            [msgLable setFont:[UIFont systemFontOfSize:14]];
            [msgLable setNumberOfLines:0];
            [msgLable setTextColor:HEX_RGB(0x666666)];
            [msgLable setTextAlignment:textAlignment];
            [msgLable setBackgroundColor:[UIColor clearColor]];
            [contentView addSubview:msgLable];
        }
        
    }
    else if( [msg isKindOfClass:[NSMutableAttributedString class]])
    {
        NSMutableAttributedString* msgStr =(NSMutableAttributedString*)msg;
        NSString *anotherString=[msgStr string];
        CGRect msgRect = [anotherString boundingRectWithSize:CGSizeMake(contentView.frame.size.width - 40, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        msgLable = [[UILabel alloc]initWithFrame:CGRectMake(20, (title.length > 0 ? 60 : 30), contentView.frame.size.width - 40 ,ceil(msgRect.size.height) + 2)];
        //[msgLable setText:msgStr];
        msgLable.attributedText = msgStr;
        [msgLable setFont:[UIFont systemFontOfSize:14]];
        [msgLable setNumberOfLines:0];
        //        [msgLable setTextColor:HEX_RGB(0x666666)];
        [msgLable setTextAlignment:textAlignment];
        [msgLable setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:msgLable];
        
    }
    
    CGFloat btnY = CGRectGetMaxY(msgLable.frame);
    CGFloat btnW = CGRectGetWidth(contentView.frame)/items.count;
    
    for (int i = 0; i < items.count ; i ++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnW*i, btnY + 20, btnW, 40)];
        [btn setTitle:items[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = i ;
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [btn setTitleColor:HEX_RGB(0xEF6F6F) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        [contentView setFrame:CGRectMake(0, 0, contentView.frame.size.width , CGRectGetMaxY(btn.frame) + 0)];
        if ((items.count -1) == i) {
            [btn setTitleColor:HEX_RGB(0x898CD3) forState:UIControlStateNormal];
        }
        
        FFBMSVerticalSingleLineView *verticalLineVeiw = [[FFBMSVerticalSingleLineView alloc]initWithFrame:CGRectMake(btnW*i, btnY + 20, 1, 40)];
        [contentView addSubview:verticalLineVeiw];
    }
    
    FFBMSTopSinglePixelLineView *bottomLine = [[FFBMSTopSinglePixelLineView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame) - 40, contentView.frame.size.width, 1)];
    [contentView addSubview:bottomLine];
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [contentView setFrame:CGRectMake(0, 0, contentView.frame.size.width , CGRectGetMaxY(contentView.frame) + 0)];
    [contentView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 10)];
    [inView addSubview:self];
    [self setAlpha:0.0f];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.0f];
        
    }];
    
    [contentView.layer setCornerRadius:4];
    [contentView setClipsToBounds:YES];
}

+(void)showNoRepeatAlert:(NSString*)title
             msg:(NSString*)msg
           inCtl:(UIViewController*)ctl
           items:(NSArray<NSString*>*)items
      clickBlock:(void(^)(NSInteger))clickCallBack
{
    if(!items || items.count==0){
        return;
    }
    
    UIView *superView = nil;
    if (ctl.navigationController) {
        superView = ctl.navigationController.view;
        if ([ctl.navigationController.view viewWithTag:8080000]) {
//            UIView *view =  [ctl.navigationController.view viewWithTag:8080000];
            //[view removeFromSuperview];
            
        }
    }else{
        superView = ctl.view;
        if ([ctl.view viewWithTag:8080000]) {
//            UIView *view =  [ctl.view viewWithTag:8080000];
            //[view removeFromSuperview];
            
        }
    }
    
    FFBMSAlertShower* shower = [[FFBMSAlertShower alloc]init];
    shower.alertClickBack = clickCallBack;
    [shower setAlpha:1];
    [shower setTag:8080000];
    [shower initAlertViewWithTitle:title msg:msg magAlignment:NSTextAlignmentLeft  inView:superView items:items];
}

+(void)showAlert:(NSString*)title
             msg:(id)msg
         magAlignment:(NSTextAlignment)textAlignment
           inCtl:(UIViewController*)ctl
           items:(NSArray<NSString*>*)items
      clickBlock:(void(^)(NSInteger))clickCallBack
{
    if(!items || items.count==0){
        return;
    }
    
    UIView *superView = nil;
    if (ctl.navigationController) {
        superView = ctl.navigationController.view;
        if ([ctl.navigationController.view viewWithTag:8080000]) {
            UIView *view =  [ctl.navigationController.view viewWithTag:8080000];
            [view removeFromSuperview];        }
    }else{
        superView = ctl.view;
        if ([ctl.view viewWithTag:8080000]) {
            UIView *view =  [ctl.view viewWithTag:8080000];
            [view removeFromSuperview];        }
    }
    
    FFBMSAlertShower* shower = [[FFBMSAlertShower alloc]init];
    shower.alertClickBack = clickCallBack;
    [shower setAlpha:1];
    [shower setTag:8080000];
    [shower initAlertViewWithTitle:title msg:msg magAlignment:(NSTextAlignment)textAlignment inView:superView items:items];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    FFBMSAlertShower* shower = [[FFBMSAlertShower alloc]init];
    if(shower.alertClickBack){
        shower.alertClickBack(buttonIndex);
    }
}

- (void)initAlertViewWithTitle:(NSString *)title
                           msg:(id)msg
                  magAlignment:(NSTextAlignment)textAlignment
                        inView:(UIView*)inView
                         items:(NSArray<NSString*>*)items
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.4];
    [self addSubview:bgView];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scale(270.0), 0)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    CGFloat viewY = 34;
    UILabel *titleLabel = [[UILabel alloc]init];
    if (title.length > 0) {
        [titleLabel setText:title];
        [titleLabel setNumberOfLines:2];
        [titleLabel setTextColor:HEX_RGB(0x202C56)];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]];
        [contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(34);
        }];
        
        CGFloat msgH = [title boundingRectWithSize:CGSizeMake(contentView.frame.size.width - 40, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLabel.font} context:nil].size.height;
        viewY = viewY + msgH;
    }
    UILabel *msgLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20,  40 ,20)];
    if ([msg isKindOfClass:[NSString class]]) {
        NSString* msgStr = (NSString*)msg;
        if (msgStr.length > 0) {
            
            CGRect msgRect = [msgStr boundingRectWithSize:CGSizeMake(contentView.frame.size.width - 40, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            
            msgLable = [[UILabel alloc]initWithFrame:CGRectMake(20, (title.length > 0 ? 50 : 30), contentView.frame.size.width - 40 ,ceil(msgRect.size.height) + 2)];
            [msgLable setText:msgStr];
            [msgLable setFont:[UIFont systemFontOfSize:Scale(13.0)]];
            [msgLable setNumberOfLines:0];
            [msgLable setTextColor:HEX_RGB(0xBDBDBD)];
            [msgLable setTextAlignment:textAlignment];
            [msgLable setBackgroundColor:[UIColor clearColor]];
            [contentView addSubview:msgLable];
            
            [msgLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                if(title.length > 0){
                    make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
                   
                }else{
                    make.top.mas_equalTo(34);
                }
            }];
            
            CGFloat msgH = [msgStr boundingRectWithSize:CGSizeMake(contentView.frame.size.width - 40, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:msgLable.font} context:nil].size.height;
            if(title.length > 0){
                viewY = viewY + msgH + 20;
            }else{
                viewY = viewY + msgH;
            }
        }
       
    }
    else if( [msg isKindOfClass:[NSMutableAttributedString class]])
    {
        NSMutableAttributedString* msgStr =(NSMutableAttributedString*)msg;
        NSString *anotherString=[msgStr string];
        CGRect msgRect = [anotherString boundingRectWithSize:CGSizeMake(contentView.frame.size.width - 40, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        msgLable = [[UILabel alloc]initWithFrame:CGRectMake(20, (title.length > 0 ? 50 : 30), contentView.frame.size.width - 40 ,ceil(msgRect.size.height) + 2)];
        msgLable.attributedText = msgStr;
        [msgLable setFont:[UIFont systemFontOfSize:Scale(13.0)]];
        [msgLable setNumberOfLines:0];
          [msgLable setTextAlignment:textAlignment];
        [msgLable setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:msgLable];
        
        [msgLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
        }];

        CGFloat msgH = [anotherString boundingRectWithSize:CGSizeMake(contentView.frame.size.width - 40, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:msgLable.font} context:nil].size.height;
        viewY = viewY + msgH + 20;
    }
    CGFloat btnW = CGRectGetWidth(contentView.frame)/items.count;
    
    for (int i = 0; i < items.count ; i ++) {
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:items[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = i ;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:Scale(16.0) weight:UIFontWeightMedium]];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn setTitleColor:HEX_RGB(0xEF6F6F) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        [contentView setFrame:CGRectMake(0, 0, contentView.frame.size.width , CGRectGetMaxY(btn.frame) + 0)];
        if ((items.count -1) == i) {
            [btn setTitleColor:HEX_RGB(0x898CD3) forState:UIControlStateNormal];
        }
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnW*i);
            make.width.mas_equalTo(btnW);
            make.top.mas_equalTo(msgLable.mas_bottom).offset(35);
        }];
        
        FFBMSVerticalSingleLineView *verticalLineVeiw = [[FFBMSVerticalSingleLineView alloc]init];
        [contentView addSubview:verticalLineVeiw];
        
        [verticalLineVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnW*i);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(24);
            make.top.mas_equalTo(msgLable.mas_bottom).offset(37);
        }];
    }
    if (items.count == 1) {
        FFBMSTopSinglePixelLineView *verticalLineVeiw = [[FFBMSTopSinglePixelLineView alloc]init];
        [contentView addSubview:verticalLineVeiw];
        
        [verticalLineVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(msgLable.mas_bottom).offset(20);
        }];
    }
    
    viewY = viewY + 80;
    
    FFBMSTopSinglePixelLineView *bottomLine = [[FFBMSTopSinglePixelLineView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame) - 40, contentView.frame.size.width, 1)];
    [contentView addSubview:bottomLine];
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [contentView setFrame:CGRectMake(0, 0, contentView.frame.size.width ,viewY)];
    [contentView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 50)];
    [inView addSubview:self];
    
    [self setAlpha:0.0f];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.0f];

    }];
    
    [contentView.layer setCornerRadius:4];
    [contentView setClipsToBounds:YES];
}

- (void)action:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (_alertClickBack) {
        _alertClickBack(btn.tag);
    }
    if (_alertClickBackF) {
        _alertClickBackF(btn.tag, !self.nonSecureInput ? _originalText : _inputView.text);
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


+(void)showSheet:(NSString*)title
           inCtl:(UIViewController*)ctl
           items:(NSArray<NSString*>*)items
      clickBlock:(void(^)(NSInteger))clickCallBack
{
    if(!items || items.count == 0){
        return;
    }
    
    UIView *superView = nil;
    if (ctl.navigationController) {
        superView = ctl.navigationController.view;
    }else{
        superView = ctl.view;
    }
    
    FFBMSAlertShower* shower = [[FFBMSAlertShower alloc]init];
    if(clickCallBack){
        shower.alertClickBack = clickCallBack;
    }
    [shower setAlpha:1];
    [shower setTag:8080000];
    [shower initActionSheetWithTitle:title inView:superView items:items];
}

- (void)initActionSheetWithTitle:(NSString *)title
                          inView:(UIView*)inView
                           items:(NSArray<NSString*>*)items
{

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.4];
    [self addSubview:bgView];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 0)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    
    NSMutableArray *resultList = [NSMutableArray arrayWithArray:items];
    if ([items containsObject:VCNSLocalizedBundleString(@"dialog_no", nil)]) {
        [resultList removeObject:VCNSLocalizedBundleString(@"dialog_no", nil)];
        items = [NSArray arrayWithArray:resultList];
    }
    for (int i = 0; i < items.count ; i ++) {
        
        UIView *cell = [self creatCell:items[i] index:i];
        [contentView addSubview:cell];
    }
    FFBMSTopSinglePixelLineView *bottomLine = [[FFBMSTopSinglePixelLineView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame) - CellHeight, SCREEN_WIDTH - 40, 1)];
    [contentView addSubview:bottomLine];
    
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
    }];
    
    CGFloat hight = items.count * CellHeight + CellHeight + 40;
    [contentView setFrame:CGRectMake(20, SCREEN_HEIGHT - hight, SCREEN_WIDTH - 40 ,  items.count * CellHeight)];
    [inView addSubview:self];
    
    UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 80, SCREEN_WIDTH - 40, CellHeight)];
    [btnCancel addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.tag = 10;
    [btnCancel.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btnCancel setTitle:VCNSLocalizedBundleString(@"dialog_no", nil) forState:UIControlStateNormal];
    [btnCancel.titleLabel setTextColor:[UIColor whiteColor]];
    [btnCancel setBackgroundColor:[UIColor whiteColor]];
    [btnCancel setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];

    [self addSubview:btnCancel];
    
    [btnCancel.layer setCornerRadius:4];
    [btnCancel setClipsToBounds:YES];
    
    [contentView.layer setCornerRadius:4];
    [contentView setClipsToBounds:YES];

}

- (UIView *)creatCell:(NSString *)msg index:(NSInteger)index
{
    UIView *cell = [[UIView alloc]initWithFrame:CGRectMake(0, index * CellHeight, SCREEN_WIDTH - 40, CellHeight)];
    
    FFBMSTopSinglePixelLineView *bottomLine = [[FFBMSTopSinglePixelLineView alloc]initWithFrame:CGRectMake(0, CellHeight - 1, SCREEN_WIDTH - 40, 1)];
    [cell addSubview:bottomLine];
    
    UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, CellHeight)];
    [btnCancel addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.tag = index;
    [btnCancel setTitle:msg forState:UIControlStateNormal];
    [btnCancel setTitleColor:HEX_RGB(0x666666) forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btnCancel setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:btnCancel];
    
    return cell;
}

+(void)showInputView:(NSString*)inputText
           inCtl:(UIViewController*)ctl
           items:(NSArray<NSString*>*)items
      clickBlock:(void(^)(NSInteger tag,NSString *msg))clickCallBack
{
    [FFBMSAlertShower showInputView:@"" inputText:inputText isPlaceholder:YES secureInput:YES inCtl:ctl items:items clickBlock:clickCallBack];
}

+(void)showInputView:(NSString*)title
           inputText:(NSString *)inputText
       isPlaceholder:(BOOL)isPlaceHolder
         secureInput:(BOOL)secureInput
               inCtl:(UIViewController*)ctl
               items:(NSArray<NSString*>*)items
          clickBlock:(void(^)(NSInteger tag,NSString *msg))clickCallBack
{
    if(!items || items.count == 0){
        return;
    }
    
    UIView *superView = nil;
    if (ctl.navigationController) {
        superView = ctl.navigationController.view;
    }else{
        superView = ctl.view;
    }
    
    FFBMSAlertShower* shower = [[FFBMSAlertShower alloc]init];
    if(clickCallBack){
        shower.alertClickBackF = clickCallBack;
    }
    [shower setAlpha:1];
    [shower setTag:8080000];
    [shower initInputViewWithTitle:title textFiedld:inputText isPlaceholder:isPlaceHolder msg:inputText magAlignment:NSTextAlignmentLeft inView:superView items:items secureInput:secureInput];
}

- (void)initInputViewWithTitle:(NSString *)title
                    textFiedld:(NSString *)textField
                 isPlaceholder:(BOOL)isPlaceHolder
                           msg:(id)msg
                  magAlignment:(NSTextAlignment)textAlignment
                        inView:(UIView*)inView
                         items:(NSArray<NSString*>*)items
                   secureInput:(BOOL)secureInput
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextView:) name:UITextViewTextDidChangeNotification object:nil];
//    NC_ADD_SELF_NAME_OBJECT(@selector(changeTextView:), UITextViewTextDidChangeNotification, nil);
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginTextView:) name:UITextViewTextDidChangeNotification object:nil];
//    NC_ADD_SELF_NAME_OBJECT(@selector(beginTextView:), UITextViewTextDidBeginEditingNotification, nil);

    self.nonSecureInput = !secureInput;
    self.isPlaceHolder = isPlaceHolder;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.4];
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBGView)];
    [tap setNumberOfTapsRequired:1];
    [bgView addGestureRecognizer:tap];
    
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 255, 0)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    
    UILabel *msgLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20,  contentView.frame.size.width - 40 ,30)];
    if (title.length == 0) {
        [msgLable setText:VCNSLocalizedBundleString(@"dialog_tip_title", nil)];
    }else{
        [msgLable setText:VCNSLocalizedBundleString(title, nil)];
    }
    msgLable.textAlignment = NSTextAlignmentCenter;
    [msgLable setTextColor:HEX_RGB(0x202C56)];
    [msgLable setBackgroundColor:[UIColor clearColor]];
    [msgLable setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]];
    [contentView addSubview:msgLable];
    
    NSInteger fontSize = 18;
    while (1 ) {
        [msgLable setFont:[UIFont boldSystemFontOfSize:fontSize]];
        CGRect msgRect = [title boundingRectWithSize:CGSizeMake(NSIntegerMax, 40)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:@"DIN-Medium"
                                                                                           size:fontSize]}
                                             context:nil];
        if (ceil(msgRect.size.width) > contentView.frame.size.width - 40 - 10 ) {
            
            fontSize  = fontSize - 1;
        }else{
            break;
        }
    }
    
    self.inputView.frame = CGRectMake(40, 40 + 25, contentView.frame.size.width - 80, 35);
    
    if ([[WalletUserDefaultManager getLanuage] isEqualToString:@"zh-Hans"]) {
        self.inputView.frame = CGRectMake(40, 40 + 20, contentView.frame.size.width - 80, 25);
        self.inputView.placeHolderYOffset = 5;
    }
    if (self.isPlaceHolder) {
        self.inputView.placeholder = textField;
    } else {
        self.inputView.text = textField;
    }
    self.inputView.delegate = self;
    self.inputView.returnKeyType = UIReturnKeyDone;
    [contentView addSubview:self.inputView];
    
    FFBMSTopSinglePixelLineView *bottomLine = [[FFBMSTopSinglePixelLineView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.inputView.frame) + 5, contentView.frame.size.width - 80, 1)];
    [contentView addSubview:bottomLine];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_inputView.frame)- 8, 5, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [self.inputView addSubview:rightBtn];
    
    __weak typeof(self) weakSelf = self;
    rightBtn.block = ^(UIButton *btn) {
        
        weakSelf.inputView.text = @"";
    };
    
    CGFloat btnY = CGRectGetMaxY(msgLable.frame) + 40;
    CGFloat btnW = CGRectGetWidth(contentView.frame)/items.count;
    
    for (int i = 0; i < items.count ; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i, btnY + 20, btnW, 40)];
        [btn setTitle:items[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = i ;
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [btn setTitleColor:HEX_RGB(0xEF6F6F) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        [contentView setFrame:CGRectMake(0, 0, contentView.frame.size.width , CGRectGetMaxY(btn.frame) + 15)];
        if ((items.count -1) == i) {
            [btn setTitleColor:HEX_RGB(0x898CD3) forState:UIControlStateNormal];
        }
        
        FFBMSVerticalSingleLineView *verticalLineVeiw = [[FFBMSVerticalSingleLineView alloc]initWithFrame:CGRectMake(btnW*i, btnY + 30, 1, 20)];
        [contentView addSubview:verticalLineVeiw];
    }
    
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [contentView setFrame:CGRectMake(0, 0, contentView.frame.size.width , CGRectGetMaxY(contentView.frame) + 0)];
    [contentView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 80)];
    [inView addSubview:self];
    [self setAlpha:0.0f];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.0f];
        
    }];
    
    [contentView.layer setCornerRadius:4];
    [contentView setClipsToBounds:YES];
}

+(void)showAlertWithTimer:(NSInteger)sec
                      msg:(NSString*)msg
                    inCtl:(UIViewController*)ctl {
    
    UIView *superView = ctl.view;
    if ([ctl.view viewWithTag:8080000]) {
        UIView *view =  [ctl.view viewWithTag:8080000];
        [view removeFromSuperview];
    }
    
    // 容器视图
    CGRect rect = CGRectMake(Scale(20.0),
                             superView.frame.size.height - Scale(30.0) - Scale(65),
                             superView.frame.size.width - Scale(40.0),
                             Scale(30.0));
    FFBMSAlertShower *shower = [[FFBMSAlertShower alloc] initWithFrame:rect];
    [shower setAlpha:1];
    [shower setTag:8080000];
    [superView addSubview:shower];
    
    // 提示信息
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:shower.bounds];
    [titleLabel setText:msg];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor colorWithHexString:@"#898CD3"]];
    [titleLabel setFont:[UIFont systemFontOfSize:Scale(12.0)]];
    titleLabel.layer.cornerRadius = 4.0;
    titleLabel.clipsToBounds = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [shower addSubview:titleLabel];
    
    // 定时器延时
   __block NSInteger num = sec;
   [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        --num;
        
        if (num  <= 0) {
            [timer invalidate];
            timer = nil;
            
            [UIView animateWithDuration:1.0
                             animations:^{
                                 [shower setAlpha:0];
                                 
                             }completion:^(BOOL finished) {
                                 [shower removeFromSuperview];
                             }];
        }
    }];
}


+(void)showAlertWithTitle:(NSString *)title
                      msg:(NSString*)msg
                    inCtl:(UIViewController*)ctl {
    
    UIView *superView = ctl.view;
    if ([ctl.view viewWithTag:8080000]) {
        UIView *view =  [ctl.view viewWithTag:8080000];
        [view removeFromSuperview];
    }
    
    // 容器视图
    CGRect rect = CGRectMake(Scale(20.0),
                             superView.frame.size.height - Scale(30.0) - Scale(65),
                             superView.frame.size.width - Scale(40.0),
                             Scale(30.0));
    FFBMSAlertShower *shower = [[FFBMSAlertShower alloc] initWithFrame:rect];
    [shower setAlpha:1];
    [shower setTag:8080000];
    [superView addSubview:shower];
    
    // 标题
    
    
    // 提示信息
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:shower.bounds];
    [titleLabel setText:msg];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor colorWithHexString:@"#898CD3"]];
    [titleLabel setFont:[UIFont systemFontOfSize:Scale(12.0)]];
    titleLabel.layer.cornerRadius = 4.0;
    titleLabel.clipsToBounds = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [shower addSubview:titleLabel];
    
    
    
    // 点击按钮

    
   
}






+(void)showAlertWithTimer:(NSString*)title
                     msg:(NSString*)msg
                   inCtl:(UIViewController*)ctl
                   items:(NSArray<NSString*>*)items
              clickBlock:(void(^)(NSInteger))clickCallBack
{
    if(!items || items.count==0){
        return;
    }
    
    UIView *superView = nil;
    if (ctl.navigationController) {
        superView = ctl.navigationController.view;
        if ([ctl.navigationController.view viewWithTag:8080000]) {
            UIView *view =  [ctl.navigationController.view viewWithTag:8080000];
            [view removeFromSuperview];
            
        }
    }else{
        superView = ctl.view;
        if ([ctl.view viewWithTag:8080000]) {
            UIView *view =  [ctl.view viewWithTag:8080000];
            [view removeFromSuperview];
            
        }
    }
    
    FFBMSAlertShower* shower = [[FFBMSAlertShower alloc]init];
    shower.alertClickBack = clickCallBack;
    [shower setAlpha:1];
    [shower setTag:8080000];
    [shower initTimerAlertViewWithTitle:title msg:msg magAlignment:NSTextAlignmentLeft  inView:superView items:items];
}

- (void)initTimerAlertViewWithTitle:(NSString *)title
                               msg:(id)msg
                      magAlignment:(NSTextAlignment)textAlignment
                            inView:(UIView*)inView
                             items:(NSArray<NSString*>*)items
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.4];
    [self addSubview:bgView];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 0)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    
    if (title.length > 0) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, contentView.frame.size.width - 40, 40)];
        [titleLabel setText:title];
        [titleLabel setTextColor:HEX_RGB(0x333333)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [contentView addSubview:titleLabel];
    }
    UILabel *msgLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20,  40 ,20)];
    if ([msg isKindOfClass:[NSString class]]) {
        NSString* msgStr = (NSString*)msg;
        if (msgStr.length > 0) {
            
            CGRect msgRect = [msgStr boundingRectWithSize:CGSizeMake(contentView.frame.size.width - 40, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            
            msgLable = [[UILabel alloc]initWithFrame:CGRectMake(20, (title.length > 0 ? 50 : 30), contentView.frame.size.width - 40 ,ceil(msgRect.size.height) + 2)];
            [msgLable setText:msgStr];
            [msgLable setFont:[UIFont systemFontOfSize:14]];
            [msgLable setNumberOfLines:0];
            [msgLable setTextColor:HEX_RGB(0x666666)];
            [msgLable setTextAlignment:textAlignment];
            [msgLable setBackgroundColor:[UIColor clearColor]];
            [contentView addSubview:msgLable];
        }
    }
    else if( [msg isKindOfClass:[NSMutableAttributedString class]])
    {
        NSMutableAttributedString* msgStr =(NSMutableAttributedString*)msg;
        NSString *anotherString=[msgStr string];
        CGRect msgRect = [anotherString boundingRectWithSize:CGSizeMake(contentView.frame.size.width - 40, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        msgLable = [[UILabel alloc]initWithFrame:CGRectMake(20, (title.length > 0 ? 50 : 30), contentView.frame.size.width - 40 ,ceil(msgRect.size.height) + 2)];
        msgLable.attributedText = msgStr;
        [msgLable setFont:[UIFont systemFontOfSize:14]];
        [msgLable setNumberOfLines:0];
        [msgLable setTextAlignment:textAlignment];
        [msgLable setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:msgLable];
    }
    
    CGFloat btnY = CGRectGetMaxY(msgLable.frame);
    CGFloat btnW = CGRectGetWidth(contentView.frame)/items.count;
    
    for (int i = 0; i < items.count ; i ++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnW*i, btnY + 20, btnW, 40)];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = i ;
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [btn setTitleColor:HEX_RGB(0x898CD3) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        [contentView setFrame:CGRectMake(0, 0, contentView.frame.size.width , CGRectGetMaxY(btn.frame) + 0)];
        if ((items.count -1) == i) {
            [btn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        }
        
       UILabel * msgLable = [[UILabel alloc]init];
        msgLable.text = items[i] ;
        [msgLable setFont:[UIFont systemFontOfSize:14]];
        [msgLable setNumberOfLines:0];
        [msgLable setTextAlignment:NSTextAlignmentCenter];
        msgLable.textColor = HEX_RGB(0xBDBDBD);
        [msgLable setBackgroundColor:[UIColor clearColor]];
        [btn addSubview:msgLable];
        
        [msgLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(btn);
        }];
        
        NSArray *tempList = [msgLable.text componentsSeparatedByString:@"("];
        
        NSString *title = [tempList[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *lastStr = [tempList lastObject];
        NSString *result = [[lastStr componentsSeparatedByString:@"s"] firstObject];
        
        __block NSInteger num = result.integerValue;
        
        [msgLable setText:[NSString stringWithFormat:@"%@ (%lds)", VCNSLocalizedBundleString(title, nil), num]];
        
        [btn setUserInteractionEnabled:NO];
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            --num;
            
            if (num  <= 0) {
                [timer invalidate];
                timer = nil;
                [btn setUserInteractionEnabled:YES];
                [msgLable setText:VCNSLocalizedBundleString(title, nil)];
                msgLable.textColor = HEX_RGB(0x898CD3);

            }else{
                [msgLable setText:[NSString stringWithFormat:@"%@ (%lds)", VCNSLocalizedBundleString(title, nil), num]];
            }
        }];
        
        FFBMSVerticalSingleLineView *verticalLineVeiw = [[FFBMSVerticalSingleLineView alloc]initWithFrame:CGRectMake(btnW*i, btnY + 20, 1, 40)];
        [contentView addSubview:verticalLineVeiw];
    }
    
    FFBMSTopSinglePixelLineView *bottomLine = [[FFBMSTopSinglePixelLineView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame) - 40, contentView.frame.size.width, 1)];
    [contentView addSubview:bottomLine];
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [contentView setFrame:CGRectMake(0, 0, contentView.frame.size.width , CGRectGetMaxY(contentView.frame) + 0)];
    [contentView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 10)];
    [inView addSubview:self];
    [self setAlpha:0.0f];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.0f];
    }];
    
    [contentView.layer setCornerRadius:4];
    [contentView setClipsToBounds:YES];
}

- (FFBMSTextView *)inputView{
    if (!_inputView) {
        FFBMSTextView *inputView = [[FFBMSTextView alloc] initWithFrame:CGRectMake(15, 5, 200, 35)];
        inputView.placeHolderYOffset = -1;
        inputView.delegate = self;
        inputView.backgroundColor = [UIColor clearColor];
        inputView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        inputView.secureTextEntry = !self.nonSecureInput;
        inputView.textAlignment = NSTextAlignmentCenter;
        inputView.textColor = HEX_RGB(0x202C56);
        _inputView = inputView;
    }
    return _inputView;
}

//要实现的Delegate方法,键盘next下跳
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.inputView]) {
        [self.inputView resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.inputView]) {
        [self.inputView resignFirstResponder];
    }
    return YES;
}

- (void)beginTextView:(NSNotification *)notificaton
{
    UITextView *textView = notificaton.object;
    if (![textView isEqual:self.inputView]) {
        return;
    }
    if (textView.text.length != 0) {
        _originalText = [[NSMutableString alloc]initWithString:textView.text];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![textView isEqual:self.inputView]) {
        return NO;
    }
    if (!self.nonSecureInput) {
        if (_originalText.length == 0) {
            if (textView.text.length == 0) {
                _originalText = [[NSMutableString alloc]initWithString:text];
                
            }else{
                _originalText = [[NSMutableString alloc]initWithString:textView.text];
            }
        }else{
            [_originalText insertString:text atIndex:range.location];
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (![textView isEqual:self.inputView]) {
        return ;
    }
    NSString *enteredText = textView.text;
    textView.text = (!self.nonSecureInput) ? [enteredText stringByReplacingOccurrencesOfString:enteredText withString:[self getSecuredTextFor:enteredText]] : enteredText;
}

-(NSString *)getSecuredTextFor:(NSString *)stringToConvert {
    NSString *securedString = @"";
    for (int i = 0; i < stringToConvert.length; i++) {
        securedString = [securedString stringByAppendingString:@"*"];
    }
    return securedString;
}

- (void)touchBGView
{
    if (self.inputView) {
         [self.inputView resignFirstResponder];
    }
}

- (void)changeTextView:(NSNotification *)notificationInfo
{
    UITextView *textView = notificationInfo.object;
    if(![textView isEqual: self.inputView]){
        return;
    }
    [textView setNeedsDisplay];
}
@end
