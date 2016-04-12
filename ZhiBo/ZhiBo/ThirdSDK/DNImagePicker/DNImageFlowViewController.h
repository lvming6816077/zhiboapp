//
//  DNImageFlowViewController.h
//  ImagePicker
//
//  Created by DingXiao on 15/2/11.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@protocol DNImageFlowViewControllerDelegate <NSObject>
-(NSMutableArray*) hasSelectedAssets;

@end
@interface DNImageFlowViewController : UIViewController
@property (nonatomic, weak) id<DNImageFlowViewControllerDelegate> delegate;
- (instancetype)initWithGroupURL:(NSURL *)assetsGroupURL;

@end
