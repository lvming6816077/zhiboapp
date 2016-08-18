//
//  PubOptionView.m
//  ZhiBo
//
//  Created by tenny on 16/2/28.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "PubOptionView.h"
#import "PublishViewController.h"
#import "Defines.h"
#import "ImageScrollView.h"
#import "DNAsset.h"
#import "DNPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "VCUtil.h"
#import "FacePanel.h"

@interface PubOptionView ()
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) FacePanel *faceView;
@property (nonatomic, strong) UIView *bottomOptionView;
@end
@implementation PubOptionView
{
    NSMutableArray *_selectedPhoto;
    UIButton *_chooseAddress;
    NSDictionary *_currentPosition;
    BOOL _clickFace;

}

-(instancetype) initWithFrame:(CGRect)frame andOption:(NSArray*)optionList{

    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _clickFace = NO;
        _selectedPhoto = [NSMutableArray new];
        _currentPosition = nil;
        [self initOptionView:optionList];
    
    }
    
    return self;
}

-(void) initOptionView:(NSArray*)optionList {
    
    NSMutableDictionary *opt = [[NSMutableDictionary alloc] init];
    for (int i = 0 ; i < optionList.count ; i++) {
        [opt setObject:@"" forKey:optionList[i]];
    }

//    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addressBtn setTitle:@"address" forState:UIControlStateNormal];
//    [addressBtn setImage:[UIImage imageNamed:@"chooseAddress"] forState:UIControlStateNormal];
//    addressBtn.frame = CGRectMake(15+i*30, 15, 30, 30);
//    self.backgroundColor = [UIColor grayColor];
//    for (int i = 0 ; i < optionList.count ; i++) {
//        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        chooseBtn.frame = CGRectMake(20+i*30, 20, 30, 30);
//        [chooseBtn setTag:i +100];
//        [chooseBtn setImage:[UIImage imageNamed:optionList[i]] forState:UIControlStateNormal];
//        [chooseBtn addTarget:self action:@selector(openView:) forControlEvents:UIControlEventTouchUpInside];
//        [chooseBtn setTitle:optionList[i] forState:UIControlStateNormal];
//        [self addSubview:chooseBtn];
//    }
    
    
//    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *faceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"faceIcon"]];
    
    faceImageView.frame = CGRectMake(6, self.frame.size.height-22-8, 22 , 22);
        
//    [chooseBtn setImage:[UIImage imageNamed:@"chooseImage"] forState:UIControlStateNormal];
    
    faceImageView.userInteractionEnabled = YES;
    [faceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didToggleFace:)]];
        
    [self addSubview:faceImageView];
        
    
    
    if ([opt valueForKey:@"chooseImage"]) {
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        chooseBtn.frame = CGRectMake(36, self.frame.size.height-26-8, 21 , 26);
        
        [chooseBtn setImage:[UIImage imageNamed:@"chooseImage"] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(showChooseImg) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:chooseBtn];
        
    }
    
    
    if ([opt valueForKey:@"chooseAddress"]) {
        _chooseAddress = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseAddress.frame = CGRectMake(self.frame.size.width-16-200, self.frame.size.height-26-8, 200, 26);
        
        
        [_chooseAddress setImage:[UIImage imageNamed:@"chooseAddress"] forState:UIControlStateNormal];
        [_chooseAddress setImage:[UIImage imageNamed:@"chooseAddressSelect"] forState:UIControlStateSelected];
        
        [_chooseAddress setTitle:@"" forState:UIControlStateNormal];
        _chooseAddress.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _chooseAddress.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
        [_chooseAddress setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_chooseAddress setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [_chooseAddress addTarget:self action:@selector(openPosition:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chooseAddress];
        
    }
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
}
-(void)openPosition:(UIButton*)btn {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:true];
    PublishViewController *vc = (PublishViewController*)[VCUtil getPresentedViewController];
    ChoosePositionViewController *choosePosition = [[ChoosePositionViewController alloc] init];
    choosePosition.delegate = self;
    choosePosition.currentCellCoordinate = _currentPosition;
    [vc.navigationController pushViewController:choosePosition animated:true];


}
-(NSDictionary*) getCurrentPosition{
    if (!_currentPosition) {
        return @{@"longitude":@"",
                @"latitude":@"",
                 @"name":@"",
                 @"address":@""};
    }
    return _currentPosition;
}
-(void) openView:(UIButton*) btn {
    
    if ([[btn currentTitle] isEqualToString:@"chooseImage"]) {
        [self showChooseImg];
    
    }

}
-(void) didToggleFace:(UITapGestureRecognizer*) ges {
    
    _clickFace = YES;
    UIViewController *vc = [VCUtil getPresentedViewController];
    
    self.faceView = [vc.view viewWithTag:102];
    
    [vc.view endEditing:YES];
}
#pragma mark - keyboard NSNotificationCenter

