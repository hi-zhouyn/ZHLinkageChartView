//
//  ZHItemModel.h
//  ZHLinkageCart
//
//  Created by 周亚楠 on 2019/8/2.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHItemModel : NSObject
/* 总楼层 */
@property (nonatomic, assign) NSInteger layersCount;

/* 最高楼层 */
@property (nonatomic, assign) NSInteger topLayers;

/* 房屋编号 */
@property (nonatomic, copy) NSString *houseId;

/* 房屋名称（部位）：3-308 */
@property (nonatomic, copy) NSString *houseName;

/* 建筑面积 */
@property (nonatomic, copy) NSString *realBuildArea;

/* 套内面积 */
@property (nonatomic, copy) NSString *realInnerArea;

/* 房型编号 */
@property (nonatomic, copy) NSString *doorTypeCode;

/* 房型名称 */
@property (nonatomic, copy) NSString *doorTypeName;

/* 用途编码 */
@property (nonatomic, copy) NSString *layoutCode;

/* 用途名称 */
@property (nonatomic, copy) NSString *layoutName;

/* 朝向 */
@property (nonatomic, copy) NSString *orientation;

/* 物理层 */
@property (nonatomic, assign) NSInteger physicLayers;

/* 底部逻辑层 */
@property (nonatomic, assign) NSInteger lowerNominalLayer;

/* 高位逻辑层 */
@property (nonatomic, assign) NSInteger highNominalLayer;

/* 所在逻辑层 */
@property (nonatomic, assign) NSInteger onNominalLayer;

/* 单元 */
@property (nonatomic, assign) NSInteger unitNum;

/* 单元名称 */
@property (nonatomic, copy) NSString *unitName;

/* 单元内序号 */
@property (nonatomic, assign) NSInteger uIndex;

/* 价钱 */
@property (nonatomic, strong) NSNumber *price;

/* 状态：未售、网签、备案、已售 */
@property (nonatomic, copy) NSString *status;
@end

NS_ASSUME_NONNULL_END
