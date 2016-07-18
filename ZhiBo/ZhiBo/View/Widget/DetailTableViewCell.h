//
//  DetailTableViewCell.h
//  ZhiBo
//
//  Created by lvming on 16/4/20.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTableViewCellData.h"

@protocol DetailTableViewCellDelegate <NSObject>

- (void)didOpenImage:(UIImageView*)currentImage;
- (void)didOpenReply;

@end
@interface DetailTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet UIView *commentContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentContentViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property(nonatomic, weak) id<DetailTableViewCellDelegate> myDelegate;


-(void) setCellData:(DetailTableViewCellData*)data;
-(CGFloat) calcHeight:(DetailTableViewCellData*) data;
@end
