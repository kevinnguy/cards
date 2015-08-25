//
//  DetailViewController.h
//  Cards
//
//  Created by Kevin Nguy on 8/24/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <VBFPopFlatButton.h>


@interface DetailViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) NSInteger dataSourceIndex;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) VBFPopFlatButton *closeButton;
@end
