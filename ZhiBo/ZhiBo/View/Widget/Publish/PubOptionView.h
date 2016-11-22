//
//  PubOptionView.h
//  ZhiBo
//
//  Created by tenny on 16/2/28.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNImagePickerController.h"
#import "DNPhotoBrowser.h"
#import "ChoosePositionViewController.h"
#import "ImageScrollView.h"
@interface PubOptionView : UIView

<DNImagePickerControllerDelegate,

ChoosePositionViewControllerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>



@property(nonatomic,strong) NSArray *optionList;

-(instancetype) initWithFrame:(CGRect)frame andOption:(NSArray*)optionList andImageScrollView:(ImageScrollView*) imageScrollView;
-(NSDictionary*) getCurrentPosition;

-(void)keyboardWillHide:(NSNotification*)notification;
-(void)keyboardWillShow:(NSNotification*)notification;
@end
