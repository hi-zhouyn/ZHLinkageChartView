//
//  BGTableViewCell.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/24.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomInfoCollectionViewCell.h"
#import "AppDelegate.h"
#import "HistoryCollectionViewCell.h"
#import "InfoModel.h"
#import "Common.h"

#define KBGTableViewCellID      @"BGTableViewCell"
#define KBGTableViewCellHeight  35

typedef NS_ENUM(NSUInteger, ContractInfoShowType) {
    ContractInfoShowTypeVertical = 1,//竖向展示
    ContractInfoShowTypeHorizontal,//横向滑动
//    ContractInfoShowTypeHorizontalEqually,
};


@interface BGTableViewCell : UITableViewCell
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, assign) ContractInfoShowType showType;
@property (nonatomic, strong) NSNumber *infotypeNum;
@end
