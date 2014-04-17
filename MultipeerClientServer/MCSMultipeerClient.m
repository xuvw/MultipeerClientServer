//
//  MCSMultipeerClient.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSMultipeerClient.h"
#import "MCSNearbyServer.h"
#import "Util.h"

@interface MCSMultipeerClient () <MCSessionDelegate, MCNearbyServiceBrowserDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) NSArray *nearbyServers;
@property (nonatomic, strong) MCPeerID *hostPeerID;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, strong) void (^onConnectBlock)(void);
@property (nonatomic, strong) NSMutableDictionary *activeRequests;

@end

@implementation MCSMultipeerClient

- (id)initWithSession:(MCSession *)session serviceType:(NSString *)serviceType
{
	self = [super init];
	if (self) {
		self.session = session;
		self.session.delegate = self;
		self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:session.myPeerID serviceType:serviceType];
		self.browser.delegate = self;
		self.nearbyServers = [NSMutableArray array];
		self.activeRequests = [NSMutableDictionary dictionary];
		
		[self startBrowsingForHosts];
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

#pragma mark MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	NSLog(@"%@ did change state with peer, %@: %@", peerID.displayName, peerID, [Util stringForSessionState:state]);
	
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
	/**/
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

#pragma mark MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
	NSLog(@"Client: Discovered potential host: %@", peerID.displayName);
	
	MCSNearbyServer *nearbyServer = [[MCSNearbyServer alloc] initWithPeerID:peerID discoveryInfo:info];
	if (nearbyServer.guid) {
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
