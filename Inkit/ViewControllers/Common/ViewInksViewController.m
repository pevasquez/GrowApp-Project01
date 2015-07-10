//
//  ViewInksViewController.m
//  Inkit
//
//  Created by Cristian Pena on 7/10/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "ViewInksViewController.h"
#import "GADBannerCollectionReusableView.h"
#import "InkCollectionViewCell.h"
#import "InkitTheme.h"
#import "UIView+Extension.h"

static NSString * const InkCollectionViewCellIdentifier = @"InkCollectionViewCell";
static NSString * const BannerCollectionViewCellIdentifier = @"BannerCollectionViewCell";

@interface ViewInksViewController () 
@end

@implementation ViewInksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.inksCollectionView registerNib:[UINib nibWithNibName:@"InkCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:InkCollectionViewCellIdentifier];
    [self.inksCollectionView registerNib:[UINib nibWithNibName:@"GADBannerCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BannerCollectionViewCellIdentifier];

    self.inksCollectionView.backgroundColor = [InkitTheme getBackgroundColor];
}

#pragma mark - CollectionView Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.inksArray.count > 0 ? self.inksArray.count : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.inksArray.count > 0) {
        return ((NSArray *)self.inksArray[section]).count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InkCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:InkCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.ink = self.inksArray[indexPath.section][indexPath.item];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    double width = (screenBounds.size.width-12)/2;
    return CGSizeMake(width, 344);
}

#pragma mark - CollectionView DataSource
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    GADBannerCollectionReusableView* cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BannerCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.rootViewController = self;
    if (indexPath.section % 2) {
        cell.bannerImageView.image = [UIImage imageNamed:@"tcl"];
    } else {
        cell.bannerImageView.image = [UIImage imageNamed:@"dior"];
    }
    return cell;
}

#pragma mark - CollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    switch ([UIView deviceType]) {
        case iPhone4:
        case iPhone5:
            return CGSizeMake(collectionView.bounds.size.width, 85);
            break;
        case iPhone6:
            return CGSizeMake(collectionView.bounds.size.width, 99);
            break;
        case iPhone6Plus:
            return CGSizeMake(collectionView.bounds.size.width, 109);
            break;
        default:
            return CGSizeMake(collectionView.bounds.size.width, 100);
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
