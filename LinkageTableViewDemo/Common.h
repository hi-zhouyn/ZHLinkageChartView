//
//  Common.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/23.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Common : NSObject

/**
 根据label宽度计算文字高度
 */
+ (CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

/**
 根据label计算文字高度
 */
+ (CGFloat)getTextHeightNotFontWithText:(UILabel *)label  width:(CGFloat)width;

/**
 根据label计算文字高度
 */
+ (CGFloat)getTextWidthNotFontWithText:(UILabel *)label  Height:(CGFloat)height;

/**
 根据label高度计算文字宽度
 */
+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font hight:(CGFloat)hight;
@end
