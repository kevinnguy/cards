//
//  DetailViewController.m
//  Cards
//
//  Created by Kevin Nguy on 8/24/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import "DetailViewController.h"

#import "CustomCollectionViewCell.h"
#import "KCNLargeCardFlowLayout.h"

@interface DetailViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.backgroundColor;
    
    [self setupCollectionView];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataSourceIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
}

- (void)setupCollectionView {
    KCNLargeCardFlowLayout *layout = [[KCNLargeCardFlowLayout alloc] initWithCollectionViewFrame:self.view.bounds];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CustomCollectionViewCell class])];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    
    [self.view addSubview:self.collectionView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CustomCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = self.dataSource[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

@end
