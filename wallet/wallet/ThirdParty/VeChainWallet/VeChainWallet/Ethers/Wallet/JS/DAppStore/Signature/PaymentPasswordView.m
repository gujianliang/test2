//
//  PaymentPasswordView.m
//  VeWallet
//
//  Created by VeChain on 2018/4/26.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "PaymentPasswordView.h"
#import "WalletGradientLayerButton.h"
@interface PaymentPasswordView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *titleTopLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet WalletGradientLayerButton *confirmButton;

@end

@implementation PaymentPasswordView

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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.view.frame = self.bounds;
}
- (IBAction)closeButtonClick:(id)sender {
    if (self.didClickCloseButton) {
        self.didClickCloseButton();
    }
}
- (IBAction)enterButtonClick:(id)sender {
    if (self.didClickEnterButton) {
        self.didClickEnterButton();
    }
}

- (void)setupUI{
    self.layer.cornerRadius = 5;
    self.view.layer.cornerRadius = 5;
    
    self.confirmButton.layer.cornerRadius = 5;
    self.confirmButton.clipsToBounds = YES;
    
    self.titleTopLabel.text = NSLocalizedString(@"dialog_coin_transfer_password", nil);
    self.pwdTextField.placeholder = NSLocalizedString(@"wallet_detail_modify_password_dialog_title", nil);
//    self.passwordTextField.disablePaste = YES;
//    self.passwordTextField.disableSelectAll = YES;
//    self.passwordTextField.disableSelect = YES;
    [self.confirmButton setTitle:NSLocalizedString(@"dialog_yes", nil) forState:UIControlStateNormal];
    [self.confirmButton setDisableGradientLayer:YES];    
}
@end
