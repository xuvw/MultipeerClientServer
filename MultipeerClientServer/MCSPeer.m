//
//  MCSPeer.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/20/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSPeer.h"

@interface MCSPeer ()

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSArray *connectedPeers;

- (NSString *)stringForSessionState:(MCSessionState)state;

@end

@implementation MCSPeer

- (id)initWithSession:(MCSession *)session serviceType:(NSString *)serviceType
{
	self = [super init];
	if (self) {
		self.session = session;
		self.session.delegate = self;
		self.guid = [[NSUUID UUID] UUIDString];
		self.connectedPeers = [NSArray array];
	}
	
	return self;
}

- (NSString *)stringForSessionState:(MCSessionState)state
{
	switch (state) {
		case MCSessionStateNotConnected:
			return @"MCSessionStateNotConnected";
		case MCSessionStateConnecting:
			return @"MCSessionStateConnecting";
		case MCSessionStateConnected:
			return @"MCSessionStateConnected";
		default:
			return @"Invalid state";
	}
}

#pragma mark MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	NSLog(@"%@ did change state with peer, %@: %@", peerID.displayName, peerID, [self stringForSessionState:state]);

	switch (state) {
		case MCSessionStateConnected:
			self.connectedPeers = [self.connectedPeers arrayByAddingObject:peerID];
			break;
		case MCSessionStateNotConnected: {
			NSMutableArray *connectedPeers = [NSMutableArray arrayWithArray:self.connectedPeers];
			[connectedPeers removeObject:peerID];
			self.connectedPeers = [NSArray arrayWithArray:connectedPeers];
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

@end
