//
//  DetailTableViewCell.m
//  ZhiBo
//
//  Created by lvming on 16/4/20.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UIKit+AFNetworking.h"
#import "Defines.h"
#import "Masonry.h"
#import "IDMPhotoBrowser.h"

@implementation DetailTableViewCell
{
    
    IDMPhotoBrowser *_browser;
    NSMutableArray *_idmPhotos;
    NSInteger _imageCount;
    
}

- (void)awakeFromNib {
    // Initialization code
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.clipsToBounds = true;
    self.avatarImageView.userInteractionEnabled = true;

    
//    self.contentTextView.backgroundColor = [UIColor redColor];
    _idmPhotos = [NSMutableArray new];
    _imageCount = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
-(void) initCommentContent:(NSArray*)commentList{
    for (UIView *view in self.commentContentView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat wrapWidth = ScreenWidth-16-8;
    CGFloat y = 0;
    CGFloat height = 20;
    CGFloat contentMax = 100;
    CGFloat timeWidth = 70;
    CGFloat marginTop = 3;
    for(int i = 0 ; i < commentList.count ; i++) {
        UIView *wrap = [[UIView alloc] initWithFrame:CGRectMake(4, y, wrapWidth, height)];
        UILabel *nickLabel = [[UILabel alloc] init];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        UILabel *timeLabel = [[UILabel alloc] init];
        nickLabel.text = @"吕小鸣：";
        [nickLabel setFont:[UIFont systemFontOfSize:14]];
        CGSize nickSize =[nickLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [nickLabel setTextColor:UIColorFromRGB(0X275dac)];
        
        
        contentLabel.text = @"我是好人啊";
        [contentLabel setTextColor:UIColorFromRGB(0x666666)];
        [contentLabel setFont:[UIFont systemFontOfSize:14]];
        
        
        timeLabel.text = @"2013-03-03";
        [timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [timeLabel setTextColor:UIColorFromRGB(0x999999)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        
        
        
        [wrap addSubview:nickLabel];
        [wrap addSubview:contentLabel];
        [wrap addSubview:timeLabel];
        
        [self.commentContentView addSubview:wrap];
        
        
        [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wrap.mas_left).with.offset(0);
            make.top.equalTo(wrap.mas_top).with.offset(0);
            make.height.mas_equalTo(height);
            make.width.mas_lessThanOrEqualTo(contentMax);
        }];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nickLabel.mas_right).with.offset(0);
            make.top.equalTo(wrap.mas_top).with.offset(0);
            make.height.mas_equalTo(height);
//            make.right.equalTo(timeLabel.mas_left).with.offset(0);
            make.width.mas_lessThanOrEqualTo(wrapWidth-fmin(nickSize.width, contentMax)-timeWidth);
        }];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentLabel.mas_right).with.offset(0);
            make.top.equalTo(wrap.mas_top).with.offset(0);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(timeWidth);
//            make.right.equalTo(wrap.mas_right).with.offset(0);
        }];
        
        
        
        y += height+marginTop;
        
    }
    self.commentContentViewHeight.constant = y+height;

}
-(void) initImageContent:(NSMutableArray*)picList index:(NSInteger)index{
    for (UIView *view in self.imageContentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat constantH = 0;
    CGFloat y = 0;
    CGFloat marginBottom = 10;
    for (int i = 0 ; i < picList.count ; i++) {

        NSDictionary *dicImage = picList[i];

        CGFloat imageW = (ScreenWidth-16);
        CGFloat imageH = [dicImage[@"h"] floatValue] * imageW/ [dicImage[@"w"] floatValue];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, imageW, imageH)];
        [imageView setImageWithURL:[NSURL URLWithString:dicImage[@"url"]]];
        [self.imageContentView addSubview:imageView];
        constantH += imageH + marginBottom;
        y += imageH + marginBottom;
        NSLog(@"%@",(NSNumber*)dicImage[@"imageIndex"]);
        [imageView setTag:[(NSNumber*)dicImage[@"imageIndex"] integerValue]+100];
        imageView.userInteractionEnabled = true;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClk:)]];
        

    }
    

    self.imageContentViewHeight.constant = constantH;
    

}

-(CGFloat) heightForComment:(NSArray*) commentList{
    CGFloat y = 0;
    CGFloat height = 20;
    CGFloat marginTop = 3;
    for(int i = 0 ; i < commentList.count ; i++) {
        
        y += height+marginTop;
        
    }
    return y+height;

}
-(CGFloat) heightForImage:(NSArray*)picList{
    CGFloat constantH = 0;

    CGFloat marginBottom = 10;
    for (int i = 0 ; i < picList.count ; i++) {
        
        NSDictionary *dicImage = picList[i];
        
        CGFloat imageW = (ScreenWidth-16);
        CGFloat imageH = [dicImage[@"h"] floatValue] * imageW/ [dicImage[@"w"] floatValue];
        constantH += imageH + marginBottom;

    }
    return constantH;
}
-(CGFloat) heightForText:(NSString*)content{
    [self.contentTextView setText:content];;
    
    CGSize sizeThatFitsTextView = [self.contentTextView sizeThatFits:CGSizeMake(ScreenWidth-16, MAXFLOAT)];
    

    
    return ceilf(sizeThatFitsTextView.height);
}
-(CGFloat) calcHeight:(DetailTableViewCellData*) data{
    
    return
    
    [self heightForText:data.content]+
    [self heightForImage:data.picList]+
    [self heightForComment:@[@"",@""]];

}
-(void) setCellData:(DetailTableViewCellData*)data{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:@"http://q1.qlogo.cn/g?b=qq&k=hGgI20ve59dSRh0GIr1Fuw&s=100&t=1448142454"]];
    
    self.floorLabel.text = [NSString stringWithFormat:@"第%@楼",data.floor];
    
    self.timeLabel.text = @"2016-01-05";
    
    [self.contentTextView setText:data.content];;

    CGSize sizeThatFitsTextView = [self.contentTextView sizeThatFits:CGSizeMake(ScreenWidth-16, MAXFLOAT)];
    
    self.contentTextViewHeight.constant = ceilf(sizeThatFitsTextView.height);
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:data.avatarImageUrl]];
    
    [self initImageContent:data.picList index:data.index];
    NSArray *arr = @[@"",@""];
    [self initCommentContent:arr];

    
    
}
-(void)imageViewClk:(UITapGestureRecognizer*) ges {
    UIImageView *currentImage = (UIImageView*)[ges view];
    
    
    [self.myDelegate didOpenImage:currentImage];
}
@end
