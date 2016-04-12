//
//  HallTableView.h
//  ZhiBo
//
//  Created by tenny on 16/2/19.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoListViewCell.h"
#import "BoListViewCellData.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface HallTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *dataList;
@end
