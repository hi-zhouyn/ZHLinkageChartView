//
//  ContractInfoBGCollectionViewCell.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/26.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractInfoItemView.h"
#import "AppDelegate.h"
#import "InfoModel.h"

#define KContractInfoBGCollectionViewCellID         @"ContractInfoBGCollectionViewCell"
#define KContractInfoBGCollectionViewCellHeight     35
#define KContractInfoBGCollectionViewCellWidth      115

typedef enum : NSUInteger {
    ContractInfoTypeHistory,
    ContractInfoTypeRoom,
    ContractInfoTypeMoney,
    ContractInfoTypeDocument,
} ContractInfoType;

@interface ContractInfoBGCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) ContractInfoType cellType;

@property (nonatomic, strong) NSMutableArray *viewArr;
@end
