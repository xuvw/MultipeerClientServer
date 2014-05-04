//
//  ListAppServer.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/30/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListAppServer.h"
#import "ListAppAPI.h"
#import "TSharedProcessorFactory.h"
#import "TBinaryProtocol.h"
#import "TNSStreamTransport.h"
#import "TTransportException.h"

@interface ListAppServer () <ListAppAPI, MCSServerDelegate>

@property (nonatomic, strong) List *list;
@property (nonatomic, strong) NSMutableDictionary *peerProcessorMap;

- (void)addProcessor:(id<TProcessor>)processor forPeer:(MCPeerID *)peerID;

@end

@implementation ListAppServer

- (id)initWithServiceType:(NSString *)serviceType list:(List *)list
{
	self = [super initWithServiceType:serviceType];
	if (self) {
		self.list = list;
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

#pragma mark ListAppAsyncAPI

- (void)addListItem:(ListItem *)listItem withCompletion:(void(^)(int32_t revision))completion
{
	if (completion) {
		int32_t result = [self addListItem:listItem];
		completion(result);
	}
}

- (void)getListRevisionWithCompletion:(void(^)(int32_t revision))completion
{
	if (completion) {
		int32_t revision = [self getListRevision];
		completion(revision);
	}
}

- (void)getListWithCompletion:(void(^)(List *list))completion
{
	if (completion) {
		List *list = [self getList];
		completion(list);
	}
}

#pragma mark ListAppAPI

- (int32_t)addListItem:(ListItem *)listItem
{
	[self.list.listItems addObject:listItem];
	self.list.revision = self.list.revision + 1;
	return self.list.revision;
}

- (int32_t)getListRevision
{
	return self.list.revision;
}

- (List *)getList
{
	return self.list;
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
	ListAppAPIProcessor *processor = [[ListAppAPIProcessor alloc] initWithListAppAPI:self];
	[self addProcessor:processor forPeer:peerID];

	@try {
		BOOL result = NO;
		do {
			@autoreleasepool {
				result = [processor processOnInputProtocol:protocol outputProtocol:protocol];
			}
		} while (result);
	}
	@catch (TTransportException *exception) {
		NSLog(@"Caught transport exception, abandoning client connection: %@", exception);
	}
}

@end
