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

@implementation DetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype) initWithData:(DetailBottomData*)data andFrame:(CGRect) frame{
    
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    self.likeCountLabel.text = @"2";
//    self.likeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(4 ,-4,4,4);

    self.frame = frame;
    return self;

}
- (IBAction)clickReply:(id)sender {
    PublishViewController *pub = [[PublishViewController alloc] initWithPubType:PubTypeReply andOption:@{@"pid":@"1"}];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pub];
    
    [[VCUtil getCurrentVC] presentViewController:navController animated:YES completion:NULL];
}
@end
