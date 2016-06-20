//
//  LoginUtil.m
//  ZhiBo
//
//  Created by lvming on 16/6/11.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "LoginUtil.h"


@implementation LoginUtil
/*
 * 判断是非登录
 */
+(BOOL) isLogin {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *exDate = [userDefaults objectForKey:@"expiration_date"];
    
    if (!exDate) {
        return NO;
    }
    
    NSDate *earlierDate = [exDate earlierDate:[NSDate date]];
    BOOL flag = earlierDate == exDate;
    
    NSDictionary *dic = [userDefaults objectForKey:@"user_info"];
    
    return !flag && [dic objectForKey:@"id"];
}
/*
 * 打开登录页面
 */

+(void) openLoginVC:(UIViewController*) currentVC {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [currentVC presentViewController:navController animated:YES completion:NULL];
}

/*
 * 获取用户id
 */

+(NSString*) getCurrentUserId {
    
    if (![self isLogin]) {
        return nil;
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [userDefaults objectForKey:@"user_info"];
        NSString *uid = [dic objectForKey:@"id"];
        return uid;
    }
}
@end
