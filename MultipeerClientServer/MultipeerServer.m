//
//  MultipeerServer.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MultipeerServer.h"

@interface MultipeerServer () <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy, readonly) NSDictionary *discoveryInfo;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation MultipeerServer

- (id)initWithSession:(MCSession *)session serviceType:(NSString *)serviceType guid:(NSString *)guid
{
	self = [super init];
	if (self) {
		self.session = session;
		self.session.delegate = self;
		self.guid = guid;
		self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:session.myPeerID discoveryInfo:self.discoveryInfo serviceType:serviceType];
		self.advertiser.delegate = self;
		self.operationQueue = [[NSOperationQueue alloc] init];
		self.operationQueue.maxConcurrentOperationCount = 2;
		
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
		@"guid" : self.guid
	};
}

#pragma mark MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	NSLog(@"Peer %@ did change state: %d", peerID.displayName, (int)state);
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
	if (peerID == self.session.myPeerID) {
		return;
	}
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
	/**/
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
	/**/
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
	/**/
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
