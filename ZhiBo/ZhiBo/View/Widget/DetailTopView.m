//
//  DetailTopView.m
//  ZhiBo
//
//  Created by lvming on 16/4/20.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "DetailTopView.h"
#import "UIKit+AFNetworking.h"
#import "Defines.h"
#import "DateUtil.h"

@implementation DetailTopView
{
    DetailTopData *_detailData;
    CGFloat _titleY;
    CGFloat _imageY;
}
-(instancetype) initWithFrame:(CGRect)frame andDetailData:(DetailTopData*) data {
    if (self = [super initWithFrame:frame]) {
        
        _detailData = data;
        
//        _titleY = 70;
        
        [self initAvatarTop];
        
        [self initTitleContent];
        
        [self initTimeContent];
        
//        [self initTextContent];
        
//        [self initImageContent];
        
        [self initBottomLine];
    }
    
    return self;
}


-(void) initAvatarTop{
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 45, 45)];
    [avatarImageView setImageWithURL:[NSURL URLWithString:_detailData.avatarUrl]];
    
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2;
    avatarImageView.clipsToBounds = true;
    avatarImageView.userInteractionEnabled = true;
    
    [self addSubview:avatarImageView];
    
    
    UILabel *nicknameLabel = [[UILabel alloc] init];
    UIFont *font = [UIFont systemFontOfSize:15.0];
    [nicknameLabel setFont:font];
    nicknameLabel.text = _detailData.nickname;
    [nicknameLabel setNumberOfLines:1];
    
    CGFloat nicknameX = 60;
    CGFloat nicknameMax = 100;
    
    CGSize nickSize =[nicknameLabel.text sizeWithAttributes:@{NSFontAttributeName:font}];
    
    
    CGFloat nickWidth = fmin(nicknameMax, nickSize.width);
    
    CGRect frame = CGRectMake(nicknameX, 21, nickWidth, nickSize.height);
    
    nicknameLabel.frame = frame;
    
    
    [self addSubview:nicknameLabel];
    
    UIImageView *genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nicknameX+nickWidth+5, 23, 16, 16)];
    [genderImageView setImage:[UIImage imageNamed:@"male"]];
    
    [self addSubview:genderImageView];
    
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 62, ScreenWidth, .5)];
    borderBottom.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    [self addSubview:borderBottom];
    
    UIButton *focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnW = 50;
    focusButton.frame = CGRectMake(ScreenWidth-btnW-10, 23, btnW, 20);
    [focusButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [focusButton.layer setBorderColor:UIColorFromRGB(0xe5e5e5).CGColor];
//    [focusButton.layer setBorderWidth:.5];
    [focusButton.layer setCornerRadius:3];
    focusButton.clipsToBounds = true;
    [focusButton setTitle:@"进行中" forState:UIControlStateNormal];
    focusButton.titleLabel.textColor = [UIColor whiteColor];
    [focusButton setBackgroundColor:UIColorFromRGB(0x62bb50)];
    
    
    [self addSubview:focusButton];
    
}

-(void) initTitleContent{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 70, ScreenWidth-8, 50)];
    titleLabel.text = _detailData.title;
    
    [titleLabel setNumberOfLines:2];
    
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    
    titleLabel.textColor = UIColorFromRGB(0x333333);
    
    [self addSubview:titleLabel];
}
-(void) initTimeContent {
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 125, 140, 20)];
    
    timeLabel.text = [DateUtil dateStr:[_detailData.createtime doubleValue] format:@"yyyy-MM-dd hh:mm"];
    
    timeLabel.textColor = UIColorFromRGB(0x999999);
    [timeLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:timeLabel];
    
    UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(145, 128, 13, 13)];
    [tagImageView setImage:[UIImage imageNamed:@"tagIcon"]];
    [self addSubview:tagImageView];
    
    
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 125, 40, 20)];
    tagLabel.text = @"生活";
    tagLabel.textColor = UIColorFromRGB(0x999999);
    [tagLabel setFont:[UIFont systemFontOfSize:13]];
    
    [self addSubview:tagLabel];
    
    
    
}
-(void) initTextContent {
    
    UITextView *textView = [[UITextView alloc] init];
    
    [textView setText:_detailData.content];
    
    [textView setFont:[UIFont systemFontOfSize:15.0]];
    
    CGSize sizeThatFitsTextView = [textView sizeThatFits:CGSizeMake(ScreenWidth-16, MAXFLOAT)];
    
    textView.frame = CGRectMake(8, 150, ScreenWidth-8, ceilf(sizeThatFitsTextView.height));
    
    [self addSubview:textView];
    
    _titleY = textView.frame.size.height + 150;
    
    
}

-(void) initImageContent {
    NSArray *list = _detailData.picList;
    CGFloat width = ScreenWidth-16;
    CGFloat y = _titleY;
    CGFloat marginTop = 4;
    for (int i = 0 ; i < list.count ; i++) {
        NSDictionary *dic = list[i];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImageWithURL:[NSURL URLWithString:qiuniuUrl(dic[@"key"],1000)]];
        
        
        CGFloat height = width*[dic[@"h"] integerValue]/[dic[@"w"] integerValue];
        imageView.frame = CGRectMake(8, y, width, height);
        
        y += height+marginTop;
        
        [self addSubview:imageView];
    }
    
    _imageY = y;
}

-(void) initBottomLine {
    CGFloat y = 153;//_imageY ? _imageY : _titleY;
    
//    y += 10;
    
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, 8)];
    borderBottom.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    [self addSubview:borderBottom];
    
    UIView *borderLine = [[UIView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, .5)];
    [borderLine.layer setBorderColor:UIColorFromRGB(0xe1e1e1).CGColor];
    [borderLine.layer setBorderWidth:.5];
    
    [self addSubview:borderLine];
    
    self.frame = CGRectMake(0, 0, ScreenWidth, borderLine.frame.origin.y);
}


@end
