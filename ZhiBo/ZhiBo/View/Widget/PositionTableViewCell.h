//
//  PositionTableViewCell.h
//  ZhiBo
//
//  Created by tenny on 16/3/3.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionTableViewCell : UITableViewCell
-(void) setCellData:(id)data index:(int)index currentCellCoordinate:(NSDictionary*)currentCellCoordinate;
-(void) initBottomView;
@end
