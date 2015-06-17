//
//  GADBannerCollectionReusableView.m
//  Inkit
//
//  Created by Cristian Pena on 6/12/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "GADBannerCollectionReusableView.h"
@import GoogleMobileAds;

@interface GADBannerCollectionReusableView()
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;


@end
@implementation GADBannerCollectionReusableView

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.bannerView.adUnitID = @"ca-app-pub-4095196226599758/4663882020";
//    self.bannerView.rootViewController = self.rootViewController;
//    GADRequest* request = [GADRequest request];
//    request.testDevices = @[kGADSimulatorID, @"5dfb40d16c63170dd13df2b3041eac9c"];
//    [self.bannerView loadRequest:request];
    
}

@end
