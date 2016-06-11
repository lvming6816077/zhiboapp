//
//  SearchPageTableViewCellData.h
//  ZhiBo
//
//  Created by lvming on 16/5/13.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchPageTableViewCellData : NSObject
@property(nonatomic,strong) NSString *picImageUrl;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSMutableDictionary *picDic;
@end
