//
//  ZHItemCollectionViewCell.h
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHItemModel.h"

#define KITEMHEIGHT      39 //表格高度
#define KITEMWIDTH       55 //表格宽度
#define KSPACE           10 //表格间距
#define KLINESPACE       15 //表格边距
#define KHEADHEIGHT      25 //表格顶部head高度
#define KSCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)

NS_ASSUME_NONNULL_BEGIN

@interface ZHItemCollectionViewCell : UICollectionViewCell

/**
 *  字段赋值
 *
 *  @param title          标题名字
 *  @param info           描述信息
 *  @param tag            0~左竖列，1~右部分表格
 */
- (void)updateDataWithTitle:(nullable NSString *)title info:(nullable NSString *)info tag:(NSInteger)tag;
@end

NS_ASSUME_NONNULL_END
