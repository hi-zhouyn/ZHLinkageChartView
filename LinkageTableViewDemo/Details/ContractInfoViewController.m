//
//  ContractInfoViewController.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/24.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "ContractInfoViewController.h"
#import "AppDelegate.h"
#import "ContractInfoTableViewHeadView.h"
#import "BGTableViewCell.h"
#import "BGScrollTableViewCell.h"

@interface ContractInfoViewController () <UITableViewDelegate,UITableViewDataSource,ContractInfoTableViewHeadViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableDictionary *openDict;//后续用Model替换
@end

@implementation ContractInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGGreenColor;
    self.navigationItem.title = @"查看合同要点信息";
    [self tableView];
}

- (void)headViewTapAction:(ContractInfoTableViewHeadView *)headView
{
    NSString *key = [NSString stringWithFormat:@"%ld",headView.indexSection];
    BOOL isOpen = [self.openDict[key] boolValue];
    [self.openDict setValue:[NSNumber numberWithBool:!isOpen] forKey:key];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:headView.indexSection] withRowAnimation:(UITableViewRowAnimationFade)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataArr[section];
    BOOL isOpen = [self.openDict[[NSString stringWithFormat:@"%ld",section]] boolValue];
    if (isOpen) {
        NSArray *typeArr = [NSArray arrayWithArray:dict[@"type"]];
        return typeArr.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSArray *typeArr = [NSArray arrayWithArray:dict[@"type"]];
    NSDictionary *typeDict = typeArr[indexPath.row];
    NSNumber *typeNum = typeDict[@"typenum"];
    NSNumber *infotypeNum = typeDict[@"infotype"];
    if (typeNum.integerValue == ContractInfoShowTypeVertical){
        BGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KBGTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showType = ContractInfoShowTypeVertical;
        cell.dataArr = typeDict[@"info"];
        cell.infotypeNum = infotypeNum;
        cell.collectionView.delegate = self;
        cell.indexRow = indexPath.section;
        cell.collectionView.tag = indexPath.section;
        return cell;
    }else{
        BGScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KBGScrollTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArr = typeDict[@"info"];
        cell.infotypeNum = infotypeNum;
        cell.collectionView.delegate = self;
        cell.indexRow = indexPath.section;
        cell.collectionView.tag = indexPath.section;
        cell.collectionView.allowsMultipleSelection = 1;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ContractInfoTableViewHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:KContractInfoTableViewHeadViewID];
    if (headView == nil) {
        headView = [[ContractInfoTableViewHeadView alloc] init];
        headView.contentView.backgroundColor = KSectionGreenColor;
    }
    NSDictionary *dict = self.dataArr[section];
    headView.nameLabel.text = dict[@"title"];
    headView.indexSection = section;
    headView.delegate = self;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSArray *typeArr = [NSArray arrayWithArray:dict[@"type"]];
    NSDictionary *typeDict = typeArr[indexPath.row];
    NSArray *infoArr = typeDict[@"info"];
    NSNumber *typeNum = typeDict[@"typenum"];
    if (typeNum.integerValue == ContractInfoShowTypeVertical) {
        if (infoArr.count < 3) {
            return infoArr.count/2 * KRoomInfoCollectionViewCellHeight;
        }
        return (infoArr.count/2 + 1) * KRoomInfoCollectionViewCellHeight;
    }else{
        return infoArr.count * KBGTableViewCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KContractInfoTableViewHeadViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary *dict = self.dataArr.count?self.dataArr[self.indexRow]:nil;
    //    InfoModel *model = [[InfoModel alloc] init];
    //    [model setValuesForKeysWithDictionary:dict];
    //    CGFloat height = [Common getTextHeightWithText:model.remark font:[UIFont systemFontOfSize:14] width:115] + 15;

    NSDictionary *dict = self.dataArr[collectionView.tag];
    NSArray *typeArr = [NSArray arrayWithArray:dict[@"type"]];
    NSDictionary *typeDict = collectionView.allowsMultipleSelection?[typeArr lastObject]:[typeArr firstObject];
    NSNumber *typeNum = typeDict[@"typenum"];
    NSArray *infoArr = typeDict[@"info"];
    NSInteger count = [[[infoArr firstObject] allKeys] count];
    if (typeNum.integerValue < 2) {
        NSDictionary *dict = infoArr[indexPath.row];
        BOOL isLong = dict[@"long"];
        if (isLong) {
            return CGSizeMake(kSCREEN_WIDTH, KRoomInfoCollectionViewCellHeight);
        }
        return CGSizeMake(kSCREEN_WIDTH/2, KRoomInfoCollectionViewCellHeight);
    }else{
        return CGSizeMake(KContractInfoBGCollectionViewCellWidth * count, KContractInfoBGCollectionViewCellHeight);
    }
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[BGTableViewCell class] forCellReuseIdentifier:KBGTableViewCellID];
        [_tableView registerClass:[BGScrollTableViewCell class] forCellReuseIdentifier:KBGScrollTableViewCellID];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = KBGGreenColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ContractInfo" ofType:@"plist"]];
        _dataArr = [NSMutableArray arrayWithArray:dict[@"info"]];
    }
    return _dataArr;
}

- (NSMutableDictionary *)openDict
{
    if (!_openDict) {
        _openDict = [NSMutableDictionary dictionary];
        for (NSInteger i = 0; i < self.dataArr.count; i ++) {
            [_openDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",i]];
        }
    }
    return _openDict;
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
