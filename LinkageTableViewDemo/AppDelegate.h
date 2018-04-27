//
//  AppDelegate.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/2.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XIBInstance.h"
#import "Masonry.h"

#define kSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight self.navigationController.navigationBar.frame.size.height
#define kNavbarAndStatusHieght (kStatusBarHeight+kNavBarHeight)
#define kTabBarHeight self.tabBarController.tabBar.height
#define kSepWidth ([UIScreen mainScreen].bounds.size.width*3/4.0/14)
#define kLTableViewWidth  ([UIScreen mainScreen].bounds.size.width/4.0)

#define kFrameScreen ([UIScreen mainScreen].bounds)
#define kFrameWithoutBar (CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavbarAndStatusHieght-kTabBarHeight))
#define kFrameWithoutNav (CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavbarAndStatusHieght))
#define kFrameWithoutNavNotStatus (CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavBarHeight - kTabBarHeight))
#define kFrame (CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT))
#define kFrameWithoutTabBar (CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTabBarHeight))

/**
 *  HEX 16进制 设置颜色
 */
#define kBaseSetHEXColor(rgbValue,al) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(al)])

#define kSetHEXColorWithAlpha(rgbValue,al) kBaseSetHEXColor(rgbValue,al)

#define kSetHEXColor(rgbValue) kBaseSetHEXColor(rgbValue,1)

#define KDarkGreenColor   kSetHEXColor(0x8BC37C)
#define KLightGreenColor  kSetHEXColor(0xD9FFD8)
#define KLineGreenColor   kSetHEXColor(0x7CA67E)
#define KSectionGreenColor   kSetHEXColor(0x6AAF72)
#define KBGGreenColor     kSetHEXColor(0xDFF7DF)
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

