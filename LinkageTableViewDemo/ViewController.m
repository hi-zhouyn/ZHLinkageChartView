//
//  ViewController.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/2.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "ViewController.h"
#import "InfoCollectionViewCell.h"
#import "LinkageTableViewCell.h"
#import "HeadTopView.h"
#import "UIView+XIBInstance.h"
#import "LMJVerticalFlowLayout.h"
#import "BGCollectionViewCell.h"
#import "HeadCollectionViewCell.h"
#import "FloorViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "IQActionSheetPickerView.h"
#import "RoomDetailsViewController.h"

static NSInteger hCount = 46;
static NSInteger hCellCount = 4;

struct {
    NSInteger unitNum;
    NSInteger floorNum;
    NSInteger roomNum;
}selectFloor;

@interface ViewController   ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,IQActionSheetPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *bgCollectionView;
@property (nonatomic, strong) UICollectionView *headCollectionView;
@property (nonatomic, strong) HeadTopView *headView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger addNum;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat scale;//缩放比例
@property (nonatomic, strong) NSMutableDictionary *refreshDict;//保存刷新状态
@property (nonatomic, assign) NSInteger refreshCount;//需要刷新的个数
@property (nonatomic, assign) BOOL pinchEnd;
@property (nonatomic, assign) BOOL pinchD;
@property (nonatomic, assign) CGFloat offictY;
@property (nonatomic, strong) NSMutableArray *numArr;

@property (nonatomic, assign) BOOL isSelectToScroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"楼盘表";
    self.count = 118 + 1;
    self.addNum = 0;
    self.scale = 1;
    //    self.tempScale = 1;
    self.pinchEnd = YES;
    self.cellHeight = KInfoCollectionViewCellHeight * self.scale;
    self.refreshCount = ceil((kSCREEN_WIDTH - KLinkageTableViewCellWidth) / (KInfoCollectionViewCellHeight * self.scale * hCellCount + 16)) + 1;
    [self headView];
    [self headCollectionView];
    [self tableView];
    [self bgCollectionView];
    self.refreshDict = [NSMutableDictionary dictionary];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"select"] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor orangeColor]] forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)selectAction:(UIBarButtonItem *)sender
{
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"快速定位" delegate:self];
    picker.backgroundColor = [UIColor whiteColor];
    picker.actionToolbar.titleButton.titleFont = [UIFont systemFontOfSize:15];
    picker.actionToolbar.titleButton.titleColor = [UIColor orangeColor];
    [picker setTag:1];
    [picker setTitlesForComponents:[self createNumArr]];
    [picker show];
}

#pragma mark - 快速定位跳转
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    NSLog(@"%@-%@-%@",titles[0],titles[1],titles[2]);
    
    selectFloor.unitNum = [[titles firstObject] integerValue] - 1;
    selectFloor.floorNum = [titles[1] integerValue];
    selectFloor.roomNum = [[titles lastObject] integerValue] - 1;
    
    [self.bgCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectFloor.roomNum inSection:selectFloor.unitNum] animated:NO scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BGCollectionViewCell *cell = (BGCollectionViewCell *)[self.bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectFloor.roomNum inSection:selectFloor.unitNum]];
        [cell.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.count - selectFloor.floorNum inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        //选中变色
        cell.selNow = YES;
        cell.floorNum = selectFloor.floorNum;
    });
}


- (void)handlePinch:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.pinchEnd = YES;
    }
    
    if ((self.scale == 1.f && sender.scale > 1.f )
        || (self.scale == 0.45f && sender.scale < 1.f)
        || !self.pinchEnd)
    {
        return;
    }
    if (sender.scale <= 1.f ) {
        self.scale = 0.455555555555555f;
    }
    if (sender.scale > 1.f) {
        self.scale = 1.f;
    }
    
    if (self.pinchEnd) {
        self.pinchEnd = NO;
        self.offictY = self.tableView.contentOffset.y;
        [self updateViewsWithScale:self.scale];
    }
    
}

