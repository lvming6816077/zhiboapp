//
//  FindTableViewCellData.h
//  ZhiBo
//
//  Created by lvming on 16/5/2.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindTableViewCellData : NSObject
@property(nonatomic,strong) NSString *avatarImageUrl;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *distance;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *tagName;
@property(nonatomic,strong) NSMutableDictionary *picDic;
@end
