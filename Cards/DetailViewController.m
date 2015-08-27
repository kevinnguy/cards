//
//  DetailViewController.m
//  Cards
//
//  Created by Kevin Nguy on 8/24/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import "DetailViewController.h"

#import "DetailCollectionViewCell.h"
#import "KCNLargeCardFlowLayout.h"
#import "TransitionController.h"

@interface DetailViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *scheduleButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = self.backgroundColor;
    
    [self setupLabels];
    [self setupCollectionView];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataSourceIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
    
    self.closeButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(20, 30, 26, 26)
                                                    buttonType:buttonDownBasicType
                                                   buttonStyle:buttonPlainStyle
                                         animateToInitialState:NO];
    self.closeButton.tintColor = [UIColor whiteColor];
    [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    self.scheduleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scheduleButton setTitle:@"Schedule Delivery" forState:UIControlStateNormal];
    self.scheduleButton.backgroundColor = [UIColor colorWithRed:119.0f/255 green:226.0f/255 blue:198.0f/255 alpha:1];
    self.scheduleButton.titleLabel.font = [UIFont systemFontOfSize:19];
    self.scheduleButton.titleLabel.textColor = [UIColor whiteColor];
    self.scheduleButton.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 56, CGRectGetWidth(self.view.bounds), 56);
    [self.view addSubview:self.scheduleButton];
}

- (NSUInteger)supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)setupLabels {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 150) / 2, 20, 150, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"3 Packages";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 150) / 2, 40, 150, 20)];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.text = @"are ready for delivery";
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.detailLabel];
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

- (void)setupCollectionView {
    CGRect collectionViewFrame = CGRectMake(0, 68, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 68 - 56);
    KCNLargeCardFlowLayout *layout = [[KCNLargeCardFlowLayout alloc] initWithCollectionViewFrame:collectionViewFrame];
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame
                                             collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[DetailCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DetailCollectionViewCell class])];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    [self.view addSubview:self.collectionView];
}

- (void)closeButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    return [TransitionController new];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCollectionViewCell *cell = (DetailCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DetailCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = self.dataSource[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];

}

@end
