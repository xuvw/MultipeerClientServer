//
//  MCSServer.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/20/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSPeer.h"

@protocol MCSServerDelegate;

@interface MCSServer : MCSPeer

@property (nonatomic, weak) id<MCSServerDelegate> delegate;

@end

@protocol MCSServerDelegate <NSObject>
@optional
- (void)multipeerServer:(MCSServer *)server didDisconnectPeer:(MCPeerID *)peerID;
- (void)multipeerServer:(MCSServer *)server didStartInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream forPeer:(MCPeerID *)peerID;
@end
