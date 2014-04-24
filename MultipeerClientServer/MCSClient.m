//
//  MCSClient.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/20/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSClient.h"
#import "MCSNearbyServer.h"
#import "MCSRequestController.h"

@interface MCSClient () <MCNearbyServiceBrowserDelegate>

@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) NSArray *nearbyServers;
@property (nonatomic, strong) MCPeerID *hostPeerID;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, strong) void (^onConnectBlock)(void);
@property (nonatomic, strong) MCSRequestController *requestController;

@end

@implementation MCSClient

- (id)initWithServiceType:(NSString *)serviceType
{
	self = [super initWithServiceType:serviceType];
	if (self) {
		self.nearbyServers = [NSMutableArray array];
		self.requestController = [[MCSRequestController alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	[self stopBrowsingForHosts];
}

- (void)startBrowsingForHosts
{
	[self.browser startBrowsingForPeers];
}

- (void)stopBrowsingForHosts;
{
	self.nearbyServers = [NSMutableArray array];
	[self.browser stopBrowsingForPeers];
}

- (void)connectToHost:(MCPeerID *)hostPeerID
{
	self.hostPeerID = hostPeerID;
	self.connected = NO;
	[self.browser invitePeer:hostPeerID toSession:self.session withContext:nil timeout:20.f];
}

- (void)start
{
	[super start];
	
	self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.session.myPeerID serviceType:self.serviceType];
	self.browser.delegate = self;
	[self startBrowsingForHosts];
}

- (void)sendRequest:(MCSRequest *)request
{
	[self.requestController sendRequest:request toPeer:self.hostPeerID withSession:self.session];
}

#pragma mark MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	[super session:session peer:peerID didChangeState:state];
	
	switch (state) {
		case MCSessionStateNotConnected: {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (peerID == self.hostPeerID) {
					self.connected = NO;
					
					if ([self.delegate respondsToSelector:@selector(multipeerClient:didDisconnectFromHost:)]) {
						[self.delegate multipeerClient:self didDisconnectFromHost:peerID];
					}
				}
			});
		}
			break;
		case MCSessionStateConnecting: {
			dispatch_async(dispatch_get_main_queue(), ^{
				if ([self.delegate respondsToSelector:@selector(multipeerClient:isConnectingToHost:)]) {
					[self.delegate multipeerClient:self isConnectingToHost:peerID];
				}
			});
		}
			break;
		case MCSessionStateConnected: {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (peerID == self.hostPeerID) {
					self.connected = YES;
					if ([self.delegate respondsToSelector:@selector(multipeerClient:didConnectToHost:)]) {
						[self.delegate multipeerClient:self didConnectToHost:peerID];
					}
				}
			});
		}
			break;
			
		default:
			break;
	}
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
	if (peerID == self.hostPeerID) {
		[self.requestController processResponseData:data];
	}
}

#pragma mark MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
	NSLog(@"Client: Discovered potential host: %@", peerID.displayName);
	
	MCSNearbyServer *nearbyServer = [[MCSNearbyServer alloc] initWithPeerID:peerID discoveryInfo:info];
	if (nearbyServer.uuid) {
		self.nearbyServers = [self.nearbyServers arrayByAddingObject:nearbyServer];
	}
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
	NSLog(@"Client: Lost potential host: %@", peerID.displayName);
	
	MCSNearbyServer *nearbyServerToRemove = nil;
	for (MCSNearbyServer *nearbyServer in self.nearbyServers) {
		if (nearbyServer.peerID == peerID) {
			nearbyServerToRemove = nearbyServer;
			break;
		}
	}
	
	if (nearbyServerToRemove) {
		NSMutableArray *nearbyServers = [NSMutableArray arrayWithArray:self.nearbyServers];
		[nearbyServers removeObject:nearbyServerToRemove];
		self.nearbyServers = nearbyServers;
	}
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
	NSLog(@"Client: Could not start browsing for peers. %@", error.localizedDescription);
}

@end
