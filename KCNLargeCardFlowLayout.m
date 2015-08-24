//
//  KCNLargeCardFlowLayout.m
//  Cards
//
//  Created by Kevin Nguy on 8/24/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import "KCNLargeCardFlowLayout.h"

@implementation KCNLargeCardFlowLayout

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
    
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 4.0f;
    
    self.itemSize = CGSizeMake(CGRectGetWidth(frame) - (self.minimumLineSpacing * 2),
                               CGRectGetHeight(frame) - (self.minimumLineSpacing * 2));
    
    // top, left, bottom, right
    self.sectionInset = UIEdgeInsetsMake(self.minimumLineSpacing,
                                         self.minimumLineSpacing,
                                         self.minimumLineSpacing,
                                         self.minimumLineSpacing);
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    return NO;
}

// UICollectionView align logic missing in horizontal paging scrollview: http://stackoverflow.com/a/20156486/1807446
- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize canvasSize = self.collectionView.frame.size;
    
    NSUInteger rowCount = (canvasSize.height - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1;
    NSUInteger columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1;
    
    CGFloat pageMarginX = (canvasSize.width - columnCount * self.itemSize.width - (columnCount > 1 ? (columnCount - 1) * self.minimumLineSpacing : 0)) / 2.0f;
    
    NSUInteger page = indexPath.row / (rowCount * columnCount);
    NSUInteger remainder = indexPath.row - page * (rowCount * columnCount);
    NSUInteger row = remainder / columnCount;
    NSUInteger column = remainder - row * columnCount;
    
    CGRect cellFrame = CGRectZero;
    cellFrame.origin.x = pageMarginX + column * (self.itemSize.width + self.sectionInset.left);
    cellFrame.origin.y = self.sectionInset.top;
    cellFrame.size.width = self.itemSize.width;
    cellFrame.size.height = self.itemSize.height;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        cellFrame.origin.x += page * canvasSize.width;
    }
    
    return cellFrame;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    attr.frame = [self frameForItemAtIndexPath:indexPath];
    return attr;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * originAttrs = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * attrs = [NSMutableArray array];
    
    [originAttrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * attr, NSUInteger idx, BOOL *stop) {
        NSIndexPath * idxPath = attr.indexPath;
        CGRect itemFrame = [self frameForItemAtIndexPath:idxPath];
        if (CGRectIntersectsRect(itemFrame, rect))
        {
            attr = [self layoutAttributesForItemAtIndexPath:idxPath];
            [attrs addObject:attr];
        }
    }];
    
    return attrs;
}



@end
































