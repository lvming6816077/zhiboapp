//
//  ImageScrollView.m
//  ZhiBo
//
//  Created by tenny on 16/3/1.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "ImageScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "PublishViewController.h"

#define imageWidth 50
@implementation ImageScrollView
{

    NSInteger _imageCount;
    ALAssetsLibrary *_lib;
    NSMutableArray *_idmPhotos;
    PublishViewController *_pvc;
    IDMPhotoBrowser *_browser;
    
}


-(instancetype) initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        _imageCount = 0;
        _lib = [ALAssetsLibrary new];
        self.showsHorizontalScrollIndicator = false;
        _idmPhotos = [[NSMutableArray alloc] init];
        _pvc = [[PublishViewController alloc] init];
//        _browser = 
    }
    return self;
}
-(void)setImage:(UIImage*)image andImageView:(UIImageView*)imageView{

    imageView.image = image;
    CGFloat x = (_imageCount+1)*8+_imageCount*self.frame.size.height;
    imageView.frame = CGRectMake(x, 0, self.frame.size.height, self.frame.size.height);
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.clipsToBounds = true;
    
    imageView.userInteractionEnabled = true;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClk:)]];
    
    
    [self setContentSize:CGSizeMake(fmax(self.frame.size.width, x+self.frame.size.height), 0)];
    [self addSubview:imageView];
    [imageView setTag:_imageCount + 100];
    _imageCount++;
    
    
    IDMPhoto *photo = [IDMPhoto photoWithImage:image];
    [_idmPhotos addObject:photo];

}
-(void)imageViewClk:(UITapGestureRecognizer*) ges {
    UIImageView *currentImage = (UIImageView*)[ges view];
    _browser = [[IDMPhotoBrowser alloc] initWithPhotos:_idmPhotos];
//    _browser.usePopAnimation = YES;
    _browser.scaleImage = currentImage.image;
    _browser.displayCounterLabel = YES;
    _browser.displayActionButton = NO;
    _browser.displayDoneButton = NO;
    _browser.displayArrowButton = NO;
//    _browser.usePopAnimation = true;
//    _browser.forceHideStatusBar = true;

    [_browser setInitialPageIndex:currentImage.tag-100];
    PublishViewController *vc = (PublishViewController*)[self.superview.superview nextResponder];
    [vc presentViewController:_browser animated:YES completion:nil];
}
-(void)addImage:(NSArray*)imgs {
    
    
    for(int i = 0 ; i < imgs.count ; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        __block UIImage *image;
        
        
        if ([imgs[i] isKindOfClass:[NSURL class]]) {
            [_lib assetForURL:imgs[i] resultBlock:^(ALAsset *asset) {
                
                
                if (!true) {
                    //        NSNumber *orientationValue = [asset valueForProperty:ALAssetPropertyOrientation];
                    //        UIImageOrientation orientation = UIImageOrientationUp;
                    //        if (orientationValue != nil) {
                    //            orientation = [orientationValue intValue];
                    //        }
                    //
                    //        image = [UIImage imageWithCGImage:asset.thumbnail];
                    //        //        image = [UIImage imageWithCGImage:asset.thumbnail scale:0.1 orientation:orientation];
                    //
                    //        string = [NSString stringWithFormat:@"fileSize:%lld k\nwidth:%.0f\nheiht:%.0f",asset.defaultRepresentation.size/1000,[[asset defaultRepresentation] dimensions].width, [[asset defaultRepresentation] dimensions].height];
                    
                } else {
                    image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    
                }
                
                [self setImage:image andImageView:imageView];

            } failureBlock:^(NSError *error) {
                
            }];
        } else {
            [self setImage:imgs[i] andImageView:imageView];
            
        }
            
    }
    
}
@end
