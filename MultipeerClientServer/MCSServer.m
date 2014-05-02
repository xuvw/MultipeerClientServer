//
//  MCSServer.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/20/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSServer.h"

static void *ConnectedPeersContext = &ConnectedPeersContext;

@interface MCSServer () <MCNearbyServiceAdvertiserDelegate, NSStreamDelegate>

@property (nonatomic, copy, readonly) NSDictionary *discoveryInfo;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

@end

@implementation MCSServer

- (id)initWithServiceType:(NSString *)serviceType
{
	self = [super initWithServiceType:serviceType];
	if (self) {
		self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.session.myPeerID discoveryInfo:self.discoveryInfo serviceType:self.serviceType];
		self.advertiser.delegate = self;
		[self.advertiser startAdvertisingPeer];
	}
	
	return self;
}

- (void)dealloc;
{
	[self.advertiser stopAdvertisingPeer];
}

- (NSDictionary *)discoveryInfo
{
	return @{
		@"uuid" : self.uuid
	};
}

#pragma mark MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	[super session:session peer:peerID didChangeState:state];
	
	if (state == MCSessionStateNotConnected) {
		if ([self.delegate respondsToSelector:@selector(multipeerServer:didDisconnectPeer:)]) {
			[self.delegate multipeerServer:self didDisconnectPeer:peerID];
		}
	}
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
	NSError *error = nil;
	NSOutputStream *outputStream = [self.session startStreamWithName:streamName toPeer:peerID error:&error];
	outputStream.delegate = self;
	[outputStream open];
	
	stream.delegate = self;
	[stream open];
	
	if (error) {
		NSLog(@"error: %@", error.localizedDescription);
	}
	else {
		if ([self.delegate respondsToSelector:@selector(multipeerServer:didStartInputStream:outputStream:forPeer:)]) {
			[self.delegate multipeerServer:self didStartInputStream:stream outputStream:outputStream forPeer:peerID];
		}
	}
}

#pragma mark MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
	NSLog(@"Server: Host received invitation from client: %@; accepting", peerID.displayName);
	if (invitationHandler) {
		invitationHandler(YES, self.session);
	}
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
	NSLog(@"Server: Did not start advertising to peer. %@", error.localizedDescription);
}

@end

