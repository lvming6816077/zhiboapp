//
//  PersonTopView.m
//  ZhiBo
//
//  Created by tenny on 16/3/27.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "PersonTopView.h"
#import "Defines.h"
#import "UIKit+AFNetworking.h"
#import "PersonPageViewController.h"
#import "MyViewController.h"
#import "Masonry.h"
#import "UIImage+ImageUtil.h"

@implementation PersonTopView

-(instancetype) initWithFrame:(CGRect)frame withData:(PersonPageData*)data{
    if(self == [super initWithFrame:frame]) {
    
        [self initTopImage:data];
        [self initTopAvatar:data];
        [self initTopText:data];
        [self initTopBottom:data];

        
    }
    
    return self;

}

-(void) initTopImage :(PersonPageData*)data{
    self.topImageView = [[UIImageView alloc] initWithFrame:self.frame];
    
    [self.topImageView setImageWithURL:[NSURL URLWithString:data.bgImageUrl]];
//    self.topImageView.image = [self.topImageView.image boxblurImageWithBlur:(.8)];

    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.clipsToBounds = true;
    [self addSubview:self.topImageView];

}
-(void) initTopAvatar :(PersonPageData*)data{
    CGFloat imageWidth = 75;
    self.topAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-imageWidth/2, 65, imageWidth, imageWidth)];
    
    [self.topAvatarImageView setImageWithURL:[NSURL URLWithString:data.avatarImageUrl]];
    
    [self.topAvatarImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.topAvatarImageView.layer setBorderWidth:2.0];
    [self.topAvatarImageView.layer setCornerRadius:self.topAvatarImageView.frame.size.width/2];
    self.topAvatarImageView.clipsToBounds = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick:)];
    self.topAvatarImageView.userInteractionEnabled = true;
    [self.topAvatarImageView addGestureRecognizer:tap];
    [self addSubview:self.topAvatarImageView];
    
}
-(void) initTopText:(PersonPageData*) data{
    CGFloat nameLabelWidth = 120;
    CGFloat addressBtnWidth = 200;
    CGFloat descLabelWidth = ScreenWidth-40;
    self.topNicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-nameLabelWidth/2, 155, nameLabelWidth, 20)];
    [self.topNicknameLabel setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.6]];
    [self.topNicknameLabel setShadowOffset:CGSizeMake(1, 1)];
    self.topNicknameLabel.numberOfLines = 1;
    self.topNicknameLabel.text = data.nickname;
    self.topNicknameLabel.textAlignment = NSTextAlignmentCenter;
    self.topNicknameLabel.textColor = [UIColor whiteColor];
    [self.topNicknameLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];

    [self addSubview:self.topNicknameLabel];
    
    self.topAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topAddressBtn.frame = CGRectMake(ScreenWidth/2-addressBtnWidth/2, 180, addressBtnWidth, 18);
    [self.topAddressBtn setTitle:@"河南郑州" forState:UIControlStateNormal];
    [self.topAddressBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];

    self.topAddressBtn.tintColor = [UIColor whiteColor];
    [self.topAddressBtn setImage:[UIImage imageNamed:@"personPageAddressIcon"] forState:UIControlStateNormal];
    [self.topAddressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7)];
    [self addSubview:self.topAddressBtn];
    
    self.topDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth, 20)];
//    [self.topDescLabel setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.6]];
//    [self.topDescLabel setShadowOffset:CGSizeMake(1, 1)];
    self.topDescLabel.numberOfLines = 1;
    self.topDescLabel.text = @"简介：我是以俄国大号一人大好人大好人啊";
    self.topDescLabel.textAlignment = NSTextAlignmentCenter;
    self.topDescLabel.textColor = [UIColor whiteColor];
    [self.topDescLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
    [self addSubview:self.topDescLabel];

}
-(void) initTopBottom:(PersonPageData*) data{
    CGFloat viewHeight = 50;
    self.topBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-viewHeight, ScreenWidth, viewHeight)];

    self.topBottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
