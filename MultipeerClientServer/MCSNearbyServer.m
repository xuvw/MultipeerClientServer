//
//  MCSNearbyServer.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSNearbyServer.h"

@interface MCSNearbyServer ()

@property (nonatomic, copy) MCPeerID *peerID;
@property (nonatomic, copy) NSString *uuid;

@end

@implementation MCSNearbyServer

- (id)initWithPeerID:(MCPeerID *)peerID discoveryInfo:(NSDictionary *)discoveryInfo
{
	self = [super init];
	if (self) {
		self.peerID = peerID;
		self.uuid = discoveryInfo[ @"uuid" ];
	}
	
	return self;
}

@end
