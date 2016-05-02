//
//  PublishViewController.m
//  ZhiBo
//
//  Created by tenny on 16/2/17.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "PublishViewController.h"
#import "Defines.h"
#import "PhotoPickerViewController.h"
#import "PubOptionView.h"
#import "ImageScrollView.h"

#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#define OptionBarHeight 130


@interface PublishViewController ()
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *bottomOptionView;
@property(nonatomic,strong) UILabel *placeHolder;
@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表";
//    self.extendedLayoutIncludesOpaqueBars = true;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self initNavBtn];
    
    [self initContainerView];
    
    [self setTitleArea];

    [self setTextArea];

    [self setPubOption];


}

- (void) initNavBtn{
    
    // set left btn
    UIBarButtonItem *btnLeft = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    btnLeft.tintColor = [UIColor whiteColor];
    [btnLeft setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f], NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = btnLeft;
    
    //set right btn
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(clickPub:)];
    btnRight.tintColor = [UIColor whiteColor];
    [btnRight setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f], NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = btnRight;
    
}


-(void)initContainerView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavigationBarHeight-OptionBarHeight);
    NSLog(@"%f",NavigationBarHeight);
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(0, self.scrollView.frame.size.height+1);
    
    [self.view addSubview:self.scrollView];
    
}

-(void) setTitleArea{
    
    // set title input
    UITextField *titleInput = [[UITextField alloc] init];
    titleInput.frame = CGRectMake(15, 10, ScreenWidth-30, 25);
    titleInput.placeholder = @"标题";
    [titleInput setFont:[UIFont boldSystemFontOfSize:16.0f]];

    // set border line
    UIView *dividerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, .5f)];
    [dividerLineView setBackgroundColor:UIColorFromRGB(0xcccccc)];
    
    [titleInput becomeFirstResponder];
    

    [self.scrollView addSubview:titleInput];
    [self.scrollView addSubview:dividerLineView];

}
-(void) setTextArea{
    UITextView *textView = [[UITextView alloc] init];
    
    self.placeHolder = [[UILabel alloc] init];
    self.placeHolder.frame = CGRectMake(4, 7, 100, 20);
    
    self.placeHolder.enabled = false;
    self.placeHolder.backgroundColor = [UIColor clearColor];
    self.placeHolder.text = @"正文内容";
    self.placeHolder.textColor = UIColorFromRGB(0xc7c7cd);
    self.placeHolder.font = [UIFont systemFontOfSize:15.0f];
//    placeHolder.backgroundColor = [UIColor blueColor];
    [textView addSubview:self.placeHolder];
    textView.delegate = self;
    textView.frame = CGRectMake(12, 46, ScreenWidth-24, self.scrollView.frame.size.height-46);
    textView.text = @"";
    textView.scrollEnabled = false;
//    textView.backgroundColor = [UIColor redColor];
    textView.contentSize = CGSizeMake(0,0);

    textView.font = [UIFont boldSystemFontOfSize:15.0f];
    [textView setEditable:true];
    
    textView.scrollEnabled = true;
    [self.scrollView addSubview:textView];

}


-(void) setPubOption{
    
    CGFloat pubOptionViewHeight = 50;
    CGFloat imageScrollViewHeight = 80;
    PubOptionView *pubOptionView = [[PubOptionView alloc] initWithFrame:CGRectMake(0, imageScrollViewHeight, ScreenWidth, pubOptionViewHeight) andOption:@[@"chooseImage",@"chooseAddress"]];
    
    ImageScrollView *imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, imageScrollViewHeight)];
    [imageScrollView setTag:101];
//    imageScrollView.backgroundColor = [UIColor blueColor];

    self.bottomOptionView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-NavigationBarHeight-OptionBarHeight, ScreenWidth, OptionBarHeight)];
    
    [self.bottomOptionView addSubview:pubOptionView];
    [self.bottomOptionView addSubview:imageScrollView];
    [self.view addSubview:self.bottomOptionView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) back:(UIButton *)btn {
    [[[UIApplication sharedApplication] keyWindow] endEditing:true];
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}
-(void) clickPub:(UIButton *)btn {
    
}



#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView {
    
    if(textView.text.length == 0) {
        self.placeHolder.text = @"正文内容";
    } else {
        self.placeHolder.text = @"";
    }
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmax(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;

    // when change the frame reset the not scroll
    [textView setScrollEnabled:false];
    textView.contentSize = CGSizeMake(0,0);

    self.scrollView.contentSize = CGSizeMake(0, fmax(self.scrollView.frame.size.height+1,textView.frame.size.height+46));

}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self.view endEditing:YES];
}

#pragma mark - keyboard NSNotificationCenter

-(void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
////    CGRect keyboardBounds;
//    CGRect keyboardFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
////    keyboardFrame
//    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [self.view bringSubviewToFront:self.bottomOptionView];

    self.bottomOptionView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height);
    
}

#pragma mark - keyboard NSNotificationCenter

-(void)keyboardWillHide:(NSNotification*)notification {
    self.bottomOptionView.transform = CGAffineTransformIdentity;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
