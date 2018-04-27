//
//  BGCollectionViewCell.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/4.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#define KBGCollectionViewCellID      @"BGCollectionViewCell"



typedef enum : NSUInteger {
    BGCollectionViewCellTypeAllFloor = 0,
    BGCollectionViewCellTypeSelectFloor,
} BGCollectionViewCellType;

@interface BGCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat scale;//缩放比例
@property (nonatomic, assign) CGFloat fontScale;
@property (nonatomic, assign) BGCollectionViewCellType cellType;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL selNow;//选择的当前collectionView
@property (nonatomic, assign) NSInteger floorNum;//选择的楼层
@property (nonatomic, assign) NSInteger roomNum;//选择的楼层
@end
