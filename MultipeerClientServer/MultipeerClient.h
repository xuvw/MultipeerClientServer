//
//  MultipeerClient.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@protocol MultipeerClientDelegate;

@interface MultipeerClient : NSObject

@property (nonatomic, strong, readonly) NSArray *nearbyServers;
@property (nonatomic, weak) id<MultipeerClientDelegate> delegate;

- (id)initWithSession:(MCSession *)session serviceType:(NSString *)serviceType;

- (void)startBrowsingForHosts;
- (void)stopBrowsingForHosts;

- (void)connectToHost:(MCPeerID *)hostPeerID;

@end

@protocol MultipeerClientDelegate <NSObject>

- (void)multipeerClient:(MultipeerClient *)multipeerClient isConnectingToHost:(MCPeerID *)hostPeerID;
- (void)multipeerClient:(MultipeerClient *)multipeerClient didConnectToHost:(MCPeerID *)hostPeerID;
- (void)multipeerClient:(MultipeerClient *)multipeerClient didDisconnectFromHost:(MCPeerID *)hostPeerID;

@end