//
//  PersonPageViewController.m
//  ZhiBo
//
//  Created by tenny on 16/3/25.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "PersonPageViewController.h"
#import "PersonTableView.h"
#import "Defines.h"
#import "UIKit+AFNetworking.h"
#import "UIImage+ImageUtil.h"

#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)

#define scrollAlphaHeight 280.0f-NavigationBarHeight
#define WeakSelf   __typeof(&*self) __weak   weakSelf   = self;
@interface PersonPageViewController ()
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIView *maskView;
@end

@implementation PersonPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = self.data.nickname;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage alloc] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    PersonTableView *tableView = [[PersonTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withData:self.data];
    [self.view addSubview:tableView];
    
    self.navOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    self.navigationBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 280)];
    
    __weak PersonPageViewController *weakSelf = self;
    [self.navigationBarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.data.bgImageUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
//        image = [image boxblurImageWithBlur:.05];
        weakSelf.navigationBarImageView.image = image;
        
    } failure:nil];
    [self.navigationBarImageView setContentMode:UIViewContentModeScaleAspectFill];

    [self.navOverView addSubview:self.navigationBarImageView];
    
    
    

    self.navOverView.userInteractionEnabled = true;
//    self.navOverView.backgroundColor = UIColorFromRGB(0x0781b7);

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 280)];
//    self.effectView.backgroundColor = [UIColor blackColor];
    
//    self.maskView.frame = CGRectMake(0, 0, ScreenWidth, 280);
    self.maskView.alpha = 0;
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    [self.navOverView addSubview:self.maskView];
    
    [self.navOverView removeFromSuperview];
    [self.view addSubview:self.navOverView];
    [self.view sendSubviewToBack:self.navOverView];

    
    
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage alloc] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    

}
-(void)alphaNavigationBar:(CGFloat)offsetY {
//    NSLog(@"%f",offsetY);

    
    
    if(offsetY > 0) {
        [self.navOverView setAlpha:1];
        if (offsetY >= scrollAlphaHeight) {
            [self.view bringSubviewToFront:self.navOverView];
            self.navOverView.clipsToBounds = true;
            self.title = self.data.nickname;
            self.maskView.alpha = 1;
//            self.navigationBarImageView.image = [self.navigationBarImageView.image boxblurImageWithBlur:0.1];
        } else {
            self.title = @"";
            [self.view sendSubviewToBack:self.navOverView];
            self.navOverView.clipsToBounds = false;
            
//            self.navigationBarImageView.image = [self.navigationBarImageView.image boxblurImageWithBlur:offsetY/216*0.1];

            [self.maskView setAlpha:offsetY/216];


        }
        
        
    } else {
        [self.navOverView setAlpha:0];
    }
    
    if (offsetY <= scrollAlphaHeight) {
        
        if (offsetY <= 0) {
            
            self.navigationBarImageView.transform = CGAffineTransformIdentity;
            
        } else {
            
            self.navigationBarImageView.transform = CGAffineTransformMakeTranslation(0, -offsetY*0.5);
            
        }
    }
    
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar64"] forBarMetrics:UIBarMetricsDefault];
    [self.navOverView removeFromSuperview];

}
//-(void) viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self.navOverView removeFromSuperview];
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
