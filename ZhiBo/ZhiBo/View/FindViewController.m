//
//  FindViewController.m
//  ZhiBo
//
//  Created by tenny on 16/2/17.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "FindViewController.h"
#import "Defines.h"
#import "UIKit+AFNetworking.h"
@interface FindViewController ()

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    
    [self initTopView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initTopView{
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 20, 60, 20)];
    categoryLabel.text = @"热门标签";
    [categoryLabel setFont:[UIFont systemFontOfSize:15.0]];
    [categoryLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.view addSubview:categoryLabel];
    
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-70, 23, 70, 20)];
    moreLabel.text = @"查看更多>>";
    [moreLabel setFont:[UIFont systemFontOfSize:12.0]];
    [moreLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.view addSubview:moreLabel];
    
    
    NSArray *result = [[NSArray alloc] initWithObjects:
    @{@"imageUrl":@"http://p.qpic.cn/qqconadmin/0/40e95ff9007e46198c3a1b7b0bf340a1/0",@"text":@"旅行"},
    @{@"imageUrl":@"http://p.qlogo.cn/gbar_heads/Q3auHgzwzM5ZkIv23UzTuDibBLO2BkIzNwHanQicpmTI31fcl9W85Jqw/",@"text":@"拍景"},
    @{@"imageUrl":@"http://p.qpic.cn/qqconadmin/0/4cfa3abc98a14d1083d28cd59734960a/0",@"text":@"超级女声"},
    @{@"imageUrl":@"http://p.qpic.cn/qqconadmin/0/a7d24efdfd11423180d444b8a12c8430/0",@"text":@"小说"},
    @{@"imageUrl":@"http://p.qlogo.cn/gbar_heads/Q3auHgzwzM4hQCQSI2FQ12Uqzf4gZgQDJp6yCAzSjXNQFNfdDnHRLw/",@"text":@"头条新闻"},
    @{@"imageUrl":@"http://p.qpic.cn/qqconadmin/0/4d0435950c8a41cfbeac33e73d2bc94f/0",@"text":@"火影忍者"},
    @{@"imageUrl":@"http://p.qpic.cn/qqconadmin/0/e6716c203a70455ab0953f3f0652872c/0",@"text":@"美食"},
    nil];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 52, ScreenWidth, 100)];
    scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat imageWidth = 70;
    
    for (int i = 0 ; i < result.count ; i++) {
        CGFloat x = i*imageWidth+(i*13);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, imageWidth, imageWidth)];
        UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, imageWidth+5, 70, 20)];
        
        
        [imageView setImageWithURL:[NSURL URLWithString:result[i][@"imageUrl"]]];
        [imageView.layer setCornerRadius:5.0f];
        imageView.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        imageView.layer.borderWidth = .5;
        imageView.clipsToBounds = YES;
        
        imageLabel.text = result[i][@"text"];
        [imageLabel setFont:[UIFont systemFontOfSize:13.0]];
        [imageLabel setTextColor:UIColorFromRGB(0x333333)];
        [imageLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        [scrollView addSubview:imageView];
        [scrollView addSubview:imageLabel];
        
        
    }
    [scrollView setContentSize:CGSizeMake(7*imageWidth+7*10, 0)];
    
    
    [self.view addSubview:scrollView];
}


@end
