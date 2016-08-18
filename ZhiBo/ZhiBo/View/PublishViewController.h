//
//  PublishViewController.h
//  ZhiBo
//
//  Created by tenny on 16/2/17.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "BaseViewController.h"
#import "FacePanel.h"

// 2种发表类型
typedef NS_ENUM(NSUInteger, PubType)
{
    PubTypePost = 1,   // 发表
    PubTypeReply = 2   // 回复
};

@interface PublishViewController : BaseViewController
<UITextViewDelegate,
UITextFieldDelegate,
UIScrollViewDelegate,
UIScrollViewDelegate,
FacePanellDelegate>


-(instancetype) initWithPubType:(PubType) type andOption:(NSDictionary*) dic;
@end
