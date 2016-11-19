//
//  EPPDFManager.m
//  pdf
//
//  Created by luchanghao on 16/11/17.
//  Copyright © 2016年 luchanghao. All rights reserved.
//

#import "EPPDFManager.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIView+Frame.h"
#import "EPPDFCollectionCell.h"
#import "UIView+Layout.h"

#define COLOR_RGBA(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define COLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define COLOR_Random \
[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]



@interface EPPDFManager()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign) CGPDFDocumentRef pdfDoc;
@property (nonatomic, assign) CGPDFPageRef page;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) CGRect frame;
@end

@implementation EPPDFManager

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super init]) {
        self.frame = frame;
        _currentIndex = 1;
        [self configCollectionView];
    }
    return self;
}




-(void)setPdfSource:(NSString *)pdfSource{
    _pdfSource = pdfSource;
    _pdfDoc = [self getPDFDocumentRef:pdfSource];
}

-(CGPDFDocumentRef)getPDFDocumentRef:(NSString *)filename{
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    size_t count;
    
    path = CFStringCreateWithCString (NULL, [filename UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    
    CFRelease (path);
    document = CGPDFDocumentCreateWithURL (url);
    CFRelease(url);
    count = CGPDFDocumentGetNumberOfPages (document);
    
    self.pageCount = [[NSString stringWithFormat:@"%zu",count] intValue];
    
    if (count == 0) {
        printf("[%s] needs at least one page!\n", [filename UTF8String]);
        return NULL;
    } else {
        printf("[%ld] pages loaded in this PDF!\n", count);
    }
    return document;

}

-(UIImage *)imageWithPage:(int)pageIndex{
    

    
    _page = CGPDFDocumentGetPage (_pdfDoc, pageIndex);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_frame];
    [[UIColor whiteColor] setFill];
    [path fill];
    
    
    CGContextTranslateCTM(context, 0, SCREEN_HEIGHT);
    CGRect frame =  CGPDFPageGetBoxRect(_page, kCGPDFMediaBox);
    
    CGFloat scale = MIN(SCREEN_WIDTH/frame.size.width, SCREEN_HEIGHT/frame.size.height);
    
    CGContextScaleCTM(context, scale, - scale);
    
    CGContextTranslateCTM(context, 0, SCREEN_HEIGHT - frame.size.height*scale);

    
    
    CGContextDrawPDFPage (context, _page);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}




- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(_frame.size.width, _frame.size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:_frame collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    [_collectionView registerClass:[EPPDFCollectionCell class] forCellWithReuseIdentifier:@"TZPhotoPreviewCell"];
}


#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _pageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EPPDFCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZPhotoPreviewCell" forIndexPath:indexPath];
    cell.img = [self imageWithPage:(int)(indexPath.row +1)];
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[EPPDFCollectionCell class]]) {
        [(EPPDFCollectionCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[EPPDFCollectionCell class]]) {
        [(EPPDFCollectionCell *)cell recoverSubviews];
    }
}



@end





















