//
//  ZHTitleCollectionViewCell.h
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHTitleCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) BOOL showBorder;//是否显示边框
@property (nonatomic, copy) NSString *nameStr;
@end

NS_ASSUME_NONNULL_END
