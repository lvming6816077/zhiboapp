//
//  ChoosePositionViewController.h
//  ZhiBo
//
//  Created by tenny on 16/3/3.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaseViewController.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>


//#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@protocol ChoosePositionViewControllerDelegate <NSObject>

-(void) selectAddress:(NSDictionary*)dic;

@end
@interface ChoosePositionViewController :BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,AMapSearchDelegate,UISearchBarDelegate/*,BMKPoiSearchDelegate*/>

@property(nonatomic,weak) id<ChoosePositionViewControllerDelegate> delegate;
@property(nonatomic,strong) NSDictionary *currentCellCoordinate;
@end
