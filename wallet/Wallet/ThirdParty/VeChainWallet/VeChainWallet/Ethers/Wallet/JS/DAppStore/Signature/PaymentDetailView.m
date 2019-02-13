//
//  PaymentDetailView.m
//  VeWallet
//
//  Created by VeChain on 2018/4/26.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "PaymentDetailView.h"
#import "WalletGradientLayerButton.h"
@interface PaymentDetailView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *orderInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *toAddressTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLabel;
@property (weak, nonatomic) IBOutlet WalletGradientLayerButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *titleTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinTypeTitleLabel;

@end

@implementation PaymentDetailView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.view];
        [self setupUI];
    }
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.view];
        [self setupUI];
    }
    return self;
}

#pragma mark - 按钮点击回调
- (IBAction)enterButtonClick:(UIButton *)sender {
    if (self.didClickEnterButton) {
        self.didClickEnterButton();
    }
}
- (IBAction)closeButtonClick:(UIButton *)sender {
    if (self.didClickCloseButton) {
        self.didClickCloseButton();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.view.frame = self.bounds;
}

- (void)setupUI{
    self.layer.cornerRadius = 5;
    self.view.layer.cornerRadius = 5;
    
    self.confirmButton.layer.cornerRadius = 5;
    self.confirmButton.clipsToBounds = YES;
    
    self.titleTopLabel.text = VCNSLocalizedBundleString(@"dialog_coin_transfer_description", nil);
    self.infoLabel.text = VCNSLocalizedBundleString(@"transfer_coin_title", nil);
    self.orderInfoTitleLabel.text = VCNSLocalizedBundleString(@"订单类型", nil);
    self.toAddressTitleLabel.text = VCNSLocalizedBundleString(@"收款地址", nil);
    self.fromAddressTitleLabel.text = VCNSLocalizedBundleString(@"dialog_coin_transfer_pay_from", nil);
    self.feeTitleLabel.text = VCNSLocalizedBundleString(@"交易费用", nil);
    self.amountTitleLabel.text = VCNSLocalizedBundleString(@"cold_transfer_amount", nil);
    self.coinTypeTitleLabel.text = VCNSLocalizedBundleString(@"dialog_coin_transfer_token_type", nil);
    [self.confirmButton setTitle:VCNSLocalizedBundleString(@"dialog_yes", nil) forState:UIControlStateNormal];
    [self.confirmButton setDisableGradientLayer:YES];
}

@end
