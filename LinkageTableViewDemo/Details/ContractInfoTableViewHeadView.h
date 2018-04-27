//
//  ContractInfoTableViewHeadView.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/24.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContractInfoTableViewHeadView;

#define KContractInfoTableViewHeadViewID      @"ContractInfoTableViewHeadView"
#define KContractInfoTableViewHeadViewHeight  40

@protocol ContractInfoTableViewHeadViewDelegate <NSObject>
- (void)headViewTapAction:(ContractInfoTableViewHeadView *)headView;
@end

@interface ContractInfoTableViewHeadView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIImageView *foldImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, weak) id<ContractInfoTableViewHeadViewDelegate>delegate;
@property (nonatomic, assign) NSInteger indexSection;
@property (nonatomic, assign) BOOL isOpen;
@end
