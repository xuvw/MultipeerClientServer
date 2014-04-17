//
//  MCSNearbyServer.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@interface MCSNearbyServer : NSObject

@property (nonatomic, copy, readonly) MCPeerID *peerID;
@property (nonatomic, copy, readonly) NSString *guid;

- (id)initWithPeerID:(MCPeerID *)peerID discoveryInfo:(NSDictionary *)discoveryInfo;

@end
