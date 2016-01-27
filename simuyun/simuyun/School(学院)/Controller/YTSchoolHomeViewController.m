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

@interface YTSchoolHomeViewController ()
/**
 *  视频数组
 */
@property (nonatomic, strong) NSMutableArray *vedios;

/**
 *  初始化推荐视频
 */
@property (nonatomic, weak) YTGroomVedioView *groomView;

/**
 *  初始化推荐视频
 */
@property (nonatomic, weak) YTSchoolHeaderView *header;

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
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    


}

#pragma mark - 初始化方法




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.vedios.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.backgroundColor = [UIColor blueColor];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        // 初始化顶部视图
        CGFloat headerHeight = DeviceWidth * 0.5625 + (DeviceWidth - 35) * 0.25 - 10;
        YTSchoolHeaderView *header = [[YTSchoolHeaderView alloc] init];
        header.frame = CGRectMake(0, 0, DeviceWidth, headerHeight);
        [headerView addSubview:header];
        self.header = header;
        // 初始化推荐视频
        YTGroomVedioView *groomView = [[YTGroomVedioView alloc] init];
        groomView.frame = CGRectMake(0, CGRectGetMaxY(header.frame), DeviceWidth, groomView.selfHeight);
        [headerView addSubview:groomView];
        self.groomView = groomView;
        return headerView;
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
            [_vedios addObject:@"ss"];
        }
    }
    return _vedios;
}


@end
