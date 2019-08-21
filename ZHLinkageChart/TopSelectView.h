//
//  TopSelectView.h
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KTopSelectViewHeight  50

NS_ASSUME_NONNULL_BEGIN

@protocol TopSelectViewDelegate <NSObject>

- (void)selectAction:(NSIndexPath *)indexPath;

@end

@interface TopSelectView : UIView
@property (nonatomic, strong) NSArray *allKeysArr;
@property (nonatomic, weak) id<TopSelectViewDelegate>zh_delegate;
@end

NS_ASSUME_NONNULL_END
