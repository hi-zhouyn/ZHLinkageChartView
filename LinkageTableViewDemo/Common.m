//
//  Common.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/23.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "Common.h"

@implementation Common
+(CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width
{
    NSDictionary *stringAttribute = @{NSFontAttributeName:font};
    CGRect frame = [(NSString *)text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:stringAttribute context:nil];
    return frame.size.height;
}

+ (CGFloat)getTextHeightNotFontWithText:(UILabel *)label  width:(CGFloat)width
{
    //文字的高
    CGSize size = CGSizeMake(width, 10000);
    CGSize labelSize = [label sizeThatFits:size];
    return labelSize.height;
}

+ (CGFloat)getTextWidthNotFontWithText:(UILabel *)label  Height:(CGFloat)height
{
    //文字的高
    CGSize size = CGSizeMake(10000, height);
    CGSize labelSize = [label sizeThatFits:size];
    return labelSize.width;
}

+(CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font hight:(CGFloat)hight
{
    NSDictionary *stringAttribute = @{NSFontAttributeName:font};
    CGRect frame = [(NSString *)text boundingRectWithSize:CGSizeMake(10000, hight) options:NSStringDrawingTruncatesLastVisibleLine attributes:stringAttribute context:nil];
    return frame.size.width;
}
@end
