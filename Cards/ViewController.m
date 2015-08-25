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

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) KCNCardFlowLayout *cardFlowLayout;

@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;



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
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
}

- (void)viewPanned:(UIPanGestureRecognizer *)panGesture {
    CGFloat progress = [panGesture translationInView:self.view].y / (float)CGRectGetHeight(self.view.bounds);
    progress = MIN(1.0f, MAX(0.0f, -progress));
    
    
    if ([panGesture locationInView:self.view].y < CGRectGetHeight(self.view.bounds) - self.cardFlowLayout.itemSize.height) {
        return;
    }
    
//    if (panGesture.state == UIGestureRecognizerStateBegan) {
//        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
//        
//        DetailViewController *detailViewController = [DetailViewController new];
//        detailViewController.backgroundColor = self.topView.backgroundColor;
//        detailViewController.dataSource = self.colorArray;
//        
//        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[panGesture locationInView:self.collectionView]];
//        detailViewController.dataSourceIndex = indexPath.item;
//        
//        [self.navigationController pushViewController:detailViewController animated:YES];
//    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
//        [self.interactiveTransition updateInteractiveTransition:progress];
//    } else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
//        if (progress < 0.5f) {
//            [self.interactiveTransition cancelInteractiveTransition];
//        } else {
//            [self.interactiveTransition finishInteractiveTransition];
//        }
//        
//        self.interactiveTransition = nil;
//    }
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactiveTransition;
}


// Implement these 2 methods to perform interactive transitions
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.interactiveTransition;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    return fabs(velocity.y) > fabs(velocity.x);
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
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 250) / 2, 80, 250, 80)];
    self.titleLabel.font = [UIFont systemFontOfSize:40];
    self.titleLabel.text = @"3 Packages";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 200) / 2, 160, 200, 30)];
    self.detailLabel.font = [UIFont systemFontOfSize:18];
    self.detailLabel.text = @"are ready for delivery";
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.detailLabel];
}

- (void)setupCollectionView {
    self.cardFlowLayout = [[KCNCardFlowLayout alloc] initWithCollectionViewFrame:self.view.bounds];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:self.cardFlowLayout];
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
