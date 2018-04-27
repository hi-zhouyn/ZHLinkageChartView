//
//  StateViewController.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/23.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "StateViewController.h"
#import "AppDelegate.h"
#import "StateCollectionReusableHeadView.h"
#import "StateCollectionViewCell.h"
#import "Common.h"

@interface StateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation StateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    [self collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataArr[section];
    return [dict[@"info"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KStateCollectionViewCellID forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr.count?self.dataArr[indexPath.section]:nil;
    NSArray *infoArr = [NSArray arrayWithArray:dict[@"info"]];
    cell.infoLabel.text = infoArr[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        StateCollectionReusableHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:KStateCollectionReusableHeadViewID forIndexPath:indexPath];
        NSDictionary *dict = self.dataArr.count?self.dataArr[indexPath.section]:nil;
        headView.titleLabel.text = dict[@"title"];
        return headView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArr.count?self.dataArr[indexPath.section]:nil;
    NSArray *infoArr = [NSArray arrayWithArray:dict[@"info"]];
    if (infoArr.count) {
        CGFloat width = [Common getTextWidthWithText:infoArr[indexPath.row] font:[UIFont systemFontOfSize:13] hight:KStateCollectionViewCellHeight];
        return CGSizeMake(width, KStateCollectionViewCellHeight);
    }
    return CGSizeMake(1, KStateCollectionViewCellHeight);
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.itemSize = CGSizeMake(kSCREEN_WIDTH/2, 15);
        flowLayout.minimumLineSpacing = 4;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(8, 4, 8, 2);
        flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, KStateCollectionReusableHeadViewHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = KBGGreenColor;
        [_collectionView registerNib:[UINib nibWithNibName:KStateCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KStateCollectionViewCellID];
        [_collectionView registerNib:[UINib nibWithNibName:KStateCollectionReusableHeadViewID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KStateCollectionReusableHeadViewID];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(super.view);
        }];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"State" ofType:@"plist"]];
        
    }
    return _dataArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
