//
//  NearbyServersDataSource.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;

@class MultipeerClient;

@interface NearbyServersDataSource : NSObject

- (id)initWithCollectionView:(UICollectionView *)collectionView multipeerClient:(MultipeerClient *)multipeerClient;

@end
