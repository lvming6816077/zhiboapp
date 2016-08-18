//
//  InputFacePanel.h
//  ZhiBo
//
//  Created by lvming on 16/7/11.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacePanel.h"
@protocol InputFacePanelDelegate <NSObject>

-(void) didToggleFace;
-(void) clickSubmit:(NSString*) str;

@end

@interface InputFacePanel : UIView<FacePanellDelegate>

@property(nonatomic, weak) id<InputFacePanelDelegate> delegate;

-(instancetype) initWithData:(NSDictionary*)option andFrame:(CGRect) frame;

-(void) focusInput:(FacePanel*) facePanel;
-(void) hideInput;


@end
