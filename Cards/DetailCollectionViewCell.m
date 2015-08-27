//
//  DetailCollectionViewCell.m
//  Cards
//
//  Created by Kevin Nguy on 8/26/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import "DetailCollectionViewCell.h"

@implementation DetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    return self;
}

@end