- (void)updateViewsWithScale:(CGFloat)scale
{
    //    self.pinchD = YES;
    
    self.refreshCount = ceil((kSCREEN_WIDTH - KLinkageTableViewCellWidth) / (KInfoCollectionViewCellHeight * scale  * hCellCount + 16)) + 1;
    
    [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KLinkageTableViewCellWidth * scale);
        make.height.mas_equalTo(KHeadTopViewHeight * scale);
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KLinkageTableViewCellWidth * scale);
    }];
    [self.headCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KHeadCollectionViewCellHeight * scale);
    }];
    [self.tableView reloadData];
    [self.headCollectionView reloadData];
    [self.bgCollectionView reloadData];
    
    [self.bgCollectionView layoutIfNeeded];
    
    [self.refreshDict removeAllObjects];
    [self.refreshDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"0"]];
    
    //滑动归零 避免约束改变后导致偏移计算出错 导致错位
    self.tableView.contentOffset = CGPointMake(0, 0);
    NSIndexPath *indexPathZero = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPathZero animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self updateCollectionViewOffictYWithView:self.tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LinkageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLinkageTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger num = self.count - indexPath.section;
    NSInteger normalNum = self.count - indexPath.section;
    cell.physicalFloorLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    //    normalNum = normalNum - self.addNum;
    
    //    if (indexPath.section == 1 || indexPath.section == 12){
    //        if (indexPath.section == 1) {
    //            self.addNum = 1;
    //        }else if (indexPath.section == 12){
    //            self.addNum = 2;
    //        }
    //
    //        normalNum = normalNum - self.addNum;
    //        cell.physicalFloorLabelBottomConstraint.constant = 4;
    //        cell.physicalFloor1Label.hidden = NO;
    //        cell.physicalFloor1Label.text = [NSString stringWithFormat:@"%ld",(long)--num];
    //        cell.physicalFloor1LabelHeightConstraint.constant = self.cellHeight;
    //    }else{
    cell.physicalFloorLabelBottomConstraint.constant = 0;
    cell.physicalFloor1LabelHeightConstraint.constant = 0;
    cell.physicalFloor1Label.hidden = YES;
    //    }
    //
    //
    //    if (normalNum < 1) {
    //        --normalNum;
    //    }
    NSString *numStr = [NSString stringWithFormat:@"%@%ld层",normalNum < 1?@"负":@"第",(long)normalNum];
    cell.physicalFloorLabel.font = [UIFont systemFontOfSize:self.scale<1?8:12];
    cell.nominalFloorLabel.font = [UIFont systemFontOfSize:self.scale<1?8:12];
    cell.floorLabel.font = [UIFont systemFontOfSize:self.scale<1?8:12];
    cell.physicalFloor1Label.font = [UIFont systemFontOfSize:self.scale<1?8:12];
    cell.nominalFloorLabel.text = numStr;
    cell.floorLabel.text = numStr;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 || indexPath.section == 12) {
        return (self.cellHeight) * 2 + 4;
    }
    return self.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.count - 1) {
        return 4;
    }
    return FLT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FloorViewController *floorVC = [[FloorViewController alloc] init];
    floorVC.floorNum = self.count - indexPath.section - self.addNum - 2;
    [self.navigationController pushViewController:floorVC animated:YES];
}


#pragma mark - UICollectionViewDelegate || UICollectionViewdataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return hCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.headCollectionView)
    {
        return 1;
    }
    return hCellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.headCollectionView){
        HeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KHeadCollectionViewCellID forIndexPath:indexPath];
        cell.titleLabel.text = [NSString stringWithFormat:@"%ld单元",(long)indexPath.section + 1];
        return cell;
    }else{
        BGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KBGCollectionViewCellID forIndexPath:indexPath];
        cell.collectionView.delegate = self;
        cell.cellType = BGCollectionViewCellTypeAllFloor;
        cell.tag = indexPath.row;
        cell.indexPath = indexPath;
        cell.fontScale = self.scale;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.headCollectionView){
        
    }else{
        
    }
    RoomDetailsViewController *detailsVC = [[RoomDetailsViewController alloc] init];
    [self.navigationController pushViewController:detailsVC animated:YES];
    NSLog(@"index:%ld",(long)indexPath.row);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.headCollectionView) {
        return CGSizeMake(((KInfoCollectionViewCellHeight * self.scale + 4) * hCellCount - 4), collectionView.frame.size.height);
    }else if (collectionView == self.bgCollectionView){
        self.cellHeight = KInfoCollectionViewCellHeight * self.scale;
        return CGSizeMake(self.cellHeight, collectionView.frame.size.height);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.headCollectionView){
        self.bgCollectionView.contentOffset = CGPointMake(self.headCollectionView.contentOffset.x, 0);
    }else if (scrollView == self.bgCollectionView){
        self.headCollectionView.contentOffset = CGPointMake(self.bgCollectionView.contentOffset.x, 0);
    }
    
    //    NSLog(@"collection:%lf",scrollView.contentOffset.y);
    
    if (scrollView == self.headCollectionView || scrollView == self.bgCollectionView){
        //            self.tableView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
        [self updateCollectionViewOffictYWithView:self.tableView];
    }else{
        self.tableView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
        [self updateCollectionViewOffictYWithView:self.tableView];
    }
}

