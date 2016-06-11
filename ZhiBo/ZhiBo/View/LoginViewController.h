//
//  LoginViewController.h
//  ZhiBo
//
//  Created by lvming on 16/6/4.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "BaseViewController.h"

@interface LoginViewController : UIViewController<TencentSessionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *qqLoginImageView;
@end
