//
//  StateCollectionReusableHeadView.h
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/23.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KStateCollectionReusableHeadViewID @"StateCollectionReusableHeadView"
#define KStateCollectionReusableHeadViewHeight 30

@interface StateCollectionReusableHeadView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *circleView;

@end
