//
//  MyViewController.m
//  Wodu
//
//  Created by tenny on 15/12/27.
//  Copyright © 2015年 tenny. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage alloc] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 3, 200, 200)];
    view.backgroundColor = [UIColor redColor];
    NSLog(@"%f",self.view.frame.size.height);
    self.navigationController.navigationBar.translucent = true;
    NSLog(@"%f",self.view.frame.size.height);
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    tableView.backgroundColor = [UIColor yellowColor];
//    self.automaticallyAdjustsScrollViewInsets = false;
//    [self.view addSubview:tableView];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    [self.view addSubview:view];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage alloc] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

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
