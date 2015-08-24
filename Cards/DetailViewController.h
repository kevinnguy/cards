//
//  DetailViewController.h
//  Cards
//
//  Created by Kevin Nguy on 8/24/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) NSInteger dataSourceIndex;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIColor *backgroundColor;

@end
