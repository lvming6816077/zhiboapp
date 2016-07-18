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
#import "CommentTopLineView.h"



#define commentHeight 20
#define commentStartY 29
#define moreHeight 20
#define moreY 9
#define imageMarginBottom 10

@implementation DetailTableViewCell
{
    
    IDMPhotoBrowser *_browser;
    NSMutableArray *_idmPhotos;
    NSInteger _imageCount;
//    CGFloat commentHeight;
    
}

- (void)awakeFromNib {
    // Initialization code
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.clipsToBounds = true;
    self.avatarImageView.userInteractionEnabled = true;

    
//    [self.commentContentView setLayoutMargins:UIEdgeInsetsZero];
//    self.contentTextView.contentInset    = UIEdgeInsetsMake(-8,0,-4,0);
    self.contentTextView.textContainer.lineFragmentPadding = 0;
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(0,4,0,0);
    _idmPhotos = [NSMutableArray new];
    _imageCount = 0;
    
    
    
    [self.replyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyClick:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void) initCommentContent:(NSArray*)commentList{
    for (UIView *view in self.commentContentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (commentList.count == 0) {
        self.commentContentViewHeight.constant = 0;
        return;
    }

    UIView *topLine = [[CommentTopLineView alloc] initWithFrame:CGRectMake(-8, 0, ScreenWidth, 9)];
    topLine.backgroundColor = [UIColor clearColor];
    [self.commentContentView addSubview:topLine];
    
    
    CGFloat wrapWidth = ScreenWidth-16-8;
    CGFloat y = commentStartY; // 评论起始y距离
    CGFloat height = commentHeight;
    CGFloat contentMax = 100;
    CGFloat timeWidth = 70;
    CGFloat marginTop = 3;
    for(int i = 0 ; i < commentList.count ; i++) {
        if (i > 2) break;
        UIView *wrap = [[UIView alloc] initWithFrame:CGRectMake(4, y, wrapWidth, height)];
        UILabel *nickLabel = [[UILabel alloc] init];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        UILabel *timeLabel = [[UILabel alloc] init];
        nickLabel.text = @"吕小鸣：";
        [nickLabel setFont:[UIFont systemFontOfSize:14]];
        CGSize nickSize =[nickLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [nickLabel setTextColor:UIColorFromRGB(0X275dac)];
        
        
        contentLabel.text = @"我是好人啊阿啊阿啊阿啊阿啊阿啊阿啊";
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
    
    if (commentList.count > 3) {
        // 更多评论链接
        
        UILabel *moreComments = [[UILabel alloc] initWithFrame:CGRectMake(0, y+moreY, ScreenWidth, moreHeight)];
        moreComments.text = @"查看更多3条回复";
        
        [moreComments setFont:[UIFont systemFontOfSize:13]];
        [moreComments setTextColor:UIColorFromRGB(0X275dac)];
        
        moreComments.textAlignment = NSTextAlignmentCenter;
        
        [self.commentContentView addSubview:moreComments];
        
        y += moreY+moreHeight;
        
//        moreComments.backgroundColor = [UIColor redColor];
    }
    
    
    self.commentContentViewHeight.constant = y+height;

}
-(void) initImageContent:(NSMutableArray*)picList index:(NSInteger)index{
    for (UIView *view in self.imageContentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat constantH = 0;
    CGFloat y = 0;

    for (int i = 0 ; i < picList.count ; i++) {

        NSDictionary *dicImage = picList[i];

        CGFloat imageW = (ScreenWidth-16);
        CGFloat imageH = [dicImage[@"h"] floatValue] * imageW/ [dicImage[@"w"] floatValue];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, imageW, imageH)];
        [imageView setImageWithURL:[NSURL URLWithString:qiuniuUrl(dicImage[@"key"], 600)]];
        [self.imageContentView addSubview:imageView];
        if (i == picList.count-1) {
            constantH += imageH + 0;
            y += imageH + 0;
        } else {
            constantH += imageH + imageMarginBottom;
            y += imageH + imageMarginBottom;
        }
        

        [imageView setTag:[(NSNumber*)dicImage[@"imageIndex"] integerValue]+100];
        imageView.userInteractionEnabled = true;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClk:)]];

    }
    

    self.imageContentViewHeight.constant = constantH;
    

}
-(void) initTextContent:(NSString*) text {
    [self.contentTextView setText:text];
    
    
    CGSize sizeThatFitsTextView = [self.contentTextView sizeThatFits:CGSizeMake(ScreenWidth-16, MAXFLOAT)];
    
    self.contentTextViewHeight.constant = ceilf(sizeThatFitsTextView.height);
//    NSLog(@"%f",sizeThatFitsTextView.height);
}
-(CGFloat) heightForComment:(NSArray*) commentList{
    
    if (commentList.count == 0) return 0;
    
    CGFloat y = commentStartY;
    CGFloat height = commentHeight;
    CGFloat marginTop = 3;
    for(int i = 0 ; i < commentList.count && i < 3 ; i++) {

        y += height+marginTop;
        
    }
    
    if (commentList.count > 3) {
        // 更多评论链接
        
        y += moreY+moreHeight;
    }
    
    return y+height;

}
-(CGFloat) heightForImage:(NSArray*)picList{
    CGFloat constantH = 0;

    for (int i = 0 ; i < picList.count ; i++) {
        
        NSDictionary *dicImage = picList[i];
        
        CGFloat imageW = (ScreenWidth-16);
        CGFloat imageH = [dicImage[@"h"] floatValue] * imageW/ [dicImage[@"w"] floatValue];

        if (i == picList.count-1) {
            constantH += imageH + 0;
        } else {
            constantH += imageH + imageMarginBottom;
        }

    }
    return constantH;
}
-(CGFloat) heightForText:(NSString*)content{
    [self.contentTextView setText:content];;
    
    CGSize sizeThatFitsTextView = [self.contentTextView sizeThatFits:CGSizeMake(ScreenWidth-16, MAXFLOAT)];
    
    
    return ceilf(sizeThatFitsTextView.height);
}
-(CGFloat) calcHeight:(DetailTableViewCellData*) data{
    
    CGFloat otherHeight = 26;
    
    return
    
    otherHeight +
    [self heightForText:data.content]+
    [self heightForImage:data.picList]+
    [self heightForComment:@[]];
 
}
-(void) setCellData:(DetailTableViewCellData*)data{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:data.avatarImageUrl]];
    
    self.floorLabel.text = [NSString stringWithFormat:@"第%@楼",data.floor];
    
    self.timeLabel.text = data.createtime;
    
    [self initTextContent:data.content];
    
    [self initImageContent:data.picList index:data.index];
    
    NSArray *arr = @[];
    [self initCommentContent:arr];
    
}

-(void)imageViewClk:(UITapGestureRecognizer*) ges {
    UIImageView *currentImage = (UIImageView*)[ges view];
    
    
    [self.myDelegate didOpenImage:currentImage];
}
-(void)replyClick:(UITapGestureRecognizer*) ges {
    
    
    [self.myDelegate didOpenReply];
}

@end
