//
//  UIView+XIBInstance.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/3.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XIBInstance)

+ (instancetype)instanceView;

// 添加边框 自定义边框颜色，宽度
- (void)setborderWithBorderColor:(UIColor *)color Width:(CGFloat) width;

- (void)setCircleWithRadius:(CGFloat)radius;
@end
