//
//  EPPDFManager.h
//  pdf
//
//  Created by luchanghao on 16/11/17.
//  Copyright © 2016年 luchanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EPPDFManager : NSObject

-(instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) NSString *pdfUrl;
@property (nonatomic, strong) NSString *pdfSource;

@property (nonatomic, assign) int pageCount;
@property (nonatomic, strong) UICollectionView *collectionView;
-(UIImage *)imageWithPage:(int)pageIndex;

@end
