//
//  LoginUtil.h
//  ZhiBo
//
//  Created by lvming on 16/6/11.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"

@interface LoginUtil : NSObject
+(BOOL) isLogin;
+(void) openLoginVC:(UIViewController*)currentVC;
+(NSString*) getCurrentUserId;
@end
