//
//  UIView+XIBInstance.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/3.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "UIView+XIBInstance.h"

@implementation UIView (XIBInstance)
+ (instancetype)instanceView
{
    NSArray *nibViewArr = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithUTF8String:object_getClassName([self class])] owner:nil options:nil];
    return [nibViewArr firstObject];
}

-(void)setborderWithBorderColor:(UIColor *)color Width:(CGFloat)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)setCircleWithRadius:(CGFloat)radius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

@end
