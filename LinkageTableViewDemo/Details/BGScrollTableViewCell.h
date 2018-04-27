//
//  BGScrollTableViewCell.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/25.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ContractInfoBGCollectionViewCell.h"
#import "InfoModel.h"
#import "Common.h"

#define KBGScrollTableViewCellID         @"BGScrollTableViewCell"
#define KBGScrollTableViewCellRowHeight  35

@interface BGScrollTableViewCell : UITableViewCell
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, strong) NSNumber *infotypeNum;
@property (nonatomic, strong) UIScrollView *scrollView;
@end
