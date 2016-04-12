//
//  PhotoPickerViewController.m
//  ZhiBo
//
//  Created by tenny on 16/2/25.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"

@interface PhotoPickerViewController ()

@end

@implementation PhotoPickerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadAssets];

   
}
-(void) initPhotoData{
    
    
    self.gridScrollView = [[UIScrollView alloc] init];

    self.gridScrollView.frame = self.view.bounds;
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];

    NSMutableArray *copy = [_assets copy];
    if (NSClassFromString(@"PHAsset")) {
        // Photos library
        UIScreen *screen = [UIScreen mainScreen];
        CGFloat scale = screen.scale;
        // Sizing is very rough... more thought required in a real implementation
        CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
        CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale);
        CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale);
        
        
//        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];

        NSInteger count = 0;
        for (PHAsset *asset in copy) {
            UIImageView *img = [[UIImageView alloc] init];
            img.frame = CGRectMake(count % 3 * thumbTargetSize.width, count % 3 * thumbTargetSize.height, thumbTargetSize.width, thumbTargetSize.height);
//            [PHImageManager defaultManager] cancelImageRequest:<#(PHImageRequestID)#>
//            PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
//            opt.synchronous = true;
//            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:thumbTargetSize contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//                img.image = result;
//            }];
//            [self.gridScrollView addSubview:img];
            [photos addObject:asset];
            [thumbs addObject:asset];
            PHImageManager *imageManager = [PHImageManager defaultManager];
            
            PHImageRequestOptions *options = [PHImageRequestOptions new];
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            options.synchronous = false;
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithDouble: progress], @"progress",
                                      self, @"photo", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_PROGRESS_NOTIFICATION object:dict];
            };
            
            [imageManager requestImageForAsset:asset targetSize:thumbTargetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    img.image = result;
                });
            }];
            [self.gridScrollView addSubview:img];
            count++;
        }
    } else {
        // Assets library
        for (ALAsset *asset in copy) {
            MWPhoto *photo = [MWPhoto photoWithURL:asset.defaultRepresentation.url];
            [photos addObject:photo];
            MWPhoto *thumb = [MWPhoto photoWithImage:[UIImage imageWithCGImage:asset.thumbnail]];
            [thumbs addObject:thumb];
            if ([asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
                photo.videoURL = asset.defaultRepresentation.url;
                thumb.isVideo = true;
            }
        }
    }
    //    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    self.delegate = self;
//    self.displayActionButton = true;
//    self.displayNavArrows = true;
//    self.displaySelectionButtons = true;
//    self.alwaysShowControls = true;
//    self.zoomPhotosToFill = YES;
//    self.enableGrid = true;
//    self.startOnGrid = true;
//    self.enableSwipeToDismiss = YES;
//    self.autoPlayOnAppear = false;
//    [self setCurrentPhotoIndex:0];
    
    self.photos = photos;
    self.thumbs = thumbs;
    
    
    [self.view addSubview:self.gridScrollView];

    
    
    

}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

#pragma mark - Load Assets

- (void)loadAssets {
    if (NSClassFromString(@"PHAsset")) {
        
        // Check library permissions
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performLoadAssets];
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self performLoadAssets];
        }
        
    } else {
        
        // Assets library
        [self performLoadAssets];
        
    }
}

- (void)performLoadAssets {
    
    // Initialise
    _assets = [NSMutableArray new];
    
    // Load
    if (NSClassFromString(@"PHAsset")) {
        
        // Photos library iOS >= 8
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
            [fetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_assets addObject:obj];
            }];
        
            [self initPhotoData];

        });

        
    } else {
        
        // Assets Library iOS < 8
        _ALAssetsLibrary = [[ALAssetsLibrary alloc] init];
        
        // Run in the background as it takes a while to get all assets from the library
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
            NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
            
            // Process assets
            void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto] || [assetType isEqualToString:ALAssetTypeVideo]) {
                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        NSURL *url = result.defaultRepresentation.url;
                        [_ALAssetsLibrary assetForURL:url
                                          resultBlock:^(ALAsset *asset) {
                                              if (asset) {
                                                  @synchronized(_assets) {
                                                      [_assets addObject:asset];
                                                  }
                                                  [self initPhotoData];
                                              }
                                          }
                                         failureBlock:^(NSError *error){
                                             NSLog(@"operation was not successfull!");
                                         }];
                        
                    }
                }
            };
            
            // Process groups
            void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group != nil) {
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                    [assetGroups addObject:group];
                }
            };
            
            // Process!
            [_ALAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                            usingBlock:assetGroupEnumerator
                                          failureBlock:^(NSError *error) {
                                              NSLog(@"There is an error");
                                          }];
            
        });
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
