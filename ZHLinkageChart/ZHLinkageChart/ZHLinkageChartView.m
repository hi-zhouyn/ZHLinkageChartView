//
//  ZHLinkageChartView.m
//  ZHLinkageChart
//
//  Created by 周亚楠 on 2019/8/14.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ZHLinkageChartView.h"
#import "Masonry.h"
#import "ZHBgCollectionViewCell.h"
#import "ZHTitleCollectionViewCell.h"
#import "ZHItemCollectionViewCell.h"

@interface ZHLinkageChartView ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
ZHBgCollectionViewCellDelegate>

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UICollectionView *leftCollectionView;
@property (nonatomic, strong) UICollectionView *headCollectionView;
@property (nonatomic, strong) UICollectionView *bgCollectionView;
@property (nonatomic, assign) NSInteger refreshCount;//需要刷新的个数
@end

@implementation ZHLinkageChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self leftCollectionView];
        [self headCollectionView];
        [self bgCollectionView];
    }
    return self;
}

- (void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    self.refreshCount = ceil((KSCREEN_WIDTH - KITEMWIDTH - KSPACE - KLINESPACE * 2) / (KITEMWIDTH + KSPACE));
}

/** 快速选择 */
- (void)speedSelectIndexPath:(NSIndexPath *)indexPath
{
    //此处用section进行下标判断选择
    [self.headCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] animated:YES scrollPosition:(UICollectionViewScrollPositionLeft)];
}

/** 处理多向滑动 */
- (void)itemCollectionViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.headCollectionView){
        self.bgCollectionView.contentOffset = CGPointMake(self.headCollectionView.contentOffset.x, 0);
    }else if (scrollView == self.bgCollectionView){
        self.headCollectionView.contentOffset = CGPointMake(self.bgCollectionView.contentOffset.x, 0);
    }
    
    if (scrollView == self.headCollectionView || scrollView == self.bgCollectionView || scrollView == self.leftCollectionView){
        [self updateCollectionViewOffictYWithView:self.leftCollectionView];
    }else{
        self.leftCollectionView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
        [self updateCollectionViewOffictYWithView:self.leftCollectionView];
    }
}

//循环取出赋值偏移量
- (void)updateCollectionViewOffictYWithView:(UIScrollView *)view
{
    NSIndexPath *indexPath = [self.bgCollectionView indexPathForItemAtPoint:self.bgCollectionView.contentOffset];
    NSInteger min = indexPath.section - self.refreshCount;
    NSInteger max = indexPath.section + self.refreshCount;
    max = max > self.dataArr.count ? self.dataArr.count : max;
    min = min > 0 ? min : 0;
    for (NSInteger i = min; i < max; i ++) {
        for (NSInteger j = 0; j < [self.dataArr[i] count]; j ++) {
            ZHBgCollectionViewCell *cell = (ZHBgCollectionViewCell *)[self.bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            if (!cell) {
                continue;
            }
            if (cell.collectionView.contentOffset.y == view.contentOffset.y) {
                continue;
            }
            cell.collectionView.contentOffset = CGPointMake(0, view.contentOffset.y);
        }
    }
}

#pragma mark - UICollectionViewDelegate | UICollectionViewdataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.leftCollectionView) {
        return self.itemModel.layersCount;
    }
    return self.allKeysArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.bgCollectionView) {
        return [self.dataArr[section] count];
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.headCollectionView){
        ZHTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZHTitleCollectionViewCell class]) forIndexPath:indexPath];
        cell.showBorder = YES;
        cell.nameStr = [NSString stringWithFormat:@"%@单元",self.allKeysArr[indexPath.section]];
        return cell;
    }else if (collectionView == self.bgCollectionView){
        ZHBgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZHBgCollectionViewCell class]) forIndexPath:indexPath];
        cell.tag = indexPath.row;
        cell.indexPath = indexPath;
        cell.itemArr = self.dataArr[indexPath.section][indexPath.row];
        cell.zh_itemDelegate = self;//用于回调事件
        return cell;
    }else { 
        ZHItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZHItemCollectionViewCell class]) forIndexPath:indexPath];
        NSInteger layer = self.itemModel.topLayers - indexPath.section;
        //考虑地下层的情况
        if (layer <= 0 && self.itemModel.topLayers > 0) {
            layer = layer - 1;
        }
        NSString *title = [NSString stringWithFormat:@"%ld楼",layer];
        NSString *info = [NSString stringWithFormat:@"物理层%ld",self.itemModel.layersCount - indexPath.section];
        [cell updateDataWithTitle:title info:info tag:0];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.headCollectionView){
        [self linkageChartViewDidSelectType:1 indexPath:nil index:indexPath.section];
    }else{
        [self linkageChartViewDidSelectType:2 indexPath:nil index:indexPath.section];
    }
}