- (void)updateCollectionViewOffictYWithView:(UIScrollView *)view
{
    NSIndexPath *indexPath = [self.bgCollectionView indexPathForItemAtPoint:self.bgCollectionView.contentOffset];
    //解决由于刚好滑到边界处时indexPath为nil
    if (!indexPath && self.bgCollectionView.contentOffset.x >= 16) {
        CGPoint point = self.bgCollectionView.contentOffset;
        point.x = point.x - 16;
        indexPath = [self.bgCollectionView indexPathForItemAtPoint:point];
    }
    NSInteger min = indexPath.section - self.refreshCount;
    NSInteger max = indexPath.section + self.refreshCount;
    
    for (NSInteger i = min; i < max; i ++) {
        if (i < 0 || i > hCount) {
            continue;
        }
        [self updateViewsWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:i] view:view];
    }
}

- (void)updateViewsWithIndexPath:(NSIndexPath *)indexPath view:(UIScrollView *)view
{
    for (NSInteger i = 0; i < hCellCount; i ++) {
        BGCollectionViewCell *cell = (BGCollectionViewCell *)[self.bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section]];
        if (!cell) {
            continue;
        }
        cell.collectionView.contentOffset = CGPointMake(0, view.contentOffset.y);
        
        if (!self.refreshDict.allValues.count) {
            //                return;
        }else{
            LMJVerticalFlowLayout *flowLayout = (LMJVerticalFlowLayout *)cell.flowLayout;
            if (cell
                && flowLayout.itemSize.width != 0
                && (fabs((flowLayout.itemSize.width - floor(KInfoCollectionViewCellHeight * self.scale))) > 1)) {
                [cell setScale:self.scale];
                [self.refreshDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",(long)cell.tag]];
            }
        }
    }
}


- (UICollectionView *)headCollectionView
{
    if (!_headCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 16;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
        
        _headCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _headCollectionView.showsHorizontalScrollIndicator = NO;
        _headCollectionView.delegate = self;
        _headCollectionView.dataSource = self;
        _headCollectionView.backgroundColor = [UIColor whiteColor];
        [_headCollectionView registerNib:[UINib nibWithNibName:KHeadCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:KHeadCollectionViewCellID];
        [self.view addSubview:_headCollectionView];
        [_headCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView.mas_right);
            make.top.right.equalTo(self.view);
            make.height.mas_equalTo(KHeadTopViewHeight);
        }];
    }
    return _headCollectionView;
}


-(HeadTopView *)headView
{
    if (!_headView) {
        _headView = [HeadTopView instanceView];
        [self.view addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.view);
            make.width.mas_equalTo(KLinkageTableViewCellWidth);
            make.height.mas_equalTo(KHeadTopViewHeight);
        }];
    }
    return _headView;
}


-(UICollectionView *)bgCollectionView
{
    if (!_bgCollectionView) {
        CGFloat height = self.view.frame.size.height - KHeadTopViewHeight;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(KInfoCollectionViewCellHeight, height);
        flowLayout.minimumLineSpacing = 4.f;
        flowLayout.minimumInteritemSpacing = 4.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _bgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _bgCollectionView.delegate = self;
        _bgCollectionView.dataSource = self;
        _bgCollectionView.backgroundColor = [UIColor whiteColor];
        [_bgCollectionView registerClass:[BGCollectionViewCell class] forCellWithReuseIdentifier:KBGCollectionViewCellID];
        _bgCollectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_bgCollectionView];
        [_bgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headCollectionView);
            make.top.equalTo(self.headCollectionView.mas_bottom);
            make.bottom.right.equalTo(self.view);
        }];
    }
    return _bgCollectionView;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:KLinkageTableViewCellID bundle:nil] forCellReuseIdentifier:KLinkageTableViewCellID];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.view);
            make.top.mas_equalTo(self.headView.mas_bottom);
            make.width.mas_equalTo(KLinkageTableViewCellWidth);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)createNumArr
{
    if (!self.numArr.count) {
        [self createArrWithNum:0 count:hCount];
        [self createArrWithNum:1 count:self.count];
        [self createArrWithNum:2 count:hCellCount];
    }
    return self.numArr;
}

- (void)createArrWithNum:(NSInteger)num count:(NSInteger)count
{
    NSMutableArray *infoArr = [NSMutableArray array];
    for (NSInteger i = 1; i <= count; i ++) {
        if (!num) {
            [infoArr addObject:[NSString stringWithFormat:@"%ld单元",(long)i]];
        }else if (num == 1){
            [infoArr addObject:[NSString stringWithFormat:@"%ld层",(long)i]];
        }else if (num == 2){
            [infoArr addObject:[NSString stringWithFormat:@"%ld号",(long)i]];
        }
    }
    [self.numArr addObject:infoArr];
}

- (NSMutableArray *)numArr
{
    if (!_numArr) {
        _numArr = [NSMutableArray array];
    }
    return _numArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
