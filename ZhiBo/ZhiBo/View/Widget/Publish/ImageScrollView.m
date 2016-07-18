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
//    PublishViewController *_pvc;
    IDMPhotoBrowser *_browser;
    NSMutableArray *_images;
    
}


-(instancetype) initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        _imageCount = 0;
        _lib = [ALAssetsLibrary new];
        self.showsHorizontalScrollIndicator = false;
        _idmPhotos = [[NSMutableArray alloc] init];
        _images = [[NSMutableArray alloc] init];
//        _pvc = [[PublishViewController alloc] init];
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
    
    [_images addObject:image];
    [_idmPhotos addObject:photo];

}
-(NSArray*)getCurrentImages{
    
    return _images;

}
-(void)imageViewClk:(UITapGestureRecognizer*) ges {
    UIImageView *currentImage = (UIImageView*)[ges view];
    _browser = [[IDMPhotoBrowser alloc] initWithPhotos:_idmPhotos];
    _browser.displayCounterLabel = YES;
    _browser.displayActionButton = NO;
    _browser.displayDoneButton = NO;
    _browser.displayArrowButton = NO;
//    _browser.usePopAnimation = true;
    _browser.forceHideStatusBar = false;
    _browser.autoHideInterface = NO;

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
                
                
                if (!asset) {
                    [_lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                       usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                     {
                         [group enumerateAssetsWithOptions:NSEnumerationReverse
                                                usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                    
                                                    if([[result valueForProperty:ALAssetPropertyAssetURL] isEqual:imgs[i]])
                                                    {
                                                        image = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                                                        [self setImage:image andImageView:imageView];
                                                        *stop = YES;
                                                    }
                                                }];
                     }
                                     failureBlock:^(NSError *error)
                     {
                         
                     }];
                    
                } else {
                    image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    [self setImage:image andImageView:imageView];
                }
                
                

            } failureBlock:^(NSError *error) {
                
            }];
        } else {
            [self setImage:imgs[i] andImageView:imageView];
            
        }
            
    }
    
}
@end
