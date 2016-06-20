//
//  BoListViewCellData.h
//  ZhiBo
//
//  Created by tenny on 16/2/19.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoListViewCellData : NSObject


@property(nonatomic,assign) NSInteger pid;
@property(nonatomic,strong) NSString *avatarImageUrl;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *createtime;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,assign) NSInteger likecount;
@property(nonatomic,assign) NSInteger commentcount;
@property(nonatomic,strong) NSArray *picList;


-(instancetype) initWithDict:(NSDictionary *)dict;
@end
