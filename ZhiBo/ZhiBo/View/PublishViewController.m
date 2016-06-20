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
#import "AFNetworking.h"
#import "HttpUtil.h"
#import "LoginUtil.h"


#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#define OptionBarHeight 130




@interface PublishViewController ()
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *bottomOptionView;
@property(nonatomic,strong) UILabel *placeHolder;
@property(nonatomic,strong) ImageScrollView *imageScrollView;
@property(nonatomic,strong) UITextField *titleInput;
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) PubOptionView *pubOptionView;


@property(nonatomic,assign) PubType pubType;
@property(nonatomic,strong) NSString *pid;
@end

@implementation PublishViewController
{
    BOOL _isPub;
}


-(instancetype) initWithPubType:(PubType) type andOption:(NSDictionary*) dic {
    if (self == [super init]) {
    
        self.pubType = type;
        _isPub = self.pubType == PubTypePost;
        
        self.pid = dic[@"pid"];
    }
    
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.pubType == PubTypePost) {
        self.title = @"发表";
    } else {
        self.title = @"回复";
    }
    
//    self.extendedLayoutIncludesOpaqueBars = true;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self initNavBtn];
    
    [self initContainerView];
    
    if (self.pubType == PubTypePost) {
        [self setTitleArea];
    }
    
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
    UIBarButtonItem *btnRight;
    
    if (self.pubType == PubTypePost) {
        btnRight = [[UIBarButtonItem alloc] initWithTitle:@"发表"  style:UIBarButtonItemStylePlain target:self action:@selector(clickPub:)];
    } else {
        btnRight = [[UIBarButtonItem alloc] initWithTitle:@"回复"  style:UIBarButtonItemStylePlain target:self action:@selector(clickReply:)];
    }
    
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
    self.titleInput = [[UITextField alloc] init];
    self.titleInput.frame = CGRectMake(15, 10, ScreenWidth-30, 25);
    self.titleInput.placeholder = @"标题";
    [self.titleInput setFont:[UIFont boldSystemFontOfSize:16.0f]];

    // set border line
    UIView *dividerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, .5f)];
    [dividerLineView setBackgroundColor:UIColorFromRGB(0xcccccc)];
    
    [self.titleInput becomeFirstResponder];
    
    

    [self.scrollView addSubview:self.titleInput];
    [self.scrollView addSubview:dividerLineView];

}
-(void) setTextArea{
    CGFloat y = _isPub ? 46 : 14;
    self.textView = [[UITextView alloc] init];
//    self.textView.backgroundColor = [UIColor redColor];
    
    self.placeHolder = [[UILabel alloc] init];
    self.placeHolder.frame = CGRectMake(4, 7, 100, 20);
    
//    self.placeHolder.enabled = false;
    self.placeHolder.backgroundColor = [UIColor clearColor];
    self.placeHolder.text = @"正文内容";//UIColorFromRGB(0xc3c3c9);
    self.placeHolder.textColor = UIColorFromRGB(0xC7C7CD);
    self.placeHolder.font = [UIFont boldSystemFontOfSize:15.0f];
//    placeHolder.backgroundColor = [UIColor blueColor];
    [self.textView addSubview:self.placeHolder];
    self.textView.delegate = self;
    self.textView.frame = CGRectMake(12, y, ScreenWidth-24, self.scrollView.frame.size.height-y);
    self.textView.text = @"";
    self.textView.scrollEnabled = false;
//    textView.backgroundColor = [UIColor redColor];
    self.textView.contentSize = CGSizeMake(0,0);

    self.textView.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.textView setEditable:true];
    
    self.textView.scrollEnabled = true;
    [self.scrollView addSubview:self.textView];
    
    
    if (!_isPub) {
        [self.textView becomeFirstResponder];
    }

}


-(void) setPubOption {
    
    CGFloat pubOptionViewHeight = 50;
    CGFloat imageScrollViewHeight = 80;
    self.pubOptionView = [[PubOptionView alloc] initWithFrame:CGRectMake(0, imageScrollViewHeight, ScreenWidth, pubOptionViewHeight) andOption:@[@"chooseImage",@"chooseAddress"]];
    
    self.imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, imageScrollViewHeight)];
    [self.imageScrollView setTag:101];
