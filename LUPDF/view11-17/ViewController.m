//
//  ViewController.m
//  view11-17
//
//  Created by lu_ios on 16/11/17.
//  Copyright © 2016年 luchanghao. All rights reserved.
//

#import "ViewController.h"
#import "EPPDFManager.h"
#import "EPPDFCollectionCell.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()


@property (nonatomic, strong) EPPDFManager *pdfManager;
@property (nonatomic, strong) UIImageView  *imgView;

@property (nonatomic, strong) EPPDFCollectionCell *photoCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.pdfManager = [[EPPDFManager alloc] initWithFrame:(CGRectMake(50, 50, SCREEN_WIDTH*0.7, SCREEN_HEIGHT*0.7))];
    _pdfManager.pdfSource = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"pdf"];
    [self.view addSubview:_pdfManager.collectionView];

}



@end
