//
//  DetailViewController.h
//  ZhiBo
//
//  Created by tenny on 16/3/10.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTableViewCell.h"
#import "DetailTopData.h"
#import "DetailBottomData.h"
#import "InputFacePanel.h"

@interface DetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DetailTableViewCellDelegate,InputFacePanelDelegate>
@property(nonatomic,strong) DetailTopData *detailTopData;
@property(nonatomic,strong) DetailBottomData *detailBottomData;

-(instancetype) initWithDetailData:(DetailTopData*)topData bottomData:(DetailBottomData*)bottomData;
@end
