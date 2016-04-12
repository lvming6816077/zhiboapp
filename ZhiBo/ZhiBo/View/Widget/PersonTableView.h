//
//  PersonTableView.h
//  ZhiBo
//
//  Created by tenny on 16/3/27.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonPageData.h"
@interface PersonTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
-(instancetype) initWithFrame:(CGRect)frame withData:(PersonPageData*)data;

@end
