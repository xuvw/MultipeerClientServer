//
//  ConnectedPeersDataSource.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/17/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@class MCSPeer;

@interface ConnectedPeersDataSource : NSObject

- (id)initWithCollectionView:(UICollectionView *)collectionView peer:(MCSPeer *)peer;

@end
