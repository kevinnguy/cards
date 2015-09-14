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
@property (nonatomic, strong) UIImageView *menuView;
@property (nonatomic, strong) UIImageView *cityView;
@property (nonatomic, strong) UITapGestureRecognizer *dismissTapGesture;

@property (nonatomic, strong) KCNCardFlowLayout *cardFlowLayout;

@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

@property (nonatomic, strong) UIButton *scheduleButton;

@property (nonatomic, strong) UIView *rotateView;

@end

@implementation ViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTopView];
    [self setupCollectionView];
    
    [self.view addSubview:self.menuButton];
    [self.view addSubview:self.cityButton];
    
    self.scheduleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scheduleButton setTitle:@"Schedule Delivery" forState:UIControlStateNormal];
    self.scheduleButton.backgroundColor = [UIColor colorWithRed:119.0f/255 green:226.0f/255 blue:198.0f/255 alpha:1];
    self.scheduleButton.titleLabel.font = [UIFont systemFontOfSize:19];
    self.scheduleButton.titleLabel.textColor = [UIColor whiteColor];
    self.scheduleButton.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 56, CGRectGetWidth(self.view.bounds), 56);
    [self.view addSubview:self.scheduleButton];
    
    [self setupCityView];
    [self setupMenuView];
    
    self.rotateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds))];
    self.rotateView.backgroundColor = self.topView.backgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:self.rotateView.bounds];
    label.numberOfLines = 0;
    label.text = @"Kevin Nguy\n502 7th Street #88BJ\nSan Francisco, CA 94103";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:50];
    label.textColor = [UIColor whiteColor];
    [self.rotateView addSubview:label];
    
    self.dismissTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTapGesturePressed:)];

    
    // Color array
    self.colorArray = [@[[UIColor flatBlueColor], [UIColor flatForestGreenColor], [UIColor flatMagentaColor], [UIColor flatMintColor], [UIColor flatOrangeColor]] mutableCopy];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [UIView setAnimationsEnabled:NO];

    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.rotateView.alpha = 0;
        [self.view addSubview:self.rotateView];

        [UIView animateWithDuration:0.3f animations:^{
            self.rotateView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.rotateView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.rotateView removeFromSuperview];
        }];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [UIView setAnimationsEnabled:YES];
}

#pragma mark - View initialization
- (void)setupTopView {
    self.topView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.topView.clipsToBounds = YES;
    self.topView.backgroundColor = [UIColor colorWithRed:43.0f/255 green:57.0f/255 blue:85.0f/255 alpha:1];
//    self.topView.backgroundColor = [UIColor colorWithWhite:0.93f alpha:1];
    [self.view addSubview:self.topView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 250) / 2, 80, 250, 80)];
    self.titleLabel.font = [UIFont systemFontOfSize:40];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"3 Packages";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 200) / 2, 160, 200, 30)];
    self.detailLabel.font = [UIFont systemFontOfSize:18];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.text = @"are ready for delivery";
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.detailLabel];
    
    self.menuButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(20, 40, 26, 26)
                                                   buttonType:buttonMenuType
                                                  buttonStyle:buttonPlainStyle
                                        animateToInitialState:NO];
    self.menuButton.tintColor = [UIColor whiteColor];
    [self.menuButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cityButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 20 - 26, 40, 26, 26)
                                                   buttonType:buttonUpTriangleType
                                                  buttonStyle:buttonPlainStyle
                                        animateToInitialState:NO];
    self.cityButton.tintColor = [UIColor whiteColor];
    [self.cityButton addTarget:self action:@selector(cityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupCollectionView {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 56);
    self.cardFlowLayout = [[KCNCardFlowLayout alloc] initWithCollectionViewFrame:frame itemSize:CGSizeMake(150, 250) lineSpacing:20.0f];
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:self.cardFlowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CustomCollectionViewCell class])];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    [self.view addSubview:self.collectionView];
}

