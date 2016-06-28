//
//  LoginViewController.m
//  ZhiBo
//
//  Created by lvming on 16/6/4.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "LoginViewController.h"
#import "Defines.h"
//#import "AFNetworking.h"
#import "HttpUtil.h"
#import "Tips.h"

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
    
    [self.tencentOAuth getUserInfo];
    
    if ([self.tencentOAuth accessToken] && [self.tencentOAuth accessToken]) {
        //获取userDefault单例
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        
        
        //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
        
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        
//        NSString *destDateString = [dateFormatter stringFromDate:[self.tencentOAuth expirationDate]];

        //登陆成功后把用户名和密码存储到UserDefault
        [userDefaults setObject:[self.tencentOAuth accessToken] forKey:@"access_token"];
        [userDefaults setObject:[self.tencentOAuth accessToken] forKey:@"open_id"];
        [userDefaults setObject:[self.tencentOAuth expirationDate] forKey:@"expiration_date"];
        [userDefaults synchronize];
    }
    
}


//可以通过response获取数据的返回结果
- (void)getUserInfoResponse:(APIResponse*) response {
    
    if (URLREQUEST_SUCCEED == response.retCode
        && kOpenSDKErrorSuccess == response.detailRetCode) {
        NSDictionary *resp = response.jsonResponse;
        
        NSDictionary *dic = @{@"nickname":resp[@"nickname"],
                              @"gender":resp[@"gender"],
                              @"city":resp[@"city"],
                              @"pic":resp[@"figureurl_qq_1"],
                              @"from":@"qq"};
        
        [self doThirdSignUp:dic];
        
    }
    
}
// 用户第一次使用第三方登录时 注册用户信息
- (void)doThirdSignUp:(NSDictionary*) dic {
    
    
    [[HttpUtil shareInstance] post:[NSString stringWithFormat:@"%@/user/createUser",BaseCgiUrl] parameters:dic formBody:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *resp = (NSMutableDictionary*)responseObject;
        if ([[resp objectForKey:@"status"] isEqualToString: @"success"]) {
            [Tips showTips:self.view text:@"登录成功"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:resp[@"content"] forKey:@"user_info"];
            [userDefaults synchronize];
            
            [self closeLogin:nil];
        } else {
            [Tips showTips:self.view text:@"登录失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tips showTips:self.view text:@"登录失败"];
    }];
    
    
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




@end
