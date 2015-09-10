//
//  KCNCardFlowLayout.m
//  Cards
//
//  Created by Kevin Nguy on 8/24/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import "KCNCardFlowLayout.h"

@interface KCNCardFlowLayout () 

@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;

// Cell animation
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat latestDelta;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation KCNCardFlowLayout

- (instancetype)init {
    return [self initWithCollectionViewFrame:CGRectZero];
}

- (instancetype)initWithCollectionViewFrame:(CGRect)frame {
    self = [super init];
    if (!self) {
        NSLog(@"KCNCardFlowLayout returned nil because self is nil");
        return nil;
    }
    
    if (CGRectEqualToRect(frame, CGRectZero)) {
        NSLog(@"KCNCardFlowLayout returned nil because frame is CGRectZero");
        return nil;
    }
    
    NSInteger itemWidth = 168;
    NSInteger itemHeight = 250;
    
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 6.0f;
    
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.sectionInset = UIEdgeInsetsMake(CGRectGetHeight(frame) - itemHeight - self.minimumLineSpacing,
                                         self.minimumLineSpacing,
                                         self.minimumLineSpacing,
                                         self.minimumLineSpacing);

    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.visibleIndexPathsSet = [NSMutableSet set];
    
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];

    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"collectionView"];
}

- (void)setupCollectionView {
//    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
//    self.longPressGestureRecognizer.delegate = self;
//    self.longPressGestureRecognizer.minimumPressDuration = 0.2f;
//    [self.collectionView addGestureRecognizer:self.longPressGestureRecognizer];
//    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
//        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
//            [gestureRecognizer requireGestureRecognizerToFail:self.longPressGestureRecognizer];
//        }
//    }
//    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:self.panGestureRecognizer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"collectionView"] && self.collectionView) {
        [self setupCollectionView];
    } else  {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.selectedIndexPath = [self.collectionView indexPathForItemAtPoint:[recognizer locationInView:self.collectionView]];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        
        [UIView animateWithDuration:0.2f animations:^{
            cell.layer.transform = [self transformCell:cell withGestureRecognizer:recognizer];
        }];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        cell.layer.transform = [self transformCell:cell withGestureRecognizer:recognizer];
    } else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        
        [UIView animateWithDuration:0.2f animations:^{
            cell.layer.transform = CATransform3DIdentity;
        }];

        self.selectedIndexPath = nil;
    }
}

- (CATransform3D)transformCell:(UICollectionViewCell *)cell withGestureRecognizer:(UIGestureRecognizer *)recognizer {
    // Get point and set its max to cell size's width
    CGPoint point = [recognizer locationInView:cell];
    point = CGPointMake(MAX(0, MIN(point.x, self.itemSize.width)), MAX(0, MIN(point.y, self.itemSize.height)));
    
    // Get cell's center
    CGPoint cellCenter = CGPointMake(self.itemSize.width / 2, self.itemSize.height / 2);
    
    // Start transformation
    CATransform3D transformation = CATransform3DIdentity;
    
    CGFloat tiltPerspective = 0.0003;
    if (point.x <= cellCenter.x) {
        // As finger pans left, m14 increases negatively
        transformation.m14 = -tiltPerspective * (cellCenter.x - point.x) / cellCenter.x;
    } else {
        // As finger pans right, m14 increases positively
        transformation.m14 = tiltPerspective * (point.x - cellCenter.x) / cellCenter.x;
    }
    
    if (point.y <= cellCenter.y) {
        // As finger pans up, m24 increases negatively
        transformation.m24 = -tiltPerspective * (cellCenter.y - point.y) / cellCenter.y;
    } else {
        // As finger pans down, m24 increases positively
        transformation.m24 = tiltPerspective * (point.y - cellCenter.y) / cellCenter.y;
    }
    
    return transformation;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin long press");
        self.selectedIndexPath = [self.collectionView indexPathForItemAtPoint:[recognizer locationInView:self.collectionView]];
        [self invalidateLayout];
    } else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end long press");
        self.selectedIndexPath = nil;
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([self.longPressGestureRecognizer isEqual:gestureRecognizer]) {
//        return [self.panGestureRecognizer isEqual:otherGestureRecognizer];
//    }
//    
//    if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
//        return [self.longPressGestureRecognizer isEqual:otherGestureRecognizer];
//    }
    
    return YES;
}
- (void)prepareLayout {
    [super prepareLayout];
    
    // Need to overflow our actual visible rect slightly to avoid flickering.
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -200, -200);
    
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    // Step 1: Remove any behaviours that are no longer visible.
    NSArray *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[[[behaviour items] firstObject] indexPath]] != nil;
        return !currentlyVisible;
    }]];
    
    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[[[obj items] firstObject] indexPath]];
    }];
    
    // Step 2: Add any newly visible behaviours.
    // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        return !currentlyVisible;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehaviour.length = 0.0f;
        springBehaviour.damping = 0.8f; // how bouncy: 0 is bounciest, 1 is no bounce
        springBehaviour.frequency = 1.0f; // speed: 0 is slowest, 1 is normal
        
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
            
            if (self.latestDelta < 0) {
                center.x += MAX(self.latestDelta, self.latestDelta*scrollResistance);
            } else {
                center.x += MIN(self.latestDelta, self.latestDelta*scrollResistance);
            }
            item.center = center;
        }
        
        [self.dynamicAnimator addBehavior:springBehaviour];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = oldBounds.origin.x - scrollView.bounds.origin.x;
    
    self.latestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 2500.0f;
        
        UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
        CGPoint center = item.center;
        if (delta < 0) {
            center.x += MAX(delta, delta*scrollResistance);
        } else {
            center.x += MIN(delta, delta*scrollResistance);
        }
        item.center = center;
        
        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    
    return NO;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
    
    self.deleteIndexPaths = [NSMutableArray new];
    self.insertIndexPaths = [NSMutableArray new];
    
    for (UICollectionViewUpdateItem *update in updateItems) {
        if (update.updateAction == UICollectionUpdateActionDelete) {
            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
        } else if (update.updateAction == UICollectionUpdateActionInsert) {
            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    
    // release the insert and delete index paths
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if ([self.insertIndexPaths containsObject:itemIndexPath]) {
        if (!attributes) {
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        
        attributes.transform = CGAffineTransformScale(CGAffineTransformMakeScale(0.01f, 0.01f), 1, 1);
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if ([self.deleteIndexPaths containsObject:itemIndexPath]) {
        if (!attributes) {
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }

        attributes.transform = CGAffineTransformScale(CGAffineTransformMakeScale(0.01f, 0.01f), 1, 1);
    }
    
    return attributes;
}

@end
