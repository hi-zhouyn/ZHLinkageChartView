//
//  FloorViewController.m
//  LinkageTableViewDemo
//
//  Created by 周亚楠 on 2018/4/8.
//  Copyright © 2018年 GuangDa. All rights reserved.
//

#import "FloorViewController.h"
#import "FloorTableViewCell.h"
#import "InfoCollectionViewCell.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "HeadCollectionViewCell.h"
#import "BGCollectionViewCell.h"
#import "LMJVerticalFlowLayout.h"
#import "IQActionSheetPickerView.h"
#import "RoomDetailsViewController.h"

static NSInteger vCount = 119;//多少行
static NSInteger hCellCount = 3;//一列多少个
static NSInteger hCount = 45;//多少单元

struct {
    NSInteger unitNum;
    NSInteger roomNum;
}selectNum;

@interface FloorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,IQActionSheetPickerViewDelegate>
@property (nonatomic, strong) UICollectionView *bgCollectionView;
@property (nonatomic, strong) UICollectionView *headCollectionView;
@property (nonatomic, assign) CGFloat offictY;
@property (nonatomic, assign) CGFloat scale;//缩放比例
//@property (nonatomic, assign) CGFloat tempScale;//存放缩放比例
@property (nonatomic, assign) NSInteger pinchSelCount;//设置缩放调用频率
@property (nonatomic, strong) NSMutableDictionary *refreshDict;//保存刷新状态
@property (nonatomic, assign) NSInteger refreshCount;//需要刷新的个数
@property (nonatomic, assign) BOOL pinchEnd;
@property (nonatomic, strong) NSMutableArray *numArr;
@end

@implementation FloorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scale = 1;
    self.pinchEnd = YES;
    self.pinchSelCount = 0;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld层",(long)self.floorNum];
    [self bgCollectionView];
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

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    NSLog(@"%@-%@",titles[0],titles[1]);
    selectNum.unitNum = [[titles firstObject] integerValue] - 1;
    selectNum.roomNum = [[titles lastObject] integerValue] - 1;
    [self.bgCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectNum.unitNum inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BGCollectionViewCell *cell = (BGCollectionViewCell *)[self.bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:selectNum.unitNum inSection:0]];
        [cell.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectNum.roomNum inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        cell.selNow = YES;
        cell.roomNum = selectNum.roomNum + 1;
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
        self.scale = 0.45f;
    }
    if (sender.scale > 1.f) {
        self.scale = 1.f;
    }
    
    if (self.pinchEnd) {
        self.pinchEnd = NO;
        [self updateViewsWithScale:self.scale];
    }
    
}

- (void)updateViewsWithScale:(CGFloat)scale
{
    self.refreshCount = kSCREEN_WIDTH / ((KInfoCollectionViewCellHeight * scale + 4) * hCellCount - 4) + 5;
    [self.headCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KHeadCollectionViewCellHeight * scale);
    }];
    [self.headCollectionView reloadData];
    [self.bgCollectionView reloadData];
    [self.bgCollectionView layoutIfNeeded];
    [self.refreshDict removeAllObjects];
    for (NSInteger i = 0; i < hCount; i ++) {
        BGCollectionViewCell *cell = (BGCollectionViewCell *)[self.bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [cell setScale:scale];
        [self.refreshDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",(long)cell.tag]];
        //        NSLog(@"cell:%@",cell);
    }
    //去除多余刷新统计
//    [self.refreshDict removeObjectForKey:@"0"];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return hCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.headCollectionView){
        HeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KHeadCollectionViewCellID forIndexPath:indexPath];
        cell.titleLabel.text = [NSString stringWithFormat:@"%ld单元",(long)indexPath.item + 1];
        return cell;
    }else{
        BGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KBGCollectionViewCellID forIndexPath:indexPath];
        cell.collectionView.delegate = self;
        cell.cellType = BGCollectionViewCellTypeSelectFloor;
        cell.tag = indexPath.row;
        cell.fontScale = self.scale;
        cell.floorNum = self.floorNum;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.headCollectionView){
        
    }else{
        
    }
    NSLog(@"index:%ld",(long)indexPath.row);
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.headCollectionView){
        self.bgCollectionView.contentOffset = CGPointMake(self.headCollectionView.contentOffset.x, 0);
    }else if (scrollView == self.bgCollectionView){
        self.headCollectionView.contentOffset = CGPointMake(self.bgCollectionView.contentOffset.x, 0);
    }
    if ([scrollView isKindOfClass:[UICollectionView class]]
        && scrollView != self.headCollectionView
        && scrollView != self.bgCollectionView)
    {
        self.offictY = scrollView.contentOffset.y;
    }else{
        NSIndexPath *indexPath = [self.bgCollectionView indexPathForItemAtPoint:self.bgCollectionView.contentOffset];
//
        NSInteger min = (indexPath.row - self.refreshCount - 1) >= 0?(indexPath.row - self.refreshCount - 1):0;
        NSInteger max = (indexPath.row + self.refreshCount + 2) <= hCount?(indexPath.row + self.refreshCount + 2):hCount;
        for (NSInteger i = min; i < max; i ++) {
            BGCollectionViewCell *cell = (BGCollectionViewCell *)[self.bgCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//            cell.collectionView.contentOffset = CGPointMake(0, 0);
            if (!self.refreshDict.allValues.count) {
                return;
            }
            
            LMJVerticalFlowLayout *flowLayout = (LMJVerticalFlowLayout *)cell.flowLayout;
            if (cell
                && flowLayout.itemSize.width != 0
                && (fabs((flowLayout.itemSize.width - floor(KInfoCollectionViewCellHeight * self.scale))) > 1)) {
                NSLog(@"idnexPath:%ld",indexPath.row);
                [cell setScale:self.scale];
                [self.refreshDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",(long)cell.tag]];
            }
        }
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.headCollectionView) {
        return CGSizeMake((KInfoCollectionViewCellHeight * self.scale + 4) * hCellCount - 4 , collectionView.frame.size.height);
    }else if (collectionView == self.bgCollectionView){
        return CGSizeMake((KInfoCollectionViewCellHeight * self.scale + 4) * hCellCount + 12, collectionView.frame.size.height);
    }else{
        return CGSizeZero;
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
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(KHeadCollectionViewCellHeight);
        }];
    }
    return _headCollectionView;
}

-(UICollectionView *)bgCollectionView
{
    if (!_bgCollectionView) {
        CGFloat height = self.view.frame.size.height - KHeadCollectionViewCellHeight;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((KInfoCollectionViewCellHeight + 4) * hCellCount + 12, height);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _bgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _bgCollectionView.delegate = self;
        _bgCollectionView.dataSource = self;
        _bgCollectionView.backgroundColor = [UIColor whiteColor];
        [_bgCollectionView registerClass:[BGCollectionViewCell class] forCellWithReuseIdentifier:KBGCollectionViewCellID];
        _bgCollectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_bgCollectionView];
        [_bgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.headCollectionView.mas_bottom);
        }];
    }
    return _bgCollectionView;
}

- (NSMutableDictionary *)refreshDict
{
    if (!_refreshDict) {
        _refreshDict = [NSMutableDictionary dictionary];
    }
    return _refreshDict;
}

- (NSMutableArray *)createNumArr
{
    if (!self.numArr.count) {
        [self createArrWithNum:0 count:hCount];
        [self createArrWithNum:1 count:hCellCount * vCount];
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
