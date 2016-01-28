//
//  YTCollectionViewController.m
//  simuyun
//
//  Created by Luwinjay on 16/1/27.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTSchoolHomeViewController.h"
#import "YTSchoolHeaderView.h"
#import "YTGroomVedioView.h"
#import "MJRefresh.h"
#import "YTSchoolCollectionCell.h"
#import "YTAccountTool.h"
#import "YTVedioModel.h"


@interface YTSchoolHomeViewController ()
/**
 *  视频数组
 */
@property (nonatomic, strong) NSMutableArray *vedios;

/**
 *  顶部视图的容器
 */
@property (nonatomic, weak) UICollectionReusableView *reusableView;

/**
 *  初始化推荐视频
 */
@property (nonatomic, weak) YTGroomVedioView *groomView;

/**
 *  初始化推荐视频
 */
@property (nonatomic, weak) YTSchoolHeaderView *headerView;

@end

@implementation YTSchoolHomeViewController

static NSString * const reuseIdentifier = @"schoolCell";

static NSString * const headerIdentifier = @"headerCell";

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    CGFloat vedioWidth = (DeviceWidth - 32) * 0.5;
//    CGFloat vedioHeight = 146;
    layout.itemSize = CGSizeMake((DeviceWidth - 32) * 0.5, 146);
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 15, 8);
//    layout.minimumInteritemSpacing = 15;
//    layout.minimumLineSpacing = 8;
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[YTSchoolCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 设置下拉刷新上拉加载
    // 设置下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadGroomVedio)];
    // 上拉加载
    self.collectionView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOtherVedio)];


}

#pragma mark - 加载数据
/**
 *  加载热门视频
 */
- (void)loadGroomVedio
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    [YTHttpTool get:YTRecommended params:param
            success:^(NSDictionary *responseObject) {
                self.vedios = [YTVedioModel objectArrayWithKeyValuesArray:responseObject];
                // 结束刷新状态
                [self.collectionView reloadData];
                [self.collectionView.header endRefreshing];
            } failure:^(NSError *error) {
                // 结束刷新状态
                [self.collectionView.header endRefreshing];
            }];
}
/**
 *  加载其他视频
 *
 */
- (void)loadOtherVedio
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 5; i++) {
            [self.vedios addObject:@""];
        }
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    });
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.vedios.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YTSchoolCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    

//    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

/**
 *  初始化headerView
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (self.reusableView)
        {
            self.headerView.vedio = self.vedios[0];
            self.groomView.vedios = self.vedios;
            return self.reusableView;
        } else {
            UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
            // 初始化顶部视图
            CGFloat headerHeight = DeviceWidth * 0.5625 + (DeviceWidth - 35) * 0.25 - 10;
            YTSchoolHeaderView *header = [[YTSchoolHeaderView alloc] init];
            header.frame = CGRectMake(0, 0, DeviceWidth, headerHeight);
            header.vedio = self.vedios[0];
            [reusableView addSubview:header];
            self.headerView = header;
            // 初始化推荐视频
            YTGroomVedioView *groomView = [[YTGroomVedioView alloc] initWithVedios:self.vedios];
            groomView.frame = CGRectMake(0, CGRectGetMaxY(header.frame), DeviceWidth, groomView.selfHeight);
            groomView.vedios = self.vedios;
            [reusableView addSubview:groomView];
            self.groomView = groomView;
            self.reusableView = reusableView;
            return reusableView;
        }
    }
    
    return nil;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = DeviceWidth * 0.5625 + (DeviceWidth - 35) * 0.25 - 10;
    CGFloat groomHeight = 410;
    return CGSizeMake(DeviceWidth, headerHeight + groomHeight);
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


#pragma mark - lazy

- (NSMutableArray *)vedios
{
    if (!_vedios) {
        _vedios = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            YTVedioModel *vedio = [[YTVedioModel alloc] initWithTitle:@"sss" image:@"SchoolBanner" shortName:@"我是子标题我是子标题我是子标题我是子标题我是子标题"];
            [_vedios addObject:vedio];
        }
    }
    return _vedios;
}


@end
