//
//  MessageViewController.m
//  ZhiBo
//
//  Created by tenny on 16/2/17.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableView.h"
#import "Defines.h"
@interface MessageViewController ()
@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *currentor;
@end

@implementation MessageViewController
{
    NSInteger _currentTab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    _currentTab = 1;
    [self initTitleView];
    [self initBottomView];
}

-(void) initTitleView{
    CGFloat titleViewHeight = 40;
    CGFloat currentorWidth = 70;
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, titleViewHeight)];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, titleViewHeight)];
    myLabel.text = @"我的通知";
    myLabel.textColor = UIColorFromRGB(0x7d7d7d);
    [myLabel setFont:[UIFont systemFontOfSize:14.0f]];
    myLabel.textAlignment = NSTextAlignmentCenter;
    [myLabel setTag:100 + 1];
    myLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTab:)];
    [myLabel addGestureRecognizer:tap1];
    
    
    
    
    UILabel *sysLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, titleViewHeight)];
    sysLabel.text = @"系统消息";
    [sysLabel setFont:[UIFont systemFontOfSize:14.0f]];
    sysLabel.textAlignment = NSTextAlignmentCenter;
    sysLabel.textColor = UIColorFromRGB(0x7d7d7d);
    [sysLabel setTag:100 + 2];
    sysLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTab:)];
    [sysLabel addGestureRecognizer:tap2];
    
    
    
    UIView *bottomBorder = [UIView new];
    bottomBorder.frame = CGRectMake(0, titleViewHeight-0.5, ScreenWidth, .5);
    bottomBorder.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.titleView addSubview:bottomBorder];
    
    self.currentor = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/4-currentorWidth/2, titleViewHeight-2, currentorWidth, 2)];
    self.currentor.backgroundColor = UIColorFromRGB(0x00CCE8);;
    [self.titleView addSubview:self.currentor];
    
    
    [self.titleView addSubview:myLabel];
    [self.titleView addSubview:sysLabel];
    
   
    [self.view addSubview:self.titleView];
    

}

-(void) initBottomView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, self.view.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*2, 0);
    self.scrollView.pagingEnabled = true;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    MessageTableView *tableView1 = [[MessageTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height)];
    
    MessageTableView *tableView2 = [[MessageTableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, self.view.frame.size.height)];
    
    [self.scrollView addSubview:tableView1];
    [self.scrollView addSubview:tableView2];
    
    [self.view addSubview:self.scrollView];
    
}

-(void) changeTab:(UITapGestureRecognizer*) recongizer {
    if (recongizer.view.tag == 101) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
    } else {
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:true];
    }
}

-(void) changeItem {

    if (self.scrollView.contentOffset.x == ScreenWidth && _currentTab == 1) {
        _currentTab = 2;
        [UIView animateWithDuration:.15 animations:^{
            CGRect frame = self.currentor.frame;
            frame.origin.x = frame.origin.x+ScreenWidth/2;
            self.currentor.frame = frame;
        } completion:^(BOOL finished) {
            //            [self.myDelegate didSelect:label.tag];
        }];
    }
    
    if(self.scrollView.contentOffset.x == 0 && _currentTab == 2){
        _currentTab = 1;
        [UIView animateWithDuration:.15 animations:^{
            CGRect frame = self.currentor.frame;
            frame.origin.x = frame.origin.x-ScreenWidth/2;
            self.currentor.frame = frame;
        } completion:^(BOOL finished) {
            //            [self.myDelegate didSelect:label.tag];
        }];
    }
}

#pragma mark - UIScrollViewDelegate
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self changeItem];
    
    
}
-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self changeItem];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
