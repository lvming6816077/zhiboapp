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

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

@end
