//
//  WalletDappStoreSelectView.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/20.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDappStoreSelectView.h"
#import "WalletExchangeWalletCell.h"
#import "UIButton+block.h"
#import "WalletSingletonHandle.h"

#define viewHeight 411

@implementation WalletDappStoreSelectView
{

}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = frame;
    }];
    [self initView];
    return self;
}

- (void)initView
{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UIView *middleView = [[UIView alloc]init];
    middleView.backgroundColor = UIColor.whiteColor;
    [self addSubview:middleView];
    [middleView setClipsToBounds:YES];
    [middleView.layer setCornerRadius:4];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(viewHeight);
    }];
    
    UIView *titleView = [[UIView alloc]init];
    [middleView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    // 主标题标签
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = VCNSLocalizedBundleString(@"选择钱包", nil);
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    // 返回箭头按钮
    UIButton *backBtn = [[UIButton alloc]init];
    UIImage *iamge = [WalletTools localImageWithName:@"icon_close_black"];
    
    [backBtn setImage:iamge forState:UIControlStateNormal];
    [titleView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    @weakify(self);
    backBtn.block = ^(UIButton *btn) {
        @strongify(self);
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    };
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [middleView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(middleView);
        make.top.mas_equalTo(50);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *walletList = [[WalletSingletonHandle shareWalletHandle] getAllWallet];
    return walletList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletExchangeWalletCell *cell = [[WalletExchangeWalletCell alloc] init];
    NSArray *walletList =[[WalletSingletonHandle shareWalletHandle] getAllWallet];
    [cell setModel:walletList[indexPath.row] amount:_amount toAddress:_toAddress];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *walletList = [[WalletSingletonHandle shareWalletHandle] getAllWallet];
    WalletManageModel *model = walletList[indexPath.row];
    
    [[WalletSingletonHandle shareWalletHandle] setCurrentModel:model.address];
    
    if ([model.address.lowercaseString isEqualToString:_toAddress.lowercaseString]) {
        return;
    }else if(model.VETCount.doubleValue > _amount.doubleValue)
    {
        if (_block) {
            _block(model.address,self);
        }
    }
}

@end
