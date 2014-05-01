//
//  ListAppServer.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/30/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListAppServer.h"
#import "ListApp.h"
#import "TSharedProcessorFactory.h"
#import "TBinaryProtocol.h"
#import "TNSStreamTransport.h"

@interface ListAppServer () <ListApp, MCSServerDelegate>

@property (nonatomic, strong) NSMutableDictionary *peerProcessorMap;

- (void)addProcessor:(id<TProcessor>)processor forPeer:(MCPeerID *)peerID;

@end

@implementation ListAppServer

- (id)initWithServiceType:(NSString *)serviceType
{
	self = [super initWithServiceType:serviceType];
	if (self) {
		self.peerProcessorMap = [NSMutableDictionary dictionary];
		self.delegate = self;
	}
	
	return self;
}

- (void)addProcessor:(id<TProcessor>)processor forPeer:(MCPeerID *)peerID
{
	NSMutableArray *processors = self.peerProcessorMap[ peerID ];
	if (!processors) {
		processors = [NSMutableArray array];
		self.peerProcessorMap[ peerID ] = processors;
	}
	
	[processors addObject:processor];
}

#pragma mark ListApp

- (BOOL)addListItem:(ListItem *)listItem
{
	NSLog(@"Server: addListItem %@", listItem.text);
	return NO;
}

#pragma mark MCSServerDelegate

- (void)multipeerServer:(MCSServer *)server didDisconnectPeer:(MCPeerID *)peerID
{
	[self.peerProcessorMap removeObjectForKey:peerID];
}

- (void)multipeerServer:(MCSServer *)server didStartInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream forPeer:(MCPeerID *)peerID
{
	TNSStreamTransport *transport = [[TNSStreamTransport alloc] initWithInputStream:inputStream outputStream:outputStream];
	TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
	ListAppProcessor *processor = [[ListAppProcessor alloc] initWithListApp:self];
	[processor processOnInputProtocol:protocol outputProtocol:protocol];
	
	[self addProcessor:processor forPeer:peerID];
}

@end
