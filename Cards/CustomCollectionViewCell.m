//
//  CustomCollectionViewCell.m
//  Cards
//
//  Created by Kevin Nguy on 8/24/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.layer.cornerRadius = 4;
    
    return self;
}

@end
