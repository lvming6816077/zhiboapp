//
//  PersonPageViewController.h
//  ZhiBo
//
//  Created by tenny on 16/3/25.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonPageData.h"
@interface PersonPageViewController : UIViewController
@property(nonatomic,strong) UIView *navOverView;
@property(nonatomic,strong) PersonPageData *data;
@property(nonatomic,strong) UIImageView *navigationBarImageView;
-(void) alphaNavigationBar:(CGFloat)offsetY;
@end
