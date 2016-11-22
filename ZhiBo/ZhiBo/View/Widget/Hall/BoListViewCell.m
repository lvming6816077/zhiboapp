//
//  BoListViewCellTableViewCell.m
//  ZhiBo
//
//  Created by tenny on 16/2/19.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "BoListViewCell.h"
#import "UIKit+AFNetworking.h"
#import "Defines.h"
#import "Masonry.h"
#import "DateUtil.h"



@implementation BoListViewCell


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self.FeedsLiView.layer setBorderColor:UIColorFromRGB(0xdedfe0).CGColor];
    [self.FeedsLiView.layer setBorderWidth:0.5];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.clipsToBounds = true;
    self.avatarImageView.userInteractionEnabled = true;
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
//    self.contentView.translatesAutoresizingMaskIntoConstraints = false;
}

-(CGFloat) heightForText:(BoListViewCellData *)data {
    [self.titleLabel setText:data.title];
    
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(ScreenWidth-16, MAXFLOAT)];
    
    CGFloat titleHeight = ceilf(titleSize.height);
    
    [self.descLabel setText:data.desc];
    
    CGSize descSize = [self.descLabel sizeThatFits:CGSizeMake(ScreenWidth-16, MAXFLOAT)];
    
    CGFloat descHeight = ceilf(descSize.height);
    
    return descHeight + titleHeight;
    
    
}

-(CGFloat) heightForImage:(BoListViewCellData *)data {
    
    CGFloat wrapperWidth = ScreenWidth;
    
    CGFloat height = 0;
    
    CGFloat marginTop = 12;
    
    if (data.picList.count == 0) {
        height = 0;
    } else if (data.picList.count == 1) {
        height = wrapperWidth/2+20 + marginTop;
    } else if (data.picList.count == 2) {
        CGFloat margin = 2.0f;
        CGFloat width = (wrapperWidth - margin)/2;
        
        height = width + marginTop;

    } else if (data.picList.count >= 3) {
        CGFloat margin = 2.0f;
        CGFloat smallWidth = (wrapperWidth-margin)/4;


        height = smallWidth*2+margin + marginTop;
    }
    
    return height;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // customer style

}
-(void) initImageContent:(BoListViewCellData *)data {
    
    for (UIView *view in self.imageContentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat wrapperWidth = ScreenWidth;

    if (data.picList.count == 0) {
        self.imageContentHeight.constant = 0;
        self.imageContentMarginTop.constant = 0;
    } else if (data.picList.count == 1) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wrapperWidth, wrapperWidth/2+20)];
        [self.imageContentView addSubview:image];

        self.imageContentHeight.constant = wrapperWidth/2+20;
        self.imageContentMarginTop.constant = 12;
        [self setImage:image url:data.picList[0]];
    
    } else if (data.picList.count == 2) {
        CGFloat margin = 2.0f;
        CGFloat width = (wrapperWidth - margin)/2;

        UIImageView *imageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake(width+margin, 0, width, width)];

        [self.imageContentView addSubview:imageLeft];
        [self.imageContentView addSubview:imageRight];
        
        
        self.imageContentHeight.constant = width;
        self.imageContentMarginTop.constant = 12;
        
        
        [self setImage:imageLeft url:data.picList[0]];
        [self setImage:imageRight url:data.picList[1]];
    } else if (data.picList.count >= 3) {
        CGFloat margin = 2.0f;
        CGFloat smallWidth = (wrapperWidth-margin)/4;
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, smallWidth*3, smallWidth*2+margin)];
        UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(smallWidth*3+margin, 0, smallWidth, smallWidth)];
        UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(smallWidth*3+margin, smallWidth+margin, smallWidth, smallWidth)];

        [self.imageContentView addSubview:image1];
        [self.imageContentView addSubview:image2];
        [self.imageContentView addSubview:image3];
        
        self.imageContentHeight.constant = smallWidth*2+margin;
        self.imageContentMarginTop.constant = 12;
        
        [self setImage:image1 url:data.picList[0]];
        [self setImage:image2 url:data.picList[1]];
        [self setImage:image3 url:data.picList[2]];
    }

}
-(void) setCellData:(BoListViewCellData *)data {
    
    
    self.nicknameLabel.text = data.nickname;
    if (data.address.length > 0) {
        self.addressLabel.text = data.address;
    } else {
        self.addressLabel.text = @"火星";
    }
//    self.addressLabel.text = data.address ? data.address : @"火星";
    self.createtimeLabel.text = [DateUtil formatShortTime:[data.createtime doubleValue]];
    self.titleLabel.text = data.title;

    self.descLabel.text = data.desc;
    
    self.likecountLabel.text = [NSString stringWithFormat:@"%d",data.likecount];
    self.commentcountLabel.text = [NSString stringWithFormat:@"%d",data.commentcount];
    
    [self initImageContent:data];
    [self setAvatarImage:data];


}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
//    // need to use to set the preferredMaxLayoutWidth below.
//    [self.contentView setNeedsLayout];
//    [self.contentView layoutIfNeeded];
//    
//    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
//    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
////    self.bodyLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bodyLabel.frame);
//    self.descLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descLabel.frame);
//}
//-(void) updateConstraints {
//    if ([_myData.nickname isEqualToString:@"吕小鸣"]) {
//        
//    } else {
//        [self.nextPicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);
//            
//        }];
////                self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
//        
//    }
//    
//    [super updateConstraints];
//    
//}
//-(void) layoutSubviews {
//
//    if ([_myData.nickname isEqualToString:@"吕小鸣"]) {
//        
//    } else {
//        [self.nextPicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);
//            
//        }];
////        self.translatesAutoresizingMaskIntoConstraints = NO;
//        
//    }
//    
//    
//    [super layoutSubviews];
//
//
//}

-(void) setAvatarImage:(BoListViewCellData *)data{
    [self setImage:self.avatarImageView url:data.avatarImageUrl];
}
-(void) setImage:(UIImageView *)imageView url:(NSString*)url{

    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.clipsToBounds = true;
    __weak UIImageView *weakSelf = imageView;
    [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:[UIImage imageNamed:@"NewsDefault"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        if (request) { // not use cache
            
            // add adimation
            [UIView transitionWithView:weakSelf
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                weakSelf.image = image;
                            }
                            completion:nil];
        } else {
            // use cache
            weakSelf.image = image;
        }
        
        
    } failure:nil];
}
@end
