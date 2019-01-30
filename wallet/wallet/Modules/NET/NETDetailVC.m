//
//  NETDetailVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "NETDetailVC.h"

@interface NETDetailVC ()
{
    NetType _netType;
}
@property (weak, nonatomic) IBOutlet UILabel *netName;
@property (weak, nonatomic) IBOutlet UILabel *netUrl;

@end

@implementation NETDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(_netType == ProductServer) {
        self.title = @"正式网络";
        self.netName.text = @"正式网络";
        self.netUrl.text = @"https://vethor-node.vechain.com";
    }else if (_netType == TestServer)
    {
        self.title = @"测试网络";
        self.netName.text = @"测试网络";
        self.netUrl.text = @"https://vethor-node-test.vechaindev.com";
    }else if (_netType == CustomServer)
    {
        
    }
}

- (void)netType:(NetType)netType
{
    _netType = netType;
    
//    self.netName.text.length
    
//    NSArray *netList = [NSMutableArray];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
