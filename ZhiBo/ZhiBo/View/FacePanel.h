//
//  FacePanel.h
//  ZhiBo
//
//  Created by lvming on 16/7/12.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FacePanellDelegate <NSObject>

-(void) didSelectFace:(NSString*)text;
-(void) didBackFace;

@end
@interface FacePanel : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
-(instancetype) initWithFrame:(CGRect)frame andOption:(NSDictionary*) option;
@property(nonatomic, weak) id<FacePanellDelegate> delegate;
@end
