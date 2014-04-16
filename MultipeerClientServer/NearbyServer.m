//
//  NearbyServer.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "NearbyServer.h"

@interface NearbyServer ()

@property (nonatomic, copy) MCPeerID *peerID;
@property (nonatomic, copy) NSString *guid;

@end

@implementation NearbyServer

- (id)initWithPeerID:(MCPeerID *)peerID discoveryInfo:(NSDictionary *)discoveryInfo
{
	self = [super init];
	if (self) {
		self.peerID = peerID;
		self.guid = discoveryInfo[ @"guid" ];
	}
	
	return self;
}

@end
