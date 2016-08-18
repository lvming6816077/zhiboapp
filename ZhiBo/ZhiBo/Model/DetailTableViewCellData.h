//
//  DetailTableViewCellData.h
//  ZhiBo
//
//  Created by lvming on 16/4/21.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailTableViewCellData : NSObject
@property(nonatomic,strong) NSString *avatarImageUrl;
@property(nonatomic,strong) NSString *createtime;
@property(nonatomic,strong) NSString *floor;
@property(nonatomic,strong) NSMutableArray<NSMutableDictionary*> *picList;
@property(nonatomic,strong) NSMutableArray<NSDictionary*> *commonList;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,assign) NSInteger replyId;
@end
