//
//  TransitionController.m
//  Cards
//
//  Created by Kevin Nguy on 8/24/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import "TransitionController.h"

#import "ViewController.h"
#import "DetailViewController.h"
#import "KCNLargeCardFlowLayout.h"

@implementation TransitionController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    id fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    id toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([fromViewController isKindOfClass:[ViewController class]] &&
        [toViewController isKindOfClass:[DetailViewController class]]) {
        [self animatePushFromViewController:fromViewController
                     toDetailViewController:toViewController
                          transitionContext:transitionContext];
    } else if ([fromViewController isKindOfClass:[DetailViewController class]] &&
               [toViewController isKindOfClass:[ViewController class]]) {
        [self animatePopFromDetailViewController:fromViewController
                                toViewController:toViewController
                               transitionContext:transitionContext];
    }
}

- (void)animatePushFromViewController:(ViewController *)viewController toDetailViewController:(DetailViewController *)detailViewController transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:viewController.view];
    
    [detailViewController.collectionView reloadData];
    detailViewController.view.hidden = YES;
    [containerView addSubview:detailViewController.view];
    
    NSIndexPath *selectedIndexPath = [viewController.collectionView indexPathsForSelectedItems].firstObject;
    UICollectionViewCell *cell = [viewController.collectionView cellForItemAtIndexPath:selectedIndexPath];
    UIView *cellSnapshot = [cell snapshotViewAfterScreenUpdates:NO];
    cellSnapshot.frame = [containerView convertRect:cell.frame fromView:viewController.collectionView];
    [containerView addSubview:cellSnapshot];
    
    [UIView animateWithDuration:0.3f animations:^{
        KCNLargeCardFlowLayout *layout = [[KCNLargeCardFlowLayout alloc] initWithCollectionViewFrame:detailViewController.collectionView.frame];
        cellSnapshot.frame = CGRectMake(CGRectGetMinX(detailViewController.collectionView.frame) + layout.minimumLineSpacing,
                                        CGRectGetMinY(detailViewController.collectionView.frame) + layout.minimumLineSpacing,
                                        layout.itemSize.width,
                                        layout.itemSize.height);
    } completion:^(BOOL finished) {
        detailViewController.view.hidden = NO;
        [cellSnapshot removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)animatePopFromDetailViewController:(DetailViewController *)detailViewController toViewController:(ViewController *)viewController transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:viewController.view];
    
    NSIndexPath *selectedIndexPath = [detailViewController.collectionView indexPathsForSelectedItems].firstObject;
    UICollectionViewCell *cell = [detailViewController.collectionView cellForItemAtIndexPath:selectedIndexPath];
    UIView *cellSnapshot = [cell snapshotViewAfterScreenUpdates:NO];
    cellSnapshot.frame = [containerView convertRect:cell.frame fromView:detailViewController.collectionView];
    [containerView addSubview:cellSnapshot];
    
    if (detailViewController.dataSourceIndex != selectedIndexPath.item) {
        if (detailViewController.dataSourceIndex < selectedIndexPath.item - 1) {
            [viewController.collectionView scrollToItemAtIndexPath:selectedIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        } else if (detailViewController.dataSourceIndex > selectedIndexPath.item + 1) {
            [viewController.collectionView scrollToItemAtIndexPath:selectedIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        UICollectionViewLayoutAttributes *cellLayout = [viewController.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:selectedIndexPath];
        cellSnapshot.frame = [containerView convertRect:cellLayout.frame fromView:viewController.collectionView];
    } completion:^(BOOL finished) {
        [cellSnapshot removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}











@end

























