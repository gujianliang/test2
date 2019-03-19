//
//  WalletDAppSignPreVC.m
//  VeWallet
//
//  Created by HuChao on 2019/1/22.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppSignPreVC.h"
#import "WalletGradientLayerButton.h"

@interface WalletDAppSignPreVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArr;  // 解析后的数据源
@property (strong, nonatomic) UIView *headV;
@property (strong, nonatomic) UITableView *table;

@end

@implementation WalletDAppSignPreVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateData];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)updateData{
    
    [self.dataArr removeAllObjects];
    
    if (_dictParam) { // 展示新值
        NSString *json = [_dictParam yy_modelToJSONString];
        if (json.length > 0) {
            [self.dataArr addObject:json];
        }
    }
    
    [self.table reloadData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = VCNSLocalizedBundleString(@"h5_contract_params_confirm_title", nil);
//    [self updateNavigationBarStyle:TintAndTitleNoneCloseWhiteOne];
    
    // 添加子视图
    [self addSubView];
    [self addBackButtonWithBGImageName:@"icon_close_black"];
}

- (void)addBackButtonWithBGImageName:(NSString*)imageName
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imageName.length > 0) {
        [backBtn setImage:[WalletTools localImageWithName:imageName] forState:UIControlStateNormal];
        [backBtn setImage:[WalletTools localImageWithName:imageName] forState:UIControlStateDisabled];
        
    }
    backBtn.frame = CGRectMake(0, 0, 50, 50);
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backBtnClick
{
    [self dismissViewControllerAnimated:true completion:nil];

}

- (void)addSubView{
    
    // 头部容器视图
    UIView *headV = [[UIView alloc] init];
    headV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headV];
    _headV = headV;
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationBarHeight);
        make.height.mas_equalTo(Scale(100.0));
    }];
    
    
    // 备注标签信息
    UILabel *lab = [[UILabel alloc] init];
    lab.text = VCNSLocalizedBundleString(@"h5_contract_params_confirm_msg", nil);
    lab.textColor = HEX_COLOR(0xEF6F6F);
    lab.font = [UIFont systemFontOfSize:Scale(14.0)];
    lab.numberOfLines = 0;
    lab.adjustsFontSizeToFitWidth = YES;
    [_headV addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20));
        make.right.mas_equalTo(-Scale(20));
        make.top.bottom.mas_equalTo(0);
    }];
    
    
    // 添加继续按钮
    WalletGradientLayerButton *confirmBtn = [[WalletGradientLayerButton alloc] init];
    [confirmBtn.layer setCornerRadius:4];
    [confirmBtn setClipsToBounds:YES];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:Scale(15.0)];
    [confirmBtn setGrayGradientLayerType:highBlueType];
    [confirmBtn setTitle:VCNSLocalizedBundleString(@"h5_contract_params_confirm_button", nil) forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(continueSign) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20.0));
        make.right.mas_equalTo(-Scale(20.0));
        make.height.mas_equalTo(Scale(44.0));
        make.bottom.mas_equalTo(-Scale(30.0) + -KBottomHeight);
    }];
    
    
    // 表视图
    UITableView *table = [[UITableView alloc] init];
    table.delegate = self;
    table.dataSource = self;
    table.allowsSelection = NO;
    table.tableFooterView = [UIView new];
    table.backgroundColor = [UIColor whiteColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    _table = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_headV.mas_bottom);
        make.bottom.mas_equalTo(confirmBtn.mas_top).offset(-Scale(30));
    }];
}

- (void)continueSign{
    NSLog(@"click 已知晓风险，继续签名");
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_block) {
            _block();
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndef = @"dataCellIndef";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndef];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIndef];
        cell.textLabel.textColor = HEX_COLOR(0x202C56);
        cell.textLabel.font = [UIFont systemFontOfSize:Scale(14.0)];
        
        UITextView *textF = [[UITextView alloc] init];
        textF.textColor = HEX_COLOR(0x202C56);
        textF.font = [UIFont systemFontOfSize:Scale(14.0)];
        textF.editable = NO;
        textF.selectable = NO;
        textF.tag = 100000;
        textF.backgroundColor = [UIColor colorWithHexString:@"#FDFDFD"];
        textF.layer.cornerRadius = 5.0;
        textF.layer.borderWidth = 1.0;
        textF.layer.borderColor = [[UIColor colorWithHexString:@"#BDDAF7"] CGColor];
        [cell addSubview:textF];
        [textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Scale(20));
            make.right.mas_equalTo(-Scale(20));
            make.top.mas_equalTo(Scale(5));
            make.bottom.mas_equalTo(0);
        }];
    }
    
    UITextView *textF = (UITextView *)[cell viewWithTag:100000];
    textF.text = [NSString stringWithFormat:@"%@", self.dataArr[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.table.bounds.size.height;
}

@end
