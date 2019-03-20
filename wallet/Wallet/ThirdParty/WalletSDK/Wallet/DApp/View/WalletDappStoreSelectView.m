//
//  WalletDappStoreSelectView.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/20.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDappStoreSelectView.h"
#import "WalletDappStoreSelectCell.h"
#import "UIButton+block.h"
#import "WalletSingletonHandle.h"
#import "WalletVETBalanceApi.h"
#import "Payment.h"

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
    titleLabel.text = VCNSLocalizedBundleString(@"h5_select_wallet_title", nil);
    
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
        if (_cancelBlock) {
            _cancelBlock();
        }
    };
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [middleView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(middleView);
        make.top.mas_equalTo(50);
    }];
    
    [WalletTools checkNetwork:^(BOOL t) {
        if (t) {
            NSArray *walletList = [[WalletSingletonHandle shareWalletHandle] getAllWallet];
            
            __block NSInteger i = 0;
            for (WalletManageModel *model in walletList) {
                
                WalletVETBalanceApi *vetBalanceApi = [[WalletVETBalanceApi alloc]initWith:model.address];
                [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
                    WalletBalanceModel *balanceModel = finishApi.resultModel;
                    
                    model.VETCount = balanceModel.balance;
                    i ++;
                    if (i == walletList.count) {
                        [tableView reloadData];
                    }
                    
                } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
                    i ++;
                    if (i == walletList.count) {
                        [tableView reloadData];
                    }
                }];
            }
        }
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
    WalletDappStoreSelectCell *cell = [[WalletDappStoreSelectCell alloc] init];
    cell.bSpecialContract = self.bSpecialContract;
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
    
    BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:model.VETCount];
    NSString *coinAmount = @"0.00";
    if (!bigNumberCount.isZero) {
        coinAmount = [Payment formatToken:bigNumberCount
                                 decimals:18
                                  options:2];
    }
    
    NSString *walletAmount = [coinAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    [[WalletSingletonHandle shareWalletHandle] setCurrentModel:model.address];
    
    if ([model.address.lowercaseString isEqualToString:_toAddress.lowercaseString]) {
        return;
    }else if(walletAmount.doubleValue >= _amount.doubleValue)
    {
        if (_block) {
            _block(model.address,self);
        }
    }
}

@end
