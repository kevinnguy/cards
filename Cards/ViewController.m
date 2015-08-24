//
//  ViewController.m
//  Cards
//
//  Created by Kevin Nguy on 8/21/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

#import "CustomCollectionViewCell.h"
#import "KCNCardFlowLayout.h"
#import "TransitionController.h"

#import <UIColor+Chameleon.h>

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) NSMutableArray *colorArray;

@end

@implementation ViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTopView];
    [self setupCollectionView];
    
    // Color array
    self.colorArray = [NSMutableArray new];
    for (NSInteger i = 0; i < 20; i++) {
        [self.colorArray addObject:[UIColor randomFlatColor]];
    }
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}

#pragma mark - View initialization
- (void)setupTopView {
    self.topView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.topView.clipsToBounds = YES;
    self.topView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1];
    [self.view addSubview:self.topView];
}

- (void)setupCollectionView {
    KCNCardFlowLayout *layout = [[KCNCardFlowLayout alloc] initWithCollectionViewFrame:self.view.bounds];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CustomCollectionViewCell class])];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    return [TransitionController new];
}


#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CustomCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = self.colorArray[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorArray.count;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailViewController = [DetailViewController new];
    detailViewController.backgroundColor = self.topView.backgroundColor;
    detailViewController.dataSource = self.colorArray;
    detailViewController.dataSourceIndex = indexPath.item;
    
//    [self presentViewController:detailViewController animated:YES completion:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    UIColor *color = self.colorArray[fromIndexPath.item];
    [self.colorArray removeObjectAtIndex:fromIndexPath.item];
    [self.colorArray insertObject:color atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return YES;
}


@end
