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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:viewController.titleLabel.frame];
    titleLabel.font = viewController.titleLabel.font;
    titleLabel.textColor = viewController.titleLabel.textColor;
    titleLabel.textAlignment = viewController.titleLabel.textAlignment;
    titleLabel.text = viewController.titleLabel.text;
    [containerView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:viewController.detailLabel.frame];
    detailLabel.font = viewController.detailLabel.font;
    detailLabel.textColor = viewController.detailLabel.textColor;
    detailLabel.textAlignment = viewController.detailLabel.textAlignment;
    detailLabel.text = viewController.detailLabel.text;
    [containerView addSubview:detailLabel];
    
    VBFPopFlatButton *menuButton = [[VBFPopFlatButton alloc] initWithFrame:viewController.menuButton.frame buttonType:viewController.menuButton.currentButtonType buttonStyle:viewController.menuButton.currentButtonStyle animateToInitialState:NO];
    menuButton.tintColor = viewController.menuButton.tintColor;
    [containerView addSubview:menuButton];
    
    viewController.titleLabel.hidden = YES;
    viewController.detailLabel.hidden = YES;
    viewController.menuButton.hidden = YES;
    viewController.cityButton.hidden = YES;
    
    [menuButton animateToType:buttonDownBasicType];

    
    [UIView animateWithDuration:0.3f animations:^{
        KCNLargeCardFlowLayout *layout = [[KCNLargeCardFlowLayout alloc] initWithCollectionViewFrame:detailViewController.collectionView.frame];
        cellSnapshot.frame = CGRectMake(CGRectGetMinX(detailViewController.collectionView.frame) + layout.minimumLineSpacing,
                                        CGRectGetMinY(detailViewController.collectionView.frame) + layout.minimumLineSpacing,
                                        layout.itemSize.width,
                                        layout.itemSize.height);
        
        titleLabel.transform = CGAffineTransformScale(titleLabel.transform, 0.45f, 0.45f);
        CGRect titleLabelFrame = titleLabel.frame;
        titleLabelFrame.origin.y = 12;
        titleLabel.frame = titleLabelFrame;

        detailLabel.transform = CGAffineTransformScale(detailLabel.transform, 0.778f, 0.778f);
        CGRect detailLabelFrame = detailLabel.frame;
        detailLabelFrame.origin.y = 39;
        detailLabel.frame = detailLabelFrame;
        
        menuButton.frame = detailViewController.closeButton.frame;
    } completion:^(BOOL finished) {
        viewController.titleLabel.hidden = NO;
        viewController.detailLabel.hidden = NO;
        viewController.menuButton.hidden = NO;
        viewController.cityButton.hidden = NO;
        detailViewController.view.hidden = NO;
        
        [cellSnapshot removeFromSuperview];
        [titleLabel removeFromSuperview];
        [detailLabel removeFromSuperview];
        [menuButton removeFromSuperview];
        
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:detailViewController.titleLabel.frame];
    titleLabel.font = detailViewController.titleLabel.font;
    titleLabel.textColor = detailViewController.titleLabel.textColor;
    titleLabel.textAlignment = detailViewController.titleLabel.textAlignment;
    titleLabel.text = detailViewController.titleLabel.text;
    [containerView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:detailViewController.detailLabel.frame];
    detailLabel.font = detailViewController.detailLabel.font;
    detailLabel.textColor = detailViewController.detailLabel.textColor;
    detailLabel.textAlignment = detailViewController.detailLabel.textAlignment;
    detailLabel.text = detailViewController.detailLabel.text;
    [containerView addSubview:detailLabel];
    
    VBFPopFlatButton *menuButton = [[VBFPopFlatButton alloc] initWithFrame:detailViewController.closeButton.frame buttonType:detailViewController.closeButton.currentButtonType buttonStyle:detailViewController.closeButton.currentButtonStyle animateToInitialState:NO];
    menuButton.tintColor = detailViewController.closeButton.tintColor;
    [containerView addSubview:menuButton];
    
    [menuButton animateToType:buttonMenuType];
    
    viewController.titleLabel.hidden = YES;
    viewController.detailLabel.hidden = YES;
    viewController.menuButton.hidden = YES;
    
    [UIView animateWithDuration:0.3f animations:^{
        UICollectionViewLayoutAttributes *cellLayout = [viewController.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:selectedIndexPath];
        cellSnapshot.frame = [containerView convertRect:cellLayout.frame fromView:viewController.collectionView];
        
        titleLabel.transform = CGAffineTransformScale(titleLabel.transform, 40.0f/18, 40.0f/18);
        CGRect titleLabelFrame = titleLabel.frame;
        titleLabelFrame.origin.y = 100;
        titleLabel.frame = titleLabelFrame;
        
        detailLabel.transform = CGAffineTransformScale(detailLabel.transform, 18.0f/14, 18.0f/14);
        CGRect detailLabelFrame = detailLabel.frame;
        detailLabelFrame.origin.y = 164;
        detailLabel.frame = detailLabelFrame;
        
        menuButton.frame = viewController.menuButton.frame;
    } completion:^(BOOL finished) {
        [cellSnapshot removeFromSuperview];
        [titleLabel removeFromSuperview];
        [detailLabel removeFromSuperview];
        [menuButton removeFromSuperview];
        
        viewController.titleLabel.hidden = NO;
        viewController.detailLabel.hidden = NO;
        viewController.menuButton.hidden = NO;
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}











@end

























