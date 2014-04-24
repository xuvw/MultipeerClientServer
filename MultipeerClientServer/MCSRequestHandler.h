//
//  MCSRequestHandler.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@class MCSServer;
@class MCSRequest;

@interface MCSRequestHandler : NSObject

- (void)registerRequestOperationClass:(Class)requestOperationClass forRequestClass:(Class)requestClass;

- (void)handleRequestData:(NSData *)data fromPeer:(MCPeerID *)peerID withServer:(MCSServer *)server;
- (void)processLocalRequest:(MCSRequest *)request withServer:(MCSServer *)server;

@end