- (void)itemDidSelectIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index
{
    [self linkageChartViewDidSelectType:3 indexPath:indexPath index:index];
}

/** 点击回调 */
- (void)linkageChartViewDidSelectType:(ZHLinkageChartViewSelectType)type indexPath:(NSIndexPath *)indexPath index:(NSInteger)index
{
    if (self.zh_delegate && [self.zh_delegate respondsToSelector:@selector(linkageChartViewDidSelect:type:indexPath:index:)]) {
        [self.zh_delegate linkageChartViewDidSelect:self type:type indexPath:indexPath index:index];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.headCollectionView) {
        return CGSizeMake((KITEMWIDTH + 10) * [self.dataArr[indexPath.section] count] - 10, collectionView.frame.size.height);
    }else if (collectionView == self.bgCollectionView){
        return CGSizeMake(KITEMWIDTH, collectionView.frame.size.height);
    }else if (collectionView == self.leftCollectionView) {
        return CGSizeMake(KITEMWIDTH, KITEMHEIGHT);
    }
    return CGSizeZero;
}


- (UILabel *)topLabel
{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.text = @"楼层";
        _topLabel.layer.masksToBounds = NO;
        _topLabel.layer.cornerRadius = 2.f;
        _topLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _topLabel.layer.borderWidth = 0.5 ;
        _topLabel.textColor = [UIColor darkTextColor];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_topLabel];
        [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KLINESPACE);
            make.top.equalTo(self).offset(KSPACE);
            make.width.mas_equalTo(KITEMWIDTH);
            make.height.mas_equalTo(KHEADHEIGHT);
        }];
    }
    return _topLabel;
}

- (UICollectionView *)leftCollectionView
{
    if (!_leftCollectionView) {
        UICollectionViewFlowLayout *bgflowLayout = [[UICollectionViewFlowLayout alloc] init];
        //        bgflowLayout.itemSize = CGSizeMake(55, self.bgCollectionView.height);
        bgflowLayout.minimumLineSpacing = KSPACE;
        bgflowLayout.minimumInteritemSpacing = KSPACE;
        bgflowLayout.sectionInset = UIEdgeInsetsMake(0, 0, KSPACE, 0);
        bgflowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _leftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:bgflowLayout];
        _leftCollectionView.delegate = self;
        _leftCollectionView.dataSource = self;
        _leftCollectionView.backgroundColor = [UIColor whiteColor];
        [_leftCollectionView registerClass:[ZHItemCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZHItemCollectionViewCell class])];
        _leftCollectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_leftCollectionView];
        [_leftCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topLabel.mas_bottom).offset(KSPACE);
            make.left.equalTo(self).offset(KLINESPACE);
            make.bottom.equalTo(self).offset(-KLINESPACE);
            make.width.equalTo(self.topLabel);
        }];
    }
    return _leftCollectionView;
}

- (UICollectionView *)headCollectionView
{
    if (!_headCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = KSPACE;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, KLINESPACE);
        
        _headCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _headCollectionView.showsHorizontalScrollIndicator = NO;
        _headCollectionView.delegate = self;
        _headCollectionView.dataSource = self;
        _headCollectionView.backgroundColor = [UIColor whiteColor];
        [_headCollectionView registerClass:[ZHTitleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZHTitleCollectionViewCell class])];
        [self addSubview:_headCollectionView];
        [_headCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topLabel.mas_right).offset(KSPACE);
            make.right.equalTo(self);
            make.height.centerY.equalTo(self.topLabel);
        }];
    }
    return _headCollectionView;
}

- (UICollectionView *)bgCollectionView
{
    if (!_bgCollectionView) {
        UICollectionViewFlowLayout *bgflowLayout = [[UICollectionViewFlowLayout alloc] init];
        //        bgflowLayout.itemSize = CGSizeMake(55, self.bgCollectionView.height);
        bgflowLayout.minimumLineSpacing = KSPACE;
        bgflowLayout.minimumInteritemSpacing = KSPACE;
        bgflowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, KLINESPACE);
        bgflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _bgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:bgflowLayout];
        _bgCollectionView.delegate = self;
        _bgCollectionView.dataSource = self;
        _bgCollectionView.backgroundColor = [UIColor whiteColor];
        [_bgCollectionView registerClass:[ZHBgCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZHBgCollectionViewCell class])];
        _bgCollectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_bgCollectionView];
        [_bgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headCollectionView.mas_bottom).offset(KSPACE);
            make.left.equalTo(self.leftCollectionView.mas_right).offset(KSPACE);
            make.bottom.equalTo(self).offset(-KLINESPACE);
            make.right.equalTo(self);
        }];
    }
    return _bgCollectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
