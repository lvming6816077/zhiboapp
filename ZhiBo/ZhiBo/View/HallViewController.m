//
//  HallViewController.m
//  ZhiBo
//
//  Created by tenny on 16/2/17.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "HallViewController.h"
#import "HallTableView.h"
#import "Defines.h"
@interface HallViewController ()

@end

@implementation HallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"大厅";
    [self initTableView];
    // Do any additional setup after loading the view.
}
-(void) initTableView{
    
    HallTableView *table = [[HallTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-HomeTabViewHeight)];
    [self.view addSubview:table];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