- (void)setupMenuView {
    self.menuView = [[UIImageView alloc] initWithFrame:CGRectMake(-(CGRectGetWidth(self.view.bounds) - 100),
                                                             0,
                                                             CGRectGetWidth(self.view.bounds) - 100,
                                                             CGRectGetHeight(self.view.bounds))];
    self.menuView.contentMode = UIViewContentModeScaleAspectFill;
    self.menuView.image = [UIImage imageNamed:@"menu"];
    [self.view addSubview:self.menuView];
}

- (void)setupCityView {
    self.cityView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds),
                                                             0,
                                                             CGRectGetWidth(self.view.bounds) - 100,
                                                             CGRectGetHeight(self.view.bounds))];
    self.cityView.contentMode = UIViewContentModeScaleAspectFill;
    self.cityView.image = [UIImage imageNamed:@"city"];
    [self.view addSubview:self.cityView];
}

#pragma mark - Buttons pressed
- (void)menuButtonPressed:(id)sender {
//    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.menuView.frame = CGRectMake(-12,
//                                         0,
//                                         CGRectGetWidth(self.view.bounds) - 100,
//                                         CGRectGetHeight(self.view.bounds));
//    } completion:^(BOOL finished) {
//        [self.view addGestureRecognizer:self.dismissTapGesture];
//    }];

    
//    [self.collectionView performBatchUpdates:^{
//        [self.colorArray removeObjectsInRange:NSMakeRange(0, 3)];
//        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0], [NSIndexPath indexPathForItem:1 inSection:0], [NSIndexPath indexPathForItem:2 inSection:0]]];
//        
//    } completion:nil];
//    
//    [self.collectionView performBatchUpdates:^{
//        [self.colorArray insertObjects:@[[UIColor randomFlatColor], [UIColor randomFlatColor], [UIColor randomFlatColor]]
//                             atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
//        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0], [NSIndexPath indexPathForItem:1 inSection:0], [NSIndexPath indexPathForItem:2 inSection:0]]];
//    } completion:nil];
    
    NSArray *cells = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in cells) {
        [UIView animateWithDuration:0.14f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.transform = CGAffineTransformMakeTranslation(0, -40);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.14f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }
    
}

- (void)cityButtonPressed:(id)sender {
//    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.cityView.frame = CGRectMake(112,
//                                         0,
//                                         CGRectGetWidth(self.view.bounds) - 100,
//                                         CGRectGetHeight(self.view.bounds));
//    } completion:^(BOOL finished) {
//        [self.view addGestureRecognizer:self.dismissTapGesture];
//    }];
//    self.colorArray = [@[[UIColor flatBlueColor], [UIColor flatPlumColor], [UIColor flatMagentaColor], [UIColor flatPinkColor], [UIColor flatPowderBlueColor]] mutableCopy];
//    [self.collectionView reloadData];
    [self.collectionView performBatchUpdates:^{
        [self.colorArray insertObject:[UIColor randomFlatColor] atIndex:1];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
    } completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate
- (void)dismissTapGesturePressed:(id)gesture {
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.menuView.frame = CGRectMake(-(CGRectGetWidth(self.view.bounds) - 100),
                                         0,
                                         CGRectGetWidth(self.view.bounds) - 100,
                                         CGRectGetHeight(self.view.bounds));
        
        self.cityView.frame = CGRectMake(CGRectGetWidth(self.view.bounds),
                                         0,
                                         CGRectGetWidth(self.view.bounds) - 100,
                                         CGRectGetHeight(self.view.bounds));
    } completion:^(BOOL finished) {
        [self.view removeGestureRecognizer:self.dismissTapGesture];
    }];
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

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    return fabs(velocity.y) > fabs(velocity.x);
}

#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactiveTransition;
}

// Implement these 2 methods to perform interactive transitions
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.interactiveTransition;
}

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

//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    
//    [UIView animateWithDuration:0.2f animations:^{
//        CATransform3D transformation = CATransform3DIdentity;
//        transformation.m14 = 0;
//        transformation.m24 = -0.0003;
//        cell.layer.transform = transformation;
//    }];
//}

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
