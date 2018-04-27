//
//  RoomInfoViewController.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/23.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "RoomInfoViewController.h"
#import "RoomInfoCollectionViewCell.h"
#import "AppDelegate.h"
//#import "UIView+XIBInstance.h"
//#import "Masonry.h"

@interface RoomInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation RoomInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RoomInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KRoomInfoCollectionViewCellID forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.titleLabel.text = dict[@"title"];
    cell.contentLabel.text = dict[@"data"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSString *title = dict[@"title"];
    if ([title isEqualToString:@"房屋坐落"]
//        ||[title isEqualToString:@"装修价格"]
        ||[title isEqualToString:@"限制销售原因"]
        ||[title isEqualToString:@"备注"]) {
        return CGSizeMake(kSCREEN_WIDTH, KRoomInfoCollectionViewCellHeight);
    }
    return CGSizeMake(kSCREEN_WIDTH/2, KRoomInfoCollectionViewCellHeight);
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kSCREEN_WIDTH/2, KRoomInfoCollectionViewCellHeight);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = KBGGreenColor;
        [_collectionView registerNib:[UINib nibWithNibName:KRoomInfoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KRoomInfoCollectionViewCellID];
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
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"RoomInfo" ofType:@"plist"]];
        _dataArr = [NSMutableArray arrayWithArray:dict[@"info"]];
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
