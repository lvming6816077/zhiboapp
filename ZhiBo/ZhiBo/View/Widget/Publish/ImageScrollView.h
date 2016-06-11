//
//  ImageScrollView.h
//  ZhiBo
//
//  Created by tenny on 16/3/1.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol ImageScrollViewDelegate <NSObject>
//
//- (void)hasAddImage:(UIImageView*)currentImage;
//
//@end

@interface ImageScrollView : UIScrollView
-(void)addImage:(NSArray*)imgs;
-(NSArray*) getCurrentImages;
@end
