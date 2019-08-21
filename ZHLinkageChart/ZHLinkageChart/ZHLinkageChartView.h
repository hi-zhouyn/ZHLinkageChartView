//
//  ZHLinkageChartView.h
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHItemModel.h"
@class ZHLinkageChartView;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZHLinkageChartViewSelectTypeTop = 1,  //顶部区域
    ZHLinkageChartViewSelectTypeLeft,     //左边区域
    ZHLinkageChartViewSelectTypeItem,     //item
} ZHLinkageChartViewSelectType;

@protocol ZHLinkageChartViewDelegate <NSObject>

/**
 *  点击事件回调
 *
 *  @param chartView          当前视图
 *  @param type               点击区域类型
 *  @param indexPath          用于ZHLinkageChartViewSelectTypeItem下配合index进行定位
 *  @param index              下标
 *
 */
- (void)linkageChartViewDidSelect:(ZHLinkageChartView *)chartView type:(ZHLinkageChartViewSelectType)type indexPath:(NSIndexPath *)indexPath index:(NSInteger)index;

@end

@interface ZHLinkageChartView : UIView
@property (nonatomic, strong) NSArray *dataArr; //传入数据源
@property (nonatomic, strong) NSArray *allKeysArr;//顶部head数据源
@property (nonatomic, strong) ZHItemModel *itemModel;//包含总楼层、最高楼层的数据模型，用于左边竖列数据展示

@property (nonatomic, weak) id<ZHLinkageChartViewDelegate>zh_delegate;

/** 快速选择 */
- (void)speedSelectIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
