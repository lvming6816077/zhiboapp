//
//  FindTableViewCell.m
//  ZhiBo
//
//  Created by lvming on 16/5/2.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "Defines.h"
#import "FindTableViewCell.h"
#import "UIKit+AFNetworking.h"



#define textContentWidth (ScreenWidth - 55 - 14.5)
@implementation FindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.frame.size.width/2];
    self.avatarImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCellData:(FindTableViewCellData*)cellData {//
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:cellData.avatarImageUrl]];
    self.nicknameLabel.text = cellData.nickname;
    self.distanceLabel.text = cellData.distance;
    self.tagLabel.text = cellData.tagName;
    self.textContent.text = cellData.content;
    
    [self setImageView:cellData.picDic];
}
-(CGFloat) heightForCell:(FindTableViewCellData*)cellData{
    
    // text
    self.textContent.text = cellData.content;
    CGSize sizeThatFitsTextView = [self.textContent sizeThatFits:CGSizeMake(textContentWidth, MAXFLOAT)];
    
    
    //image
    CGFloat maxWidth = textContentWidth*3/4;
    CGFloat maxHeight = (ScreenWidth)/2;
    CGFloat maxZ = textContentWidth/2;
    
    CGFloat w = [cellData.picDic[@"w"] floatValue];
    CGFloat h = [cellData.picDic[@"h"] floatValue];
    
    
    CGFloat height = 0.0;
    if (w > h) { // 宽图
        CGFloat width = fmin(maxWidth,w);
        height = width * h / w;
        
    }
    
    if (w < h) { // 长图
        height = fmin(maxHeight, h);
    }
    
    if (w == h) { // 方图
        height = fmin(maxZ, w);
    }
    if (!w || !h) {
        height = 0;
    }
    
    return
    
    ceilf(sizeThatFitsTextView.height) // text height
    +
    height // image height
    +
    95.0f // other height
    ;
}
-(void) setImageView:(NSDictionary*)obj{ //960 1280
    
    for (UIView *v in self.imageContentView.subviews) {
        [v removeFromSuperview];
    }
    
    if (!obj[@"w"]) {
        self.imageViewHeight.constant = 0;
        return;
    }
    CGFloat maxWidth = textContentWidth*3/4;
    CGFloat maxHeight = (ScreenWidth)/2;
    CGFloat maxZ = textContentWidth/2;
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setTag:[(NSNumber*)obj[@"imageCount"] integerValue]+100];
    imageView.userInteractionEnabled = true;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClk:)]];
    
    
    
    [imageView setImageWithURL:[NSURL URLWithString:obj[@"url"]]];
    CGFloat w = [obj[@"w"] floatValue];
    CGFloat h = [obj[@"h"] floatValue];
    
    if (w > h) { // 宽图
        CGFloat width = fmin(maxWidth,w);
        CGFloat height = width * h / w;
        imageView.frame = CGRectMake(0, 0, width, height);
    
    }
    
    if (w < h) { // 长图
        CGFloat height = fmin(maxHeight, h);
        CGFloat width = height * w / h;
        imageView.frame = CGRectMake(0, 0, width, height);
    }
    
    if (w == h) { // 方图
        CGFloat height = fmin(maxZ, w);
        imageView.frame = CGRectMake(0, 0, height, height);
    }
    self.imageViewHeight.constant = imageView.frame.size.height;
    [self.imageContentView addSubview:imageView];
}
-(void)imageViewClk:(UITapGestureRecognizer*) ges {
    UIImageView *currentImage = (UIImageView*)[ges view];
    
    
    [self.myDelegate didOpenImage:currentImage];
}
@end
