//
//  PersonTopView.h
//  ZhiBo
//
//  Created by tenny on 16/3/27.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonPageData.h"
@interface PersonTopView : UIView
@property(nonatomic,strong) UIImageView *topImageView;
@property(nonatomic,strong) UIImageView *topAvatarImageView;
@property(nonatomic,strong) UILabel *topNicknameLabel;
@property(nonatomic,strong) UIButton *topAddressBtn;
@property(nonatomic,strong) UIView *topBottomView;
@property(nonatomic,strong) UILabel *topDescLabel;

-(instancetype) initWithFrame:(CGRect)frame withData:(PersonPageData*)data;
@end