//    imageScrollView.backgroundColor = [UIColor blueColor];

    self.bottomOptionView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-NavigationBarHeight-OptionBarHeight, ScreenWidth, OptionBarHeight)];
    
    [self.bottomOptionView addSubview:self.pubOptionView];
    [self.bottomOptionView addSubview:self.imageScrollView];
    [self.view addSubview:self.bottomOptionView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) back:(UIButton *)btn {
    [[[UIApplication sharedApplication] keyWindow] endEditing:true];
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}
//-(void) clickPub:(UIButton *)btn {
//    NSArray *images = [self.imageScrollView getCurrentImages];
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://10.66.69.180:8888/zhibo/index.php/post/createPost" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (int i = 0; i<images.count; i++) {
//            UIImage *uploadImage = images[i];
//            [formData appendPartWithFileData:UIImagePNGRepresentation(uploadImage) name:@"file" fileName:@"test.jpg" mimeType:@"image/jpg"];
//        }
//    } error:nil];
//    
//    AFHTTPRequestOperation *opration = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    
//    [opration setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
////        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSMutableDictionary *dic = [(NSDictionary*)responseObject valueForKey:@"content"];
//        NSLog(@"%@",dic);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    [opration start];
//}
-(void) clickReply:(UIButton *)btn {
    [self.view endEditing:YES];
    [self showLoading];
    
    NSArray *images = [self.imageScrollView getCurrentImages];
    
    NSString *content = self.textView.text;

    
    
    NSString *uid = [LoginUtil getCurrentUserId];
    NSString *pid = self.pid;
    
    if (!uid || !pid) return;
    
    NSDictionary *dic = @{
                          @"content":content,
                          @"uid":uid,
                          @"pid":pid};
    
    
    
    [[HttpUtil shareInstance] post:[NSString stringWithFormat:@"%@/reply/createReply", BaseCgiUrl]parameters:dic formBody:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i<images.count; i++) {
            UIImage *uploadImage = images[i];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(uploadImage,0.5) name:images.count > 1 ? @"file[]" : @"file" fileName:[NSString stringWithFormat:@"%dname.jpg",i] mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dic = [(NSDictionary*)responseObject valueForKey:@"content"];
        NSLog(@"%@",dic);
        [self hideLoading];
        
        [self back:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoading];
    }];

}
-(void) clickPub:(UIButton *)btn {
    [self.view endEditing:YES];
    [self showLoading];
    
    NSArray *images = [self.imageScrollView getCurrentImages];
    
    NSString *title = self.titleInput.text;
    NSString *content = self.textView.text;
    NSDictionary *poi = [self.pubOptionView getCurrentPosition];
    NSString *longitude = poi[@"longitude"];
    NSString *latitude = poi[@"latitude"];
    NSString *city = [NSString stringWithFormat:@"%@ %@",poi[@"city"],poi[@"name"]];
    NSString *address = poi[@"address"];
    
    
    NSString *uid = [LoginUtil getCurrentUserId];
    
    if (!uid) return;
    
    NSDictionary *dic = @{@"title":title,
                          @"content":content,
                          @"longitude":longitude,
                          @"latitude":latitude,
                          @"city":city,
                          @"address":address,
                          @"uid":uid};
    
    
    
    
    [[HttpUtil shareInstance] post:[NSString stringWithFormat:@"%@/post/createPost", BaseCgiUrl]parameters:dic formBody:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i<images.count; i++) {
            UIImage *uploadImage = images[i];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(uploadImage,0.5) name:images.count > 1 ? @"file[]" : @"file" fileName:[NSString stringWithFormat:@"%dname.jpg",i] mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dic = [(NSDictionary*)responseObject valueForKey:@"content"];
        NSLog(@"%@",dic);
        [self hideLoading];
        
        [self back:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoading];
    }];
    
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
