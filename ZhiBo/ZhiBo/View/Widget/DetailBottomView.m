//
//  DetailBottomView.m
//  ZhiBo
//
//  Created by lvming on 16/6/19.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "DetailBottomView.h"
#import "PublishViewController.h"
#import "VCUtil.h"
#import "POP.h"
#import "HttpUtil.h"
#import "Defines.h"
#import "Tips.h"
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "LoginUtil.h"
@implementation DetailBottomView

{
    DetailBottomData *_detailBottomData;
}

-(instancetype) initWithData:(DetailBottomData*)data andFrame:(CGRect) frame{
    
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    
    self.frame = frame;
    
    _detailBottomData = data;
    
    [self initData];
    
    return self;
}
-(void) initData {
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",_detailBottomData.likecount] forState:UIControlStateNormal];
    
    if (_detailBottomData.isZan == 1) {
        self.likeButton.selected = true;
        
    }
}
- (IBAction)clickLike:(id)sender {
    NSString *uid = [LoginUtil getCurrentUserId];
    NSString *pid = [NSString stringWithFormat:@"%d",_detailBottomData.pid];
    
    [[HttpUtil shareInstance] post:[NSString stringWithFormat:@"%@/post/doLikePost", BaseCgiUrl] parameters:@{@"pid":pid,@"uid":uid} formBody:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *status = [responseObject valueForKeyPath:@"status"];
        if ([status isEqualToString:@"fail"]) {
            
        } else {
            self.likeButton.selected = true;
            POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.3, 1.3)];
            //    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
            sprintAnimation.springBounciness = 15;
            sprintAnimation.springSpeed = 12;
            sprintAnimation.autoreverses = YES;
            [self.likeButton pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [Tips showTips:nil text:@"失败"];
    }];
    
    
    
//    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    scaleAnimation.duration = 1;
//    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
//    [self.likeButton pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
}
- (IBAction)clickReply:(id)sender {
    PublishViewController *pub = [[PublishViewController alloc] initWithPubType:PubTypeReply andOption:@{@"pid":[NSString stringWithFormat:@"%d",_detailBottomData.pid]}];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pub];
    
    [[VCUtil getCurrentVC] presentViewController:navController animated:YES completion:NULL];
}
- (IBAction)clickShare:(id)sender {
    
    [UMSocialData defaultData].extConfig.title = @"分享的title";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    [UMSocialSnsService presentSnsIconSheetView:[VCUtil getCurrentVC]
                                         appKey:@"57764482e0f55abd06001308"
                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:@[UMShareToQQ,UMShareToQzone]
                                       delegate:nil];
}
@end
