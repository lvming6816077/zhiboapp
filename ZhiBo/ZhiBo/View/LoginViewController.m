//
//  LoginViewController.m
//  ZhiBo
//
//  Created by lvming on 16/6/4.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "LoginViewController.h"
#import "Defines.h"

@interface LoginViewController ()
@property (retain, nonatomic) TencentOAuth *tencentOAuth;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    [self bindEvents];
    
    
}
-(void) setUpNavBar{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage alloc] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //set right btn
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeLogin:)];
    btnRight.tintColor = UIColorFromRGB(0x333333);
    [btnRight setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f], NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = btnRight;
}
-(void) closeLogin:(UIButton *)btn {
    [[[UIApplication sharedApplication] keyWindow] endEditing:true];
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}
-(void) bindEvents {
    
//    self.qqLoginImageView.userInteractionEnabled = YES;
    [self.qqLoginImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qqLogin)]];
}
-(void)qqLogin {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105377239" andDelegate:self];
    NSArray *permissions =  @[@"get_user_info", @"get_simple_userinfo", @"add_t"];
    [self.tencentOAuth authorize:permissions inSafari:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TencentLoginDelegate

- (void)tencentDidLogin
{
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

- (void)tencentDidNotNetWork
{
    
}

#pragma mark - TencentSessionDelegate

- (void)tencentDidLogout
{
    
}

- (void)responseDidReceived:(APIResponse*)response forMessage:(NSString *)message
{
    
}



@end
