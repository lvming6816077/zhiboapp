//
//  InputFacePanel.m
//  ZhiBo
//
//  Created by lvming on 16/7/11.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "InputFacePanel.h"
#import "Defines.h"

@implementation InputFacePanel
{
    UITextView *_textView;
    FacePanel *_facePanel;
    BOOL _clickFace;
    CGFloat _inputY;
}

-(instancetype) initWithData:(NSDictionary*)option andFrame:(CGRect) frame {
    
    
    if (self == [super initWithFrame:frame]) {
        _clickFace = NO;
        UIView *topBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        topBorderView.backgroundColor = UIColorFromRGB(0xcccccc);//b8b8b8
        self.backgroundColor = UIColorFromRGB(0xfafafa);
        [self addSubview:topBorderView];
        [self initInput];
    }
    
    return self;
}
-(void) focusInput:(FacePanel*) facePanel {
    if (facePanel) {
        _facePanel = facePanel;
        _facePanel.delegate = self;
    }
    [_textView becomeFirstResponder];
}
-(void) hideInput {
    [_textView resignFirstResponder];
    [UIView animateWithDuration:.2 animations:^{
        self.transform = CGAffineTransformIdentity;
        _facePanel.transform = CGAffineTransformIdentity;
    }];
    
}
-(void) initInput {
    CGFloat height = 35;
    CGFloat cy = 8;
    UIImageView *faceIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, cy+4, 25, 25)];
    [faceIconImageView setImage:[UIImage imageNamed:@"faceIcon"]];
    faceIconImageView.userInteractionEnabled = YES;
    [faceIconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didToggleFace:)]];
    [self addSubview:faceIconImageView];
    
    CGFloat sbtnWidth = 40;
    CGFloat textWidth = self.frame.size.width-30-sbtnWidth-20;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(35, cy, textWidth, height)];
//    _textView.shouldAvoidEmoji =YES;
    _textView.layer.borderColor = UIColorFromRGB(0xe2e2e2).CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.font = [UIFont systemFontOfSize:15.0];
    _textView.textContainerInset = UIEdgeInsetsMake(8.5,3,0,0);
    [self addSubview:_textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(_textView.frame.origin.x+_textView.frame.size.width+7, cy, sbtnWidth, height);
    [submitBtn setTitle:@"发送" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [submitBtn setBackgroundColor:UIColorFromRGB(0X0078cd)];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitBtn];
}
-(void) clickSubmit:(UIButton*)btn {
    NSString *str = _textView.text;
    [self.delegate clickSubmit:str];
}
-(void) didToggleFace:(UITapGestureRecognizer*) ges {
    _clickFace = YES;
    [_textView resignFirstResponder];
    [self.delegate didToggleFace];
    
    [UIView animateWithDuration:.2 animations:^{
        _facePanel.transform = CGAffineTransformMakeTranslation(0, -_facePanel.frame.size.height);
    }];
}
#pragma mark - keyboard NSNotificationCenter
-(void)keyboardWillShow:(NSNotification*)notification {
    if (_textView.isFirstResponder) {
        NSDictionary* info = [notification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        ////    CGRect keyboardBounds;
        //    CGRect keyboardFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        ////    keyboardFrame
        //    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        //    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        //    [self.view bringSubviewToFront:self.bottomOptionView];
        
        _inputY = -kbSize.height-self.frame.size.height;
        
        self.transform = CGAffineTransformMakeTranslation(0, _inputY);
        _facePanel.transform = CGAffineTransformIdentity;
    }
    
    
}

#pragma mark - keyboard NSNotificationCenter
-(void)keyboardWillHide:(NSNotification*)notification {
    if (_textView.isFirstResponder) {
        if (_clickFace) {
            [UIView animateWithDuration:.2 animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, -_facePanel.frame.size.height-self.frame.size.height);
            }];
            
        } else {
            self.transform = CGAffineTransformIdentity;
        }
    }
    
    
}
#pragma mark - FaceDelegate
-(void) didSelectFace:(NSString *)currentFace {
    NSLog(@"%@",currentFace);
//    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,currentFace];
    [_textView insertText:currentFace];
}
-(void) didBackFace {
    
    [_textView deleteBackward];

}


@end
