//
//  PersonTableViewCell.m
//  ZhiBo
//
//  Created by tenny on 16/3/31.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "PersonTableViewCell.h"
#import "Defines.h"
#import "UIKit+AFNetworking.h"
@implementation PersonTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.avatarImageView.layer setCornerRadius:2];
    self.imageWraperView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)setCellData:(PersonTableCellData *)data{
    NSString *url = @"";
    if (data.picList.count > 0) {
        url = data.picList[0];
    }
    [self setImage:self.avatarImageView url:url];
    self.titleLabel.text = data.postTitle;
    self.tagLabel.text = data.tagList[0];
    self.statusLabel.text = data.status;
    [self setAvatarList:data];
}
-(void) setAvatarList:(PersonTableCellData *)data {
    for (UIView *view in self.imageWraperView.subviews) {
        [view removeFromSuperview];
    }
    NSInteger count = MIN(data.avatarList.count,3);
    CGFloat imageWidth = 19;
    for(int i = 0 ; i < count ; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*imageWidth+(i*4), 3, imageWidth, imageWidth)];
        
        [imageView.layer setCornerRadius:imageWidth/2];
        imageView.clipsToBounds = true;
        [imageView setImageWithURL:[NSURL URLWithString:data.avatarList[i]]];
//        imageView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5].CGColor;
//        imageView.layer.borderWidth = .3;
//        imageView.layer.
        [self.imageWraperView addSubview:imageView];
    
    }
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
