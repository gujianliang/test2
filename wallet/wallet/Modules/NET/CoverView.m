//
//  CoverView.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "CoverView.h"


@implementation CoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = UIColor.clearColor;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [bgView setAlpha:0.4];
    bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFromSuperview)];
    [bgView addGestureRecognizer:tap];
    [tap setNumberOfTapsRequired:1];
    
    
    UIView *coverView = [[UIView alloc]init];
    coverView.frame = CGRectMake(self.frame.size.width - 200, 80, 180, 150);
    coverView.backgroundColor = UIColor.whiteColor;
    [self addSubview:coverView];
    
    UIButton *btnProduct = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 180, 50)];
    [btnProduct setTitle:@"生产节点" forState:UIControlStateNormal];
    [btnProduct addTarget:self action:@selector(selectNode:) forControlEvents:UIControlEventTouchUpInside];
    btnProduct.tag = 10;
    [coverView addSubview:btnProduct];
    [btnProduct setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *btnTest = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, 180, 50)];
    [btnTest setTitle:@"测试节点" forState:UIControlStateNormal];
    btnTest.tag = 20;
    [btnTest addTarget:self action:@selector(selectNode:) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:btnTest];
    [btnTest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    UIButton *btnCustom = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 180, 50)];
    [btnCustom setTitle:@"添加自定义节点" forState:UIControlStateNormal];
    btnCustom.tag = 30;
    [btnCustom addTarget:self action:@selector(selectNode:) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:btnCustom];
    [btnCustom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}

- (void)selectNode:(UIButton *)sender
{
    NetType netType = TestServer;
    if (sender.tag == 10) {
        netType = ProductServer;
        
       
        
    }else if (sender.tag == 20)
    {
        netType = TestServer;
    }else if (sender.tag == 30)
    {
        netType = CustomServer;
    }
    if (_block) {
        _block(netType);
    }
    [self removeFromSuperview];
}

@end
