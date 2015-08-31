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
    self.minimumLineSpacing = 4.0f;
    
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.sectionInset = UIEdgeInsetsMake(CGRectGetHeight(frame) - itemHeight - self.minimumLineSpacing,
                                         self.minimumLineSpacing,
                                         self.minimumLineSpacing,
                                         self.minimumLineSpacing);

    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
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

// Note: name of method changed
// Also this gets called for all visible cells (not just the inserted ones) and
// even gets called when deleting cells!
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if ([self.insertIndexPaths containsObject:itemIndexPath]) {
        // only change attributes on inserted cells
        if (!attributes) {
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        
        NSLog(@"asdf");

        // Configure attributes ...
        attributes.transform = CGAffineTransformScale(CGAffineTransformMakeScale(0.01f, 0.01f), 1, 1);
//        attributes.transform3D = CATransform3DMakeScale(0.0, 0.0, 1);
    }
    
    return attributes;
}

// Note: name of method changed
// Also this gets called for all visible cells (not just the deleted ones) and
// even gets called when inserting cells!
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if ([self.deleteIndexPaths containsObject:itemIndexPath]) {
        // only change attributes on deleted cells
        if (!attributes) {
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        
        NSLog(@"dsfsfd");

        // Configure attributes ...
//        attributes.transform = CGAffineTransformScale(attributes.transform, 0, 0);
//        attributes.transform = CGAffineTransformScale(CGAffineTransformMakeScale(0, 0), 0, 0);
//        attributes.transform3D = CATransform3DMakeScale(0.9, 0.9, 0.5);
//        attributes.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        attributes.transform = CGAffineTransformScale(CGAffineTransformMakeScale(0.01f, 0.01f), 1, 1);
    }
    
    return attributes;
}

@end
