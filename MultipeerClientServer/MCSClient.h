//
//  MCSClient.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/20/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSPeer.h"

@interface MCSClient : MCSPeer

@property (nonatomic, strong, readonly) NSArray *nearbyServers;

- (void)startBrowsingForHosts;
- (void)stopBrowsingForHosts;

- (void)connectToHost:(MCPeerID *)hostPeerID completion:(void(^)())completion;

@end
