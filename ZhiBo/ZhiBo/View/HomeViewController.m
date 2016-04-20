//
//  HomeViewController.m
//  Wodu
//
//  Created by tenny on 15/12/24.
//  Copyright © 2015年 tenny. All rights reserved.
//

#import "HomeViewController.h"
#import "HallViewController.h"
#import "FindViewController.h"
#import "PublishViewController.h"
#import "MessageViewController.h"
#import "MyViewController.h"
#import "HomeTarBarView.h"
#import "Defines.h"
#import "BaseNavigationViewController.h"
static NSString const *PUBLISH = @"PublishViewController";
@interface HomeViewController ()<HomeTabBarDelegate>
@property(nonatomic,strong)HomeTarBarView *tabView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTabBar];
    

}
-(UINavigationController*)rootCurrentNavigation{

    return [[self viewControllers] objectAtIndex:self.selectedIndex];

}
-(void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self.tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];
    self.tabView = [[HomeTarBarView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.tabBar.frame.size.height)];
    self.tabBar.layer.borderWidth = 0;

    self.tabView.myDelegate = self;
    
    for (UIView *v in self.tabBar.subviews) {
        [v removeFromSuperview];
    }

    [self.tabBar addSubview:self.tabView];

}
- (void) initTabBar {

    
    

    // get tabbar config from file
    NSString *configFile = [[NSBundle mainBundle] pathForResource:@"TabBarItem" ofType:@"plist"];
    NSArray *pageConfigs = [NSArray arrayWithContentsOfFile:configFile];
    
    // nav array
    NSMutableArray *navs = [[NSMutableArray alloc] initWithCapacity:pageConfigs.count];
    

    // add tab viewcontroller
    for (int i = 0; i < pageConfigs.count; i++) {
        NSDictionary *dic = pageConfigs[i];
        
        // if the controller is show
        if (![PUBLISH isEqualToString:dic[@"ID"]]) {
            UIViewController *vc = [[NSClassFromString(dic[	@"ID"]) alloc] init];
            
//            if ([PUBLISH isEqualToString:dic[@"ID"]]) {
//                UIImage *img = [UIImage imageNamed:dic[@"Image"]];
//                img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//                vc.tabBarItem.badgeValue = @"";
////                vc.tabBarItem.imageInsets = UIEdgeInsetsMake(-6, 0, 6, 0); // todo
//                
//            } else {
//                vc.tabBarItem.title = dic[@"Title"];
//                
//                [vc.tabBarItem setTitleTextAttributes:titleColor forState:UIControlStateNormal];
//                [vc.tabBarItem setTitleTextAttributes:titleSelectColor forState:UIControlStateSelected];
//                UIImage *img1 = [UIImage imageNamed:dic[@"Image"]];
//                img1 = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                vc.tabBarItem.image = img1;
//                UIImage *img = [UIImage imageNamed:dic[@"SelectImage"]];
//                img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                vc.tabBarItem.selectedImage = img;
////                vc.tabBarItem.
//                vc.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0); // todo
//                vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
//                vc.tabBarItem.badgeValue = @"";
//            }
            
//            vc.tabBarItem = nil;
            
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            
            
            [navs addObject:nav];
        }
        
    }
    
    self.viewControllers = navs;

}
-(void) didSelect:(NSInteger)pageIndex {

    self.selectedIndex = pageIndex;
}

-(void) publishClick {
    PublishViewController *pub = [[PublishViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pub];
    [self presentViewController:navController animated:YES completion:NULL];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
