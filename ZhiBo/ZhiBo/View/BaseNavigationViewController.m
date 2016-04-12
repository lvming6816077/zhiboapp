//
//  BaseNavigationViewController.m
//  ZhiBo
//
//  Created by tenny on 16/3/10.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "HomeTarBarView.h"
@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    viewController.hidesBottomBarWhenPushed = true;
    [super pushViewController:viewController animated:animated];
    

}

@end
