//
//  Defines.h
//  Wodu
//
//  Created by tenny on 15/12/24.
//  Copyright © 2015年 tenny. All rights reserved.
//

// device info
#define IsiPad     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IsiPhone   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IsRetain   ([[UIScreen mainScreen] scale] >= 2.0)
#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define ScreenMaxLength (MAX(ScreenWidth, ScreenHeight))
#define ScreenMinLength (MIN(ScreenWidth, ScreenHeight))

#define IsiPhone4   (IsiPhone && ScreenMaxLength < 568.0)
#define IsiPhone5   (IsiPhone && ScreenMaxLength == 568.0)
#define IsiPhone6   (IsiPhone && ScreenMaxLength == 667.0)
#define IsiPhone6P  (IsiPhone && ScreenMaxLength == 736.0)

// configs

#define HomeTabViewHeight  50
#define NewsColumnWidth  60
#define NewsTopViewHeight  36
//#define BaseCgiUrl @"http://zhibocgi.applinzi.com/index.php"

#define BaseCgiUrl @"http://localhost:8888/zhibocgi/index.php"

// utils

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define qiuniuUrl(key,size) [NSString stringWithFormat:@"http://tenny.qiniudn.com/%@?imageView2/2/w/%d",key,size]