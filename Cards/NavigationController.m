//
//  NavigationController.m
//  Cards
//
//  Created by Kevin Nguy on 8/27/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import "NavigationController.h"

#import "DetailViewController.h"

@implementation NavigationController

- (BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[DetailViewController class]]) {
        return NO;
    }
    
    return YES;
}

@end