-(void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    ////    CGRect keyboardBounds;
    //    CGRect keyboardFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    ////    keyboardFrame
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
//    [self.view bringSubviewToFront:self.bottomOptionView];
    
//    [self performSelector:@selector(delayMethod:) withObject:[NSString stringWithFormat:@"%f",kbSize.height] afterDelay:.1f];
//    NSLog(@"%@",duration);
    
//    [UIView animateWithDuration:[duration floatValue]  animations:^{
//        
//        
//    }];
//    NSLog(@"x:%f",kbSize.height);
    if (kbSize.height > 0) {
        self.transform = CGAffineTransformMakeTranslation(0, -kbSize.height);
        
        self.faceView.transform = CGAffineTransformIdentity;
    }
    
}
-(void) delayMethod:(NSString*)height {
    
}
#pragma mark - keyboard NSNotificationCenter

-(void)keyboardWillHide:(NSNotification*)notification {
    if (_clickFace) {
        [UIView animateWithDuration:.2 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, -self.faceView.frame.size.height);
            self.faceView.transform = CGAffineTransformMakeTranslation(0, -self.faceView.frame.size.height);
            
        }];
        _clickFace = NO;
        
    } else {
        self.transform = CGAffineTransformIdentity;
    }
    
}

-(void) showChooseImg{
//    [[VCUtil getPresentedViewController].view endEditing:YES];
//    PublishViewController *vc = (PublishViewController*)[self.superview nextResponder];
//        
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
//        
//        
//        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [vc presentViewController:imgPicker animated:YES completion:nil];
//    }]];
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self openPhotoBrower];
//    }]];
//    
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsheet showInView:self];

    
//    [vc presentViewController:actionSheet animated:YES completion:nil];

}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    PublishViewController *vc = (PublishViewController*)[self.superview nextResponder];
    if (buttonIndex == 0) {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.delegate = self;
//        imgPicker.allowsEditing = true;
        [vc presentViewController:imgPicker animated:YES completion:nil];
    } else if(buttonIndex == 1) {
    
        [self openPhotoBrower];
    }

}
-(void) openPhotoBrower {
    
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    imagePicker.imagePickerDelegate = self;
    PublishViewController *vc = (PublishViewController*)[self.superview nextResponder];
    [vc presentViewController:imagePicker animated:YES completion:nil];
    
    
}
#pragma mark - choosePositionViewControllerDelegate
-(void) selectAddress:(NSDictionary *)dic {
    _currentPosition = dic;
    if (dic) {
        _chooseAddress.selected = true;
        [_chooseAddress setTitle:dic[@"name"] forState:UIControlStateNormal];
    } else {
        _chooseAddress.selected = false;
        [_chooseAddress setTitle:nil forState:UIControlStateNormal];
    }
    

}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    ImageScrollView *imageScroll = (ImageScrollView*)[[self.superview viewWithTag:104] viewWithTag:101];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        CGSize imagesize = image.size;
        imagesize.height = ScreenHeight*2;
        imagesize.width = ScreenWidth*2;
        //对图片大小进行压缩--
        image = [self imageWithImage:image scaledToSize:imagesize];
//        NSData *imageData = UIImageJPEGRepresentation(imageNew,0.00001);
        [imageScroll addImage:@[image]];
        [picker dismissViewControllerAnimated:true completion:nil];
    }
    
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
#pragma mark - DNImagePickerControllerDelegate

- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage andAssets:(NSArray*) asstesImages
{
    

    ImageScrollView *imageScroll = (ImageScrollView*)[[self.superview viewWithTag:104] viewWithTag:101];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:imageAssets.count];
    for(DNAsset* asset in imageAssets) {
        
        [arr addObject:asset.url];
        [_selectedPhoto addObject:asset];
    
    }
    [imageScroll addImage:arr];

}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)viewDidUnload{
//    [super viewDidUnload];
    
}
@end
