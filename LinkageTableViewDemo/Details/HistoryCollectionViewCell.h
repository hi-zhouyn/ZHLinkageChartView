//
//  HistoryCollectionViewCell.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/24.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KHistoryCollectionViewCellID      @"HistoryCollectionViewCell"
#define KHistoryCollectionViewCellHeight  35
#define KHistoryCollectionViewCellWidth   115

typedef enum : NSUInteger {
    HistoryCollectionViewCellTypeHistory,
    HistoryCollectionViewCellTypeRoom,
    HistoryCollectionViewCellTypeMoney,
    HistoryCollectionViewCellTypeDocument,
    HistoryCollectionViewCellTypeChanged,
} HistoryCollectionViewCellType;

@interface HistoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *setImageView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) HistoryCollectionViewCellType cellType;
@end
