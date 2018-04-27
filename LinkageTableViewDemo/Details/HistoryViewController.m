//
//  HistoryViewController.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/23.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCollectionViewCell.h"
#import "AppDelegate.h"
#import "BGTableViewCell.h"
#import "InfoModel.h"
#import "Common.h"
#import "ContractInfoViewController.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) CGPoint offict;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGGreenColor;
    
    [self tableView];
    
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KBGTableViewCellID forIndexPath:indexPath];
    cell.collectionView.delegate = self;
    cell.collectionView.tag = indexPath.row;
    cell.showType = ContractInfoShowTypeHorizontal;
    cell.dataArr = self.dataArr;
    cell.indexRow = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dict = self.dataArr.count?self.dataArr[indexPath.row]:nil;
//    InfoModel *model = [[InfoModel alloc] init];
//    [model setValuesForKeysWithDictionary:dict];
//    CGFloat height = [Common getTextHeightWithText:model.remark font:[UIFont systemFontOfSize:14] width:115]  + 15;
    return KBGTableViewCellHeight;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selIndePath = [NSIndexPath indexPathForRow:indexPath.row inSection:collectionView.tag];
    NSLog(@"%ld-%ld",selIndePath.section,selIndePath.row);
    
    if (!selIndePath.row) {
        ContractInfoViewController *contractInfoVC = [[ContractInfoViewController alloc] init];
        [self.navigationController pushViewController:contractInfoVC animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
       return CGSizeMake(KHistoryCollectionViewCellWidth/2, KHistoryCollectionViewCellHeight);
    }
    return CGSizeMake(KHistoryCollectionViewCellWidth, KHistoryCollectionViewCellHeight);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UITableView class]]) {
        self.offict = scrollView.contentOffset;
    }
    for (int i = 0; i < self.dataArr.count; i ++) {
        BGTableViewCell *cell = (BGTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (!cell) {
            continue;
        }
        cell.collectionView.contentOffset = CGPointMake(self.offict.x, 0);
    }
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[BGTableViewCell class] forCellReuseIdentifier:KBGTableViewCellID];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = KBGGreenColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"History" ofType:@"plist"]];
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
