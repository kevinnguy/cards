//
//  KCNCardFlowLayout.m
//  Cards
//
//  Created by Kevin Nguy on 8/24/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import "KCNCardFlowLayout.h"

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
    
    NSInteger itemWidth = 142;
    NSInteger itemHeight = 254;
    
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 2.0f;
    
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


@end
