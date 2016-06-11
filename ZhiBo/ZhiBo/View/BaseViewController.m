//
//  BaseViewController.m
//  Wodu
//
//  Created by tenny on 15/12/24.
//  Copyright © 2015年 tenny. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"


@interface BaseViewController ()
@property(nonatomic,strong) MBProgressHUD *hud;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationController.navigationBar.translucent = true;
    // set background color
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // set navigation bar color
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar64"] forBarMetrics:UIBarMetricsDefault];
    
    // set title color
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dic];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];// not work?
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    self.navigationController.navigationBar.translucent = true;
//    self.navigationController.navigationItem setl
//    [btnRight setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f], NSFontAttributeName,nil] forState:UIControlStateNormal];
}

-(void) showLoading {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"发表中...";
//    self.hud.dimBackground = YES;
//    self.hud.detailsLabelText = @"Test detail";
}
-(void) hideLoading {
    [self.hud hide:YES];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
