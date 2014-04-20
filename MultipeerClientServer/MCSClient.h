//
//  MCSClient.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/20/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSPeer.h"

@protocol MCSClientDelegate;

@interface MCSClient : MCSPeer

@property (nonatomic, strong, readonly) NSArray *nearbyServers;
@property (nonatomic, weak) id<MCSClientDelegate> delegate;

- (void)startBrowsingForHosts;
- (void)stopBrowsingForHosts;

- (void)connectToHost:(MCPeerID *)hostPeerID;

@end

@protocol MCSClientDelegate <NSObject>

- (void)multipeerClient:(MCSClient *)client isConnectingToHost:(MCPeerID *)hostPeerID;
- (void)multipeerClient:(MCSClient *)client didConnectToHost:(MCPeerID *)hostPeerID;
- (void)multipeerClient:(MCSClient *)client didDisconnectFromHost:(MCPeerID *)hostPeerID;

@end