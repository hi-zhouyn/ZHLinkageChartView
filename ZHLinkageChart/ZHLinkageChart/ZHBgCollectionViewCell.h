//
//  ZHBgCollectionViewCell.h
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ItemSelectBlock)(NSIndexPath *indexPath,NSInteger index);

@protocol ZHBgCollectionViewCellDelegate <NSObject>

/** 滑动回调 */
- (void)itemCollectionViewDidScroll:(UIScrollView *)scrollView;
/** 点击回调 */
- (void)itemDidSelectIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index;

@end

@interface ZHBgCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *itemArr;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<ZHBgCollectionViewCellDelegate>zh_itemDelegate;
@property (nonatomic, copy) ItemSelectBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
