//
//  Tips.m
//  ZhiBo
//
//  Created by lvming on 16/6/11.
//  Copyright © 2016年 tenny. All rights reserved.
//

#import "Tips.h"
#import "VCUtil.h"

@implementation Tips

+(void) showTips:(UIView *) view text:(NSString *)text {
    
    if (!view) {
        view = [VCUtil getCurrentVC].view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    //    self.hud.dimBackground = YES;
    //    self.hud.detailsLabelText = @"Test detail";
    [hud hide:YES afterDelay:2];
    
}
+(void) showeErrTips:(UIView *) view text:(NSString *)text {
    
    if (!view) {
        view = [VCUtil getCurrentVC].view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    //    self.hud.dimBackground = YES;
    //    self.hud.detailsLabelText = @"Test detail";
    [hud hide:YES afterDelay:2];
    
}


@end