//    self.topBottomView.layer.borderWidth = 0.5;
//    self.topBottomView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
//    [self.topBottomView.layer setShadowColor:[UIColor blackColor].CGColor];
//    [self.topBottomView.layer setShadowOffset:CGSizeMake(0, -20)];
//    self.topBottomView.layer.masksToBounds = false;
//    self.topBottomView.layer.shouldRasterize = true;
//    self.topBottomView.layer.shadowOpacity = .2;
//    self.topBottomView.layer.shadowRadius = 5;
//    self.topBottomView.clipsToBounds = true;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.topBottomView.bounds;
    effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [view addSubview:effectView];
    [self addSubview:self.topBottomView];
    
    
    
    UIView *flowersView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, viewHeight)];
    UIView *focusView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, viewHeight)];
    UIView *followsView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, viewHeight)];

    UILabel *flowerCountLabel = [UILabel new];
    [flowersView addSubview:flowerCountLabel];
    flowerCountLabel.text = @"1233";
    [flowerCountLabel setFont:[UIFont boldSystemFontOfSize:18]];
    flowerCountLabel.textColor = [UIColor whiteColor];
    flowerCountLabel.textAlignment = NSTextAlignmentCenter;

    [flowerCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(flowersView).with.offset(5);
        make.left.equalTo(flowersView).with.offset(0);
        make.right.equalTo(flowersView).with.offset(0);

    }];
    
    
    UILabel *flowerLabel = [UILabel new];//[[UILabel alloc] initWithFrame:CGRectMake(0, 40, flowersView.frame.size.width, 20)];
    flowerLabel.text = @"粉丝";
    [flowerLabel setFont:[UIFont systemFontOfSize:13]];
    flowerLabel.textColor = [UIColor whiteColor];
    flowerLabel.textAlignment = NSTextAlignmentCenter;
    
    [flowersView addSubview:flowerLabel];
    
    [flowerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(flowerCountLabel.mas_bottom);
        make.left.equalTo(flowersView).with.offset(0);
        make.right.equalTo(flowersView).with.offset(0);
        
    }];
    
    
    UILabel *followCountLabel = [UILabel new];
    [followsView addSubview:followCountLabel];
    followCountLabel.text = @"888";
    [followCountLabel setFont:[UIFont boldSystemFontOfSize:18]];
    followCountLabel.textColor = [UIColor whiteColor];
    followCountLabel.textAlignment = NSTextAlignmentCenter;
    //    flowerCountLabel.backgroundColor = [UIColor redColor];
    [followCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(followsView).with.offset(5);
        make.left.equalTo(followsView).with.offset(0);
        make.right.equalTo(followsView).with.offset(0);
        
    }];
    
    
    UILabel *followLabel = [UILabel new];//[[UILabel alloc] initWithFrame:CGRectMake(0, 40, flowersView.frame.size.width, 20)];
    followLabel.text = @"关注";
    [followLabel setFont:[UIFont systemFontOfSize:13]];
    followLabel.textColor = [UIColor whiteColor];
    followLabel.textAlignment = NSTextAlignmentCenter;
    
    [followsView addSubview:followLabel];
    
    [followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(followCountLabel.mas_bottom);
        make.left.equalTo(followsView).with.offset(0);
        make.right.equalTo(followsView).with.offset(0);
        
    }];
    
    
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];//[[UILabel alloc] initWithFrame:CGRectMake(0, 40, flowersView.frame.size.width, 20)];
//    focusBtn.titleLabel.text = @"关注";
    [focusBtn setTitle:@"关注" forState:UIControlStateNormal];
    focusBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    focusBtn.layer.borderWidth = 2;
    [focusBtn.layer setCornerRadius:14.0];
    [focusBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    focusBtn.titleLabel.textColor = [UIColor whiteColor];
    focusBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [focusView addSubview:focusBtn];
    
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(focusView).with.offset(7);
//        make.left.equalTo(focusView).with.offset(13);
//        make.right.equalTo(focusView).with.offset(-13);
        make.centerX.equalTo(focusView);
        make.width.mas_equalTo(60);
        make.bottom.equalTo(focusView).with.offset(-11);
        
    }];
    
    
    
    [self.topBottomView addSubview:flowersView];
    [self.topBottomView addSubview:followsView];
    [self.topBottomView addSubview:focusView];
    
    
}
-(void) avatarClick:(UITapGestureRecognizer*) recongizer {
    PersonPageViewController *personVC = (PersonPageViewController*)[self.superview.superview nextResponder];
    [personVC.navigationController pushViewController:[[MyViewController alloc] init] animated:true];
}


@end
