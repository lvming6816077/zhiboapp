//
//  PhotoPickerViewController.h
//  ZhiBo
//
//  Created by tenny on 16/2/25.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface PhotoPickerViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;
@property (nonatomic, strong) UIScrollView *gridScrollView;
@end
