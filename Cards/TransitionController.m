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
    }
}

- (void)animatePushFromViewController:(ViewController *)viewController toDetailViewController:(DetailViewController *)detailViewController transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:viewController.view];
    
    [detailViewController.collectionView reloadData];
    detailViewController.view.hidden = YES;
    [containerView addSubview:detailViewController.view];
    
    UICollectionViewCell *cell = [viewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:detailViewController.dataSourceIndex inSection:0]];
    UIView *cellSnapshot = [cell snapshotViewAfterScreenUpdates:NO];
    cellSnapshot.frame = [containerView convertRect:cell.frame fromView:viewController.view];
    [containerView addSubview:cellSnapshot];
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = CGRectMake(4, 68 + 4, CGRectGetWidth(detailViewController.collectionView.frame) - (4 * 2), CGRectGetHeight(detailViewController.collectionView.frame) - (4 * 2));
        cellSnapshot.frame = frame;
    } completion:^(BOOL finished) {
        detailViewController.view.hidden = NO;
        [cellSnapshot removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}


@end
