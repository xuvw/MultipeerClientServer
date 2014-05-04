//
//  MCSClient.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/20/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSClient.h"
#import "MCSNearbyServer.h"
#import "MCSStreamRequest.h"

static void *ConnectedContext = &ConnectedContext;

@interface MCSClient () <MCNearbyServiceBrowserDelegate, NSStreamDelegate>

@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) NSArray *nearbyServers;
@property (nonatomic, strong) MCPeerID *hostPeerID;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, strong) void (^onConnectBlock)(void);
@property (nonatomic, strong) NSMutableDictionary *streamRequests;

@end

@implementation MCSClient

- (id)initWithServiceType:(NSString *)serviceType
{
	self = [super initWithServiceType:serviceType];
	if (self) {
		self.nearbyServers = [NSMutableArray array];
		self.streamRequests = [NSMutableDictionary dictionary];
		self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.session.myPeerID serviceType:self.serviceType];
		self.browser.delegate = self;
		[self startBrowsingForHosts];

		[self addObserver:self forKeyPath:@"connected" options:NSKeyValueObservingOptionNew context:ConnectedContext];
	}
	
	return self;
}

- (void)dealloc
{
	[self stopBrowsingForHosts];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == ConnectedContext) {
		if (self.connected && self.onConnectBlock) {
			self.onConnectBlock();
			self.onConnectBlock = nil;
		}
	}
	else {
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
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

- (void)connectToHost:(MCPeerID *)hostPeerID completion:(void(^)())completion
{
	self.onConnectBlock = completion;
	self.hostPeerID = hostPeerID;
	self.connected = NO;
	[self.browser invitePeer:hostPeerID toSession:self.session withContext:nil timeout:20.f];
}

- (void)createStreamToHostWithCompletion:(void(^)(NSInputStream *inputStream, NSOutputStream *outputStream))completion
{
	NSString *uuid = [[NSUUID UUID] UUIDString];
	NSError *error = nil;
	NSOutputStream *outputStream = [self.session startStreamWithName:uuid toPeer:self.hostPeerID error:&error];
	if (error || !outputStream) {
		NSLog(@"Error: %@", error.localizedDescription);
	}
	else {
		NSLog(@"Client: started stream named %@ with host %@", uuid, self.hostPeerID.displayName);
		
		outputStream.delegate = self;
		[outputStream open];
		MCSStreamRequest *request = [[MCSStreamRequest alloc] initWithOutputStream:outputStream completion:completion];
		self.streamRequests[ uuid ] = request;
	}
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
				}
			});
		}
			break;
		case MCSessionStateConnecting: {
			dispatch_async(dispatch_get_main_queue(), ^{
			});
		}
			break;
		case MCSessionStateConnected: {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (peerID == self.hostPeerID) {
					self.connected = YES;
				}
			});
		}
			break;
			
		default:
			break;
	}
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
	if (peerID == self.hostPeerID) {
		MCSStreamRequest *streamRequest = self.streamRequests[ streamName ];
		if (streamRequest && streamRequest.completion) {
			stream.delegate = self;
			[stream open];
			streamRequest.completion(stream, streamRequest.outputStream);
			[self.streamRequests removeObjectForKey:streamName];
		}
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
