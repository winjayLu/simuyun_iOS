//
//  ViewController.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/9.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "YTPhotoViewController.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YTPhotoCell.h"
#import "JKAssets.h"


@interface YTPhotoViewController ()<JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray   *assetsArray;



@end

@implementation YTPhotoViewController


- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [[UIButton alloc] init];
    
    button.frame = CGRectMake(self.viewWidth - 35,0, 35, 35);
    [button setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(composePicAdd) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView reloadData];
}


- (void)composePicAdd
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 5;
    imagePickerController.selectedAssetArray = self.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.selectedPhoto removeAllObjects];
        [self.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YTPhotoCell *cell = (YTPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];

    JKAssets *asset = [self.assetsArray objectAtIndex:[indexPath row]];
    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *newAsset) {
        if (asset) {
            UIImage *image = [UIImage imageWithCGImage:[[newAsset defaultRepresentation] fullScreenImage]];
            cell.itemImage = image;
            [self.selectedPhoto addObject:image];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(35, 35);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.assetsArray removeObjectAtIndex:indexPath.row];
    [self.selectedPhoto removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumLineSpacing = 15.0;
        layout.minimumInteritemSpacing = 15.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, self.viewWidth - 50, 35) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[YTPhotoCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}


- (NSMutableArray *)selectedPhoto
{
    if (!_selectedPhoto) {
        _selectedPhoto = [[NSMutableArray alloc] init];
    }
    return _selectedPhoto;
}

@end
