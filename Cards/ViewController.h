//
//  ViewController.h
//  Cards
//
//  Created by Kevin Nguy on 8/21/15.
//  Copyright (c) 2015 kevinnguy. All rights reserved.
//

#import <VBFPopFlatButton.h>

@import UIKit;

@interface ViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) VBFPopFlatButton *menuButton;

@end

